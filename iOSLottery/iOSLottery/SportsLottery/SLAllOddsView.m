//
//  SLAllOddsView.m
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/13.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLAllOddsView.h"
#import "SLConfigMessage.h"
#import "SLAllOddsSPFCell.h"
#import "SLPlayMethodModel.h"
#import "SLAllOddsScoreCell.h"
#import "SLAllOddsGoalCell.h"
#import "SLAllOddsHalfOverallCell.h"
#import "SLMatchTitleView.h"
#import "SLBottomBtnView.h"
#import "SLMatchBetModel.h"
#import "SLSPFModel.h"
#import "SLBFModel.h"
#import "SLJPSModel.h"
#import "SLBQCModel.h"
#import "SLBetSelectInfo.h"
#import "SLBetInfoManager.h"
#import "SLAllOddsUnsaleCell.h"

#import "SLBetInfoCache.h"

#import "SLBasicAnimation.h"



@interface SLAllOddsView ()<UITableViewDelegate, UITableViewDataSource,CAAnimationDelegate>

@property (nonatomic, strong) UIView *backView;//背景View
@property (nonatomic, strong) UIView *listBaseView;//所有内容的基层View
@property (nonatomic, strong) SLMatchTitleView *titleView;

@property (nonatomic, strong) SLBottomBtnView *bottomView;
@property (nonatomic, strong) UIView *topLineView;

@property (nonatomic, strong) UITableView *mainTableView;

/**
 胜平负cell
 */
@property (nonatomic, strong) SLAllOddsSPFCell *spfCell;

/**
 比分cell
 */
@property (nonatomic, strong) SLAllOddsScoreCell *scoreCell;

/**
 总进球cell
 */
@property (nonatomic, strong) SLAllOddsGoalCell *goalsCell;

/**
 半全场cell
 */
@property (nonatomic, strong) SLAllOddsHalfOverallCell *halfOverallCell;

@property (nonatomic, strong) SLSPFModel *spfModel;
@property (nonatomic, strong) SLSPFModel *rqspfModel;
@property (nonatomic, strong) SLBFModel *bfModel;
@property (nonatomic, strong) SLJPSModel *jqsModel;
@property (nonatomic, strong) SLBQCModel *bqcModel;

@property (nonatomic, strong) NSDictionary *cellDictionary;

/**
 截屏Image
 */
@property (nonatomic, strong) UIImageView *snapshotView;

@property (nonatomic, strong) CAAnimationGroup *appearGroupAnimation;

@end

@implementation SLAllOddsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self addSubviews];
        
        [self addConstraints];

//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf)];
//        [self.backView addGestureRecognizer:tap];
        
        self.appearGroupAnimation = [SLBasicAnimation alertContentAppearGruopAnimation];
        
        self.appearGroupAnimation.delegate = self;
    }
    return self;
}

- (void)addSubviews
{
    [self addSubview:self.backView];
    [self addSubview:self.listBaseView];
    [self.listBaseView addSubview:self.titleView];
    [self.listBaseView addSubview:self.mainTableView];
    [self.listBaseView addSubview:self.bottomView];
    [self.listBaseView addSubview:self.topLineView];
}

- (void)addConstraints
{

    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
    }];
    
    [self.listBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(SL__SCALE(20.f));
        make.top.equalTo(self).offset(SL__SCALE(70.f));
        make.bottom.equalTo(self).offset(SL__SCALE(-70.f));
        make.right.equalTo(self).offset(SL__SCALE(-20.f));
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(self.listBaseView);
        make.height.mas_equalTo(SL__SCALE(44.f));
    }];
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.listBaseView);
        make.top.equalTo(self.titleView.mas_bottom);
        make.height.mas_equalTo(0.5f);
        
    }];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.right.equalTo(self.listBaseView);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mainTableView.mas_bottom);
        make.bottom.left.right.equalTo(self.listBaseView);
        make.height.mas_equalTo(SL__SCALE(60));
        
    }];

}

