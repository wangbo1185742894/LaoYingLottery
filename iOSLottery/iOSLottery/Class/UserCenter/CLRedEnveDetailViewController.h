//
//  CLRedEnveDetailViewController.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/28.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseViewController.h"

@class CLRedEnveDetaModel;
@interface CLRedEnveDetailViewController : CLBaseViewController

@property (nonatomic, strong) NSString* fid;

@end


@interface CLRedEvneDetaHeadView : UIView

@property (nonatomic, strong) UILabel* titleLbl;
@property (nonatomic, strong) UILabel* contentLbl;

- (void)configureHeadData:(CLRedEnveDetaModel*)data;

@end
