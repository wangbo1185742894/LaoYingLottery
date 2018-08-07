//
//  CLQLCBetOptionsView.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/16.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLQLCBetOptionsView.h"

#import "CLConfigMessage.h"

#import "CLFTImageLabel.h"

#import "CLLotteryOmissionView.h"

#import "CLDEBetButton.h"

#import "CLATManager.h"

#import "UIResponder+CLRouter.h"

#import "AppDelegate.h"

@interface CLQLCBetOptionsView ()<UIGestureRecognizerDelegate>{
    
    NSInteger __randomAnimationIndex;
}

@property (nonatomic, strong) CLFTImageLabel *tagLabel;

@property (nonatomic, strong) UILabel *reminderLabel;

@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, strong) NSMutableArray *omissionLabelArray;

/**
 滑动手势是否可以触发按钮选中状态
 */
@property (nonatomic, assign) BOOL isAllowButtonSelected;


@end

@implementation CLQLCBetOptionsView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self p_addSubviews];
        [self p_addConstraints];
    }
    return self;
}


- (void)p_addSubviews
{
    [self addSubview:self.tagLabel];
    [self addSubview:self.reminderLabel];
    
    [self p_createBetButtons];
    
    [self p_addPanGesture];
}

- (void)p_addConstraints
{
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(CL__SCALE(10.f));
        make.width.mas_equalTo(CL__SCALE(46.2f));
        make.top.equalTo(self);
    }];
    
    [self.reminderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tagLabel.mas_right).offset(3.8f);
        make.centerY.equalTo(self.tagLabel);
    }];
    
}

- (void)p_createBetButtons
{
    
    int row,col = 0;
    
    CGFloat width = CL__SCALE(40.f);
    CGFloat height = CL__SCALE(40.f);
    
    
    for (int i = 0; i < 30 ; i ++) {
        
        CLDEBetButton *button = [[CLDEBetButton alloc] initWithFrame:(CGRectZero)];
        
        button.tag = i + 100 + 1;
        button.contentString = [NSString stringWithFormat:@"%02zi",i + 1];
        button.selectBetButtonBlock = ^(CLDEBetButton *button) {
            
            [self p_buttonClick:button];
        };
        
        row = i / 7;
        col = i % 7;
        
        CGFloat margin = CL__SCALE(12.F);
        
        button.frame = CGRectMake(CL__SCALE(10.f) + margin * col + col * width, row *  height + CL__SCALE(33.f) * row + CL__SCALE(35.f), width, height);
        
        [self addSubview:button];
        
        [self.buttonArray addObject:button];
        
        //创建遗漏lebal
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"-";
        label.font = FONT_SCALE(13);
        label.textColor = UIColorFromRGB(0x988366);
        label.textAlignment = NSTextAlignmentCenter;
        
        label.frame = CGRectMake(CL__SCALE(10.f) +  margin * col + col * width, CGRectGetMaxY(button.frame) + CL__SCALE(5.f), CL__SCALE(40.f), CL__SCALE(13.f));
        
        [self.omissionLabelArray addObject:label];
        
        [self addSubview:label];
    }
}


#pragma mark - 添加手势
- (void)p_addPanGesture
{
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestrueRespone:)];
    pan.delegate = self;
    [pan setMinimumNumberOfTouches:1];
    [pan setMaximumNumberOfTouches:1];
    [self addGestureRecognizer:pan];
}

- (void)p_buttonClick:(UIButton *)btn
{
    
    if ([self.delegate respondsToSelector:@selector(didSelectedOptions:groupTag:)]) {
        
        [self.delegate didSelectedOptions:btn groupTag:self.groupTag];
        
    }
}



#pragma mark ----- Set Method -----
- (void)setPromptText:(NSString *)text andTagText:(NSString *)tag;
{
    self.reminderLabel.text = text;
    
    if (tag == nil) {
        
        self.tagLabel.hidden = YES;
        
        [self.tagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(0);
        }];
        
    }else{
        
        self.tagLabel.hidden = NO;
        
        [self.tagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
           
            make.width.mas_equalTo(CL__SCALE(46.2f));
        }];
    
        self.tagLabel.contentString = tag;
    }
}


