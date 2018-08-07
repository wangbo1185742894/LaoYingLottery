//
//  CLBankCardDetailViewController.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/2.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseViewController.h"

@class CLBankCardInfoModel;

@interface CLBankCardDetailViewController : CLBaseViewController

@property (nonatomic, strong) CLBankCardInfoModel* bankCardModel;

@end


@interface CQUserBankInfoCell : UITableViewCell

+ (CGFloat)userBankInfoCellHeightIsLastCell:(BOOL)isLastCell;

+ (instancetype)createUserBankInfoCellWithTableView:(UITableView *)tableView method:(id)method isLastCell:(BOOL)isLastCell;

@end


@interface CQUserBankInfoCellModel : NSObject

@property (nonatomic, strong) NSString *itemString;
@property (nonatomic, strong) NSString *infoString;

+ (instancetype)createUserInfoCellModelWithItem:(NSString *)itemString infoString:(NSString *)infoString;


@end
