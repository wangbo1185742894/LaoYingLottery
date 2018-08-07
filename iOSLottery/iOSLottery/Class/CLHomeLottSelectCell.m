//
//  CLHomeLottSelectCell.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/7.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLHomeLottSelectCell.h"
#import "CLLotterySelectView.h"
#import "CLConfigMessage.h"
#import "CLHomeGameEnteranceModel.h"
#import "UIImageView+CQWebImage.h"
#import "CLLotteryDataManager.h"
@interface CLHomeLottSelectCell ()

@property (nonatomic, strong) CLLotterySelectView* firstLotteryView;
@property (nonatomic, strong) CLLotterySelectView* secoundLotteryView;
@property (nonatomic, strong) UIView* lineView;
@property (nonatomic, strong) UIView* topLineView;

/**
 彩种折叠View
 */
@property (nonatomic, strong) UIView* unfoldView;
/**
 箭头imageView
 */
@property (nonatomic, strong) UIImageView *arrowsView;
@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic, copy) NSArray* lotterys;
@property (nonatomic, strong) NSArray *subEntraceArr;
@end

@implementation CLHomeLottSelectCell

+ (CLHomeLottSelectCell*) lottSelectCellInitWith:(UITableView*)tableView {
    
    CLHomeLottSelectCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLHomeLottSelectCellId"];
    
    if (!cell) {
        cell = [[CLHomeLottSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLHomeLottSelectCell"];
        cell.tableView = tableView;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self p_addSubviews];
        [self p_addConstraints];
    }
    return self;
}

- (void)p_addSubviews
{
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    self.topLineView = [[UIView alloc] init];
    self.topLineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    
    [self.contentView addSubview:self.firstLotteryView];
    [self.contentView addSubview:self.secoundLotteryView];
    [self.contentView addSubview:self.unfoldView];
    [self.contentView addSubview:self.arrowsView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.topLineView];
}

- (void)p_addConstraints
{
    [self.firstLotteryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView);
        make.height.mas_equalTo(__SCALE(70.f));
        make.width.equalTo(self.contentView).multipliedBy(.5f);
    }];
    
    [self.secoundLotteryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(self.firstLotteryView);
        make.left.equalTo(self.firstLotteryView.mas_right);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.centerX.equalTo(self);
        make.width.mas_equalTo(.5f);
    }];
    
    [self.arrowsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(__SCALE(13.f));
        make.height.mas_equalTo(__SCALE(6.f));
        make.bottom.mas_equalTo(self.unfoldView.mas_top).offset(.5f);
    }];
    
    [self.unfoldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.firstLotteryView.mas_bottom);
        make.left.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
    }];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(.5f);
    }];
    
}
#pragma mark ---- Event Click -----
- (void)firstLotteryClicked {
    if ([self.delegate respondsToSelector:@selector(selectCellLott:index:)]) {
        [self.delegate selectCellLott:self.lotterys[0] index:[self.tableView indexPathForCell:self]];
    }
}

- (void)secoundLotteryClicked {
    if ([self.delegate respondsToSelector:@selector(selectCellLott:index:)]) {
        [self.delegate selectCellLott:self.lotterys[1] index:[self.tableView indexPathForCell:self]];
    }
}
- (void)subEntranceLotteryClicked {
    if ([self.delegate respondsToSelector:@selector(selectCellLott:index:)]) {
        [self.delegate selectCellLott:nil index:[self.tableView indexPathForCell:self]];
    }
}

