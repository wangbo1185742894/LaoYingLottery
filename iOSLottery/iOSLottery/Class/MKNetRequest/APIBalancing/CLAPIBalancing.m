//
//  CLAPIBalancing.m
//  iOSLottery
//
//  Created by 彩球 on 17/2/25.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLAPIBalancing.h"



@implementation CLAPIBalancing

- (NSString *)apiUrl {
    
    if (_apiUrl && (_apiUrl.length > 0)) return _apiUrl;
    
    [self randomKeyUrl];
    return _apiUrl;
}

- (void) switchKeyUrl {
    
    if (_urls && _apiUrl && _urls.count > 0) {
        
        NSInteger idx = [_urls indexOfObject:_apiUrl];
        _apiUrl = [_urls objectAtIndex:((idx + 1) % _urls.count)];
    }
}

- (void) randomKeyUrl {
    
    //若当前存在可用api,不进行随机 return
    if ([_apiUrl isKindOfClass:NSString.class] && _apiUrl.length > 0) return;
    //urls池不存在或无内容，return
    if (!_urls || (_urls.count == 0)) return;
    
    int idx = arc4random() % _urls.count;
    _apiUrl = _urls[idx];
}

@end