- (void)setSelectedOptionsWithData:(NSArray *)data
{
    
    
    [self.buttonArray enumerateObjectsUsingBlock:^(CLDEBetButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        btn.selected = [data containsObject:[NSString stringWithFormat:@"%02zi", btn.tag - 100]];
    }];
    
}

- (CLDEBetButton *)getRandomOptions:(NSInteger)tag
{
    
    return (CLDEBetButton *)[self viewWithTag:tag + 100];
    
}

- (void)setOmissionWithData:(NSArray *)data
{
    
    if (data == nil || data.count != self.omissionLabelArray.count) {
        
        [self.omissionLabelArray makeObjectsPerformSelector:@selector(setText:) withObject:@"-"];
        
        [self.omissionLabelArray makeObjectsPerformSelector:@selector(setTextColor:) withObject:UIColorFromRGB(0x988366)];
        
        return;
    }
    
    [self.omissionLabelArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *text = data[idx];
        
        if ([text containsString:@"^"]) {
            
            text = [text stringByReplacingOccurrencesOfString:@"^" withString:@""];
            
            label.textColor = [UIColor redColor];
            
            label.text = text;
        }else{
            
            label.text = text;
            
            label.textColor = UIColorFromRGB(0x988366);
            
        }
    }];
}


- (void)restoreOptionStatus
{

    if (self.buttonArray == nil || self.buttonArray.count == 0) return;
    
    [self.buttonArray enumerateObjectsUsingBlock:^(CLDEBetButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [btn setSelected:NO];
    }];
}


#pragma mark - 滑动手势触发事件
- (void)panGestrueRespone:(UIGestureRecognizer *)pan{
    
    if (self.isAllowButtonSelected) {
        
        CGPoint point = [pan locationInView:self];
        for (CLDEBetButton *betButton in self.buttonArray) {
            if (CGRectContainsPoint(betButton.frame, point)) {
                betButton.scaleAnimation = YES;
            }else{
                betButton.scaleAnimation = NO;
            }
        }
        
        if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
            self.isAllowButtonSelected = NO;
            CGPoint point = [pan locationInView:self];
            for (CLDEBetButton *betButton in self.buttonArray) {
                if (CGRectContainsPoint(betButton.frame, point)) {
                    betButton.scaleAnimation = NO;
                    betButton.selected = !betButton.selected;
                }
            }
        }
    }else{
        if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled){
            self.isAllowButtonSelected = YES;
        }
    }
    
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    CGPoint point = [gestureRecognizer locationInView:self];
    for (CLDEBetButton *betButton in self.buttonArray) {
        if (CGRectContainsPoint(betButton.frame, point)) {
            self.isAllowButtonSelected = YES;
            return NO;
        }
    }
    self.isAllowButtonSelected = NO;
    return YES;
}


#pragma mark ----- lazyLoad -----
- (CLFTImageLabel *)tagLabel
{
    
    if (_tagLabel == nil) {
        _tagLabel = [[CLFTImageLabel alloc] initWithFrame:CGRectZero];
        _tagLabel.contentString = @"选号";
        _tagLabel.contentFont = FONT_SCALE(14);
        _tagLabel.contentColor = UIColorFromRGB(0x333333);
        _tagLabel.backImage = [UIImage imageNamed:@"lotteryMainBetTag.png"];
    }
    return _tagLabel;
}

- (UILabel *)reminderLabel
{

    if (_reminderLabel == nil) {
        
        _reminderLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        
        _reminderLabel.text = @"选7-24个号码";
        _reminderLabel.textColor = UIColorFromRGB(0x333333);
        _reminderLabel.font = FONT_SCALE(15.f);
    }
    return _reminderLabel;
}

- (NSMutableArray *)buttonArray
{
    
    if (_buttonArray == nil) {
        
        _buttonArray = [NSMutableArray new];
    }
    return _buttonArray;
}

- (NSMutableArray *)omissionLabelArray
{
    
    if (_omissionLabelArray == nil) {
        
        _omissionLabelArray = [NSMutableArray new];
    }
    return _omissionLabelArray;
}

@end
