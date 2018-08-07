//
//  BBMatchNewPlayMethodView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBMatchNewPlayMethodView.h"

#import "SLConfigMessage.h"

#import "BBPlayMethodTagLabel.h"

#import "BBOddsItemButton.h"

#import "BBMatchInfoManager.h"

#import "BBPlayMethodModel.h"

#import "SLExternalService.h"

#import "UILabel+SLAttributeLabel.h"

#import "BBNoSaleLabel.h"

@interface BBMatchNewPlayMethodView ()

@property (nonatomic, strong) BBPlayMethodTagLabel *tagLabel;

@property (nonatomic, strong) BBOddsItemButton *leftItem;

@property (nonatomic, strong) BBOddsItemButton *rightItem;

@property (nonatomic, strong) NSDictionary *playMethodDic;

@property (nonatomic, strong) BBNoSaleLabel *noSaleLabel;

@end

@implementation BBMatchNewPlayMethodView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        

        [self addSubview:self.tagLabel];
        [self addSubview:self.leftItem];
        [self addSubview:self.rightItem];
        [self addSubview:self.noSaleLabel];
        
    }
    return self;
}

- (void)layoutSubviews
{

    [super layoutSubviews];
    
    self.tagLabel.frame = CGRectMake(0, 0, SL__SCALE(40.f), SL__SCALE(40.f));
    
    self.leftItem.frame = CGRectMake(CGRectGetMaxX(self.tagLabel.frame), 0, SL__SCALE(125.f), SL__SCALE(40.f));
    
    self.rightItem.frame = CGRectMake(CGRectGetMaxX(self.leftItem.frame), 0, SL__SCALE(125.f), SL__SCALE(40.f));
    
    self.noSaleLabel.frame = CGRectMake(CGRectGetMaxX(self.tagLabel.frame), SL__SCALE(0), SL__SCALE(250.f), SL__SCALE(40.f));
}


- (void)itemButtonClick:(UIButton *)item
{

    
    if ([[BBMatchInfoManager shareManager] isCanSaveSelectBetInfoWithMatchIssue:self.playMethodModel.matchIssuse] == NO) {
        
        [SLExternalService showError:@"最多支持8场"];
        
        return;
        
    }
    
    item.selected = ! item.isSelected;
    
    NSString *selectTag = [NSString stringWithFormat:@"%zi",item.tag];
    
    if (item.isSelected == YES) {
        
        if (self.playMethodModel.isRangFen == YES) {
            
            [[BBMatchInfoManager shareManager] saveSelectBetInfoWithMatchIssue:self.playMethodModel.matchIssuse palyMothed:self.playMethodModel.playMethodName selectItem:@[selectTag] isDanGuan:self.playMethodModel.isDanGuan rangFenCount:self.playMethodModel.rangFenNumber];
            
        }else{
        
            [[BBMatchInfoManager shareManager] saveSelectBetInfoWithMatchIssue:self.playMethodModel.matchIssuse palyMothed:self.playMethodModel.playMethodName selectItem:@[selectTag] isDanGuan:self.playMethodModel.isDanGuan];
            
        }
        
        
    }else{
        
        [[BBMatchInfoManager shareManager] removeSelectBetInfoWithMatchIssue:self.playMethodModel.matchIssuse palyMothed:self.playMethodModel.playMethodName selectItem:@[selectTag]];
    }
    
    self.reloadUIBlock ? self.reloadUIBlock() : nil;

    
}


- (void)setPlayMethodModel:(BBPlayMethodModel *)playMethodModel
{

    _playMethodModel = playMethodModel;
    
    
    //设置未开售状态
    self.noSaleLabel.hidden = !(playMethodModel.isSale == 0);
    
    self.leftItem.tag = [playMethodModel.playMethodTag[0] integerValue];
    [self.leftItem setPlayName:playMethodModel.itemNameArray[0]];
    [self.leftItem setOdds:playMethodModel.oddsArray[0]];
    
    self.rightItem.tag = [playMethodModel.playMethodTag[1] integerValue];
    /** 兼容让分胜负玩法 */
    NSString *rightItemString = [NSString stringWithFormat:@"%@",playMethodModel.itemNameArray[1]];
    if ([rightItemString rangeOfString:@"_"].length) {
        
        NSArray *itemNameArr = [rightItemString componentsSeparatedByString:@"_"];
        NSString *itemStrig = [itemNameArr componentsJoinedByString:@""];
        UIColor *tagColor;
        if ([itemStrig rangeOfString:@"+"].length) {
            tagColor = SL_UIColorFromRGB(0xFC5548);
        // #00251E
        }else if([itemStrig rangeOfString:@"-"].length){
        // #2BC57C
            tagColor = SL_UIColorFromRGB(0x2bc57c);
        }
    
        [self.rightItem setAttributePlayName:itemStrig attributeArr:@[[SLAttributedTextParams attributeRange:[itemStrig rangeOfString:itemNameArr.lastObject] Color:tagColor]]];
    }else{
        
        [self.rightItem setPlayName:playMethodModel.itemNameArray[1]];
    }
    
    [self.rightItem setOdds:playMethodModel.oddsArray[1]];
    
    [self.tagLabel setTagText:self.playMethodDic[playMethodModel.playMethodName]];
    [self.tagLabel setShowTag:self.playMethodModel.isDanGuan];
    
}

- (void)setSelectedArray:(NSArray *)selectedArray
{
    
    NSString *leftTag = [NSString stringWithFormat:@"%zi",self.leftItem.tag];
    NSString *rightTag = [NSString stringWithFormat:@"%zi",self.rightItem.tag];

    if ([selectedArray containsObject:leftTag]) {
        
        self.leftItem.selected = YES;
        
    }else{
    
        self.leftItem.selected = NO;
    }
    
    if ([selectedArray containsObject:rightTag]) {
        
        self.rightItem.selected = YES;
        
    }else{
    
        self.rightItem.selected = NO;
    }
    
}


- (BBPlayMethodTagLabel *)tagLabel
{

    if (_tagLabel == nil) {
        
        _tagLabel = [[BBPlayMethodTagLabel alloc] init];
    }
    return _tagLabel;
}

- (BBOddsItemButton *)leftItem
{

    if (_leftItem == nil) {
        
        _leftItem = [[BBOddsItemButton alloc] initWithFrame:(CGRectZero)];
        
        [_leftItem addTarget:self action:@selector(itemButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _leftItem;
}



- (BBOddsItemButton *)rightItem
{

    if (_rightItem == nil) {
        
        _rightItem = [[BBOddsItemButton alloc] initWithFrame:(CGRectZero)];
        
        [_rightItem setShowRightLine:YES];
        
        [_rightItem addTarget:self action:@selector(itemButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _rightItem;
}

- (BBNoSaleLabel *)noSaleLabel
{
    
    if (_noSaleLabel == nil) {
        
        _noSaleLabel = [[BBNoSaleLabel alloc] init];
        
        _noSaleLabel.hidden = YES;
        
        [_noSaleLabel showButtomLine:NO];
    }
    return _noSaleLabel;
}

- (NSDictionary *)playMethodDic
{
    
    if (_playMethodDic == nil) {
        
        _playMethodDic = @{@"sf":@"胜负",
                           @"rfsf":@"让分",
                           @"dxf":@"大小分",
                           @"sfc":@"胜分差",
                           };
    }
    return _playMethodDic;
}


@end
