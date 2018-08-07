//
//  CQUserRedPacketsConsumeTableViewCell.m
//  caiqr
//
//  Created by 小铭 on 16/4/18.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQUserRedPacketsConsumeTableViewCell.h"
#import "CQDefinition.h"
#import "CLConfigMessage.h"
#import "CQViewQuickAllocDef.h"
#import "UILabel+CLAttributeLabel.h"
#import "CLRedEnveConsumeModel.h"


#define CQUserRedPacketsConsumeCellMargin 5.f
#define CQUserRedPacketsConsumeCellItemWidth (SCREEN_WIDTH - 2 * CQUserRedPacketsConsumeCellMargin) / 3


@interface CQUserRedPacketsConsumeTableViewCell()

@property (nonatomic, strong) UILabel *itemLabel;

@property (nonatomic, strong) UILabel *amountLabel;

@property (nonatomic, strong) UIButton *detailButton;

@property (nonatomic, strong) CALayer *bottomLayer;

@property (nonatomic, copy) void(^clickOrderDetail)(NSString *orderString);

@property (nonatomic, strong) NSString *orderIdString;

@end

@implementation CQUserRedPacketsConsumeTableViewCell

+ (instancetype)userRedPacketConsumeTableView:(UITableView *)tableView
                                       Method:(id)obj
                                   clickOrder:(void (^)(NSString *))clickOrderDetailBlock
{
    CQUserRedPacketsConsumeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CQUserRedPacketsConsumeTableViewCellId"];
    if (!cell) {
        cell = [[CQUserRedPacketsConsumeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CQUserRedPacketsConsumeTableViewCellId"];
    }
    [cell assignMethodWithObj:obj];
    cell.clickOrderDetail = clickOrderDetailBlock;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.itemLabel];
        [self.contentView addSubview:self.amountLabel];
        [self.contentView addSubview:self.detailButton];
        [self.contentView.layer insertSublayer:self.bottomLayer above:self.contentView.layer];
    }
    return self;
}

- (void)assignMethodWithObj:(id)obj
{
    CLRedEnveConsumeModel *consumeModel = (CLRedEnveConsumeModel *)obj;
    self.itemLabel.text = consumeModel.create_time;
    self.amountLabel.text = consumeModel.amount;
    if (consumeModel.order_id)
    {
        NSString *detailString = [NSString stringWithFormat:@"%@",[consumeModel.order_id componentsSeparatedByString:@"_"].firstObject];
        self.orderIdString = [NSString stringWithFormat:@"%@",[consumeModel.order_id componentsSeparatedByString:@"_"].lastObject];
        self.detailButton.hidden = NO;
        [self.detailButton setTitle:detailString forState:UIControlStateNormal];
    }
    else
    {
        self.detailButton.hidden = YES;
        [self.detailButton setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)redParketsConsumeDetailClickAction:(id)sender
{
    if (self.clickOrderDetail)
    {
        if (self.orderIdString.length > 0) self.clickOrderDetail(self.orderIdString);
    }
}

#pragma mark gettingMethod

- (UILabel *)itemLabel
{
    if (!_itemLabel) {
        AllocNormalLabel(_itemLabel, @"", FONT_SCALE(13), NSTextAlignmentCenter, UIColorFromRGB(0x333333), __Rect(CQUserRedPacketsConsumeCellMargin, 0, CQUserRedPacketsConsumeCellItemWidth, 60.f));
        _itemLabel.numberOfLines = 0;
    }
    return _itemLabel;
}

- (UILabel *)amountLabel
{
    if (!_amountLabel) {
        AllocNormalLabel(_amountLabel, @"", FONT_SCALE(15), NSTextAlignmentCenter, UIColorFromRGB(0x333333), __Rect(__Obj_XW_Value(self.itemLabel), __Obj_Frame_Y(self.itemLabel), __Obj_Bounds_Width(self.itemLabel), __Obj_Bounds_Height(self.itemLabel)));
    }
    return _amountLabel;
}

- (UIButton *)detailButton
{
    if (!_detailButton) {
        _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailButton.frame = __Rect(__Obj_XW_Value(self.amountLabel), __Obj_Frame_Y(self.amountLabel), __Obj_Bounds_Width(self.amountLabel), __Obj_Bounds_Height(self.amountLabel));
        [_detailButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        _detailButton.titleLabel.font = FONT_SCALE(13);
        _detailButton.backgroundColor = CLEARCOLOR;
        [_detailButton addTarget:self action:@selector(redParketsConsumeDetailClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailButton;
}

- (CALayer *)bottomLayer
{
    if (!_bottomLayer) {
        _bottomLayer = [[CALayer alloc] init];
        _bottomLayer.frame = __Rect(0, 60.f - .5f, SCREEN_WIDTH, .5f);
        _bottomLayer.backgroundColor = UIColorFromRGB(0xefefef).CGColor;
    }
    return _bottomLayer;
}

@end


@interface CQUserRedPacketsConsumeTableViewHeaderView()

@property (nonatomic, strong) CALayer *topLayer;

@property (nonatomic, strong) UIView *headerBackView;

@end

@implementation CQUserRedPacketsConsumeTableViewHeaderView

+ (instancetype)userRedPacketsConsumeTableViewHeaderViewWithMethod:(id)obj
{
    CQUserRedPacketsConsumeTableViewHeaderView *headerView = [[CQUserRedPacketsConsumeTableViewHeaderView alloc] init];
    return headerView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        [self.layer addSublayer:self.topLayer];
        [self addSubview:self.headerBackView];
        self.frame = __Rect(__Obj_Frame_X(self), __Obj_Frame_Y(self), SCREEN_WIDTH, __Obj_YH_Value(self.headerBackView));
    }
    return self;
}

- (CALayer *)topLayer
{
    if (!_topLayer) {
        _topLayer = [[CALayer alloc] init];
        _topLayer.frame = __Rect(0, 0, SCREEN_WIDTH, 5.f);
        _topLayer.backgroundColor = UIColorFromRGB(0xefefef).CGColor;
    }
    return _topLayer;
}

- (UIView *)headerBackView
{
    if (!_headerBackView) {
        _headerBackView = [[UIView alloc] init];
        _headerBackView.backgroundColor = UIColorFromRGB(0xffffff);
        _headerBackView.frame = __Rect(0, 5.f, SCREEN_WIDTH, 30.f);
        NSArray <NSString *> *itemArr = @[@"时间",@"消费金额",@"订单"];
        for (NSInteger i = 0; i <itemArr.count; i++) {
            UILabel *itemLabel;
            AllocNormalLabel(itemLabel, itemArr[i], FONT(15), NSTextAlignmentCenter, UIColorFromRGB(0x666666), __Rect(CQUserRedPacketsConsumeCellMargin + CQUserRedPacketsConsumeCellItemWidth * i, 0, CQUserRedPacketsConsumeCellItemWidth, 30.f));
            [_headerBackView addSubview:itemLabel];
        }
        CALayer *bottomLayer = [[CALayer alloc] init];
        bottomLayer.frame = __Rect(0, 30.f - .5f, __Obj_Bounds_Width(_headerBackView), .5f);
        bottomLayer.backgroundColor = UIColorFromRGB(0xefefef).CGColor;
        [_headerBackView.layer insertSublayer:bottomLayer above:_headerBackView.layer];
    }
    return _headerBackView;
}

@end
