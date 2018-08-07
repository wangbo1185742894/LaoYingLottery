//
//  CLTwoImageButton.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/30.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLTwoImageButton : UIButton

@property (nonatomic, strong) UIImage *leftImage;
@property (nonatomic, strong) UIImage *rightImage;
@property (nonatomic, strong) UIImageView *mainImageView;
- (void)assignMianImageViewHidden:(BOOL)hidden;

@end