- (void)layoutSubviews
{

//    [super layoutSubviews];
//
//    
//
//    [self addSubview:self.snapshotView];
//    
//    self.listBaseView.hidden = YES;
//    
//    self.snapshotView.frame = self.listBaseView.frame;
//
//    
//    [self.snapshotView.layer addAnimation:self.appearGroupAnimation forKey:@"groupAnimation"];
//    
//    [self.backView.layer addAnimation:[SLBasicAnimation alertMaskAppearAppearAnimation] forKey:@"animation"];
}

- (void)showInWindow
{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];

}


- (void)removeFromSuperviewWithAnimation
{

    [self startDisMissAnimation];
}

- (void)tapSelf{
    
//    [self startDisMissAnimation];
    
    [self removeFromSuperview];
}

#pragma mark --- CAAnimationDelegate ---

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([self.snapshotView.layer animationForKey:@"groupAnimation"] == anim) {
        
        self.listBaseView.hidden = NO;
        
        self.snapshotView.hidden = YES;
        
    }else{
    
            [self removeFromSuperview];
    }
    

}


//移除动画
- (void)startDisMissAnimation
{
    
    [self.backView.layer addAnimation:[SLBasicAnimation alertMaskDisAppearAnimation] forKey:@"didmiss"];
    
    CAAnimationGroup *groupAnimation = [SLBasicAnimation alertContentDisAppearGroupAnimation];
    
    groupAnimation.delegate = self;
    
    [self.listBaseView.layer addAnimation:groupAnimation forKey:@"didmiss"];
    
}

//底部确定按钮点击事件
- (void)confimButtonOnClick{
    

    SLBetSelectSingleGameInfo *gameInfo = [self getNeedSaveMatch];
    //判断这场比赛是否无选项 即 是否是删除该场比赛
    BOOL isDeleteMatch = YES;
    for (SLBetSelectPlayMothedInfo *playInfo in gameInfo.singleBetSelectArray) {
        if (playInfo.selectPlayMothedArray.count > 0) {
            isDeleteMatch = NO;
            break;
        }
    }
    if (self.sureClearMatchBlock && isDeleteMatch) {
        self.sureClearMatchBlock();
    }else{
        
        [self saveMatchSelect];
        [self tapSelf];
    }
}

//设置串关项
- (void)setChuanGuanItem
{
    
//    [[SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray removeAllObjects];
    [SLBetInfoManager saveOneMatchSelectInfo:[self getNeedSaveMatch]];
//    return;
    //记录当前选择的串关项是否有最高串关项（为了修改默认最高串关项）
//    BOOL record = [[SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray containsObject:[NSString stringWithFormat:@"%zi", [SLBetInfoManager getCurrentMaxChuanGuanCount]]];
//    
//    //记录当前的最高项
//    NSInteger count = [SLBetInfoManager getCurrentMaxChuanGuanCount];
//    
//    
//    //判断当前是否应该默认选择最高串关项 如果有则添加默认最高串关项
//    if (record) {
//        
//        //删除之前的最高项
//        if ([[SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray containsObject:[NSString stringWithFormat:@"%zi", (count)]]) {
//            [[SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray removeObject:[NSString stringWithFormat:@"%zi", (count)]];
//        }
//        
//        if (![[SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray containsObject:[NSString stringWithFormat:@"%zi", ([SLBetInfoManager getCurrentMaxChuanGuanCount])]]) {
//            //判断当前选中的串关是否已有最高串关项，没有则添加
//            [[SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray addObject:[NSString stringWithFormat:@"%zi", [SLBetInfoManager getCurrentMaxChuanGuanCount]]];
//        }
//    }
}

- (void)saveMatchSelect{
    
    [self setChuanGuanItem];
    
    !self.reloadSelectDataBlock ? : self.reloadSelectDataBlock(self.selectIndexPath);
}

