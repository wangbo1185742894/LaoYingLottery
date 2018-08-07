//
//  CKFOPAPI.m
//  caiqr
//
//  Created by 洪利 on 2017/4/27.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKFOPAPI.h"
#import "CKPayClient.h"
@interface CKFOPAPI ()

@property (nonatomic, strong) NSMutableDictionary *caiqrParams;

@end

@implementation CKFOPAPI


- (NSTimeInterval)requestTimeoutInterval{
    return self.timeOut;
}
- (NSDictionary *)ck_requestBaseParams{
    
    return self.caiqrParams;
}
/** 小额免密设置状态查询 */
- (void)userReLate_CheckUserFreePayPWDQuotaListresponse
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:2];
    [params setObject:@"small_secret_remind" forKey:@"cmd"];
    if([[CKPayClient sharedManager].intermediary token])[params setObject:[[CKPayClient sharedManager].intermediary token] forKey:@"token"];
    self.caiqrParams = params;
    
}
/**  小额免密快捷设置  */
- (void)resetFreeOfPayWithisNeverNotify:(NSString *)never_notify
                                  quato:(NSString *)quato
                              iskaitong:(NSString *)isKaitong{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:2];
    [params setObject:@"set_user_free_pay_pwd_quota" forKey:@"cmd"];
    [params setObject:[[CKPayClient sharedManager].intermediary token] forKey:@"token"];
    if ([isKaitong isEqualToString:@"0"]) {
        //不开通 只传token 是否点叉 是否不再提醒
        [params setObject:@"1" forKey:@"is_click"];
    }else{
        //开通 传 额度，免密开关
        [params setObject:quato forKey:@"free_pay_pwd_quota"];
        [params setObject:isKaitong forKey:@"free_pay_pwd_status"];
    }
    [params setObject:never_notify forKey:@"never_notify"];
    self.caiqrParams = params;
}
@end
