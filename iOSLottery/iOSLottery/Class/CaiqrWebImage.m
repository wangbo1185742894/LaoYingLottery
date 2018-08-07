//
//  CaiqrWebImage.m
//  iOSLottery
//
//  Created by 彩球 on 17/1/11.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CaiqrWebImage.h"
#import "SDWebImageManager.h"


@implementation CaiqrWebImage


+ (void) downloadImageUrl:(NSString*)urlString
                 progress:(void(^)(NSInteger receivedSize, NSInteger expectedSize))progress
                completed:(void(^)(UIImage *image,NSError *error, BOOL finished, NSURL *imageURL))completed {
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        progress ? progress(receivedSize,expectedSize) : nil;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        !completed ? : completed(image,error,finished,imageURL);
    }];
}



@end
