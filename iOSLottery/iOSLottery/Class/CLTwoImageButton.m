//
//  CLTwoImageButton.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/30.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLTwoImageButton.h"
#import "CLConfigMessage.h"

@interface CLTwoImageButton ()

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;


@end

@implementation CLTwoImageButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.leftImageView = [[UIImageView alloc] init];
        self.leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.rightImageView = [[UIImageView alloc] init];
        self.rightImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.mainImageView = [[UIImageView alloc] init];
        self.mainImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.mainImageView.hidden = YES;
        self.mainImageView.clipsToBounds = YES;
        [self addSubview:self.leftImageView];
        [self addSubview:self.rightImageView];
        [self addSubview:self.mainImageView];
        [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_left).offset(__SCALE(-2.f));
            make.centerY.equalTo(self);
            make.width.height.mas_equalTo(__SCALE(10.f));
        }];
         
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_right);
            make.centerY.equalTo(self);
            make.width.height.mas_equalTo(__SCALE(10.f));
        }];
        
        [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self);
        }];
    }
    return self;
}
- (void)setLeftImage:(UIImage *)leftImage{
    
    self.leftImageView.image = leftImage;
}

- (void)setRightImage:(UIImage *)rightImage{
    
    self.rightImageView.image = rightImage;
}

- (void)assignMianImageViewHidden:(BOOL)hidden{
    
    self.mainImageView.hidden = hidden;
    self.leftImageView.hidden = self.rightImageView.hidden = !hidden;
}

@end
