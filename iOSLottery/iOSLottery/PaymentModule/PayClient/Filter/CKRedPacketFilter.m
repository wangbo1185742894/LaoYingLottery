//
//  CKRedPacketFilter.m
//  iOSLottery
//
//  Created by 彩球 on 17/4/13.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CKRedPacketFilter.h"


@interface CKRedPacketFilter ()


@property (nonatomic, strong) NSMutableArray* indexArray; //红包id顺序索引

@property (nonatomic, strong) NSMutableArray<id<CKRedPacketDataSourceInterface>> *sourceArray;  //源红包数组

@property (nonatomic, strong) NSMutableDictionary* sourceDict; //源红包数据字典

@property (nonatomic, strong) NSMutableDictionary* uiDict;  //红包UI字典

@property (nonatomic, strong) Class uiClass;

@end

@implementation CKRedPacketFilter

- (instancetype) initWithpacketUISource:(Class)UIClass
                               delegate:(id<CKRedPacketFilterDelegate>)delegate; {
    
    self = [super init];
    if (self) {
        //拷贝数据源
        self.sourceArray = [NSMutableArray new];
        self.indexArray = [NSMutableArray arrayWithCapacity:self.sourceArray.count];
        self.sourceDict = [NSMutableDictionary dictionaryWithCapacity:self.sourceArray.count];
        self.uiDict = [NSMutableDictionary dictionaryWithCapacity:self.sourceArray.count];
        self.delegate = delegate;
        self.uiClass = UIClass;
        
    }
    return self;
}

- (void) initDataAndUISource
{
    [self.sourceArray enumerateObjectsUsingBlock:^(id<CKRedPacketDataSourceInterface> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //初始化id索引
        [self.indexArray addObject:[obj redPacketFid]];
        //源数据map
        [self.sourceDict setObject:obj forKey:[obj redPacketFid]];
        //ui数据map
        id<CKRedPacketUISourceInterface> uiSource = [[self.uiClass alloc] init];
        [uiSource viewModelConfigWithSource:obj];
        [self.uiDict setObject:uiSource forKey:[obj redPacketFid]];
        
        //配置默认选择项
        if ([obj defaultSelected]) {
            _cntSelectRedFid = [obj redPacketFid];
            _electedRedPacketStatus = (![_cntSelectRedFid isEqualToString:@"-1"]);
            
        }
        
    }];
    
    //创建最后一个例外情况 - 仅设置索引与UImap  不添加至源数据map
    id<CKRedPacketUISourceInterface> uiSource = [[self.uiClass alloc] init];
    if ([uiSource respondsToSelector:@selector(identifierViewModelCreatedLastest)]) {
        NSString* identifier = [uiSource identifierViewModelCreatedLastest];
        [self.indexArray addObject:identifier];
        [self.uiDict setObject:uiSource forKey:identifier];
    } else {
        uiSource = nil;
    }
    
//    [self callBack];
}


- (void)clearAllSource
{
    [self.sourceArray removeAllObjects];
    [self.indexArray removeAllObjects];
    [self.sourceDict removeAllObjects];
    [self.uiDict removeAllObjects];
}

#pragma mark - call back

- (void) callBack {
    
    if ([self.delegate respondsToSelector:@selector(redPacketFinishFilter:)]) {
        [self.delegate redPacketFinishFilter:self];
    }
}


#pragma mark - setter

- (void)setRedSource:(NSArray<id<CKRedPacketDataSourceInterface>> *)redSource {
    
    [self clearAllSource];
    if (redSource || redSource.count > 0) {
        [self.sourceArray addObjectsFromArray:[redSource mutableCopy]];
        [self initDataAndUISource];
    } else {
        [self callBack];
    }
    
}


- (void)setCntSelectRedFid:(NSString *)cntSelectRedFid {
    
    if (_cntSelectRedFid == cntSelectRedFid) return; //id相同
    if (![self.indexArray containsObject:cntSelectRedFid]) return; //列表中暂无此ID
    
    //恢复原数据选择状态
    [self changeRedPacketSelectedState:NO redPacketFid:_cntSelectRedFid];
    _cntSelectRedFid = cntSelectRedFid;
    
    //设置现有数据选择状态
    [self changeRedPacketSelectedState:YES redPacketFid:_cntSelectRedFid];
    
    _electedRedPacketStatus = (![_cntSelectRedFid isEqualToString:@"-1"]);

    [self callBack];
}

/* 修改红包选择状态  仅修改UISource */
- (void)changeRedPacketSelectedState:(BOOL)state redPacketFid:(NSString*)fid {
    
    if ([self.indexArray containsObject:fid]) {
        //fid存在
        id <CKRedPacketUISourceInterface> ui = [self.uiDict objectForKey:fid];
        if ([ui respondsToSelector:@selector(changeSelectState:)]) {
            [ui changeSelectState:state];
        }
    }
}


#pragma mark - getter

- (NSArray *) uiList {
    
    return [self.indexArray copy];
}

- (NSDictionary *) sourceRedPacketDictionary {
    return [self.sourceDict copy];
}

- (NSDictionary *) uiRedPacketDictionary {
    return [self.uiDict copy];
}


@end
