//
//  CKFOPAlertView.m
//  caiqr
//
//  Created by 洪利 on 2017/4/27.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKFOPAlertView.h"
#import "Masonry.h"
#import "CKFOPModel.h"
#import "CKFOPService.h"
#define cellHeight CKFOP_SCALE(40.f)
#define CKFOP_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define CKFOP_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define CKFOP_SCREEN_SCALE (CKFOP_SCREEN_WIDTH / 320.0f)
#define CKFOP_SCALE(a) (a * CKFOP_SCREEN_SCALE)
#define CKFOP_SCALE_HALE(a) (a * ((((CKFOP_SCREEN_SCALE - 1) / 2.0f)) + 1))
#define CKFOP_SCALE_ADD_HALE(a) ((a) * (((CKFOP_SCREEN_SCALE - 1) > 0)? 2 :1))
#define CKFOP_FONT(F) [UIFont systemFontOfSize:F]
#define CKFOP_FONT_SCALE(F) [UIFont systemFontOfSize:CKFOP_SCALE_HALE(F)]
#define CKFOP_FONT_FIX(F) [UIFont systemFontOfSize:CKFOP_SCALE(F)]
// rgb颜色转换（16进制->10进制）
#define CKFOP_UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface CKFOPAlertView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIButton *rightTopBtn;//关闭按钮
@property (nonatomic, strong) UIView *backView;//白色背景
@property (nonatomic, strong) UITableView *listView;//中间限额列表
@property (nonatomic, strong) UILabel *topTitle;//顶部标题
@property (nonatomic, strong) UIButton *OKBtn;//开通按钮
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *checkBoxBtn;//不再提醒勾选框
@property (nonatomic, strong) UILabel *noShowsAnymore;//不再提醒标签
@property (nonatomic, strong) CKFOPModel *mainDataModel;
@property (nonatomic, strong) NSString *selectedString;
@property (nonatomic, strong) CKFOPService *myService;

@end


@implementation CKFOPAlertView
+ (instancetype)creatWithData:(id)model frame:(CGRect)frame{
    CKFOPAlertView *selfView = [[CKFOPAlertView alloc] initWithFrame:frame];
    selfView.mainDataModel = model;
    if (selfView.mainDataModel.default_quota.count && [[selfView.mainDataModel.default_quota firstObject] integerValue]) {
        selfView.selectedString = [NSString stringWithFormat:@"%ld", [[selfView.mainDataModel.default_quota firstObject] integerValue]];
    }else{
        selfView.selectedString = [NSString stringWithFormat:@"%ld", [[selfView.mainDataModel.default_quota_list firstObject] integerValue]];
    }
    //    selfView.backgroundColor = UIColorFromRGB(0xffffff);
    //    selfView.layer.masksToBounds = YES;
    //    selfView.layer.cornerRadius = 2.0f;
    [selfView configureSubViews];
    [selfView.listView reloadData];
    return selfView;
}

- (void)configureSubViews{
    [self addSubview:self.rightTopBtn];
    [self addSubview:self.backView];
    [self.backView addSubview:self.topTitle];
    [self.backView addSubview:self.listView];
    [self.backView addSubview:self.bottomLine];
    [self.backView addSubview:self.OKBtn];
    [self.backView addSubview:self.checkBoxBtn];
    [self.backView addSubview:self.noShowsAnymore];
    [self addConstraint];
}

- (void)addConstraint{
    
    [self.rightTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self);
        make.height.with.mas_equalTo(CKFOP_SCALE(40));
    }];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rightTopBtn.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
    
    [self.topTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.backView);
        make.height.mas_equalTo(cellHeight);
    }];
    
    
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.topTitle);
        make.top.mas_equalTo(self.topTitle.mas_bottom);
        make.height.mas_lessThanOrEqualTo(cellHeight*3);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.listView);
        make.top.mas_equalTo(self.listView.mas_bottom).offset(0.5);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self.OKBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.listView.mas_bottom).offset(CKFOP_SCALE(20.f));
        make.left.mas_equalTo(self.topTitle).offset(10.f);
        make.right.mas_equalTo(self.topTitle).offset(-10.f);
        make.height.mas_equalTo(CKFOP_SCALE(36));
    }];
    
    [self.noShowsAnymore sizeToFit];
    [self.checkBoxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.OKBtn.mas_bottom).offset(CKFOP_SCALE(9.f));
        make.width.height.mas_equalTo(self.noShowsAnymore.frame.size.height+3);
        make.left.mas_equalTo((CGRectGetWidth(self.frame)/2.0 - (CGRectGetHeight(self.noShowsAnymore.frame)+CGRectGetWidth(self.noShowsAnymore.frame)/2.0)));
        make.bottom.mas_equalTo(self.backView.mas_bottom).offset(-CKFOP_SCALE(15));
    }];
    
    [self.noShowsAnymore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.checkBoxBtn);
        make.left.mas_equalTo(self.checkBoxBtn.mas_right).offset(2.f);
        make.size.mas_equalTo(self.noShowsAnymore.frame.size);
    }];
    
}

#pragma mark - Userinterface
- (void)cancel:(id)sender{
    //右上角 关闭按钮点击
    [self.myService resetFreeOfPayWithisNeverNotify:[NSString stringWithFormat:@"%d", self.checkBoxBtn.selected]
                                              quato:self.selectedString
                                          iskaitong:@"0" complete:^(id obj){
                                              self.chooseComplete(nil);
                                          }];
}
- (void)okBtnSelected:(id)sender{
    //开通按钮 点击
    [self.myService resetFreeOfPayWithisNeverNotify:[NSString stringWithFormat:@"%d", self.checkBoxBtn.selected]
                                              quato:self.selectedString
                                          iskaitong:@"1" complete:^(id obj){
                                              self.chooseComplete(obj);
                                          }];
}

