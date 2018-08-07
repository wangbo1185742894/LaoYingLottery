//
//  CKFOPAPI.h
//  caiqr
//
//  Created by 洪利 on 2017/4/27.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKBaseAPI.h"

@interface CKFOPAPI : CKBaseAPI
@property (nonatomic, assign) NSInteger timeOut;



//小额免密快捷设置
- (void)resetFreeOfPayWithisNeverNotify:(NSString *)never_notify
                                  quato:(NSString *)quato
                              iskaitong:(NSString *)isKaitong;



/** 小额免密设置状态查询 */
- (void)userReLate_CheckUserFreePayPWDQuotaListresponse;
@end
