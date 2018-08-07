//
//  CQBetODTableViewCell.h
//  caiqr
//
//  Created by huangyuchen on 16/7/22.
//  Copyright © 2016年 Paul. All rights reserved.
//
//  投注订单详情页的所有 cell


#import <UIKit/UIKit.h>
#pragma mark - 上方的订单详情的cell
@interface SLBetODContentTableViewCell : UITableViewCell
+ (instancetype)createBODContentTableViewCellWithTableView:(UITableView *)tableView
                                                      Data:(id)data
                                                Identifier:(NSString *)cellID
                                               lotteryCode:(NSString *)lotteryCode;
@property (nonatomic, copy) void (^sessionBlock)(NSString *pageUrl);

@end

#pragma mark - 下方的信息类Cell
typedef NS_ENUM(NSInteger, CQBetODMessageType) {
    CQBetODMessageTypeNone = 0,
    CQBetODMessageTypeOnlyLeft = 1,
    CQBetODMessageTypeOnlyRight,
    CQBetODMessageTypeLeftRight
};

@interface CQBetODMessageTableViewCell : UITableViewCell

@property (nonatomic, assign) CQBetODMessageType messageType;
+ (instancetype)createBODMessageTableViewCellWithTableView:(UITableView *)tableView
                                                      Data:(id)data
                                                Identifier:(NSString *)cellID;
/**
 *  退款说明
 */
@property (nonatomic, copy) void (^refundBlock)(void);
/**
 *  奖金优化详情
 */
@property (nonatomic, copy) void (^awardOptimizeBlock)(void);
/**
 *  出票详情
 */
@property (nonatomic, copy) void (^drawerBlock)();
/** 长按复制 */
@property (nonatomic, copy) void (^contentLongBlock)(CGRect contentCellRect,UILabel *contentLabel);
@end

#pragma mark - 最上方的标题cell
@interface SLBetODTitleTableViewCell : UITableViewCell

+ (instancetype)createBODTitleTableViewCellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;
@end

#pragma mark - 二级cell
@interface SLBETODSubOrderDetailCell : UITableViewCell

+ (instancetype)createBODSubOrderDetailCellWithTableView:(UITableView *)tableView
                                                    Data:(id)data;
@property (nonatomic, readwrite) BOOL has_BottomLine;
@end

#pragma mark - 中奖怎么算cell
@interface SLBetODAwardTableViewCell : UITableViewCell

+ (instancetype)createBODAwardCellWithTableView:(UITableView *)tableView
                                           Data:(id)data;

@property (nonatomic, copy) void(^winAwardBlock)();

@end
