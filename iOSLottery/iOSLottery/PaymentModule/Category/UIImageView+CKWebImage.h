//
//  UIImageView+CKWebImage.h
//  caiqr
//
//  Created by huangyuchen on 2017/5/4.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CKWebImage)

- (void)setImageWithURL:(NSURL *)url;

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage;

@end