- (void)configureLottery:(NSArray*)lotterys {
    
    self.lotterys = lotterys;
    [self.unfoldView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //是否展示彩种系列
    BOOL canShowSubentrance = NO;
    
    //数据校验
    if (lotterys == nil || lotterys.count == 0) return;
    
    CLHomeGameEnteranceModel* first = lotterys[0];
    [self configSelectView:self.firstLotteryView model:first];
    
    CLHomeGameEnteranceModel* secound = lotterys.count > 1 ? lotterys[1] : nil;
    canShowSubentrance = first.ifGameSeries;
    
    if (lotterys.count > 1) {
        
        self.secoundLotteryView.hidden = NO;
        [self configSelectView:self.secoundLotteryView model:secound];
        canShowSubentrance = secound.ifGameSeries;
        
    }else{
        
        self.secoundLotteryView.hidden = YES;
    }
    
    if (canShowSubentrance) {
        
        NSArray *subEnranceArr;
        if (first.subEntranceIsShow) {
            
            subEnranceArr = first.subEntrances;
            self.unfoldView.hidden = self.arrowsView.hidden = !first.subEntranceIsShow;
            [self.arrowsView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(__SCALE(35.f) - __SCALE(6.5));
            }];
            
        }else if (secound.subEntranceIsShow){
            
            subEnranceArr = secound.subEntrances;
            self.unfoldView.hidden = self.arrowsView.hidden = !secound.subEntranceIsShow;
            [self.arrowsView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(__SCALE(35.f) - __SCALE(6.5) + SCREEN_WIDTH * .5f);
            }];
        }
        self.subEntraceArr = subEnranceArr;
        
        if (!self.unfoldView.hidden) {
            [self.unfoldView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(__SCALE(70.f) * (subEnranceArr.count%2 ? (subEnranceArr.count / 2 + 1):subEnranceArr.count / 2));
            }];
            /** 彩种系列数据赋值 */
            [self addSubEntranceViewWithArr:self.subEntraceArr];
            //[self updateConstraintsIfNeeded];
        }
    }else{
        self.unfoldView.hidden = YES;
    }
}

//设置彩种系列
- (void)addSubEntranceViewWithArr:(NSArray *)subEntranceArr
{
    
    for (NSInteger i = 0; i < subEntranceArr.count ; i++) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
        [self.unfoldView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.unfoldView);
            make.height.mas_equalTo(.5f);
            make.top.mas_equalTo(i * __SCALE(70.f));
        }];
        CLLotterySelectView *selectView = [[CLLotterySelectView alloc] init];
        WS(_weakSelf);
        selectView.tapBlock = ^{
            if ([_weakSelf.delegate respondsToSelector:@selector(selectCellLott:index:)]) {
                [_weakSelf.delegate selectCellLott:subEntranceArr[i] index:[_weakSelf.tableView indexPathForCell:_weakSelf]];
            }
        };
        [self.unfoldView addSubview:selectView];
        [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(i / 2 * __SCALE(70.f));
            make.left.mas_equalTo(i % 2 * SCREEN_WIDTH / 2);
            make.height.mas_equalTo(__SCALE(70.f));
            make.width.mas_equalTo(SCREEN_WIDTH / 2);
        }];
        [self configSelectView:selectView model:subEntranceArr[i]];
    }
}

//设置单个view数据
- (void)configSelectView:(CLLotterySelectView *)view model:(CLHomeGameEnteranceModel *)model
{
    view.lotteryNameLbl.text = model.title;
    view.lotteryDesLbl.text = model.tips;
    [view.lotteryIconImgView setImageWithURL:[NSURL URLWithString:model.imgUrl]];
    [view setTag:([model.ifShowTipsStyle integerValue] == 1) color:model.tipsType];
    [view.rightTopImageView setImageWithURL:[NSURL URLWithString:model.activityIconUrl]];
}

#pragma mark ---- lazyLoad ----

- (CLLotterySelectView *)firstLotteryView
{
    if (_firstLotteryView == nil) {
        
        _firstLotteryView = [[CLLotterySelectView alloc] init];
        [_firstLotteryView addTarget:self selector:@selector(firstLotteryClicked)];
    }
    return _firstLotteryView;
}

- (CLLotterySelectView *)secoundLotteryView
{
    if (_secoundLotteryView == nil) {
        
        _secoundLotteryView = [[CLLotterySelectView alloc] init];
        [_secoundLotteryView addTarget:self selector:@selector(secoundLotteryClicked)];
    }
    return _secoundLotteryView;
}

- (UIView *)unfoldView
{

    if (_unfoldView == nil) {
        
        _unfoldView = [[UIView alloc] init];
        _unfoldView.backgroundColor = UIColorFromRGB(0xfaf8f6);
        _unfoldView.hidden = YES;
    }
    return _unfoldView;
}

- (UIImageView *)arrowsView
{

    if (_arrowsView == nil) {
        
        _arrowsView = [[UIImageView alloc] init];
        _arrowsView.image = [UIImage imageNamed:@"CLHomeModuleBetHeaveImage"];
        _arrowsView.hidden = YES;
    }
    return _arrowsView;
}
@end
