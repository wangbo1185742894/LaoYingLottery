//
//  CBMatchSelectView.m
//  赛事筛选
//
//  Created by 任鹏杰 on 2017/5/9.
//  Copyright © 2017年 任鹏杰. All rights reserved.
//

#import "SLConfigMessage.h"

#import "SLMatchSelectView.h"
#import "SLMatchSelectBtnView.h"
#import "SLMatchsSelectCell.h"
#import "SLBottomBtnView.h"
#import "SLMatchSelectModel.h"
#import "SLBetInfoCache.h"

#import "SLBasicAnimation.h"

#import "SLExternalService.h"

@interface SLMatchSelectView ()<UICollectionViewDelegate,UICollectionViewDataSource,SLMatchSelectBtnDelegate,CAAnimationDelegate>


/**
 内容view
 */
@property (nonatomic, strong) UIView *contentView;
/**
 标题label
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 筛选按钮
 */
@property (nonatomic, strong) SLMatchSelectBtnView *selectView;

/**
 内容(滚动)视图
 */
@property (nonatomic, strong) UICollectionView *collectView;

/**
 底部按钮view
 */
@property (nonatomic, strong) SLBottomBtnView *bottomView;

/**
 蒙版Layer
 */
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) CAAnimation *dismissAmiation;


@end

@implementation SLMatchSelectView

- (void)dealloc
{

    NSLog(@" i am die");
}

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubviews];
        [self addConstraints];
    }

    return self;
}

- (void)addSubviews
{
    [self addSubview:self.maskView];

    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.selectView];
    [self.contentView addSubview:self.collectView];
    [self.contentView addSubview:self.bottomView];
    [self addSubview:self.contentView];
    
}

- (void)addConstraints
{

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(SL__SCALE(18.f));
        make.right.equalTo(self.mas_right).offset(SL__SCALE(-18.f));
//        make.height.mas_offset(SL__SCALE(420.f));
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(SL__SCALE(15.f));
        
    }];
    
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView.mas_left).offset(SL__SCALE(10.f));
        make.right.equalTo(self.contentView.mas_right).offset(SL__SCALE(-10.f));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(SL__SCALE(11.f));
        make.height.mas_equalTo(SL__SCALE(40.f));
        
    }];
    
    [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.selectView.mas_bottom).offset(SL__SCALE(10.f));
        make.left.equalTo(self.selectView.mas_left);
        make.right.equalTo(self.selectView.mas_right);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(SL__SCALE(60.f));
    }];
}

- (void)layoutSubviews
{

    [super layoutSubviews];

    self.frame = CGRectMake(0, 0, SL_SCREEN_WIDTH, SL_SCREEN_HEIGHT);
    
    self.maskView.bounds = self.frame;
    
    [self addConstraints];
}


- (void)show
{
    [self.dataArray removeAllObjects];
    
    for (SLMatchSelectModel *model in [SLBetInfoCache shareBetInfoCache].leagueMatchesArray) {
        
        [self.dataArray addObject:[model copy]];
    }
    
    if (self.dataArray.count) {
        NSInteger collectViewRow = self.dataArray.count / 3 + (self.dataArray.count % 3 ? 1 : 0);
        CGFloat collectViewHeight = SL__SCALE(45) * collectViewRow - SL__SCALE(5.f);
        [self.collectView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(collectViewHeight>SL__SCALE(255.f)?SL__SCALE(255.f):collectViewHeight);
        }];
    }
    [self updateConstraints];
    [self.collectView reloadData];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [self.contentView.layer addAnimation:[SLBasicAnimation alertContentAppearGruopAnimation] forKey:@"groupAnimation"];
    
    [self.maskView.layer addAnimation:[SLBasicAnimation alertMaskAppearAppearAnimation] forKey:@"animation"];
}


#pragma mark --- SLMatchSelectBtnDelegate ---

- (void)selectBtnAtIndex:(NSInteger)index
{

    switch (index) {
        case 1:
            [self allSelected];
            break;
        case 2:
            [self fiveSelected];
            break;
        case 3:
            [self clearAllSelected];
            break;
        default:
            break;
    }

}

//点击全选
- (void)allSelected
{

    for (SLMatchSelectModel *model in self.dataArray) {
        
        model.isSelect = YES;
    }

    [self.collectView reloadData];
}

//点击五大联赛
- (void)fiveSelected
{

    for (SLMatchSelectModel *model in self.dataArray) {
        model.isSelect = model.isFiveLeague;
    }
    [self.collectView reloadData];
}

//清空
- (void)clearAllSelected
{

    for (SLMatchSelectModel *model in self.dataArray) {
        
        model.isSelect = NO;
    }
    
    [self.collectView reloadData];

}


