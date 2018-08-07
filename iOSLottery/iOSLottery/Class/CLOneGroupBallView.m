//
//  CLOneGroupBallView.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/1.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLOneGroupBallView.h"
#import "CLLotteryBallView.h"
#import "CLConfigMessage.h"
#import "CLTools.h"

@interface CLOneGroupBallView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *betButtonArray;//投注按钮的数组
@property (nonatomic, strong) NSMutableArray *omissionArray;//遗漏数组
@property (nonatomic, strong) UIPanGestureRecognizer *panGes;//拖拽手势

@property (nonatomic, assign) BOOL isAllowButtonSelected;//滑动手势是否可以触发按钮选中状态
@property (nonatomic, readwrite) BOOL showOmmission;
@end

@implementation CLOneGroupBallView

- (CLOneGroupBallView *)initWithFrame:(CGRect)frame ballCount:(NSInteger)count ballColor:(UIColor *)color{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.maxSelectedCount = 0;
        [self createBall:count color:color];
        [self addGestureRecognizer:self.panGes];
        self.showOmmission = NO;
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
    
    for (CLLotteryBallView *betBtn in self.betButtonArray) {
        betBtn.selected = NO;
    }
    for (NSNumber *selectNumber in sortArray) {
        NSInteger selectInteger = [selectNumber integerValue];
        
        for (CLLotteryBallView *betBtn in self.betButtonArray) {
            if (betBtn.tag == selectInteger) {
                [array addObject:betBtn];
            }
        }
    }
    return array;
}
#pragma mark - 改变按钮的选中状态
- (void)changeMutualExclusionBetButton:(NSInteger)tag{
    
    for (CLLotteryBallView *betButton in self.betButtonArray) {
        
        if (betButton.tag == tag) {
            betButton.selected = NO;
        }
    }
}
#pragma mark - 选中对应的按钮
- (void)selectBetButtonWithTag:(NSInteger)tag{
    
    for (CLLotteryBallView *betButton in self.betButtonArray) {
        
        if (betButton.tag == tag) {
            betButton.selected = YES;
        }
    }
}
#pragma mark - 清空所有选项
- (void)clearAllBet{
    
    for (CLLotteryBallView *betButton in self.betButtonArray) {
        betButton.selected = NO;
    }
}
#pragma mark - 配置遗漏信息
- (void)assignOmissionData:(NSArray *)dataArray{
    
    if (dataArray && dataArray.count > 0 && dataArray.count == self.omissionArray.count) {
        [self.omissionArray enumerateObjectsUsingBlock:^(UILabel *  _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *omissionStr = dataArray[idx];
            if ([omissionStr rangeOfString:@"^"].location != NSNotFound) {
                
                label.text =  [omissionStr stringByReplacingOccurrencesOfString:@"^" withString:@""];
                label.textColor = THEME_COLOR;
            }else{
                label.textColor = UIColorFromRGB(0x988366);
                label.text = omissionStr;
            }
        }];
    }else{
        
        [self setDefaultOmission];
    }
    
}
#pragma mark - 配置默认遗漏信息
- (void)setDefaultOmission{
    
    [self.omissionArray enumerateObjectsUsingBlock:^(UILabel *  _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        label.textColor = UIColorFromRGB(0x988366);
        label.text = @"-";
    }];
}
#pragma mark - 展示或隐藏遗漏
- (void)hiddenOmissionView:(BOOL)hidden
{
    self.showOmmission = !hidden;
//    for (NSInteger i = 0 ; i < self.betButtonArray.count; i++) {
//        CLLotteryBallView *betButton = self.betButtonArray[i];
//        CGRect betFrame = betButton.frame;
//        betFrame.origin.y = i / 7 * (hidden ? __SCALE(49.f) : __SCALE(69.f));
//        betButton.frame = betFrame;
//    }
//    for (NSInteger i = 0 ; i < self.omissionArray.count; i++) {
//        UILabel *label = self.omissionArray[i];
//        label.hidden = hidden;
//        CGRect labelFrame = label.frame;
//        labelFrame.origin.y = __SCALE(34.f) + i / 7 * ((hidden ? 0 : __SCALE(20.f) + __SCALE(49.f)));
//        label.frame = labelFrame;
//    }
    
    [self.betButtonArray enumerateObjectsUsingBlock:^(CLLotteryBallView *btn, NSUInteger idx, BOOL * _Nonnull stop) {
       
        CGRect betFrame = btn.frame;
        betFrame.origin.y = idx / 7 * (hidden ? __SCALE(49.f) : __SCALE(69.f));
        btn.frame = betFrame;
        
    }];
    
    [self.omissionArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
       
        label.hidden = hidden;
        CGRect labelFrame = label.frame;
        labelFrame.origin.y = __SCALE(34.f) + idx / 7 * ((hidden ? 0 : __SCALE(20.f) + __SCALE(49.f)));
        label.frame = labelFrame;
    }];
    
    //[self layoutIfNeeded];
}
#pragma mark ------------ event Response ------------
#pragma mark - 滑动手势触发事件
- (void)panGestrueRespone:(UIGestureRecognizer *)pan{
    
    if (self.isAllowButtonSelected) {
        
        CGPoint point = [pan locationInView:self];
        for (CLLotteryBallView *betButton in self.betButtonArray) {
            if (CGRectContainsPoint(betButton.frame, point)) {
                betButton.scaleAnimation = YES;
            }else{
                betButton.scaleAnimation = NO;
            }
        }
        
        if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
            self.isAllowButtonSelected = NO;
            CGPoint point = [pan locationInView:self];
            for (CLLotteryBallView *betButton in self.betButtonArray) {
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
    for (CLLotteryBallView *betButton in self.betButtonArray) {
        if (CGRectContainsPoint(betButton.frame, point)) {
            self.isAllowButtonSelected = YES;
            return NO;
        }
    }
    self.isAllowButtonSelected = NO;
    return YES;
}
#pragma mark - 投注按钮 选中事件
- (void)selectBetButton:(CLLotteryBallView *)betButton{
    
    if (self.maxSelectedCount == 0) return;
    NSInteger selectCount = 0;
    for (CLLotteryBallView *betView in self.betButtonArray) {
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

- (CGFloat)getOneGroupBallVeiwHeightWithCount:(NSInteger)interger
{
    CGFloat obetViewHeight = (self.showOmmission ? __SCALE(69.f) : __SCALE(49.f));
    CGFloat marginHeight = interger % 7 ? (self.showOmmission ? __SCALE(54.f) : __SCALE(34.f)) : __SCALE(-15.f);
    return interger > 0 ? (interger / 7 * obetViewHeight + marginHeight) : 0;
}

#pragma mark ------------ private Mothed ------------
#pragma mark - 创建对用的球数
- (void)createBall:(NSInteger)count color:(UIColor *)color{
    NSInteger consult = count / 7;//取商
    NSInteger remainder = count % 7;//取余
    NSInteger rowCount = consult;//行数
    NSInteger col = 0;//如果1行不足时，用col代替
    if (rowCount == 0) {
        rowCount = 1;
        col = remainder;
        remainder = 0;
    }
    
    NSLog(@"***************************8");
    
    [self.omissionArray removeAllObjects];
    [self.betButtonArray removeAllObjects];
    CGFloat buttonW = (SCREEN_WIDTH - 2 * __SCALE(10.f) - 6 * __SCALE(12.f)) / 7;
    for (NSInteger i = 0; i < count; i++) {
        CLLotteryBallView *betButton = [self createBallViewWithTag:i + 1 selectColor:color];
        betButton.frame = __Rect(__SCALE(10.f) + i % 7 * (buttonW + __SCALE(12.f)), i / 7 * __SCALE(49.f), buttonW, __SCALE(34.f));
        UILabel *label = [self createOmissionLable];
        label.hidden = YES;
        label.frame = __Rect(CGRectGetMinX(betButton.frame), 0, buttonW, __SCALE(20.f));
    }
    
//    NSMutableArray *lastBetButtonArray = [NSMutableArray arrayWithCapacity:0];//用来记录上一行的按钮
//    NSMutableArray *lastLabelArray = [NSMutableArray arrayWithCapacity:0];
//    CLLotteryBallView *rowLastBetButton = nil;
//    UILabel *rowLastLabel = nil;
//    for (NSInteger i = 0; i < rowCount; i++) {
//        
//        [lastBetButtonArray removeAllObjects];
//        [lastLabelArray removeAllObjects];
//        CLLotteryBallView *lastBetButton = nil;
//        UILabel *lastLabel = nil;
//        for (NSInteger j = 0; j < 7; j++) {
//            
//            CLLotteryBallView *betButton = [self createBallViewWithTag:(i * 7) + j + 1 selectColor:color];
//            [lastBetButtonArray addObject:betButton];
//            
//            [betButton mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(__SCALE(34.f));
//                
//                if (rowLastBetButton) {
//                    make.top.equalTo(rowLastLabel.mas_bottom).offset(__SCALE(15.f));
//                }else{
//                    make.top.equalTo(self);
//                }
//                
//                if (lastBetButton) {
//                    make.left.equalTo(lastBetButton.mas_right).offset(__SCALE(12.f));
//                }else{
//                    make.left.equalTo(self).offset(__SCALE(10.f));
//                }
//                if (lastBetButton) {
//                    make.width.equalTo(lastBetButton);
//                }
//            }];
//            
//            //创建遗漏lebal
//            UILabel *label = [self createOmissionLable];
//            [lastLabelArray addObject:label];
//            [label mas_makeConstraints:^(MASConstraintMaker *make) {
//                
//                make.left.right.equalTo(betButton);
//                make.top.equalTo(betButton.mas_bottom).offset(__SCALE(0.f));
//                make.height.mas_equalTo(__SCALE(0.f));
//            }];
//            
//            if (col > 0 && j > col - 1) {
//                //表示只有一行 则隐藏多余的
//                betButton.hidden = YES;
//                label.hidden = YES;
//            }
//            lastLabel = label;
//            lastBetButton = betButton;
//        }
//        //再给最后一个加一个约束 距离右边界
//        [lastBetButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self).offset(- __SCALE(10.f));
//        }];
//        rowLastLabel = lastLabel;
//        rowLastBetButton = lastBetButton;
//    }
//    if (remainder == 0) {
//        
//        [rowLastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self);
//        }];
//        
//    }
//    
//    //创建完基本九宫格之后  再将 余数 的View添加
//    for (NSInteger i = 0; i < remainder; i ++) {
//        
//        CLLotteryBallView *betButton = [self createBallViewWithTag:rowCount * 7 + i + 1 selectColor:color];
//        CLLotteryBallView *lastRowBetButton = lastBetButtonArray[i];
//        UILabel *lastLabel = lastLabelArray[i];
//        [betButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.right.height.equalTo(lastRowBetButton);
//            make.top.equalTo(lastLabel.mas_bottom).offset(__SCALE(15.f));
//        }];
//        //创建遗漏lebal
//        UILabel *label = [self createOmissionLable];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.right.equalTo(betButton);
//            make.top.equalTo(betButton.mas_bottom).offset(__SCALE(0.f));
//            make.height.mas_equalTo(__SCALE(0.f));
//            make.bottom.equalTo(self);
//        }];
//    }
    
}
#pragma mark - 创建按钮
- (CLLotteryBallView *)createBallViewWithTag:(NSInteger)tag selectColor:(UIColor *)color{
    
    CLLotteryBallView *betButton = [[CLLotteryBallView alloc] initWithFrame:CGRectZero];
    betButton.contentString = [NSString stringWithFormat:@"%02zi",tag];
    betButton.tag = tag;
    betButton.selectColor = color;
    WS(_weakSelf)
    betButton.selectBetButtonBlock = ^(CLLotteryBallView *betButton){
        
        [_weakSelf selectBetButton:betButton];
        _weakSelf.selectStateChangeBlock ? _weakSelf.selectStateChangeBlock(betButton) : nil;
    };
    [self addSubview:betButton];
    [self.betButtonArray addObject:betButton];
    return betButton;
}
#pragma mark - 创建遗漏的label
- (UILabel *)createOmissionLable{
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"-";
    label.textColor = UIColorFromRGB(0x988366);
    label.font = FONT_SCALE(13);
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    [self.omissionArray addObject:label];
    return label;
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
- (UIPanGestureRecognizer *)panGes{
    
    if (!_panGes) {
        _panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestrueRespone:)];
        _panGes.delegate = self;
        [_panGes setMinimumNumberOfTouches:1];
        [_panGes setMaximumNumberOfTouches:1];
    }
    return _panGes;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect selfFreme = self.frame;
    selfFreme.size.height = [self getOneGroupBallVeiwHeightWithCount:self.betButtonArray.count];
    self.frame = selfFreme;
}

@end
