//
//  CQRedPacketsTableViewCell.m
//  caiqr
//
//  Created by huangyuchen on 16/8/31.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQRedPacketsTableViewCell.h"
#import "CQDefinition.h"
#import "CQUserRedPacketsNewModel.h"
#import "UILabel+CLAttributeLabel.h"
#import "CLConfigMessage.h"

@interface CQRedPacketsTableViewCell ()

@property (nonatomic, strong) UIImageView *mainBackgroundView;//主背景图
@property (nonatomic, strong) UIImageView *redBackgroundView;//红包的底部背景
@property (nonatomic, strong) UIView *redMoneyBackgroundView;//红包总额的View
@property (nonatomic, strong) UILabel *redMoneyLabel;//红包金额
@property (nonatomic, strong) UILabel *redYuanLabel;//红包的单位“元”
@property (nonatomic, strong) UIView *redMoneyBaseView;//红包总额和满减 的基层View
@property (nonatomic, strong) UILabel *redDescLabel;//满。。可用
@property (nonatomic, strong) UILabel *redBalanceLabel;//红包余额
@property (nonatomic, strong) UILabel *redTypelabel;//红包类型
@property (nonatomic, strong) UILabel *redValidityLabel;//有效期
@property (nonatomic, strong) UILabel *redExplainLabel;//过期或用完说明
@property (nonatomic, strong) UIButton *redUseButton;//使用按钮
@property (nonatomic, strong) UIView *baseView;//余额 说明 有效期  的底层View

@end
@implementation CQRedPacketsTableViewCell

+ (instancetype)createRedPacketsCellWithInitiator:(UITableView *)tableView
                                           cellId:(NSString *)cellId
                                             data:(id)data{
    CQRedPacketsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[CQRedPacketsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell assignViewWithData:data];
    return cell;
}
#pragma mark - 重载init方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.mainBackgroundView];
        [self.contentView addSubview:self.redBackgroundView];
        [self.contentView addSubview:self.redMoneyBaseView];
        [self.redMoneyBaseView addSubview:self.redMoneyBackgroundView];
        [self.redMoneyBackgroundView addSubview:self.redMoneyLabel];
        [self.redMoneyBackgroundView addSubview:self.redYuanLabel];
        [self.redMoneyBaseView addSubview:self.redDescLabel];
        [self.contentView addSubview:self.baseView];
        [self.baseView addSubview:self.redBalanceLabel];
        [self.baseView addSubview:self.redTypelabel];
        [self.baseView addSubview:self.redValidityLabel];
        [self.contentView addSubview:self.redExplainLabel];
        [self.contentView addSubview:self.redUseButton];
        //添加约束
        [self addSubContraint];
        
    }
    return self;
}

#pragma mark - event Response
//使用按钮 点击事件
- (void)redUseButtonOnClick:(UIButton *)btn{
    
    if (self.redPacketsUseBlock) {
        self.redPacketsUseBlock();
    }
    
}

