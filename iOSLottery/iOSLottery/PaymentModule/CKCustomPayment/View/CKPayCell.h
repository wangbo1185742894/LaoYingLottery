//
//  CKPayCell.h
//  caiqr
//
//  Created by huangyuchen on 2017/4/27.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CKPayCellType) {
    
    CKPayCellTypeNormal,
    CKPayCellTypeSelect,
    CKPayCellTypeMarking,
};


@interface CKPayCell : UITableViewCell

//UI
@property (nonatomic, strong) UIImageView* icon;
@property (nonatomic, strong) UILabel* textLbl;//主标题
@property (nonatomic, strong) UILabel* subTextLbl;//子标题
@property (nonatomic, strong) UILabel* markTextLbl;//渠道状态

//Show
@property (nonatomic) CKPayCellType cellType;
@property (nonatomic) BOOL onlyShowTitle;
@property (nonatomic) BOOL isSelectState;

@end
