//
//  CQLabelButtonImageView.h
//  caiqr
//
//  Created by huangyuchen on 16/8/7.
//  Copyright © 2016年 Paul. All rights reserved.
//

//带有label button imageView的View

#import <UIKit/UIKit.h>

@interface CQLabelButtonImageView : UIView

@property (nonatomic, strong) NSString *labelText;

@property (nonatomic, strong) UIFont *labelTextFont;

@property (nonatomic, strong) NSString *buttonText;

@property (nonatomic, strong) UIColor *buttonTextColor;

@property (nonatomic, strong) UIImage *contentImage;

@property (nonatomic, assign) UIControlContentHorizontalAlignment contentButtonHorizontalAlignment;

@property (nonatomic, copy) void (^contentBtnBlock)();

@end
