//
//  CLDEOneGroupBetNmuberView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/29.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLDEOneGroupBetNmuberView.h"
#import "CLConfigMessage.h"
#import "CLDEBetButton.h"
#import "CLFTImageLabel.h"
#import "CLTools.h"
@interface CLDEOneGroupBetNmuberView ()<UIGestureRecognizerDelegate>{
    
}

@property (nonatomic, strong) NSMutableArray *betButtonArray;//投注按钮的数组
@property (nonatomic, strong) NSMutableArray *omissionArray;//遗漏

@end

@implementation CLDEOneGroupBetNmuberView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addPreSixBetButton];
        [self addNextFiveBetButton];
        [self addPanGesture];
        self.maxSelectedCount = 0;
    }
    return self;
}
#pragma mark ------------ public Mothed ------------
#pragma mark - 随机出来的按钮
- (NSArray *)randomSelectNumberWithArray:(NSArray *)selectNumberArray{
    
    //振动
    [CLTools vibrate];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    NSArray *sortArray = [selectNumberArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return ([obj1 integerValue] > [obj2 integerValue]);
    }];
    
    for (CLDEBetButton *betBtn in self.betButtonArray) {
        betBtn.selected = NO;
    }
    for (NSNumber *selectNumber in sortArray) {
        NSInteger selectInteger = [selectNumber integerValue];
        
        for (CLDEBetButton *betBtn in self.betButtonArray) {
            if (betBtn.tag == selectInteger) {
                [array addObject:betBtn];
            }
        }
    }
    return array;
}
#pragma mark - 改变按钮的选中状态
- (void)changeMutualExclusionBetButton:(NSInteger)tag{
    
    for (CLDEBetButton *betButton in self.betButtonArray) {
        
        if (betButton.tag == tag) {
            betButton.selected = NO;
        }
    }
}
#pragma mark - 选中对应的按钮
- (void)selectBetButtonWithTag:(NSInteger)tag{
    
    for (CLDEBetButton *betButton in self.betButtonArray) {
        
        if (betButton.tag == tag) {
            betButton.selected = YES;
        }
    }
}
#pragma mark - 清空所有选项
- (void)clearAllBet{
    
    for (CLDEBetButton *betButton in self.betButtonArray) {
        betButton.selected = NO;
    }
}
#pragma mark - 配置遗漏
- (void)setOmissionData:(NSArray *)omissionArray{
    
    if (omissionArray && omissionArray.count == 11) {
        [self.omissionArray enumerateObjectsUsingBlock:^(UILabel *  _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            NSString *omissionStr = omissionArray[idx];
            if ([omissionStr rangeOfString:@"^"].location != NSNotFound) {
                
                label.text =  [omissionStr stringByReplacingOccurrencesOfString:@"^" withString:@""];
                label.textColor = THEME_COLOR;
            }else{
                label.textColor = UIColorFromRGB(0x988366);
                label.text = omissionStr;
            }
        }];
    }
}
- (void)setDefaultOmission{
    
    [self.omissionArray enumerateObjectsUsingBlock:^(UILabel *  _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        label.textColor = UIColorFromRGB(0x988366);
        label.text = @"-";
    }];
}
#pragma mark ------------ event Response ------------
#pragma mark - 滑动手势触发事件
- (void)panGestrueRespone:(UIGestureRecognizer *)pan{
    
    CGPoint point = [pan locationInView:self];
    for (CLDEBetButton *betButton in self.betButtonArray) {
        if (CGRectContainsPoint(betButton.frame, point)) {
            betButton.scaleAnimation = YES;
        }else{
            betButton.scaleAnimation = NO;
        }
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        CGPoint point = [pan locationInView:self];
        for (CLDEBetButton *betButton in self.betButtonArray) {
            if (CGRectContainsPoint(betButton.frame, point)) {
                betButton.scaleAnimation = NO;
                betButton.selected = !betButton.selected;
            }
        }
    }
}
#pragma mark - 投注按钮 选中事件
- (void)selectBetButton:(CLDEBetButton *)betButton{
    
    if (self.maxSelectedCount == 0) return;
    NSInteger selectCount = 0;
    for (CLDEBetButton *betView in self.betButtonArray) {
        if (betView.selected) {
            selectCount++;
        }
    }
    if (selectCount > self.maxSelectedCount) {
        betButton.selected = NO;
        //需要弹窗 弹窗提示
        self.needShowHUDBlock ? self.needShowHUDBlock() : nil;
    }
}
#pragma mark ------------ private Mothed ------------
#pragma mark - 添加手势
- (void)addPanGesture{
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestrueRespone:)];
    pan.delegate = self;
    [pan setMinimumNumberOfTouches:1];
    [pan setMaximumNumberOfTouches:1];
    [self addGestureRecognizer:pan];
}
#pragma mark - 添加第一行的六个按钮
- (void)addPreSixBetButton{
    
    WS(_weakSelf)
    CLDEBetButton *lastBetButton = nil;
    for (NSInteger i = 0; i < 6; i++) {
        
        CLDEBetButton *betButton = [[CLDEBetButton alloc] initWithFrame:CGRectZero];
        betButton.contentString = [NSString stringWithFormat:@"%02zi", i + 1];
        betButton.tag = i + 1;
        betButton.selectBetButtonBlock = ^(CLDEBetButton *betButton){
            
            [_weakSelf selectBetButton:betButton];
            _weakSelf.selectStateChangeBlock ? _weakSelf.selectStateChangeBlock(betButton) : nil;
        };
        [self addSubview:betButton];
        [self.betButtonArray addObject:betButton];
        [betButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(__SCALE(34.f));
            make.top.equalTo(self.mas_top);
            if (lastBetButton) {
                make.left.equalTo(lastBetButton.mas_right).offset(__SCALE(5.f));
            }else{
                make.left.equalTo(self).offset(__SCALE(5.f));
            }
            if (lastBetButton) {
                make.width.equalTo(lastBetButton);
            }
        }];
        
        //创建遗漏lebal
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"-";
        label.font = FONT_SCALE(13);
        label.textColor = UIColorFromRGB(0x988366);
        label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(betButton);
            make.top.equalTo(betButton.mas_bottom).offset(__SCALE(0.f));
            make.height.mas_equalTo(__SCALE(25.f));
        }];
        [self.omissionArray addObject:label];
        lastBetButton = betButton;
    }
    //再给最后一个加一个约束 距离右边界
    [lastBetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(- __SCALE(10.f));
    }];
}
#pragma mark - 添加第二行5个
- (void)addNextFiveBetButton{
    
    WS(_weakSelf)
    for (NSInteger i = 0; i < 5; i++) {
        UILabel *lastLabel = self.omissionArray[i];
        CLDEBetButton *betButton = [[CLDEBetButton alloc] initWithFrame:CGRectZero];
        betButton.contentString = [NSString stringWithFormat:@"%02zi", i + 7];
        betButton.tag = i + 7;
        betButton.selectBetButtonBlock = ^(CLDEBetButton *betButton){
            
            [_weakSelf selectBetButton:betButton];
            _weakSelf.selectStateChangeBlock ? _weakSelf.selectStateChangeBlock(betButton) : nil;
        };
        [self addSubview:betButton];
        [self.betButtonArray addObject:betButton];
        [betButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(__SCALE(34.f));
            make.left.right.equalTo(lastLabel);
            make.top.equalTo(lastLabel.mas_bottom).offset(__SCALE(10.f));
            
        }];
        
        //创建遗漏lebal
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"-";
        label.font = FONT_SCALE(13);
        label.textColor = UIColorFromRGB(0x988366);
        label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(betButton);
            make.top.equalTo(betButton.mas_bottom).offset(__SCALE(0.f));
            make.height.mas_equalTo(__SCALE(25.f));
            make.bottom.equalTo(self);
        }];
        [self.omissionArray addObject:label];
    }
}
#pragma mark ------------ getter Mothed ------------
- (NSMutableArray *)betButtonArray{
    
    if (!_betButtonArray) {
        _betButtonArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _betButtonArray;
}
- (NSMutableArray *)omissionArray{
    
    if (!_omissionArray) {
        _omissionArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _omissionArray;
}

@end
