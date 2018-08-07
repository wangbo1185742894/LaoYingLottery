//
//  CLWithdrawBankCardCell.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/12.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLBankCardInfoModel;

typedef NS_ENUM(NSInteger, CLWithdrawBankCardCellStyle){
    CLWithdrawBankCardCellNormal,
    CLWithdrawBankCardCellSelect,
};

@interface CLWithdrawBankCardCell : UITableViewCell

+ (CGFloat) cellHeight;

@property (nonatomic) CLWithdrawBankCardCellStyle cellStyle;

@property (nonatomic) BOOL isSelect;

- (void) configureData:(CLBankCardInfoModel*) infoModel;

@end
