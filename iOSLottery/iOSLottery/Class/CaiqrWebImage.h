//
//  CaiqrWebImage.h
//  iOSLottery
//
//  Created by 彩球 on 17/1/11.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;
@interface CaiqrWebImage : NSObject

+ (void) downloadImageUrl:(NSString*)urlString
                 progress:(void(^)(NSInteger receivedSize, NSInteger expectedSize))progress
                completed:(void(^)(UIImage *image,NSError *error, BOOL finished, NSURL *imageURL))completed;

@end
