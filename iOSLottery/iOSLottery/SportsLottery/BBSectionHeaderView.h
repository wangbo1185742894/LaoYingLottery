//
//  BBSectionHeaderView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BBSectionHeaderBlock)(BOOL visible);

@interface BBSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) BBSectionHeaderBlock headerBlock;

@property (nonatomic, assign,getter=isVisible) BOOL visible;

@property (nonatomic, strong) NSString *headerTitle;

+ (instancetype)createBBSectionHeaderViewWithTableView:(UITableView *)tableView;

- (void)returnHeaderTapClick:(BBSectionHeaderBlock)block;

@end
