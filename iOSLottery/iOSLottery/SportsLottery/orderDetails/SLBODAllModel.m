//
//  CQBODAllModel.m
//  caiqr
//
//  Created by huangyuchen on 16/7/27.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "SLBODAllModel.h"

#import "DisplayView.h"
#import "CQDefinition.h"
#import "CTUnit.h"
#import "CTFrameParserConfig.h"
#import "CTFrameParser.h"
#define SessionW (__SCALE(40)) //场次的宽度
#define PlayerW (__SCALE(90)) //比赛双方的宽度
#define GameW (__SCALE(75)) //玩法的宽度
#define BetW (__SCALE(75)) //投注内容的宽度
#define Max(a,b) a > b ? a : b //获取两数之间的大数

#define CellMinHeight (100)//暂定二级cell的最小高度
#pragma mark - 全部数据
@implementation SLBODAllModel
- (void)setBetMatchVos:(NSArray<CQBODProgrammeInfoModel *> *)betMatchVos
{
    _betMatchVos = [CQBODProgrammeInfoModel mj_objectArrayWithKeyValuesArray:betMatchVos];
    
}
- (void)setOrderMessageModel:(NSArray<SLBODOrderMessageModel *> *)orderMessageModel{
    _orderMessageModel = [SLBODOrderMessageModel mj_objectArrayWithKeyValuesArray:orderMessageModel];
}
- (void)setAwardStatusArr:(NSArray<SLBODOrderMessageModel *> *)awardStatusArr{
    _awardStatusArr = [SLBODOrderMessageModel mj_objectArrayWithKeyValuesArray:awardStatusArr];
}



@end

#pragma mark - 赛事信息
@implementation CQBODProgrammeInfoModel

- (void)setBetMaps:(NSArray<CQBODBettingInfoModel *> *)betMaps
{
    _betMaps = [CQBODBettingInfoModel mj_objectArrayWithKeyValuesArray:betMaps];
    //计算投注内容的总高度并返回
    self.programmeInfoHeight = [self calcuateProgrammeInfoHeight:_betMaps];
}

- (CGFloat)calcuateProgrammeInfoHeight:(NSArray<CQBODBettingInfoModel *> *)array{
    CGFloat height = 0;
    if ([array isKindOfClass:[NSArray class]] && array.count > 0) {
        //获取共有多少组投注内容
        NSInteger betCount = 0;
        for (CQBODBettingInfoModel *model in array) {
            if ([model isKindOfClass:[CQBODBettingInfoModel class]]) {
                height += model.bettingInfoHeight;
                betCount += model.betItem.count;
            }
        }
        //判断height 与 预设最低高度 大小
        //根据比赛双方内容计算高度
        //1.拼接字符串
        NSString *playerStr = [NSString stringWithFormat:@"%@\n%@\n%@", self.hostTeam,self.score,self.awayTeam];
        //2.计算label的高度
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSFontAttributeName] = FONT_FIX(12);//设置文字大小
        
        //创建NSMutableParagraphStyle实例
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        //设置行距
        [style setLineSpacing:__SCALE(5)];
        attrs[NSParagraphStyleAttributeName] = style;
        CGSize size = [playerStr boundingRectWithSize:CGSizeMake(PlayerW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        
        CGFloat playerMinHeight = size.height + __SCALE(20);
        if (height < playerMinHeight) {
            height = playerMinHeight;
            //修改投注详情中每一个model的高度
            NSInteger subHeight = height / betCount;
            for (CQBODBettingInfoModel *model in array) {
                model.bettingInfoHeight = model.betItem.count * subHeight;
            }
        }
    }
    return height;
}

@end


#pragma mark - 投注内容
@implementation CQBODBettingInfoModel
static CTFrameParserConfig *__config;
- (void)setBetItem:(NSArray *)betItem
{
    _betItem = betItem;
    //根据数组内容计算View高度 并赋值
    self.bettingInfoHeight = [self calculateBettingInfoHeightWithData:betItem];
}
- (CGFloat)calculateBettingInfoHeightWithData:(NSArray *)array{
    //计算投注内容的高度
    //1.首先获取投注内容项的高度
    NSString *str = [array componentsJoinedByString:@"\n"];
    NSMutableArray <__kindof CTUnit*> *content_units = [NSMutableArray new];
    CTUnit* unit = [[CTUnit alloc] init];
    unit.type = CTUnitTxtType;
    unit.content = str;
    [content_units addObject:unit];
    /** 创建绘制数据源 */
    CoreTextData *data = [CTFrameParser parserCTUnits:content_units config:[CQBODBettingInfoModel parserLeftConfig]];
    //2.计算 玩法高度 如果玩法的高度 高于投注项的高度则重新赋值
    //判断是否需要换行
    //1.先用#分隔 若数组大于1个，则说明有需要换行
    NSArray *playArr = [self.playTypeCn componentsSeparatedByString:@"#"];
    //2.拼接字符串
    NSString *playStr = [NSString new];
    if (playArr.count > 1) {
        playStr = [playArr componentsJoinedByString:@"\n"];
    }else{
        playStr = playArr[0];
    }
    //计算高度
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = FONT_FIX(12);
    
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
//    //设置行距
//    [style setLineSpacing:__SCALE(2)];
    
    //attrs[NSParagraphStyleAttributeName] = style;
    
    CGSize size = [playStr boundingRectWithSize:CGSizeMake(PlayerW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    CGFloat playHeight = size.height + __SCALE(20);
    if (playHeight > data.height) {
        return playHeight + 1.f;
    }else{
        return data.height + __SCALE(10) + 1.f + array.count * __SCALE(4);
    }
}

+ (CTFrameParserConfig*)parserLeftConfig
{
    @autoreleasepool {
        if (!__config) {
            __config = [[CTFrameParserConfig alloc] init];
        }
        
        __config.width = BetW;
        __config.lineSpace = 10.f;
        __config.fontSize = __SCALE(12.f);
        __config.textColor = [UIColor blackColor];
        __config.textAlignment = NSTextAlignmentCenter;
        return __config;
    }
}
@end


#pragma mark - 订单状态
@implementation CQBODAwardStatusModel



@end

#pragma mark - 订单信息（投注时间  截止时间等等）

@implementation SLBODOrderMessageModel

@end

#pragma mark - 头部视图的数据模型
@implementation SLBODHeaderViewModel

//- (void)setMoneyViewArr:(NSMutableArray<CQBODHeaderMoneyModel *> *)moneyViewArr{
//    
//    _moneyViewArr = [CQBODHeaderMoneyModel objectArrayWithKeyValuesArray:moneyViewArr];
//}

@end

#pragma mark - 头部视图中 金额 是否中奖 等数据
@implementation SLBODHeaderMoneyModel

@end


#pragma mark - 未中奖 信息

@implementation CQBODNotWinModel


@end

#pragma mark - 头部视图中 流程图数据
@implementation SLBODHeaderProcessModel

//- (void)setSubProcessArr:(NSArray<SLBODHeaderSubProcessModel *> *)subProcessArr{
//    
//    _subProcessArr = [SLBODHeaderSubProcessModel objectArrayWithKeyValuesArray:subProcessArr];
//    
//}

@end
#pragma mark - 单独一个视图的model
@implementation SLBODHeaderSubProcessModel


@end



