//
//  BBMatchInfoView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BBMatchInfoBlock)();

@class BBMatchModel;

@interface BBMatchInfoView : UIView

@property (nonatomic, copy) BBMatchInfoBlock infoBlock;

@property (nonatomic, strong) BBMatchModel *infoModel;

- (void)setMatchLeagueName:(NSString *)str;

- (void)setMatchNumber:(NSString *)str;

- (void)setCutOffTime:(NSString *)str;



@end