#pragma mark --- CollectionDelegate ---
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.dataArray.count;
}

- (SLMatchsSelectCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    SLMatchsSelectCell *cell = (SLMatchsSelectCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    SLMatchSelectModel *model = self.dataArray[indexPath.row];
    
    cell.selectModel = model;
    
    return cell;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake(SL__SCALE(100), SL__SCALE(35));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SLMatchSelectModel *model = self.dataArray[indexPath.row];
    model.isSelect = !model.isSelect;
    
    [self.collectView reloadItemsAtIndexPaths:@[indexPath]];

}

#pragma mark --- ButtonClick ---


- (void)tapClick
{

    [self startDisMissAnimation];
}

- (void)startDisMissAnimation
{
    
    [self.maskView.layer addAnimation:[SLBasicAnimation alertMaskDisAppearAnimation] forKey:@"didmiss"];
    
    CAAnimationGroup *groupAnimation = [SLBasicAnimation alertContentDisAppearGroupAnimation];
    
    groupAnimation.delegate = self;
    
    [self.contentView.layer addAnimation:groupAnimation forKey:@"didmiss"];

}

#pragma mark --- CAAnimationDelegate ---

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    [self removeFromSuperview];
}

- (BOOL)checkIsHaveSelectedLeague
{

    BOOL result = false;
    
    for (SLMatchSelectModel *model in self.dataArray) {
        
        if (model.isSelect == YES) {
            
            result = YES;
            
            break;
            
        }else{
        
            result = NO;
        }
    }
    
    if (result == NO) {
        
        [SLExternalService showError:@"请至少选择一场联赛"];
        
    }
    
    return result;
}


#pragma mark --- Get Method ---

- (UIView *)contentView
{

    if (_contentView == nil) {
        
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = SL_UIColorFromRGB(0xFAF8F6);
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = SL__SCALE(6);
    }

    return _contentView;
}

- (UILabel *)titleLabel
{

    if (_titleLabel == nil) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = @"赛事筛选";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = SL_UIColorFromRGB(0x333333);
        _titleLabel.font = SL_FONT_SCALE(17);
    }
    
    return _titleLabel;
}

- (SLMatchSelectBtnView *)selectView
{

    if (_selectView == nil) {
        
        _selectView = [[SLMatchSelectBtnView alloc] initWithFrame:(CGRectZero)];
        _selectView.delegate = self;
    }
    
    return _selectView;

}

- (UICollectionView *)collectView
{

    if (_collectView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //layout.minimumLineSpacing = 40;
        layout.minimumInteritemSpacing = SL__SCALE(5.f);
        _collectView = [[UICollectionView alloc] initWithFrame:(CGRectZero) collectionViewLayout:layout];
        _collectView.showsVerticalScrollIndicator = NO;
        _collectView.delegate = self;
        _collectView.dataSource = self;
        [_collectView registerClass:[SLMatchsSelectCell class] forCellWithReuseIdentifier:@"cell"];
        _collectView.backgroundColor = SL_UIColorFromRGB(0xFAF8F6);
        _collectView.contentInset = UIEdgeInsetsMake(0, 0, SL__SCALE(10.f), 0);
    }
    
    return _collectView;
}

- (NSMutableArray *)dataArray
{

    if (_dataArray == nil) {
        
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}


- (SLBottomBtnView *)bottomView
{

    WS_SL(weakSelf);
    if (_bottomView == nil) {
        
        _bottomView = [[SLBottomBtnView alloc] initWithFrame:(CGRectZero)];
        
        [_bottomView returnCancelClick:^{
           
            
            
            [weakSelf startDisMissAnimation];
        }];
        
        [_bottomView returnSureClick:^{
            
            if ([weakSelf checkIsHaveSelectedLeague] == NO) return;
            
            [[SLBetInfoCache shareBetInfoCache].leagueMatchesArray removeAllObjects];
            [[SLBetInfoCache shareBetInfoCache].leagueMatchesArray addObjectsFromArray:weakSelf.dataArray];
            
            [weakSelf startDisMissAnimation];
            !weakSelf.reloadLeagueMatchs ? : weakSelf.reloadLeagueMatchs();
        }];
    }
    
    return _bottomView;
}

- (UIView *)maskView
{

    if (_maskView == nil) {
        
        _maskView = [[UIView alloc] init];
    
        _maskView.layer.backgroundColor = SL_UIColorFromRGBandAlpha(0x000000, 0.7).CGColor;
        
        _maskView.layer.anchorPoint = CGPointMake(0, 0);
    }
    return _maskView;
}

@end
