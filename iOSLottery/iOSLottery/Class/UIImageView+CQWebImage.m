//
//  UIImageView+CQWebImage.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/10.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "UIImageView+CQWebImage.h"
#import "UIImageView+AFNetworking.h"


@implementation UIImageView (CQWebImage)

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

@end
