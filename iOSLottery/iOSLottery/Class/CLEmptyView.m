//
//  CLEmptyView.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLEmptyView.h"
#import "CLConfigMessage.h"
#import "CLTools.h"
#import "Masonry.h"
#import "CLEmptyButton.h"


#define contentLabelHeight 20.f
@interface CLEmptyView ()

@property (nonatomic, strong) EmptyViewTopView *topView;
@property (nonatomic, strong) UIView *buttonSuperView;//展示button的底部View
@property (nonatomic, strong) NSMutableArray *buttonArray;//存储添加过得button

@end
@implementation CLEmptyView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //默认加载全部视图
        [self addSubview:self.topView];
        [self addSubview:self.buttonSuperView];
        self.buttonArray = [NSMutableArray arrayWithCapacity:0];
        [self addConstraint];
    }
    return self;
}
#pragma mark ------------ event Response ------------
- (void)btnOnClick:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(clickButtonWithEmpty:clickIndex:)]) {
        
        [self.delegate clickButtonWithEmpty:self clickIndex:btn.tag];
    }
}
- (void)addConstraint{
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.mas_equalTo(self.mas_centerY).offset(-__SCALE(30));
        make.left.right.equalTo(self);
        make.width.mas_greaterThanOrEqualTo(SCREEN_WIDTH/4.0*3);
    }];
    [self.buttonSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.top.equalTo(self.topView.mas_bottom).offset(__SCALE(10.f));
    }];
}

#pragma mark - private Method
- (void)createButton{
    
    if (self.buttonArray.count > 0) {
        for (UIButton *btn in self.buttonArray) {
            [btn removeFromSuperview];
        }
        [self.buttonArray removeAllObjects];
    }
    UIButton *lastButton = nil;
    for (NSInteger i = 0; i < self.butTitleArray.count; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
        btn.tag = i;
        [btn setTitle:self.butTitleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [btn setBackgroundColor:UIColorFromRGB(0xff4747)];
        [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = FONT_SCALE(13);
        btn.layer.cornerRadius = 2.f;
        btn.layer.masksToBounds = YES;
        [self.buttonSuperView addSubview:btn];
        [self.buttonArray addObject:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(__SCALE(34.f));
            make.top.equalTo(self.buttonSuperView);
            make.bottom.equalTo(self.buttonSuperView);
            if (lastButton) {
                make.left.equalTo(lastButton.mas_right).offset(__SCALE(10.f));
            }else{
                make.left.equalTo(self.buttonSuperView);
            }
            make.width.mas_equalTo(__SCALE(200.f));
        }];
        lastButton = btn;
    }
    //再给最后一个加一个约束 距离右边界
    [lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.buttonSuperView);
    }];
    [self updateConstraintsIfNeeded];
}

#pragma mark - Setter Method

- (void)setEmptyImageName:(NSString *)emptyImageName{
    
    _emptyImageName = emptyImageName;
    self.topView.emptyImageName = emptyImageName;
}

- (void)setContentString:(NSString *)contentString{
    
    _contentString = contentString;
    self.topView.contentString = contentString;
}

- (void)setDetailContentString:(NSString *)detailContentString{
    
    _detailContentString = detailContentString;
    self.topView.detailContentString = detailContentString;
}

- (void)setButTitleArray:(NSArray *)butTitleArray{
    
    _butTitleArray = butTitleArray;
    
    [self createButton];
}

#pragma mark - Getter Method

- (EmptyViewTopView *)topView{
    
    if (!_topView) {
        _topView = [[EmptyViewTopView alloc] init];
        _topView.backgroundColor = [UIColor clearColor];
    }
    return _topView;
}
- (UIView *)buttonSuperView{
    
    if (!_buttonSuperView) {
        _buttonSuperView = [[UIView alloc] initWithFrame:CGRectZero];
        _buttonSuperView.backgroundColor = CLEARCOLOR;
    }
    return _buttonSuperView;
}

@end

