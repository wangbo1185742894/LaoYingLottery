//
//  PZAppNetAPIClient.m
//  caiqr
//
//  Created by Apple on 14/12/20.
//  Copyright (c) 2014年 Paul. All rights reserved.
//

#import "CLAppNetAPIClient.h"


@implementation CLAppNetAPIClient


+ (instancetype)sharedClient {
    static CLAppNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[CLAppNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        //设置默认请求超时时间
        [_sharedClient.requestSerializer setTimeoutInterval:9.0f];
        
        //配置基础信息
        [_sharedClient configApiClient];
        
        //以下为修改 content_Type属性
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain", nil];

    });
    
    return _sharedClient;
}

#pragma mark - supple hook

//配置请求单例相关信息 (可支持hook)
- (void) configApiClient {
    

}

#pragma mark - Setter SSL Mode

- (void)setSecurityPolicyPinningMode:(MKSSLPinningMode)securityPolicyPinningMode {
    
    if (MKSSLPinningModeNone == securityPolicyPinningMode) {
        self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    } else if (MKSSLPinningModeCertificate == securityPolicyPinningMode) {
        self.securityPolicy = [CLAppNetAPIClient customSecurityPolicy];
    } else if (MKSSLPinningModePublicKey == securityPolicyPinningMode) {
        
    }
    _securityPolicyPinningMode = securityPolicyPinningMode;
}

/**
 *  init PolicyPinningMode is CertificatesMode 
 */

+ (AFSecurityPolicy *)customSecurityPolicy
{
    //先导入证书，找到证书的路径
    //    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"apicn2" ofType:@"cer"];
    //    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    //AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[AFSecurityPolicy certificatesInBundle:[NSBundle mainBundle]]];
    
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = YES;
    return securityPolicy;
}



@end
