//
//  BBSeletedGameModel.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBSeletedGameModel.h"

@interface BBSeletedGameModel ()

@property (nonatomic, strong) NSDictionary *playMethodDic;

@end

@implementation BBSeletedGameModel

- (NSString *)getCreadOrderString
{
    NSMutableString *betString = [NSMutableString string];
    if (self.sfInfo && self.sfInfo.selectPlayMothedArray && self.sfInfo.selectPlayMothedArray.count) {
        
        NSArray *betResult = [self.sfInfo.selectPlayMothedArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2]; //升序
        }];
        
        [betString appendString:[betResult componentsJoinedByString:@"#"]];
        if (self.sfInfo.selectPlayMothedArray.count > 0) [betString appendString:@"#"];
    }
    if (self.sfcInfo && self.sfcInfo.selectPlayMothedArray && self.sfcInfo.selectPlayMothedArray.count) {
        
        NSArray *betResult = [self.sfcInfo.selectPlayMothedArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2]; //升序
        }];
        
        
        [betString appendString:[betResult componentsJoinedByString:@"#"]];
        if (self.sfcInfo.selectPlayMothedArray.count > 0) [betString appendString:@"#"];
    }
    if (self.dxfInfo && self.dxfInfo.selectPlayMothedArray && self.dxfInfo.selectPlayMothedArray.count) {
        
        NSArray *betResult = [self.dxfInfo.selectPlayMothedArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2]; //升序
        }];
        
        [betString appendString:[betResult componentsJoinedByString:@"#"]];
        if (self.dxfInfo.selectPlayMothedArray.count > 0) [betString appendString:@"#"];
    }
    if (self.rfsfInfo && self.rfsfInfo.selectPlayMothedArray && self.rfsfInfo.selectPlayMothedArray.count) {
        
        
        NSArray *betResult = [self.rfsfInfo.selectPlayMothedArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2]; //升序
        }];
        
        [betString appendString:[betResult componentsJoinedByString:@"#"]];
        if (self.rfsfInfo.selectPlayMothedArray.count > 0) [betString appendString:@"#"];
    }
    if (betString.length) {
        return [NSString stringWithFormat:@"%@:%@:0",self.matchIssue,[betString substringToIndex:betString.length - 1]];
        
    }else{
        return @"";
    }
    
}


- (NSString *)appStringToBetString:(NSArray *)betArr
{
    return @"";
}

//- (void)setOnePlayMethodWith:(BBSelectPlayMethodInfo *)info
//{
//
//    BBSelectPlayMethodInfo *onePlayMethod = self.playMethodDic[info.playMothed];
//    
//    
//    
//}
//
//- (BBSelectPlayMethodInfo *)sfInfo
//{
//
//    if (_sfInfo == nil) {
//        
//        _sfInfo = [[BBSelectPlayMethodInfo alloc] init];
//    }
//    return _sfInfo;
//}
//
//- (BBSelectPlayMethodInfo *)rfsfInfo
//{
//    
//    if (_rfsfInfo == nil) {
//        
//        _rfsfInfo = [[BBSelectPlayMethodInfo alloc] init];
//    }
//    return _rfsfInfo;
//}
//
//- (BBSelectPlayMethodInfo *)dxfInfo
//{
//    
//    if (_dxfInfo == nil) {
//        
//        _dxfInfo = [[BBSelectPlayMethodInfo alloc] init];
//    }
//    return _dxfInfo;
//}
//
//- (BBSelectPlayMethodInfo *)sfcInfo
//{
//    
//    if (_sfcInfo == nil) {
//        
//        _sfcInfo = [[BBSelectPlayMethodInfo alloc] init];
//    }
//    return _sfcInfo;
//}
//
//- (NSDictionary *)playMethodDic
//{
//
//    if (_playMethodDic == nil) {
//        
//        _playMethodDic = @{@"sf":self.sfInfo,
//                           @"rfsf":self.rfsfInfo,
//                           @"dxf":self.dxfInfo,
//                           @"sfc":self.sfcInfo};
//    }
//    return _playMethodDic;
//}


@end

@implementation BBSelectPlayMethodInfo



@end
