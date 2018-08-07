//
//  CLPersJourDetailViewController.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/25.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseViewController.h"

@interface CLPersJourDetailViewController : CLBaseViewController

- (void)assignDataSource:(id)dataSource;

@end



@interface CLPersJourDetailHeadView : UIView

@property (nonatomic, strong) UILabel* titleLbl;
@property (nonatomic, strong) UILabel* contentLbl;

@end
