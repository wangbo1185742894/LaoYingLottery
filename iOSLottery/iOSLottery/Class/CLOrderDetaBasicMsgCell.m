//
//  CLOrderDetaBasicMsgCell.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/15.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLOrderDetaBasicMsgCell.h"
#import "CQDefinition.h"
#import "TTTAttributedLabel.h"
#import "CLConfigMessage.h"
#import "CLOrderDetailLineViewModel.h"
#import "MLLinkLabel.h"

@interface CLOrderDetaBasicMsgCell ()<TTTAttributedLabelDelegate>


@property (nonatomic, strong) UILabel* titleLbl;
@property (nonatomic, strong) MLLinkLabel* contentLbl;

@property (nonatomic, strong) CLOrderDetailLineViewModel * lineModel;

@end

@implementation CLOrderDetaBasicMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [CATransaction setDisableActions:YES];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorFromRGB(0xF7F7EE);
        [self addSubview:self.titleLbl];
        [self addSubview:self.contentLbl];
        
        [self setConstraints];
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)setUpBasicMsg:(CLOrderDetailLineViewModel*)viewModel {
    
    self.lineModel = viewModel;
    self.titleLbl.text = viewModel.title;
    self.contentLbl.text = viewModel.content;
    
    [self.contentLbl addLink:[MLLink linkWithType:MLLinkTypeOther value:viewModel.linkText range:viewModel.linkRange color:viewModel.linkColor ? viewModel.linkColor : UIColorFromRGB(0x666666)]];
    
    [self layoutIfNeeded];
}

- (void)setConstraints {
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(CL__SCALE(10.f));
        make.top.equalTo(self).offset(CL__SCALE(3.f));
        make.bottom.lessThanOrEqualTo(self).offset(CL__SCALE(- 3.f));
        make.width.equalTo(self.mas_width).multipliedBy(0.20f);
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl.mas_right);
        make.top.equalTo(self).offset(CL__SCALE(3.f));
        make.bottom.equalTo(self).offset(CL__SCALE(- 3.f));
        make.right.lessThanOrEqualTo(self).offset(CL__SCALE(-10.f));
    }];
    
}

- (void)longPressGestureClick:(UILongPressGestureRecognizer *)gesture
{
    if (self.contentLongBlock) {
        [self becomeFirstResponder];
        if([UIMenuController sharedMenuController].isMenuVisible){
            return;
        }
        self.contentLbl.backgroundColor = UIColorFromRGB(0xd9d9d9);
        self.contentLongBlock([self.GestureTableView rectForRowAtIndexPath:[self.GestureTableView indexPathForCell:self]],self.contentLbl);
    }
    
}


#pragma mark - getter

- (UILabel *)titleLbl {
    
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.textColor = UIColorFromRGB(0x8F6E51);
        _titleLbl.font = CL_FONT_SCALE(13.f);
    }
    return _titleLbl;
}


- (MLLinkLabel *)contentLbl {
    
    if (!_contentLbl) {
        _contentLbl = [[MLLinkLabel alloc] initWithFrame:CGRectZero];
        _contentLbl.dataDetectorTypes = MLDataDetectorTypeAttributedLink;
        _contentLbl.numberOfLines = 0;
        _contentLbl.userInteractionEnabled = YES;
        _contentLbl.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLbl.font = CL_FONT_SCALE(13.f);
        _contentLbl.textColor = UIColorFromRGB(0x8F6E51);
        WS(_ws)
        [_contentLbl setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            !_ws.cellContentClick?:_ws.cellContentClick(_ws.lineModel);
        }];
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureClick:)];
        
        longPressGesture.minimumPressDuration = 0.8f;
        _contentLbl.userInteractionEnabled = YES;
        [_contentLbl addGestureRecognizer:longPressGesture];
    }
    return _contentLbl;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
