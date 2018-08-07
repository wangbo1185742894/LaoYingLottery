//
//  CQCreditCardCell.h
//  caiqr
//
//  Created by 彩球 on 16/4/8.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, creditCardMode)
{
    creditCardModeNormal,
    creditCardModeSelect,
    creditCardModeOnlyTextSelect,
};

@interface CQCreditCardCell : UITableViewCell

+ (CQCreditCardCell*)initWithTableView:(UITableView*)tableView mode:(creditCardMode)mode;

+ (CGFloat)heightOfCreditCardCell;

+ (CGFloat)heightOfCreditListCardCellHeight;

@property (nonatomic, assign) creditCardMode mode;
@property (nonatomic, readwrite) BOOL cellSelectState;

@property (nonatomic, strong) NSString* bankIconUrl;
@property (nonatomic, strong) NSString* bankCardCode;
@property (nonatomic, strong) NSString* bankName;
@property (nonatomic, strong) NSString* cardListCardCode;

@property (nonatomic, strong) UIImage *withdrawRedImage;

/** 3.4 add */
@property (nonatomic, strong) UIColor* bankNameColor;
@property (nonatomic, readwrite) BOOL showUsuallyBankCard;

@end