- (void)neverNotify:(id)sender{
    self.checkBoxBtn.selected = !self.checkBoxBtn.selected;
}

#pragma tableviewdelegate
#pragma mark - TableViewDelegate TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainDataModel.default_quota_list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    WS(weakSelf)
    CKFOPCell* cell = [tableView dequeueReusableCellWithIdentifier:@"freeCell"];
    if (!cell) {
        
        cell = [[CKFOPCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"freeCell"];
    }
    cell.data = [NSString stringWithFormat:@"%@%@", self.mainDataModel.word,self.mainDataModel.default_quota_list[indexPath.row]];
    cell.isSelected = ([self.mainDataModel.default_quota_list[indexPath.row] longLongValue] == [self.selectedString longLongValue])?YES:NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = indexPath.row;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.selectedString = self.mainDataModel.default_quota_list[indexPath.row];
    [self.listView reloadData];
}







- (UIView *)backView{
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 2.0f;
    }
    return _backView;
}


- (UIButton *)rightTopBtn{
    if (!_rightTopBtn) {
        _rightTopBtn = [UIButton new];
        [_rightTopBtn setImage:[UIImage imageNamed:@"ck_europeClose"] forState:UIControlStateNormal];
        [_rightTopBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightTopBtn;
}

- (UILabel *)topTitle{
    if (!_topTitle) {
        _topTitle = [UILabel new];
        _topTitle.textColor = CKFOP_UIColorFromRGB(0x333333);
        _topTitle.font = CKFOP_FONT_SCALE(14);
        _topTitle.text = @"小额免密支付";
        //        _topTitle.backgroundColor = UIColorFromRGB(0xffffff);
        _topTitle.textAlignment = NSTextAlignmentCenter;
        
    }
    return _topTitle;
}

- (UITableView *)listView{
    if (!_listView) {
        _listView = [[UITableView alloc] init];
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listView.dataSource = self;
        _listView.delegate = self;
        _listView.bounces = NO;
    }
    return _listView;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = CKFOP_UIColorFromRGB(0xe6e6e6);
    }
    return _bottomLine;
}

- (UIButton *)OKBtn{
    if (!_OKBtn) {
        _OKBtn = [UIButton new];
        [_OKBtn setTitleColor:CKFOP_UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _OKBtn.titleLabel.font = CKFOP_FONT_SCALE(15);
        _OKBtn.backgroundColor = CKFOP_UIColorFromRGB(0x5494ff);
        [_OKBtn setTitle:@"开通" forState:UIControlStateNormal];
        _OKBtn.layer.masksToBounds = YES;
        _OKBtn.layer.cornerRadius = 2.f;
        [_OKBtn addTarget:self action:@selector(okBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _OKBtn;
}

- (UIButton *)checkBoxBtn{
    if (!_checkBoxBtn) {
        _checkBoxBtn = [UIButton new];
        [_checkBoxBtn setImage:[UIImage imageNamed:@"ck_bslCheckbox"] forState:UIControlStateNormal];
        [_checkBoxBtn setImage:[UIImage imageNamed:@"ck_bslCheckboxSelected"] forState:UIControlStateSelected];
        [_checkBoxBtn addTarget:self action:@selector(neverNotify:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBoxBtn;
}

- (UILabel *)noShowsAnymore{
    if (!_noShowsAnymore) {
        _noShowsAnymore = [UILabel new];
        _noShowsAnymore.textColor = CKFOP_UIColorFromRGB(0x666666);
        _noShowsAnymore.text = @"不再提醒";
        _noShowsAnymore.font = CKFOP_FONT_SCALE(10);
        _noShowsAnymore.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(neverNotify:)];
        ges.numberOfTapsRequired = 1;
        ges.numberOfTouchesRequired = 1;
        [_noShowsAnymore addGestureRecognizer:ges];
    }
    return _noShowsAnymore;
}



- (CKFOPService *)myService{
    if (!_myService) {
        _myService = [CKFOPService allocWithWeakViewController:nil];
    }
    return _myService;
}
@end


@interface CKFOPCell ()
@property (nonatomic, strong) UILabel *leftTitle;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;
@end


@implementation CKFOPCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureSubViews];
    }
    return self;
}

- (void)configureSubViews{
    [self.contentView addSubview:self.topLine];
    [self.contentView addSubview:self.leftTitle];
    [self.contentView addSubview:self.rightBtn];
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(0.5f);
    }];
    
    
    [self.leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10.f);
        make.top.bottom.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView.mas_width);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.width.height.mas_equalTo(CKFOP_SCALE(20.f));
        make.centerY.mas_equalTo(self.contentView);
    }];
}

- (void)setData:(NSString *)data{
    self.leftTitle.text = data;
}
- (void)setIsSelected:(BOOL)isSelected{
    self.rightBtn.selected = isSelected;
}



#pragma mark - get method
- (UILabel *)leftTitle{
    if (!_leftTitle) {
        _leftTitle = [UILabel new];
        _leftTitle.font = CKFOP_FONT_SCALE(14.f);
        _leftTitle.textColor = CKFOP_UIColorFromRGB(0x333333);
    }
    return _leftTitle;
}

- (UIView *)topLine{
    if (!_topLine) {
        _topLine = [UIView new];
        _topLine.backgroundColor = CKFOP_UIColorFromRGB(0xe6e6e6);
    }
    return _topLine;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton new];
        [_rightBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"ck_selected"] forState:UIControlStateSelected];
    }
    return _rightBtn;
}

@end
