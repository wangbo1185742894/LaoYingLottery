//
//  CQHeadImgCollectionViewCell.h
//  caiqr
//
//  Created by 彩球 on 15/9/17.
//  Copyright (c) 2015年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CQHeadImgCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;


@property (readwrite, nonatomic) BOOL headImgSelect;
@property (strong, nonatomic) NSString* headImgUrl;
@end