#pragma mark - private Mothed
//配置数据
- (void)assignViewWithData:(id)data{
    CQUserRedPacketsListModel *model = data;
    //红包总额
    if ([model.red_amount rangeOfString:@"元"].location != NSNotFound) {
        self.redMoneyLabel.text= [model.red_amount stringByReplacingOccurrencesOfString:@"元" withString:@""];
    }else{
        self.redMoneyLabel.text= model.red_amount;
    }
    //红包描述  “满。。送。。” 数据源内容 刮刮乐8元\n，满10可用
    NSArray *strArr = [model.red_name componentsSeparatedByString:@"\n"];
    if (strArr.count == 2) {
        self.redDescLabel.text = strArr[1];
        self.redTypelabel.text = strArr[0];
    }else{
        //如果数据不对，展示内容？
        self.redTypelabel.text = model.red_name;
        self.redDescLabel.text = @"";
    }
    //余额内容
    self.redBalanceLabel.text = [NSString stringWithFormat:@"余额:%.2f元", model.balance_num / 100.00];
    
    //有效期内容
    //判断该字符串是否含有数字
    NSArray *arr = [model.red_left_date componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]];
    if (arr.count > 1) {
        //有数字  表示未过期或未用完
        //需要富文本变色操作
        AttributedTextParams *params1 = [[AttributedTextParams alloc] init];
        params1.range = NSMakeRange(4, model.red_left_date.length);// 4表示“有效期：”的长度
        //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型
        if (model.red_left_date_color != nil && model.red_left_date_color.length > 0) {
            params1.color = UIColorFromRGB(strtoul([model.red_left_date_color UTF8String],0,16));
        }else{
            params1.color = UIColorFromRGB(0x666666);
        }
        [self.redValidityLabel attributeWithText:[NSString stringWithFormat:@"有效期:%@", model.red_left_date] controParams:@[params1]];
        //未过期 未用完则表示 说明label必定隐藏
        self.redExplainLabel.hidden = YES;

        //"使用"按钮是否显示 和 红色背景是否置灰
        if (model.red_line_color != nil && model.red_line_color.length > 0) {
            self.redUseButton.hidden = YES;
            self.redBackgroundView.image = [UIImage imageNamed:@"unuseRedPacket.png"];
            //更新约束
            [self.baseView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.redBackgroundView.mas_right).offset(__SCALE(10.5f));
                make.centerY.equalTo(self.redBackgroundView.mas_centerY);
                make.right.equalTo(self.mainBackgroundView).offset(-3.f);
            }];
        }else{
            self.redUseButton.hidden = NO;
            self.redBackgroundView.image = [UIImage imageNamed:@"useRedPackets.png"];;
            //更新约束
            [self.baseView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.redBackgroundView.mas_right).offset(__SCALE(10.5f));
                make.centerY.equalTo(self.redBackgroundView.mas_centerY);
                make.right.equalTo(self.redUseButton.mas_left).offset(-3.f);
            }];
        }
        
    }else{
        //表示过期或已用完
        self.redValidityLabel.text = @"有效期:0天";
        self.redExplainLabel.text = model.red_left_date;
        self.redExplainLabel.hidden = NO;
        self.redUseButton.hidden = YES;
        self.redBackgroundView.image = [UIImage imageNamed:@"unuseRedPacket.png"];
        //更新约束
        [self.baseView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.redBackgroundView.mas_right).offset(__SCALE(10.5f));
            make.centerY.equalTo(self.redBackgroundView.mas_centerY);
            make.right.equalTo(self.redExplainLabel.mas_left).offset(-3.f);
        }];
    }
    [self updateConstraintsIfNeeded];
}
//添加约束
- (void)addSubContraint{
    
    [self.mainBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(__SCALE(10.f));
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(__SCALE(80.5f));
        make.width.mas_equalTo(__SCALE(300.f));
    }];
    [self.redBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(__SCALE(10.5f));
        make.top.bottom.equalTo(self.mainBackgroundView);
        make.width.mas_equalTo(__SCALE(92.f));
    }];
    [self.redMoneyBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.redBackgroundView);
    }];
    [self.redMoneyBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.redMoneyBaseView);
        make.centerX.equalTo(self.redMoneyBaseView);
    }];
    [self.redDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.redMoneyBackgroundView.mas_bottom).offset(__SCALE(2.5f));
        make.left.right.equalTo(self.redMoneyBaseView);
        make.bottom.equalTo(self.redMoneyBaseView);
    }];
    
    [self.redMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.redMoneyBackgroundView);
        make.top.equalTo(self.redMoneyBackgroundView);
        make.bottom.equalTo(self.redMoneyBackgroundView);
        make.width.mas_lessThanOrEqualTo(__SCALE(80.f));
    }];
    [self.redYuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.redMoneyLabel.mas_right).offset(1.f);
        make.baseline.equalTo(self.redMoneyLabel).offset(- 1.f);
        make.right.equalTo(self.redMoneyBackgroundView);
    }];
    [self.redExplainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mainBackgroundView.mas_right).offset(__SCALE(- 10.5f));
        make.centerY.equalTo(self.mainBackgroundView);
    }];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.redBackgroundView.mas_right).offset(__SCALE(10.5f));
        make.centerY.equalTo(self.redBackgroundView.mas_centerY);
        make.right.equalTo(self.redExplainLabel.mas_left).offset(-3.f);
    }];
    
    [self.redBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView);
        make.top.equalTo(self.baseView);
    }];
    
    [self.redTypelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseView);
        make.top.equalTo(self.redBalanceLabel.mas_bottom).offset(__SCALE(3.5f));
        make.right.lessThanOrEqualTo(self.baseView);
    }];
    [self.redValidityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.redTypelabel.mas_bottom).offset(2.5f);
        make.left.equalTo(self.redTypelabel);
        make.bottom.equalTo(self.baseView);
    }];
    
    [self.redUseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mainBackgroundView.mas_right).offset(__SCALE(- 10.5f));
        make.centerY.equalTo(self.mainBackgroundView);
        make.width.mas_equalTo(__SCALE(45.f));
    }];
}