- (SLBetSelectSingleGameInfo *)getNeedSaveMatch{
    
    //存储选中项
    SLBetSelectSingleGameInfo *gameInfo = [[SLBetInfoManager getSingleMatchSelectInfoWithMatchIssue:self.currentMatchInfo.match_issue] copy];
    
    if (gameInfo == nil) {

        gameInfo = [[SLBetSelectSingleGameInfo alloc] init];
        gameInfo.matchIssue = self.currentMatchInfo.match_issue;

    }
    
    if (self.spfCell) {
    
        [self savaOneKindPlayMethodWithName:SPF playInfo:self.spfCell.spfSelectPlayMothedInfo inGameInfo:gameInfo];
        
        [self savaOneKindPlayMethodWithName:RQSPF playInfo:self.spfCell.rqspfSelectPlayMothedInfo inGameInfo:gameInfo];
        
    }
    
    if (self.scoreCell) {
        
        [self savaOneKindPlayMethodWithName:BF playInfo:self.scoreCell.scoreSelectPlayMothedInfo inGameInfo:gameInfo];
    }
    
    if (self.goalsCell) {
        
        [self savaOneKindPlayMethodWithName:ZJQ playInfo:self.goalsCell.jqsSelectPlayMothedInfo inGameInfo:gameInfo];
    }
    
    if (self.halfOverallCell) {
        
        [self savaOneKindPlayMethodWithName:BQC playInfo:self.halfOverallCell.bqcSelectPlayMothedInfo inGameInfo:gameInfo];
    }
    
    return gameInfo;
}

//保存一个玩法选项
- (void)savaOneKindPlayMethodWithName:(NSString *)playName playInfo:(SLBetSelectPlayMothedInfo *)playInfo inGameInfo:(SLBetSelectSingleGameInfo *)gameInfo
{

    __block BOOL isAdd = YES;
    
    [gameInfo.singleBetSelectArray enumerateObjectsUsingBlock:^(SLBetSelectPlayMothedInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.playMothed isEqualToString:playName]) {
            
            [gameInfo.singleBetSelectArray replaceObjectAtIndex:idx withObject:playInfo];
            isAdd = NO;
            *stop = YES;
        }
    }];
    
    if (isAdd) {
        
        [gameInfo.singleBetSelectArray addObject:playInfo];
    }
    
}

#pragma mark ------------ UITableView delegate ------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:{
        
           return self.spfCell;
           break;
        }
        
        case 1:{

            return [self retureCellWithModel:self.bfModel tableView:tableView];
            break;
        }
        
        case 2:{
    
            return [self retureCellWithModel:self.jqsModel tableView:tableView];
            break;
        }
            
        case 3:{
            
            return [self retureCellWithModel:self.bqcModel tableView:tableView];
            break;
        }
            
        default:{
            
            //异常情况
            return [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"defaultCell"];
            
            break;
        }
    }
}

#pragma make --- 根据Model获取Cell ----
- (id)retureCellWithModel:(id)model tableView:(UITableView *)tableView
{

    if ([model isSale] == YES) {
        
        return self.cellDictionary[[model playName]];
        
    }else{
        
        SLAllOddsUnsaleCell *cell = [SLAllOddsUnsaleCell createAllOddsUnsaleCellWithTableView:tableView];
        
        cell.titleText = [model playName];
        cell.isDanGuan = ([model danguan] == 1);
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0) return SL__SCALE(100.f);
    
    if (indexPath.row == 1) {
        
        return self.bfModel.isSale ? SL__SCALE(230.f) : SL__SCALE(65.f);
        
    }
    
    if (indexPath.row == 2) {
    
        return self.jqsModel.isSale ?  SL__SCALE(84.f) : SL__SCALE(65.f);
        
    }
    
    if (indexPath.row == 3 ) {
    
        return self.bqcModel.isSale ? SL__SCALE(128.f) : SL__SCALE(65.f);
        
    }

    return 0;
}

