//
//  CQBetODHeaderMoneyView.m
//  caiqr
//
//  Created by huangyuchen on 16/7/22.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "SLBetODHeaderMoneyView.h"
#import "SLBetODHeaderMoneySubView.h"
#import "CQDefinition.h"
#import "SLBODAllModel.h"
@interface SLBetODHeaderMoneyView ()

@property (nonatomic, strong) NSMutableArray<SLBODHeaderMoneyModel *> *dataSource;
@property (nonatomic, strong) SLBODHeaderViewModel *normalHeaderModel;
@property (nonatomic, strong) SLBetODHeaderMoneySubView *lastOneMoneySubView;
@property (nonatomic, strong) SLBetODHeaderMoneySubView *recordTimerSubView;
@end

@implementation SLBetODHeaderMoneyView

#pragma mark - 配置数据
- (void)assignHeaderMoneyWithData:(id)data{
    self.normalHeaderModel = data;
    //配置数据
    self.dataSource = [data moneyViewArr];
    //移除原有子View，防止重复添加，造成叠加
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //创建View
    [self createUI];
}
#pragma mark - 创建View
- (void)createUI{
    //根据dataSource的个数来确定子View的宽度
    CGFloat subViewWight = CGRectGetWidth(self.bounds) / self.dataSource.count;
    
    for (NSInteger i = 0; i < self.dataSource.count ; i++) {
        
        CGFloat subViewX = i * subViewWight;
        
        SLBetODHeaderMoneySubView *moneySubView = [[SLBetODHeaderMoneySubView alloc] initWithFrame:__Rect(subViewX, 0, subViewWight, CGRectGetHeight(self.bounds))];
        moneySubView.isFirstAllocView = self.isFirstAllocView;
        [moneySubView assignHeaderMoneyWithData:self.dataSource[i] HeaderType:self.dataSource[i].status];
        moneySubView.headerMoneyLineType = CQBODHeaderMoneyLineTypeLine;
        if (i == self.dataSource.count - 1) {
            moneySubView.headerMoneyLineType = CQBODHeaderMoneyLineTypeNone;
            
        }
        if (self.continuePayBlock) {
            self.recordTimerSubView = moneySubView;
            moneySubView.continuePayBlock = self.continuePayBlock;
        }else{
            moneySubView.continuePayBlock = nil;
        }
        if (self.awarImageViewCilck) {
            moneySubView.awardImageViewClick = self.awarImageViewCilck;
        }else{
            moneySubView.awardImageViewClick = nil;
        }
        if (self.notWinImageViewClick) {
            moneySubView.notWinImageViewClick = self.notWinImageViewClick;
            self.lastOneMoneySubView = moneySubView;
        }else{
            moneySubView.notWinImageViewClick = nil;
        }
        
        [self addSubview:moneySubView];
    }
    
}


#pragma mark - 重置图片 停止动画
- (void)resetImageAndStatus:(NSString *)dyImage bgImage:(NSString *)bgImage{
    [self.lastOneMoneySubView resetImageAndStatus:dyImage bgImage:bgImage];
}

- (void)stopTimer{
    
    if (self.recordTimerSubView) {
        [self.recordTimerSubView stopTimer];
    }
}

#pragma mark - getterMothed
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
@end
