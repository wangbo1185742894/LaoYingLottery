//
//  CLPersonalMsgViewModel.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/22.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLPersonalMsgViewModel.h"
#import "NSString+Coding.h"
@implementation CLPersonalMsgViewModel

+ (CLPersonalMsgViewModel *) initHeadImage:(NSString*)headImgStr state:(NSString*)state canClick:(BOOL)click {
    
    CLPersonalMsgViewModel* vm = [CLPersonalMsgViewModel new];
    [vm setValue:@(YES) forKey:@"isHeadImgShow"];
    vm.headImgStr = headImgStr;
    vm.state = state;
    vm.canClicking = click;
    return vm;
}

+ (CLPersonalMsgViewModel *) initTitle:(NSString*)title content:(NSString*)content state:(NSString*)state canClick:(BOOL)click {
    
    CLPersonalMsgViewModel* vm = [CLPersonalMsgViewModel new];
    [vm setValue:@(NO) forKey:@"isHeadImgShow"];
    vm.title = title;
    vm.content = content;
    vm.state = state;
    vm.canClicking = click;
    return vm;
}

@end


@implementation CLPersonalMsgAPIModel

- (void)setNick_name:(NSString *)nick_name{
    
    _nick_name = [nick_name urlDecode];
}

@end
