//
//  CQCommonAlterControl.m
//  caiqr
//
//  Created by 洪利 on 2017/3/29.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CQCommonAlterControl.h"
#import "CQCommonAlterConfigModel.h"


@interface CQCommonAlterControl ()

@property (nonatomic, strong) NSMutableArray *alertGlobalArray;//全局弹窗存放队列
@property (nonatomic, strong) NSMutableDictionary *alterDataDic;//弹窗基本数据队列

@property (nonatomic, strong) NSString *nowExecutedDataKey;//当前活跃状态的VC
@property (nonatomic, assign) BOOL isOnExecuted;//队列是否正在被执行

//用于锁定手动实现加载的弹窗
@property (nonatomic, copy) NSMutableDictionary *alterViewDelegaterHashLish;//弹窗实例表，存储代理对象
@end




@implementation CQCommonAlterControl
static CQCommonAlterControl *control = nil;
+ (instancetype)sharedCommonControl{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        control = [[CQCommonAlterControl alloc] init];
        control.isOnExecuted = NO;
    });
    return control;
}


#pragma mark - Delegate
//弹窗 被关闭
- (void)alterClosed:(id)alterInfo{
    NSLog(@"弹窗 %@ 被关闭", alterInfo);
    [self remveDelegater:alterInfo];
    self.isOnExecuted = NO;
    //开始执行队列
    [self startShowAlters:self.nowExecutedDataKey];
    
}

//控制器viewWillAppear
- (void)viewControllerWillExecuteWillAppear:(id)viewController{
    NSLog(@"控制器 %@ 即将展示", viewController);
    //将要展示时 检验当前即将显示的vc的窗是否未弹完，是则继续
    if (viewController && [self.alterDataDic[viewController] count]) {
        [self startShowAlters:viewController];
    }
}
////控制器viewWillDisppear
//- (void)viewControllerWillExecuteWillDisappear:(id)viewController{
//    NSLog(@"控制器 %@ 即将消失", viewController);
//    //将要消失 标记队列停止
//    if ([viewController isEqualToString:self.nowExecutedDataKey]) {
//        self.isOnExecuted = NO;
//    }
//}





#pragma mark- 弹窗注册
//VC发起的注册弹框
- (void)addAlterWithArray:(NSArray *)array withController:(NSString *)controllerName{
    //注册即开始 展示
    [self reorderCacheData:array controllerName:controllerName];
    [self startShowAlters:controllerName];
}


//全局弹窗注册
- (void)addGlobalAlertWithArray:(NSArray *)array{
    [self.alertGlobalArray addObjectsFromArray:array];
    if (self.isOnExecuted) {
        [self reorderCacheData:self.alertGlobalArray controllerName:self.nowExecutedDataKey];
    }
}

#pragma mark - 展示队列中的弹窗
//开始执行
- (void)startShowAlters:(NSString *)controllerName{
    
    if (!controllerName) return;
    //push 或 present 新的VC
    if (![controllerName isEqualToString:self.nowExecutedDataKey]) {
        self.isOnExecuted = NO;
    }
    //正在执行 越过本次请求
    if (self.isOnExecuted) {
        return;
    }
    if ([self.alterDataDic[controllerName] count]>0) {
        
        //标记当前活跃状态的VC
        self.nowExecutedDataKey = controllerName;
        //取出弹窗模型
        CQCommonAlterConfigModel *model = [self.alterDataDic[controllerName] firstObject];
        
        //展示
        if (model.showStyle == CQAlertViewShowStyleDefault) {
            self.isOnExecuted = YES;
            //选择交由control 实现添加弹窗
            [model.superView performSelector:@selector(addSubview:) withObject:model.alertView];
        }else if(model.showStyle == CQAlertViewShowStyleBySelf){
            //选择自己实现添加逻辑
            [self getDelegater:model.alertViewClassName];
            if ([self.alertViewShowDelegate respondsToSelector:@selector(alertCanShowAtTheMoment)]) {
                [self.alertViewShowDelegate alertCanShowAtTheMoment];
                [self remveDelegater:model.showStyle == CQAlertViewShowStyleDefault?NSStringFromClass([model.alertView class]):model.alertViewClassName];
                self.isOnExecuted = YES;
            }else{
                NSLog(@"----------------------------------------\n      %@ 的弹窗选择了自己实现添加逻辑但是却未响应——alertCanShowAtTheMoment方法来添加 既然弹窗为空或者未实现认为你自动放弃本次加载   ----------------------\n    ",NSStringFromClass([model.alertView class]));
                [self remveDelegater:model.showStyle == CQAlertViewShowStyleDefault?NSStringFromClass([model.alertView class]):model.alertViewClassName];
                //移除
                [self removeAlertWithObject:model];
                self.isOnExecuted = NO;
                //进行下一次加载
                [self startShowAlters:self.nowExecutedDataKey];
            }
        }
        //移除
        [self removeAlertWithObject:model];
        
    }else{
        //标记队列处于闲置状态
        self.isOnExecuted = NO;
        [self.alterDataDic removeObjectForKey:controllerName];
        NSLog(@"%@ 所注册的弹窗已全部加载完毕", self.nowExecutedDataKey);
    }
}



