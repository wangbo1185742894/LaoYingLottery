//
//  CKFOPService.m
//  caiqr
//
//  Created by 洪利 on 2017/4/27.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKFOPService.h"
#import "CKFOPAlertViewController.h"
#import "CKFOPModel.h"
#import "CKPayClient.h"
#import "CKFOPAPI.h"
#import "CKBaseAPI+CKLaunchRequest.h"
@interface CKFOPService ()<CLRequestCallBackDelegate>

@property (nonatomic, strong) CKFOPAPI *request;
@property (nonatomic, copy) void (^ checkComplete)(id obj);
@property (nonatomic, strong) NSString *requestTimeOutOrHasResult;//请求有结果或者超时  1 超时 2 已返回
@end


@implementation CKFOPService

+ (instancetype)allocWithWeakViewController:(UIViewController *)weakViewController{
    CKFOPService *selfService = [[CKFOPService alloc] init];
    selfService.weakSelfViewController = weakViewController;
    
    return selfService;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)cancelRequest{
    if ([self.requestTimeOutOrHasResult isEqualToString:@"1"]) {
        //请求结果尚未返回
        [self.request ck_cancelRequest];
        !self.checkComplete?:self.checkComplete(nil);
    }else if([self.requestTimeOutOrHasResult isEqualToString: @"2"]){
        //请求已经有结果 不取消请求
        
    }
}

//内部调用
- (void)isAlreadyFreeOfPayService:(void (^)(id obj))complete{
//    self.request.timeOut = 2.0;
    self.checkComplete = complete;
    if (self.isNeedShowAlter) {
        [self performSelector:@selector(cancelRequest) withObject:nil afterDelay:2.0f];
        [self.request userReLate_CheckUserFreePayPWDQuotaListresponse];
        [[CKPayClient sharedManager].intermediary startLoading];
        [self.request start];
        self.requestTimeOutOrHasResult = @"1";
    }else{
        self.checkComplete?self.checkComplete(nil):nil;
    }
}
//外部调用
+ (void)isAlreadyFreeOfPayServiceIfNeedPassword:(BOOL)isNeedPassword weakViewController:(UIViewController *)weakViewController block:(void (^)(id))complete{}

- (void)resetFreeOfPayWithisNeverNotify:(NSString *)never_notify
                                  quato:(NSString *)quato
                              iskaitong:(NSString *)isKaitong
                               complete:(void (^)(id obj))complete{
    self.checkComplete = complete;
    [self.request resetFreeOfPayWithisNeverNotify:never_notify quato:quato iskaitong:isKaitong];
    [[CKPayClient sharedManager].intermediary startLoading];
    [self.request start];
    
}



#pragma mark - RequestDelegate

/** 请求成功 */
- (void)requestFinished:(CLBaseRequest *)request{
    [[CKPayClient sharedManager].intermediary stopLoading];
    self.requestTimeOutOrHasResult = @"2";
    if (request.urlResponse.success) {
        //        request.urlResponse.resp
        if (request.urlResponse.resp && [request.urlResponse.resp count]){
            
            self.checkComplete?self.checkComplete(request.urlResponse.resp):nil;
        }
        return;
    }else{
        [[CKPayClient sharedManager].intermediary showError:request.urlResponse.errorMessage];
    }
    self.checkComplete?self.checkComplete(nil):nil;
    
}

/** 请求失败 */
- (void)requestFailed:(CLBaseRequest *)request{
    self.requestTimeOutOrHasResult = @"2";
    self.checkComplete?self.checkComplete(nil):nil;
    [[CKPayClient sharedManager].intermediary showError:request.urlResponse.errorMessage];
    [[CKPayClient sharedManager].intermediary stopLoading];
}

- (CKFOPAPI *)request
{
    if (!_request) {
        _request = [[CKFOPAPI alloc] init];
        _request.delegate = self;
    }
    return _request;
}

@end
