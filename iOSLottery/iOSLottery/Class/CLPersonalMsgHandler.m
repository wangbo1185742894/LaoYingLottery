//
//  CLPersonalMsgHandler.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/22.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLPersonalMsgHandler.h"
#import "CLPersonalMsgViewModel.h"
#import "CLAppContext.h"
#import "CLUserBaseInfo.h"
#import "NSString+NSFormat.h"
#import "CQDefinition.h"
@interface CLPersonalMsgHandler ()

@property (nonatomic, strong) CLPersonalMsgAPIModel* apiResult;
@property (nonatomic, strong) NSMutableArray* resultArrays;
@end

@implementation CLPersonalMsgHandler

+ (CLPersonalMsgHandler *) sharedPersonal
{
    static CLPersonalMsgHandler *sharedPersonalMessageInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedPersonalMessageInstance = [[self alloc] init];
    });
    return sharedPersonalMessageInstance;
}



- (void) updatePersonalMesssageFrom:(NSDictionary*)dict{
    
    //处理数据时  同步更新appContext中个人信息内容
    
    self.apiResult = [CLPersonalMsgAPIModel mj_objectWithKeyValues:dict];
    
    [CLAppContext context].userMessage.user_info.head_img_url = self.apiResult.head_img_url;
    [CLAppContext context].userMessage.user_info.nick_name = self.apiResult.nick_name;
    if (self.resultArrays && self.resultArrays.count > 0) {
        [self.resultArrays removeAllObjects];
    }
    
    NSMutableArray* firstSectionArray = [NSMutableArray arrayWithCapacity:0];
    //屏蔽 头像修改次数限制
    //NSString* head_string = (apiResult.change_head_img_times > 0)?[NSString stringWithFormat:@"还可修改%zi次",apiResult.change_head_img_times]:@"暂无修改次数";
    CLPersonalMsgViewModel* headVM = [CLPersonalMsgViewModel initHeadImage:self.apiResult.head_img_url state:@"" canClick:YES];
    [firstSectionArray addObject:headVM];
    
    //屏蔽 头像修改次数限制
    //NSString* nickNameString = (apiResult.change_nick_name_times > 0)?[NSString stringWithFormat:@"还可修改%zi次",apiResult.change_nick_name_times]:@"无修改机会";
    CLPersonalMsgViewModel* nickVM = [CLPersonalMsgViewModel initTitle:@"昵称:" content:self.apiResult.nick_name state:@"" canClick:YES];
    [firstSectionArray addObject:nickVM];
    
//    [firstSectionArray addObject:[CLPersonalMsgViewModel initTitle:@"第三方账号" content:@"" state:@"" canClick:YES]];
    [firstSectionArray addObject:[CLPersonalMsgViewModel initTitle:@"手机:" content:[self.apiResult.mobile stringByReplacingEachCharactersInRange:NSMakeRange(3, 4) withString:@"*"] state:@"" canClick:NO]];
    
    [self.resultArrays addObject:firstSectionArray];
    
    
    
    if (DEFAULTS(bool, @"bet_limit_status")) {
        NSMutableArray* secoundSectionArray = [NSMutableArray arrayWithCapacity:0];
        
        [secoundSectionArray addObject:[CLPersonalMsgViewModel initTitle:@"实名信息" content:@"" state:@"" canClick:YES]];
        
        [secoundSectionArray addObject:[CLPersonalMsgViewModel initTitle:@"银行卡" content:@"" state:[NSString stringWithFormat:@"%zi",self.apiResult.bound_count] canClick:YES]];
        [self.resultArrays addObject:secoundSectionArray];
    }
    
}

+ (NSArray *)personalMessage {
    
    return [CLPersonalMsgHandler sharedPersonal].resultArrays;
}

+ (NSString *)personalHeadImgStr {
    
    return [CLAppContext context].userMessage.user_info.head_img_url;
}

+ (NSString *)personalNickName {
    
    return [CLAppContext context].userMessage.user_info.nick_name;
}

+ (NSString *)personalMobile {
    
    return [CLPersonalMsgHandler sharedPersonal].apiResult.mobile;
}

+ (NSString *)personalRealName {
    
   return [CLAppContext context].userMessage.user_info.real_name;
}
+ (NSString *)personalIdCardNo {
    
    return [CLAppContext context].userMessage.user_info.card_code;
}

+ (BOOL) identityAuthentication {
    
    NSString *realName = [CLPersonalMsgHandler personalRealName];
    NSString *idCard = [CLPersonalMsgHandler personalIdCardNo];
    
    return ([realName isKindOfClass:NSString.class] &&
            (realName.length > 0) &&
            [idCard isKindOfClass:NSString.class] &&
            (idCard.length > 0));
}

+ (void) updateIdentityAuthenForRealName:(NSString*)realName idCard:(NSString*)idCard {
    
    [CLAppContext context].userMessage.user_info.real_name = realName;
    [CLAppContext context].userMessage.user_info.card_code = idCard;
}

#pragma mark - getter

- (NSMutableArray *)resultArrays {
    
    if (!_resultArrays) {
        _resultArrays = [NSMutableArray new];
    }
    return _resultArrays;
}

@end