- (void)setCurrentMatchInfo:(SLMatchBetModel *)currentMatchInfo{
    
    _currentMatchInfo = currentMatchInfo;
    
    self.titleView.titleModel = currentMatchInfo;
    self.spfModel = currentMatchInfo.spf;
    self.rqspfModel = currentMatchInfo.rqspf;
    self.bfModel = currentMatchInfo.bifen;
    self.jqsModel = currentMatchInfo.jqs;
    self.bqcModel = currentMatchInfo.bqc;
    
    
    //注册cell映射
    self.cellDictionary = @{self.bfModel.playName:self.scoreCell,
                            self.jqsModel.playName:self.goalsCell,
                            self.bqcModel.playName:self.halfOverallCell};
    
    [self.spfCell assignDataWithNormalData:self.spfModel concedeData:self.rqspfModel matchIssue:self.currentMatchInfo.match_issue];
    
    [self.scoreCell assignDataWithNormalData:self.bfModel matchIssue:self.currentMatchInfo.match_issue];
    
    [self.goalsCell assignDataWithNormalData:self.jqsModel matchIssue:self.currentMatchInfo.match_issue];
    
    [self.halfOverallCell assignDataWithNormalData:self.bqcModel matchIssue:self.currentMatchInfo.match_issue];

    [self.mainTableView reloadData];
    
}

#pragma mark ------------ getter Mothed ------------
- (UIView *)backView{
    
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = SL_UIColorFromRGBandAlpha(0x000000, 0.7);
    }
    return _backView;
}

- (UIView *)listBaseView{
    
    if (!_listBaseView) {
        _listBaseView = [[UIView alloc] init];
        
        _listBaseView.backgroundColor = SL_UIColorFromRGB(0xFAF8F6);
        _listBaseView.layer.cornerRadius = 5.f;
        _listBaseView.layer.masksToBounds = YES;
    }
    return _listBaseView;
}

- (UITableView *)mainTableView{
    
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.estimatedRowHeight = 400;
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
        _mainTableView.backgroundColor = SL_UIColorFromRGB(0xfaf8f6);
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.contentInset = UIEdgeInsetsMake(0, 0,SL__SCALE(10.f), 0);
    }
    
    return _mainTableView;
}

- (SLAllOddsSPFCell *)spfCell
{

    if (_spfCell == nil) {
        
        _spfCell = [SLAllOddsSPFCell createAllOddsSPFCellWithTableView:nil];
        
    }

    return _spfCell;
}

- (SLAllOddsScoreCell *)scoreCell
{

    if (_scoreCell == nil) {
        
        _scoreCell = [SLAllOddsScoreCell createAllOddsScoreCellWithTableView:nil];
    }
    return _scoreCell;
}

- (SLAllOddsGoalCell *)goalsCell
{

    if (_goalsCell == nil) {
        
        _goalsCell = [SLAllOddsGoalCell createAllOddsGoalCellWithTableView:nil];
    }
    
    return _goalsCell;
}

- (SLAllOddsHalfOverallCell *)halfOverallCell
{

    if (_halfOverallCell == nil) {
        
        _halfOverallCell = [SLAllOddsHalfOverallCell createAllOddsHalfOverCellWithTableView:nil];

    }
    return _halfOverallCell;
}

- (SLMatchTitleView *)titleView{
    
    if (!_titleView) {
        _titleView = [[SLMatchTitleView alloc] initWithFrame:CGRectZero];
    }
    return _titleView;
}

- (SLBottomBtnView *)bottomView{
    
    if (!_bottomView) {
        WS_SL(_weakSelf)
        _bottomView = [[SLBottomBtnView alloc] initWithFrame:CGRectZero];
        [_bottomView returnSureClick:^{
            
            [_weakSelf confimButtonOnClick];
        }];
        
        [_bottomView returnCancelClick:^{
            
            [_weakSelf tapSelf];
        }];
    }
    return _bottomView;
}
- (UIView *)topLineView{
    
    if (!_topLineView) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _topLineView.backgroundColor = SL_UIColorFromRGB(0xece5dd);
    }
    return _topLineView;
}

- (UIImageView *)snapshotView
{
    if (!_snapshotView)
    {
        UIGraphicsBeginImageContextWithOptions(self.listBaseView.frame.size, self.opaque, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.listBaseView.layer renderInContext:context];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        _snapshotView = [[UIImageView alloc] initWithFrame:self.listBaseView.frame];
        _snapshotView.image = image;
        
    }
    
    return _snapshotView;
}

@end
