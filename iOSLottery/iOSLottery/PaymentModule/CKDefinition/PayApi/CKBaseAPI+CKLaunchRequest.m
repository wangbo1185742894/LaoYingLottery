//
//  NSObject+CKTestssss.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/5/5.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CKBaseAPI+CKLaunchRequest.h"
#import <objc/runtime.h>
#import "CLBaseRequest.h"
#import "CKPayClient.h"
@interface CKBaseAPI () <CLRequestCallBackDelegate>

@property (nonatomic, strong) id api_instance;
@property (nonatomic, strong) Class api_private_Class;

@end

@implementation CKBaseAPI (CKLaunchRequest)

#pragma mark -API_Instance

static char *ck_baseAPI_Instance = "ck_baseAPI_Instance";
-(void)setApi_instance:(id)api_instance{
    objc_setAssociatedObject(self, ck_baseAPI_Instance, api_instance, OBJC_ASSOCIATION_RETAIN);
}

- (id)api_instance{
    return objc_getAssociatedObject(self, ck_baseAPI_Instance);
}

#pragma mark -Delegate

static char *ck_baseAPIDelegateKey = "ck_baseAPIDelegateKey";
-(void)setDelegate:(id)delegate{
    
    objc_setAssociatedObject(self, ck_baseAPIDelegateKey, delegate, OBJC_ASSOCIATION_RETAIN);
}
- (id)delegate{
    return objc_getAssociatedObject(self, ck_baseAPIDelegateKey);
}

#pragma mark -Ck_api_private_ClassKey
static char *ck_api_private_ClassKey = "ck_api_private_ClassKey";

- (void)setApi_private_Class:(Class)api_private_Class {
    
    objc_setAssociatedObject(self, ck_api_private_ClassKey, api_private_Class, OBJC_ASSOCIATION_RETAIN);
}

- (Class)api_private_Class{
    return objc_getAssociatedObject(self, ck_api_private_ClassKey);
}


#pragma mark - Start

- (void)ck_startRequest {
    
    if (!self.api_instance) {
        
        NSString* custom_class_name = [NSString stringWithFormat:@"%@_CKBaseAPIClass",self.description];
        const char *class_name = [custom_class_name UTF8String];
        
        Class api_Class = objc_allocateClassPair([[CKPayClient sharedManager].intermediary ckInheritAPIClass], class_name, 0);
        
        IMP cus_imp = class_getMethodImplementation([self class], NSSelectorFromString(@"requestBaseParams"));
        
        class_addMethod(api_Class, NSSelectorFromString(@"requestBaseParams"), cus_imp, "@@:");
        self.api_private_Class = api_Class;
        objc_registerClassPair(api_Class);
        
        self.api_instance = [[api_Class alloc] init];
        [self.api_instance setValue:self.delegate forKey:@"delegate"];
        
        [self addStrPropertyForTargetClass:api_Class Name:@"ck_apiBase_private_Property"];
        
        [self.api_instance performSelector:NSSelectorFromString(@"setCk_private_class_instance:") withObject:self];
    
    }
    
    [self.api_instance performSelector:NSSelectorFromString(@"start")];
}

#pragma mark - Cancel

- (void)ck_cancelRequest {
    
    if (self.api_instance) {
        SEL cancalSel = NSSelectorFromString(@"cancel");
        [self.api_instance respondsToSelector:cancalSel];
        [self.api_instance performSelector:cancalSel];
    }
}

#pragma mark - 添加属性，并设置set get方法

- (void)addStrPropertyForTargetClass:(Class)targetClass Name:(NSString *)propertyName{
    objc_property_attribute_t type = { "T", [[NSString stringWithFormat:@"@\"%@\"",NSStringFromClass([NSObject class])] UTF8String] }; //type
    objc_property_attribute_t ownership0 = { "W", "" }; // C = copy
    objc_property_attribute_t ownership = { "N", "" }; //N = nonatomic
    objc_property_attribute_t backingivar  = { "V", [[NSString stringWithFormat:@"_%@", propertyName] UTF8String] };  //variable name
    objc_property_attribute_t attrs[] = { type, ownership0, ownership, backingivar };
    if (class_addProperty(targetClass, [propertyName UTF8String], attrs, 4)) {
//        NSLog(@"创建属性Property成功");
        objc_property_t property = class_getProperty(targetClass, [propertyName UTF8String]);
//        NSLog(@"%s %s", property_getName(property), property_getAttributes(property));
        
        class_addMethod(targetClass, @selector(ck_private_class_instance), (IMP)ck_nameGetter, "@@:");
        class_addMethod(targetClass, @selector(setCk_private_class_instance:), (IMP)ck_nameSetter, "v@:@");
    }
}

static NSString *ck_apiBase_private_class_keyName = @"ck_apiBase_private_class_nameKey";

NSString *ck_nameGetter(id self, SEL _cmd) {
    return objc_getAssociatedObject(self, &ck_apiBase_private_class_keyName);
}

void ck_nameSetter(id self, SEL _cmd, NSString *newName) {
    objc_setAssociatedObject(self, &ck_apiBase_private_class_keyName, newName, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - Method

//此方法用于添加至新创建子类中,并对此方法进行操作

- (NSDictionary*)requestBaseParams {
    
    id objc = [self performSelector:NSSelectorFromString(@"ck_private_class_instance")];
    return [objc performSelector:NSSelectorFromString(@"ck_requestBaseParams")];
}

- (void)dealloc {
    
    self.api_instance = nil;
    objc_disposeClassPair(self.api_private_Class);
}


@end
