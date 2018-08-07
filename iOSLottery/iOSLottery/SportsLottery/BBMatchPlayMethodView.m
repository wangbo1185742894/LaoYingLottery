//
//  BBMatchPlayMethodView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/7.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBMatchPlayMethodView.h"
#import "SLConfigMessage.h"

#import "BBOddsItemButton.h"

#import "BBPlayMethodTagView.h"

#import "BBMatchModel.h"
#import "BBSFModel.h"
#import "BBRFSFModel.h"
#import "BBDXFModel.h"

#import "BBMatchInfoManager.h"

#import "BBSeletedGameModel.h"

@interface BBMatchPlayMethodView ()

@property (nonatomic, strong) NSArray *tagArray;

@property (nonatomic, strong) NSDictionary *playMethodDic;

@property (nonatomic, strong) NSArray *playMethodArray;

/**
 客胜选项
 */
@property (nonatomic, strong) BBOddsItemButton *awayWinItem;

/**
 主胜选项
 */
@property (nonatomic, strong) BBOddsItemButton *hostWinItem;

/**
 让客胜选项
 */
@property (nonatomic, strong) BBOddsItemButton *letAwayWinItem;

/**
 让主胜选项
 */
@property (nonatomic, strong) BBOddsItemButton *letHostWinItem;

/**
 大分选项
 */
@property (nonatomic, strong) BBOddsItemButton *bigScoreItem;

/**
 小分选项
 */
@property (nonatomic, strong) BBOddsItemButton *smallScoreItem;

@property (nonatomic, strong) BBPlayMethodTagView *sfTag;

@property (nonatomic, strong) BBPlayMethodTagView *rfsfTag;

@property (nonatomic, strong) BBPlayMethodTagView *dxfTag;

@property (nonatomic, strong) BBPlayMethodTagView *sfcTag;

/**
 投注项数组
 */
@property (nonatomic, strong) NSMutableArray *itemArray;

@end

@implementation BBMatchPlayMethodView

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.layer.borderWidth = 0.2501;
        self.layer.borderColor = SL_UIColorFromRGB(0xECE5DD).CGColor;
        
        [self addSubviews];
        
    }
    return self;
}