#pragma mark - getter Mothed
- (UIImageView *)mainBackgroundView{
    if (!_mainBackgroundView) {
        _mainBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _mainBackgroundView.image = [UIImage imageNamed:@"redPacketsListBackground.png"];
    }
    return _mainBackgroundView;
}
- (UIImageView *)redBackgroundView{
    if (!_redBackgroundView) {
        _redBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _redBackgroundView;
}
- (UIView *)redMoneyBackgroundView{
    if (!_redMoneyBackgroundView) {
        _redMoneyBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _redMoneyBackgroundView;
}
- (UILabel *)redMoneyLabel{
    if (!_redMoneyLabel) {
        _redMoneyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _redMoneyLabel.font = FONT_SCALE(20.f);
        _redMoneyLabel.numberOfLines = 0;
        _redMoneyLabel.textColor = UIColorFromRGB(0xffffff);
    }
    return _redMoneyLabel;
}
- (UILabel *)redYuanLabel{
    if (!_redYuanLabel) {
        _redYuanLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _redYuanLabel.text = @"元";
        _redYuanLabel.textColor = UIColorFromRGB(0xffffff);
        _redYuanLabel.font = FONT_SCALE(12);
    }
    return _redYuanLabel;
}
- (UILabel *)redDescLabel{
    if (!_redDescLabel) {
        _redDescLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _redDescLabel.font = FONT_SCALE(13);
        _redDescLabel.textColor = UIColorFromRGB(0xffffff);
    }
    return _redDescLabel;
}
- (UILabel *)redBalanceLabel{
    if (!_redBalanceLabel) {
        _redBalanceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _redBalanceLabel.font = FONT_SCALE(16.f);
        _redBalanceLabel.textColor = UIColorFromRGB(0x333333);
    }
    return _redBalanceLabel;
}
- (UILabel *)redTypelabel{
    if (!_redTypelabel) {
        _redTypelabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _redTypelabel.numberOfLines = 0;
        _redTypelabel.font = FONT_SCALE(13.f);
        [_redTypelabel setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        _redTypelabel.textColor = UIColorFromRGB(0x666666);
    }
    return _redTypelabel;
}
- (UILabel *)redValidityLabel{
    if (!_redValidityLabel) {
        _redValidityLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _redValidityLabel.font = FONT_SCALE(13.f);
        _redValidityLabel.textColor = UIColorFromRGB(0x666666);
    }
    return _redValidityLabel;
}
- (UILabel *)redExplainLabel{
    if (!_redExplainLabel) {
        _redExplainLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _redExplainLabel.font = FONT_SCALE(13.f);
        _redExplainLabel.textColor = UIColorFromRGB(0xcacaca);
    }
    return _redExplainLabel;
}
- (UIButton *)redUseButton{
    if (!_redUseButton) {
        _redUseButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_redUseButton setTitleColor:UIColorFromRGB(0xff4747) forState:UIControlStateNormal];
        _redUseButton.titleLabel.font = FONT_SCALE(13.f);
        _redUseButton.layer.cornerRadius = 3.f;
        _redUseButton.layer.borderWidth = 1.f;
        _redUseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [_redUseButton setTitle:@"使用" forState:UIControlStateNormal];
        _redUseButton.layer.borderColor = UIColorFromRGB(0xff4747).CGColor;
        [_redUseButton addTarget:self action:@selector(redUseButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _redUseButton;
}
- (UIView *)baseView{
    if (!_baseView) {
        
        _baseView = [[UIView alloc] initWithFrame:CGRectZero];
        _baseView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _baseView;
}
- (UIView *)redMoneyBaseView{
    if (!_redMoneyBaseView) {
        _redMoneyBaseView = [[UIView alloc] initWithFrame:CGRectZero];
        _redMoneyBaseView.backgroundColor = CLEARCOLOR;
    }
    return _redMoneyBaseView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    // Configure the view for the selected state
}
@end
