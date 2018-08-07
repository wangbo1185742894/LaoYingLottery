//
//  CLBuyRedEnveSelectCell.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/10.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CLBuyRedEnveSelectType) {
    
    CLBuyRedEnveSelectTypeNormal,
    CLBuyRedEnveSelectTypeCustom,
};

@protocol CLBuyRedEnveSelectCellDelegate <NSObject>

- (NSString*) inputAmountChangeFor:(NSString*)source;

- (void) purchaseRedEnveolpeAtIndexPath:(NSIndexPath*)indexPath;

@end


@interface CLBuyRedEnveSelectCell : UITableViewCell

+ (CLBuyRedEnveSelectCell*)redEnvelopeCellInitWithTableView:(UITableView*)tableView;

@property (nonatomic, weak) id<CLBuyRedEnveSelectCellDelegate> delegate;

- (void)configureRedValue:(long long) redValue amountValue:(long long) amountValue isCustom:(BOOL)isCustom;

+ (CGFloat) cellHeight;

@end
