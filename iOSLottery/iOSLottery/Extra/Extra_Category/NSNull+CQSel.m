//
//  NSNull+CQSel.m
//  caiqr
//
//  Created by 彩球 on 16/10/12.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "NSNull+CQSel.h"
#import <objc/runtime.h>

/** @ id
 *  i int
 *  s short
 *  l long
 *  q longlong
 *  I unsigned int
 *  S unsigned short
 *  L unsigned long
 *  Q unsigned longlong
 *  f float
 *  d double
 *  B bool
 */

#define UXY_NullObjects @[@"",@0,@{},@[]]
#define CQ_Sel_ReturnTypes  {"@","i","s","l","q","I","S","L","Q","f","d","B"}
#define CQ_Sel_ReplaceMethodNames  {"nil","int","short","long","longlong","uint","ushort","ulong","ulonglong","float","double","boolean"}

@implementation NSNull (CQSel)

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature* signature = [super methodSignatureForSelector:aSelector];
    if (signature) return signature;
    
    for (id object in UXY_NullObjects) {
        
        signature = [object methodSignatureForSelector:aSelector];
        if (signature) {

            char *type[] = CQ_Sel_ReturnTypes;
            char *method[] = CQ_Sel_ReplaceMethodNames;
            
            Boolean __setSignFinish = false;
            for (int i = 0; i < (sizeof(type) / sizeof(type[0])); i++) {
                if (strcmp(type[i], signature.methodReturnType) == 0) {
                    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"__sel_%s",method[i]]);
                    signature = [[NSNull null] methodSignatureForSelector:sel];
                    __setSignFinish = true;
                    break;
                }
            }
            if (__setSignFinish)
                break;
        }
    }
    return signature;
}


- (void)forwardInvocation:(NSInvocation *)anInvocation
{
   
    char *type[] = CQ_Sel_ReturnTypes;
    char *method[] = CQ_Sel_ReplaceMethodNames;
    
    for (int i = 0; i < (sizeof(type) / sizeof(type[0])); i++) {
        if (strcmp(type[i], anInvocation.methodSignature.methodReturnType) == 0) {
            SEL sel = NSSelectorFromString([NSString stringWithFormat:@"__sel_%s",method[i]]);
            anInvocation.selector = sel;
            [anInvocation invokeWithTarget:self];
        }
    }
}


- (id)__sel_nil { return nil; }

- (int)__sel_int { return 0; }

- (short)__sel_short {  return 0; }

- (long)__sel_long {  return 0; }

- (long long)__sel_longlong {  return 0; }

- (unsigned int)__sel_uint { return 0; }

- (unsigned short)__sel_ushort {  return 0; }

- (unsigned long)__sel_ulong {  return 0; }

- (unsigned long long)__sel_ulonglong {  return 0; }

- (float)__sel_float {  return 0.f; }

- (double)__sel_double { return 0.f; }

- (BOOL)__sel_boolean { return NO; }

@end