@interface EmptyViewTopView ()

@property (nonatomic, strong)UIImageView *emptyImageView;//图片
@property (nonatomic, strong)UILabel     *contentLabel;//提示文字
@property (nonatomic, strong)UILabel     *detailContentLabel;//提示文字

@end

@implementation EmptyViewTopView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.emptyImageView];
        [self addSubview:self.contentLabel];
        [self addSubview:self.detailContentLabel];
        [self addConstraint];
    }
    return self;
}

- (void)addConstraint{
    
    //    将super view的x,y,width加上约束，再加上subview与superview的顶部约束，再加个subview与superview的高度约束，如果subview的高度能随内容或者model自行layout，那么superview的高度就能够随着subview变化
    CGSize imageSize = self.emptyImageView.image.size;
    imageSize.width/=2.0;
    imageSize.height/=2.0;
    [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.size.mas_equalTo(self.emptyImageView.image.size);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.emptyImageView);
        make.top.mas_equalTo(self.emptyImageView.mas_bottom).offset(15.f);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}
#pragma mark - SET METHOD
- (void)setContentString:(NSString *)contentString{
    
    _contentString = contentString;
    _contentLabel.text = _contentString;
    [self needsUpdateConstraints];
}

- (void)setDetailContentString:(NSString *)detailContentString{
    
    _detailContentString = detailContentString;
    self.detailContentLabel.text = detailContentString;
    //需要展示副标题修改约束
    self.contentLabel.textColor = [UIColor darkGrayColor];
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.emptyImageView);
        make.top.mas_equalTo(self.emptyImageView.mas_bottom).offset(10.f);
    }];
    [self.detailContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentLabel);
        make.top.mas_equalTo(self.contentLabel.mas_bottom);
        make.bottom.mas_equalTo(self);
    }];
    
    [self updateConstraintsIfNeeded];
}
- (void)setEmptyImageName:(NSString *)emptyImageName
{
    _emptyImageName = emptyImageName;
    self.emptyImageView.image = [UIImage imageNamed:_emptyImageName];
    CGSize imageSize = self.emptyImageView.image.size;
    float scale = [UIScreen mainScreen].bounds.size.width/320.0;
    imageSize.width*=scale;
    imageSize.height*=scale;
    [self.emptyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(imageSize);
    }];
    [self updateConstraintsIfNeeded];
}
#pragma mark - GET METHOD
- (UILabel *)contentLabel{
    
    if (!_contentLabel) {
        AllocNormalLabel(_contentLabel, @"服务器正在思考人生，请给Ta一点时间", [UIFont systemFontOfSize:__SCALE_HALE(14)], NSTextAlignmentCenter, UIColorFromRGB(0x666666), CGRectZero);
        _contentLabel.numberOfLines = 0;
        _contentLabel.backgroundColor = [UIColor clearColor];
        /**  */
        _contentLabel.preferredMaxLayoutWidth = (SCREEN_WIDTH -10.0 * 2);
        [_contentLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
    }
    return _contentLabel;
}

- (UILabel *)detailContentLabel{
    
    if (!_detailContentLabel) {
        AllocNormalLabel(_detailContentLabel, @"", [UIFont systemFontOfSize:__SCALE_HALE(13)], NSTextAlignmentCenter, UIColorFromRGB(0xbbbbbb), CGRectZero);
        _detailContentLabel.numberOfLines = 0;
        _detailContentLabel.backgroundColor = [UIColor clearColor];
        /**  */
        _detailContentLabel.preferredMaxLayoutWidth = (SCREEN_WIDTH -10.0 * 2);
        [_detailContentLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self addSubview:_detailContentLabel];
    }
    return _detailContentLabel;
}

- (UIImageView *)emptyImageView{
    
    if (!_emptyImageView) {
        _emptyImageView = [[UIImageView alloc] init];
        _emptyImageView.backgroundColor = [UIColor clearColor];
    }
    return _emptyImageView;
}

@end
