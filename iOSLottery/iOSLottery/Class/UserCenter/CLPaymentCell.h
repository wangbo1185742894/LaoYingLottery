//
//  CLPaymentCell.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/12.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PaymentCellType) {
    
    PaymentCellTypeNormal,
    PaymentCellTypeSelect,
    PaymentCellTypeMarking,
};

@interface CLPaymentCell : UITableViewCell

//UI
@property (nonatomic, strong) UIImageView* icon;
@property (nonatomic, strong) UILabel* textLbl;
@property (nonatomic, strong) UILabel* subTextLbl;
@property (nonatomic, strong) UILabel* markTextLbl;
@property (nonatomic, strong) UIColor* markColor;

//Show
@property (nonatomic) PaymentCellType cellType;
@property (nonatomic) BOOL onlyShowTitle;
@property (nonatomic) BOOL isSelectState;

@end