- (void)addSubviews
{

    CGFloat tagWidth = SL__SCALE(40.f);
    CGFloat tagHeight = SL__SCALE(40.f);
    
    for (int i = 0; i < 4; i ++) {
        
        BBPlayMethodTagView *tagView = [[BBPlayMethodTagView alloc] initWithFrame:(CGRectMake(0, i * tagHeight, tagWidth, tagHeight))];
        
        [tagView setShowTag:YES];
        
        [tagView setTagText:self.tagArray[i]];
        
        [self addSubview:tagView];
    }
    
    
    self.awayWinItem = [[BBOddsItemButton alloc] initWithFrame:(CGRectZero)];
    
    self.hostWinItem = [[BBOddsItemButton alloc] initWithFrame:(CGRectZero)];
    
    self.letAwayWinItem = [[BBOddsItemButton alloc] initWithFrame:(CGRectZero)];
    
    self.letHostWinItem = [[BBOddsItemButton alloc] initWithFrame:(CGRectZero)];
    
    self.bigScoreItem = [[BBOddsItemButton alloc] initWithFrame:(CGRectZero)];
    
    self.smallScoreItem = [[BBOddsItemButton alloc] initWithFrame:(CGRectZero)];
    
    [self.itemArray addObjectsFromArray:@[self.awayWinItem,self.hostWinItem,self.letAwayWinItem,self.letHostWinItem,self.bigScoreItem,self.smallScoreItem]];
    
    
    
    CGFloat itemWidth = SL__SCALE(125.f);
    
    CGFloat itemHeight = tagHeight;
    
    int row,col = 0;
    
    for (int i = 0; i < 6; i ++) {
        
        
        row = i / 2;
        col = i % 2;
        
        //BBOddsItemButton *oddsItem = [[BBOddsItemButton alloc] initWithFrame:(CGRectMake(tagWidth + col * itemWidth, row * itemHeight,itemWidth, itemHeight))];
        
        BBOddsItemButton *oddsItem = self.itemArray[i];
        
        oddsItem.frame = CGRectMake(tagWidth + col * itemWidth, row * itemHeight,itemWidth, itemHeight);
        
        [oddsItem addTarget:self action:@selector(oddsItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self addSubview:oddsItem];
        
//        [self.itemArray addObject:oddsItem];
    }
    
    [self.itemArray enumerateObjectsUsingBlock:^(BBOddsItemButton *item, NSUInteger idx, BOOL * _Nonnull stop) {
       
        item.tag = [self.playMethodArray[idx] integerValue];
        
    }];
}

- (void)oddsItemClick:(BBOddsItemButton *)item
{

    item.selected = ! item.isSelected;
    
    NSString *selectTag = [NSString stringWithFormat:@"%zi",item.tag];
    
    if (item.isSelected == YES) {
       
//        if (item.tag == 1000 || item.tag == 1003) {
//            
//           [BBMatchInfoManager shareManager] saveSelectBetInfoWithMatchIssue:self.playMethodModel.match_issue palyMothed:self.playMethodDic[selectTag] selectItem:@[selectTag] isDanGuan:<#(BOOL)#> rangFenCount:<#(NSString *)#>
//        }
        
        
      [[BBMatchInfoManager shareManager] saveSelectBetInfoWithMatchIssue:self.playMethodModel.match_issue palyMothed:self.playMethodDic[selectTag] selectItem:@[selectTag] isDanGuan:YES];
        
    }else{
        
        [[BBMatchInfoManager shareManager] removeSelectBetInfoWithMatchIssue:self.playMethodModel.match_issue palyMothed:self.playMethodDic[selectTag] selectItem:@[selectTag]];
    }
    
    self.reloadUIBlock ? self.reloadUIBlock() : nil;
    
}

//- (void)drawRect:(CGRect)rect
//{
//
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
//    
//    path.lineWidth = 2;
//    path.lineCapStyle = kCGLineCapRound;
//    path.lineJoinStyle = kCGLineCapRound;
//    
//    UIColor *color = SL_UIColorFromRGB(0xECE5DD);
//    [color set];
//    
//    [path stroke];
//    
//}

- (void)setPlayMethodModel:(BBMatchModel *)playMethodModel
{

    _playMethodModel = playMethodModel;
    
    NSString *rangHostWinStr = [NSString stringWithFormat:@"让主胜%@",playMethodModel.rfsf.odds];
    
    NSString *smallScore = [NSString stringWithFormat:@"小于%@",playMethodModel.dxf.odds];
    
    NSString *bigScore = [NSString stringWithFormat:@"大于%@",playMethodModel.dxf.odds];
    
    NSArray *array = @[@{@"playName": @"主负",
                         @"odds": playMethodModel.sf.sp.loss ? playMethodModel.sf.sp.loss : @"0"},
                       @{@"playName": @"主胜",
                         @"odds": playMethodModel.sf.sp.win ? playMethodModel.sf.sp.win : @"0"},
                       @{@"playName": @"让主负",
                         @"odds": playMethodModel.rfsf.sp.loss ? playMethodModel.rfsf.sp.loss : @"0"},
                       @{@"playName": rangHostWinStr,
                         @"odds":playMethodModel.rfsf.sp.win ? playMethodModel.rfsf.sp.win : @"0"},
                       @{@"playName": bigScore,
                         @"odds": playMethodModel.dxf.sp.big ? playMethodModel.dxf.sp.big : @"0"},
                       @{@"playName": smallScore,
                         @"odds": playMethodModel.dxf.sp.small ? playMethodModel.dxf.sp.small : @"0" }
                       ];

    
    if (self.itemArray.count != array.count) return;
    
    [self.itemArray enumerateObjectsUsingBlock:^(BBOddsItemButton *itemButton, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary *dic = array[idx];
        
        [itemButton setPlayName:dic[@"playName"]];
        [itemButton setOdds:dic[@"odds"]];
    }];
 
    
    
}

- (void)setSelectedModel:(BBSeletedGameModel *)selectedModel
{

    _selectedModel = selectedModel;
    
    
    [self.itemArray makeObjectsPerformSelector:@selector(setSelected:) withObject:@NO];
    
    
    if ([selectedModel.sfInfo.selectPlayMothedArray containsObject:@"0"]) {
        
        self.awayWinItem.selected = YES;
    }else{
        self.hostWinItem.selected = NO;
    }
    
    if ([selectedModel.sfInfo.selectPlayMothedArray containsObject:@"3"]) {
        
        self.hostWinItem.selected = YES;
    }else{
        self.hostWinItem.selected = NO;
    }
    
    if ([selectedModel.sfInfo.selectPlayMothedArray containsObject:@"1000"]) {
        
        self.letAwayWinItem.selected = YES;
    }else{
        self.letAwayWinItem.selected = NO;
    }
    
    if ([selectedModel.sfInfo.selectPlayMothedArray containsObject:@"1003"]) {
        
        self.letHostWinItem.selected = YES;
    }else{
        self.letHostWinItem.selected = NO;
    }
    
    if ([selectedModel.sfInfo.selectPlayMothedArray containsObject:@"102"]) {
        
        self.bigScoreItem.selected = YES;
    }else{
        self.bigScoreItem.selected = NO;
    }
    
    if ([selectedModel.sfInfo.selectPlayMothedArray containsObject:@"101"]) {
        
        self.smallScoreItem.selected = YES;
    }else{
        self.smallScoreItem.selected = NO;
    }
    
}

#pragma mark ---- lazyLoad -----
- (NSArray *)tagArray
{

    if (_tagArray == nil) {
        
        _tagArray = @[@"胜负",@"让分",@"大小分",@"胜分差"];
    }
    return _tagArray;
}

- (NSArray *)playMethodArray
{

    if (_playMethodArray == nil) {
        
        _playMethodArray = @[@"0",@"3",@"1000",@"1003",@"102",@"101"];
    }
    return _playMethodArray;
}

- (NSDictionary *)playMethodDic
{

    if (_playMethodDic == nil) {
        
        _playMethodDic = @{@"0":@"sf",
                           @"3":@"sf",
                           @"1000":@"rfsf",
                           @"1003":@"rfsf",
                           @"102":@"dxf",
                           @"101":@"dxf"
                           };
    }
    return _playMethodDic;
}

- (NSMutableArray *)itemArray
{

    if (_itemArray == nil) {
        
        _itemArray = [NSMutableArray new];
    }
    return _itemArray;
}

@end
