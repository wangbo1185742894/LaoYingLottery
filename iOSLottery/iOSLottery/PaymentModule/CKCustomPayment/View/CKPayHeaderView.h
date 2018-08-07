//
//  CKPayHeaderView.h
//  caiqr
//
//  Created by huangyuchen on 2017/4/27.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CKTwoLabelView;
@interface CKPayHeaderView : UIView

@property (nonatomic, strong) CKTwoLabelView *titleLabel;//共需支付多少元
@property (nonatomic, strong) CKTwoLabelView *redLabel;//红包
@property (nonatomic, strong) CKTwoLabelView *needPayLabel;//需支付多少元
@property (nonatomic, assign) BOOL hasRedPacket;
@property (nonatomic, copy) void(^clickRedBlock)();
@end

@interface CKTwoLabelView : UIView

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, assign) BOOL hasLine;
@property (nonatomic, assign) BOOL hasArrow;
@property (nonatomic, copy) void(^onClickBlock)();
@end
