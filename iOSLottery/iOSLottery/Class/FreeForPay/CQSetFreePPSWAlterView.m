//
//  CQSetFreePPSWAlterView.m
//  caiqr
//
//  Created by 洪利 on 2017/3/9.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CQSetFreePPSWAlterView.h"
#import "CLConfigMessage.h"
#import "Masonry.h"
#import "CQFreeOfpayModel.h"
#import "CQFreeOfPayService.h"
#define cellHeight __SCALE(40.f)

@interface CQSetFreePPSWAlterView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIButton *rightTopBtn;//关闭按钮
@property (nonatomic, strong) UIView *backView;//白色背景
@property (nonatomic, strong) UITableView *listView;//中间限额列表
@property (nonatomic, strong) UILabel *topTitle;//顶部标题
@property (nonatomic, strong) UIButton *OKBtn;//开通按钮
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *checkBoxBtn;//不再提醒勾选框
@property (nonatomic, strong) UILabel *noShowsAnymore;//不再提醒标签
@property (nonatomic, strong) CQFreeOfpayModel *mainDataModel;
@property (nonatomic, strong) NSString *selectedString;
@property (nonatomic, strong) CQFreeOfPayService *freePayServeive;


@end


@implementation CQSetFreePPSWAlterView
+ (instancetype)creatWithData:(id)model frame:(CGRect)frame{
    CQSetFreePPSWAlterView *selfView = [[CQSetFreePPSWAlterView alloc] initWithFrame:frame];
    selfView.mainDataModel = model;
    if (selfView.mainDataModel.default_quota.count && [[selfView.mainDataModel.default_quota firstObject] length]) {
        selfView.selectedString = [selfView.mainDataModel.default_quota firstObject];
    }else{
        selfView.selectedString = [selfView.mainDataModel.default_quota_list firstObject];
    }
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
        make.height.with.mas_equalTo(__SCALE(40));
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
        make.top.equalTo(self.listView.mas_bottom).offset(__SCALE(20.f));
        make.left.mas_equalTo(self.topTitle).offset(10.f);
        make.right.mas_equalTo(self.topTitle).offset(-10.f);
        make.height.mas_equalTo(__SCALE(36));
    }];
    
    [self.noShowsAnymore sizeToFit];
    [self.checkBoxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.OKBtn.mas_bottom).offset(__SCALE(9.f));
        make.width.height.mas_equalTo(self.noShowsAnymore.frame.size.height+3);
        make.left.mas_equalTo((CGRectGetWidth(self.frame)/2.0 - (CGRectGetHeight(self.noShowsAnymore.frame)+CGRectGetWidth(self.noShowsAnymore.frame)/2.0)));
        make.bottom.mas_equalTo(self.backView.mas_bottom).offset(-__SCALE(15));
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
    [self.freePayServeive resetFreeOfPayWithisNeverNotify:[NSString stringWithFormat:@"%d", self.checkBoxBtn.selected]
                                                  quato:self.selectedString
                                              iskaitong:@"0" complete:^{
        self.chooseComplete();
    }];
}
- (void)okBtnSelected:(id)sender{
    //开通按钮 点击
    [self.freePayServeive resetFreeOfPayWithisNeverNotify:[NSString stringWithFormat:@"%d", self.checkBoxBtn.selected]
                                                  quato:self.selectedString
                                              iskaitong:@"1" complete:^{
        self.chooseComplete();
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
    CQFreeOfPayCell* cell = [tableView dequeueReusableCellWithIdentifier:@"freeCell"];
    if (!cell) {
        
        cell = [[CQFreeOfPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"freeCell"];
    }
    cell.data = [NSString stringWithFormat:@"%@%@", self.mainDataModel.word,self.mainDataModel.default_quota_list[indexPath.row]];
    cell.isSelected = [self.mainDataModel.default_quota_list[indexPath.row] isEqualToString:self.selectedString];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = indexPath.row;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.selectedString = self.mainDataModel.default_quota_list[indexPath.row];
    [self.listView reloadData];
}




- (CQFreeOfPayService *)freePayServeive{
    
    if (!_freePayServeive) {
        _freePayServeive = [[CQFreeOfPayService alloc] init];
    }
    return _freePayServeive;
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
        [_rightTopBtn setImage:[UIImage imageNamed:@"europeClose"] forState:UIControlStateNormal];
        [_rightTopBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightTopBtn;
}

- (UILabel *)topTitle{
    if (!_topTitle) {
        _topTitle = [UILabel new];
        _topTitle.textColor = UIColorFromRGB(0x333333);
        _topTitle.font = FONT_SCALE(14);
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
        _bottomLine.backgroundColor = UIColorFromRGB(0xe6e6e6);
    }
    return _bottomLine;
}

- (UIButton *)OKBtn{
    if (!_OKBtn) {
        _OKBtn = [UIButton new];
        [_OKBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _OKBtn.titleLabel.font = FONT_SCALE(15);
        _OKBtn.backgroundColor = LINK_COLOR;
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
        [_checkBoxBtn setImage:[UIImage imageNamed:@"bslCheckbox"] forState:UIControlStateNormal];
        [_checkBoxBtn setImage:[UIImage imageNamed:@"bslCheckboxSelected"] forState:UIControlStateSelected];
        [_checkBoxBtn addTarget:self action:@selector(neverNotify:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBoxBtn;
}

- (UILabel *)noShowsAnymore{
    if (!_noShowsAnymore) {
        _noShowsAnymore = [UILabel new];
        _noShowsAnymore.textColor = UIColorFromRGB(0x666666);
        _noShowsAnymore.text = @"不再提醒";
        _noShowsAnymore.font = FONT_SCALE(10);
        _noShowsAnymore.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(neverNotify:)];
        ges.numberOfTapsRequired = 1;
        ges.numberOfTouchesRequired = 1;
        [_noShowsAnymore addGestureRecognizer:ges];
    }
    return _noShowsAnymore;
}

@end


@interface CQFreeOfPayCell ()
@property (nonatomic, strong) UILabel *leftTitle;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;
@end


@implementation CQFreeOfPayCell

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
        make.width.height.mas_equalTo(__SCALE(20.f));
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
        _leftTitle.font = FONT_SCALE(14.f);
        _leftTitle.textColor = UIColorFromRGB(0x333333);
    }
    return _leftTitle;
}

- (UIView *)topLine{
    if (!_topLine) {
        _topLine = [UIView new];
        _topLine.backgroundColor = UIColorFromRGB(0xe6e6e6);
    }
    return _topLine;
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton new];
        [_rightBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:@"paywaychoose"] forState:UIControlStateSelected];
    }
    return _rightBtn;
}

@end
