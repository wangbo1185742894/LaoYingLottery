//
//  CQHeadImgCollectionViewCell.m
//  caiqr
//
//  Created by 彩球 on 15/9/17.
//  Copyright (c) 2015年 Paul. All rights reserved.
//

#import "CQHeadImgCollectionViewCell.h"
#import "CLConfigMessage.h"
#import "UIImageView+CQWebImage.h"

@implementation CQHeadImgCollectionViewCell


- (void)setHeadImgUrl:(NSString *)headImgUrl
{
    [self.headImageView setImageWithURL:[NSURL URLWithString:headImgUrl]];
}

- (void)setHeadImgSelect:(BOOL)headImgSelect
{
    _headImgSelect = headImgSelect;
    self.headImageView.layer.borderColor = THEME_COLOR.CGColor;
    self.headImageView.layer.borderWidth = _headImgSelect?2.0f:0.f;
    self.selectedImageView.hidden = !_headImgSelect;
    
}

@end
