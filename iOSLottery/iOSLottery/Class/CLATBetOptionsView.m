//
//  CLATBetOptionView.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/13.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLATBetOptionsView.h"

#import "CLConfigMessage.h"

#import "CLFTImageLabel.h"

#import "CLLotteryOmissionView.h"

#import "CLDEBetButton.h"

#import "CLATManager.h"

#import "UIResponder+CLRouter.h"

#import "AppDelegate.h"

@interface CLATBetOptionsView ()<UIGestureRecognizerDelegate>{

    NSInteger __randomAnimationIndex;
}

@property (nonatomic, strong) CLFTImageLabel *tagLabel;

@property (nonatomic, strong) CLFTImageLabel *omissionTag;

@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, strong) NSMutableArray *omissionLabelArray;

/**
 滑动手势是否可以触发按钮选中状态
 */
@property (nonatomic, assign) BOOL isAllowButtonSelected;


@end

@implementation CLATBetOptionsView

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
    [self addSubview:self.omissionTag];
    
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
    
    [self.omissionTag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.tagLabel);
        make.top.equalTo(self.tagLabel.mas_bottom).offset(CL__SCALE(14.f));
    }];
    
}

- (void)p_createBetButtons
{

    int row,col = 0;
    
    CGFloat width = CL__SCALE(40.f);
    CGFloat height = CL__SCALE(40.f);

    
    for (int i = 0; i < 10 ; i ++) {
       
        CLDEBetButton *button = [[CLDEBetButton alloc] initWithFrame:(CGRectZero)];
        
        button.tag = i + 100;
        button.contentString = [NSString stringWithFormat:@"%zi", i];
        
        button.selectBetButtonBlock = ^(CLDEBetButton *button) {
          
            [self p_buttonClick:button];
        };
        
        row = i / 5;
        col = i % 5;
        
        CGFloat margin = col == 0 ? 0 : CL__SCALE(20.f);
        
        button.frame = CGRectMake(CL__SCALE(70) + margin * col + col * width, row *  height + (row == 0 ? 0 : CL__SCALE(33.f)), width, height);
        
        [self addSubview:button];
        
        [self.buttonArray addObject:button];
    
        //创建遗漏lebal
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"-";
        label.font = FONT_SCALE(13);
        label.textColor = UIColorFromRGB(0x988366);
        label.textAlignment = NSTextAlignmentCenter;
        
        label.frame = CGRectMake(CL__SCALE(70.f) + margin * col + col * width, CL__SCALE(45.f) + row *  CL__SCALE(13.f) + (row == 0 ? 0 : CL__SCALE(60.f)), CL__SCALE(40.f), CL__SCALE(13.f));
        
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
    
    if ([[CLATManager shareManager] getCurrentPlayMethodType] == CLATPlayMothedTypeTwo) {
        
        [self routerWithEventName:@"restoreOptionStatus" userInfo:nil];
    }
    
    [self routerWithEventName:@"OPTIONSBUTTONCLICK" userInfo:nil];
}



#pragma mark ----- Set Method -----
- (void)setTagText:(NSString *)text
{

    self.tagLabel.contentString = text;
}


- (void)setSelectedOptionsWithData:(NSArray *)data
{

    
    [self.buttonArray enumerateObjectsUsingBlock:^(CLDEBetButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
       
        
        btn.selected = [data containsObject:[NSString stringWithFormat:@"%zi", btn.tag - 100]];
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
- (CLFTImageLabel *)omissionTag
{
    
    if (!_omissionTag) {
        _omissionTag = [[CLFTImageLabel alloc] initWithFrame:CGRectZero];
        _omissionTag.contentString = @"遗漏";
        _omissionTag.contentFont = FONT_SCALE(13);
        _omissionTag.contentColor = UIColorFromRGB(0x988366);
        _omissionTag.backImage = [UIImage imageNamed:@""];
        _omissionTag.onClickBlock = ^(){
            
            [CLLotteryOmissionView showLotteryOmissionInWindowWithType:CLOmissionPromptTypeD11];
        };
    }
    return _omissionTag;
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
