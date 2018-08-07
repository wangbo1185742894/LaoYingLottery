//
//  CLTicketDetailViewController.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/27.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseViewController.h"

@interface CLTicketDetailViewController : CLBaseViewController

@property (nonatomic, strong) NSString* orderId;

@end



@interface CLTicketHeadView : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel* titleLbl;

@end

@interface CLTicketCell : UITableViewCell

@property (nonatomic, strong) UILabel* ticketNoLbl;
@property (nonatomic, strong) UILabel* ticketInfoLbl;
@property (nonatomic, strong) UILabel* multipleLbl;
@property (nonatomic, strong) UILabel* stateLbl;

@property (nonatomic) BOOL showBottomLine;

@end
