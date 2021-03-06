//
//  CLLotteryBalancing.m
//  iOSLottery
//
//  Created by 彩球 on 17/2/25.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLLotteryBalancing.h"
#import "CLConfigAPIMessage.h"

@implementation CLLotteryBalancing

+ (instancetype)sharedBalancing {
    static CLLotteryBalancing *_sharedLotteryBalancing = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedLotteryBalancing = [[CLLotteryBalancing alloc] init];
        _sharedLotteryBalancing.urls = [_sharedLotteryBalancing setUpUrls];
        _sharedLotteryBalancing.privateKey = [_sharedLotteryBalancing setUpPrivateKey];
    });
    
    
    return _sharedLotteryBalancing;
}

- (NSArray*) setUpUrls {
    
    if (API_Environment == 1) {
        return @[@"https://lottery.laoyingcp.com"];
    }else if (API_Environment == 0){
        return @[@"http://lydev.caiqr.cn"];
    }else if (API_Environment == 2){
        return @[@"http://debug.laoyingcp.com"];
    }else if (API_Environment == 3){
        //return @[@"http://lottery.caiqr.cn"];
        return @[@"http://lydev.caiqr.cn"];
    }
}

- (NSString*) setUpPrivateKey {
    
//    return @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAMc/0snyoKR1mHrc5KhW+XrMQ3vcZPPXCrs+tsk0F6pEoxzFt44qU6yeiUaV+UhzfEhLWBdG2vDR+dDp4gyemo1EHwpDXXSO3y8Km5WlvfGKL1ze66eDAF+eUvL+ayqfVCNbc/gmFYPWNhVQah68tYPZez+TakOsu+IPvchHdtCTAgMBAAECgYEAmqSFhGnEloASvWEOMz112gIJamuvCrXfRV6yXU0KBQPKmT03bqaZVMOjBd7GoJ3JWw7nKwG6UeiWfLfZ0zOR/S2j2mB1rmS3S6h+/KRNMowVTzVZ1EJnljjZYUJUEwabWdslUfs49Vg39ZRXthc8Tf3ZGIphZnZiV3/DOTWoPCECQQDokExLze391phNVJCjg11hgixK0byFltPwkcUEoursgw+flI4tfc85soOhgvIexx3BhE35o6Vlb9W6WtU9hTpjAkEA21QUAN8L88lHGCOBqvvZXDrDvjybWkfbaIDkt8TE79bOqNEwtCKOYV7VsRIc8dQFI3MHWHgGWwWof/OPidVQEQJBAI2U234CvnKcpFfftbZ2EPF96C0chqLlcd2xQLpT3KVkHKzQKcZ0IyZDEXPQXkpyeiEHxNjH0bdxYDJ1fgBYDXUCQFW2ygp9IKKpaotYdPhpbEzK+myCKwRhSLHSjY/z6jMA88qt1ibPymzrLwAAYCdyAIAWGCzO20z/LRa0DMiFAMECQQC26sF3onHGQtVWTNPXSdZr3Rm/R3cV87QCywsrMGbZuqRQxL6XiraQqmRyi7LYnFvc23YMu4XevdaeFx1gnlGl";
    
    return @"MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC0d92PKDQhTRhZ0a9NC56URlz2RUTbPB9zh7bl8xODPcQ/AJFjf1OeNprBZua1QVPPHKSPGa+DucRtee1GhV5ncXL8skbmPL8vwScfHI5dLXl2agB0ovXfxbcuOmeO7Qn+poVjHDHmJjk2/xL0PIf5tXDI+6mcQZjtm449k6bYXxZW1dt9PZHfdOap1OwDsVSJUHQias0MRikwYdjOEPP+VRFTFdZWBIwe7w1akgerXdrtDSvekZd9poDxZUlT5Pl8nP1WH0PRbepCj6vH0EuQOsxOvCanTgctLdzfzaogQNljnZgm0ZgJYTrMZzLP9oaP59RsVxNv+cynXUq3L2X9AgMBAAECggEAaMwGbABTrVbgoh/ipWHu93mYuCXnY0wZk3Qm4Id0OE0g7dj9lIK24vQgj9iadnz2Fxox8StgQaUZjN01zTLbbER0GovIIiD6gNewSR/DCBbFJt9NXm3XS9e7lOuzgUri9+5pHPGdhGGD7gzXS97uszIKyZtilet9y9T+F4HrbE9prN6joZ3DT2wbIF+2EGodAXCU3JcBgqOYXCpOH9qi5apQcvuUPkJUU7EiRZ1TdPXwO/ju0oKfMlP4Ag4Ikq1GmGhCBvxbUnzuzFnS2N7BrzJSvW9EACOtoHf4QYIYEzFkqKZk+vtMm3GG1sPcv/6Apy19ZBbxFk5aD+vE5isEnQKBgQDb+9aTNYB2xmBcuh7YXwArzJ0FKEzwIJWmhdk6nGIQ3R0ye8rcN/bFweGXn58Xg02v6rPq1x+S5PFO2Ky6u4V8xRbae5oDzAvACl/eNY2LdW2fBuONoWSt14dGOdCqwrtU/Pwjmtpb4SWApS7VyKVz6Axn9LmU2tM+FBZd53kk7wKBgQDSA9D+AHBvUM7+dDWLtVHB6/WJB1DAC4vzVYljuxXcrUEcvRJiIl5YDSRzwRmVM8BoWCP5CVG0YV2eKxyQ7mwxMqGZOrXh5r+EUNDfrorsuvOx1vNysPtRVCj9CHcvX0mcF5x1s4KtNWxvBShsm9QGYatS11Wr92KY8jTDlxtb0wKBgQDATuxKTJ89NjbPWTXV2VcA8yLhe1WnJhUtOh2pC0T/kQ0RMP8qfRIR12grcLNXjsW/X+JhDibf95ysXObDZ2NOq81KunrtjtdGzsr4KsDOhZ2LRC5xhgHJp3zue2Rbo1i492BEj/8MC0sJp13GLl3VcapGxr3lz1aUEmNrPAu/qQKBgHh4i/hIlDamqja4vsaHmoCdNFoIgj/H394UIR2+ggn2sLUlmFgG0wu7bj+gc2ZtK2Avv2Lp/55zg9ppbJeOzS1jl+NoFFGjphTmrwrA+xxVGdnYLgqKj3/VwTV1F7lq9bS+rpeuA7YMQUlmMgwrT3Lhr/9zWsesvzhxJ+dS1PTVAoGAS3uTulKKTOZxPdcPUOE4vf7hQFLZ4Sek+uJdasG2we3/8JcWwVTVMjY8wf4bov65vM7f63vwNp9mu/3brTmMyxu3lD2MZhGegd3xw4rUKVpb/SvbJWEgkXmbtJzP9WS9xuHTl0NXjtoLopkqn/pn8sEQHJ6zDFw4xnWDsbEDl5Y=";
}

@end
