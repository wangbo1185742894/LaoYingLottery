//
//  CLPayCardListCell.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/4/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLBankCardInfoModel;
@interface CLPayCardListCell : UITableViewCell

@property (nonatomic, assign) BOOL selectedBackCard;

- (void)assignData:(CLBankCardInfoModel *)data;

@end
