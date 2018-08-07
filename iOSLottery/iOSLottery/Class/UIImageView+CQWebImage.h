//
//  UIImageView+CQWebImage.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/10.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CQWebImage)

- (void)setImageWithURL:(NSURL *)url;


- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage;


- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;

@end
