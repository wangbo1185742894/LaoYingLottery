//
//  UIImageView+CKWebImage.m
//  caiqr
//
//  Created by huangyuchen on 2017/5/4.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "UIImageView+CKWebImage.h"
#import "UIImageView+WebCache.h"
@implementation UIImageView (CKWebImage)
- (void)setImageWithURL:(NSURL *)url {
    [self setImageWithURL:url];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage {
    [self setImageWithURL:url placeholderImage:placeholderImage];
}

- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure {
    [self setImageWithURLRequest:urlRequest placeholderImage:placeholderImage success:success failure:failure];
}

- (void)setImageWithUrl:(NSURL*)url comlete:(void(^)(void))completeBlock
{
    [self sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error && image) {
            if (completeBlock) {
                completeBlock();
            }
        }
    }];
    
}
@end