//从队列中移除已经被展示的弹窗
- (void)removeAlertWithObject:(CQCommonAlterConfigModel *)model{
    if ([self.alertGlobalArray containsObject:model]) {
        [self.alertGlobalArray removeObject:model];
    }
    for (NSString *key in [self.alterDataDic allKeys]) {
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        [tempArr addObjectsFromArray:self.alterDataDic[key]];
        if ([tempArr containsObject:model]) {
            [tempArr removeObject:model];
        }
        [self.alterDataDic removeObjectForKey:key];
        [self.alterDataDic setObject:tempArr forKey:key];
    }
}

#pragma mark - 队列内容排序
//队列预缓存数据排序
- (void)reorderCacheData:(NSArray *)arr controllerName:(NSString *)controllerName{
    
    NSMutableArray *newDataArr = [[NSMutableArray alloc] init];
    [newDataArr addObjectsFromArray:self.alertGlobalArray];
    [newDataArr addObjectsFromArray:arr];
    //将全局队列内的弹窗添加进来
    //检索队列中是否已有该controllerName对应的
    if (self.alterDataDic[controllerName]) {
        //存在
        [newDataArr addObjectsFromArray:self.alterDataDic[controllerName]];
    }
    //按照option排序
    NSArray *orderByOptionArray = [newDataArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CQCommonAlterConfigModel *pModel1 = obj1;
        CQCommonAlterConfigModel *pModel2 = obj2;
        if (pModel1.option < pModel2.option) {
            return NSOrderedDescending;//降序
        }else if (pModel1.option > pModel2.option){
            return NSOrderedAscending;//升序
        }else {
            return NSOrderedSame;//相等
        }
    }];
    [self.alterDataDic removeObjectForKey:controllerName];
    [self.alterDataDic setObject:orderByOptionArray forKey:controllerName];

}

#pragma mark - 代理对象表
- (void)getDelegater:(NSString *)delegaterClassName{
    self.alertViewShowDelegate = self.alterViewDelegaterHashLish[delegaterClassName];
}

- (void)addAlertDelegater:(id)delegater{
    if (!self.alterViewDelegaterHashLish[NSStringFromClass([delegater class])]) {
        [self.alterViewDelegaterHashLish setObject:delegater forKey:NSStringFromClass([delegater class])];
        NSLog(@"代理对象 %@ 保存成功", NSStringFromClass([delegater class]));
    }
}

- (void)remveDelegater:(NSString *)delegaterClassName{
    [self.alterViewDelegaterHashLish removeObjectForKey:delegaterClassName];
}













#pragma getter method
- (NSMutableDictionary *)alterViewDelegaterHashLish{
    if (!_alterViewDelegaterHashLish) {
        _alterViewDelegaterHashLish = [[NSMutableDictionary alloc] init].mutableCopy;
    }
    return _alterViewDelegaterHashLish;
}
- (NSMutableDictionary *)alterDataDic{
    if (!_alterDataDic) {
        _alterDataDic = [[NSMutableDictionary alloc] init];
    }
    return _alterDataDic;
}
- (NSMutableArray *)alertGlobalArray{
    if (!_alertGlobalArray) {
        _alertGlobalArray = [[NSMutableArray alloc] init];
    }
    return _alertGlobalArray;
}

@end
