//
//  CLLotteryBespeakViewController.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLLotteryBespeakViewController.h"
#import "UILabel+CLAttributeLabel.h"
#import "DALabeledCircularProgressView.h"

#define CQ_BESPEAK_RED_COLOR  UIColorFromRGB(0xff4747)
#define CQ_BESPEAK_Timer_Interval 0.02f
#define CQ_BESPEAK_Timer_Multiple 3.f

@interface CLLotteryBespeakViewController ()

@property (nonatomic, strong) CALayer* bgImgLayer;
@property (nonatomic, strong) CQBesPeakAnimateView* bespeakAnimateView;
@property (nonatomic, strong) CQBesPeakImgView* bespeakImgView;

@property (nonatomic, strong) NSTimer* timer;

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* describLabel;
@property (nonatomic, strong) UIImageView* bottomImgView;

@property (nonatomic, assign) NSTimeInterval totalTimeInterval;
@property (nonatomic, assign) NSTimeInterval cntTimeInterval;
@property (nonatomic, assign) NSInteger storeOldCount;
@property (nonatomic, assign) NSInteger storeTotalCount;

@property (nonatomic, assign) NSTimeInterval progressInterval; //进度条进度频率

@end

@implementation CLLotteryBespeakViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageStatisticsName = @"彩票店抢单";
    self.view.backgroundColor = [UIColor blackColor];
    if (self.snapView){
        [self.view.layer addSublayer:self.bgImgLayer];
        self.bgImgLayer.contents = (id)self.snapView.CGImage;
        self.bgImgLayer.opacity = .6f;
    }
    
    
    if (self.lotteryBespeak.ifShowPostName == CLLotteryBespeakTypeAnimation) {
        self.cntTimeInterval = 0.f;
        self.totalTimeInterval = (self.lotteryBespeak.counter <= 0)?4:self.lotteryBespeak.counter;
        self.storeOldCount = 0;
        self.storeTotalCount = arc4random() % 50 + 50;
        self.progressInterval = 1.f/(self.totalTimeInterval / (CQ_BESPEAK_Timer_Multiple *CQ_BESPEAK_Timer_Interval));
        
        [self addObserver:self forKeyPath:@"cntTimeInterval" options:NSKeyValueObservingOptionNew context:nil];
        [self.view addSubview:self.bespeakAnimateView];
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:CQ_BESPEAK_Timer_Interval target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
        
    } else if (self.lotteryBespeak.ifShowPostName == CLLotteryBespeakTypeNoAnimation) {
        [self.view addSubview:self.bespeakImgView];
        self.bespeakImgView.flagLbl.text = self.lotteryBespeak.soldInfo;
        self.bespeakImgView.msgLbl.text = self.lotteryBespeak.saleInfo;
        
        [self performSelector:@selector(closeCntViewController) withObject:nil afterDelay:1.f];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSTimeInterval interval = [change[@"new"] doubleValue];
    NSInteger index = ceill(interval);
    
    if (interval >= self.totalTimeInterval) {
        [self.timer invalidate];
        self.timer = nil;
        
        self.bespeakAnimateView.msgLbl.text = self.lotteryBespeak.postStationName;
        self.bespeakAnimateView.flagLbl.text = self.lotteryBespeak.soldInfo;
        self.bespeakAnimateView.labeledProgressView.progressLabel.text = @"";
        self.bespeakAnimateView.successLayer.hidden = NO;
        self.bespeakAnimateView.flagLbl.hidden = NO;
        
        [self removeObserver:self forKeyPath:@"cntTimeInterval"];
        [self performSelector:@selector(closeCntViewController) withObject:nil afterDelay:1.f];
    } else {
        
        NSInteger ii = (NSInteger)ceill(interval / 0.06);
        // 频率每秒
        NSInteger rate =  1 / (CQ_BESPEAK_Timer_Multiple * CQ_BESPEAK_Timer_Interval);
        
        if (ii % rate == 0) {
            self.storeOldCount += ceill(self.storeTotalCount / self.totalTimeInterval);
        }
        
        NSString* storeCount =[NSString stringWithFormat:@"%zi",self.storeOldCount];
        NSString* storeString = [NSString stringWithFormat:@"%@%@",storeCount,self.lotteryBespeak.saleInfo];
        [self.bespeakAnimateView.msgLbl attributeWithText:storeString controParams:@[[AttributedTextParams attributeRange:[storeString rangeOfString:storeCount] Color:CQ_BESPEAK_RED_COLOR]]];
        
        self.bespeakAnimateView.labeledProgressView.progressLabel.text = [NSString stringWithFormat:@"%ld", (NSInteger)index];
        
        
        float progress = ((NSInteger)(interval * 100.f) % 100 ) / 100.f;
        
        self.bespeakAnimateView.labeledProgressView.progressLabel.textColor = [UIColor redColor];
        self.bespeakAnimateView.labeledProgressView.progressLabel.font = FONT(progress * 15 + 20);
        
    }
}

/** 倒计时计时器触发事件 */
- (void) progressChange
{
    //叠加当前时间
    self.cntTimeInterval += (CQ_BESPEAK_Timer_Multiple * CQ_BESPEAK_Timer_Interval);
    //叠加进度条进度
    
    if (self.timer == nil) {
        return;
    }
    
    float progress = ((NSInteger)(self.cntTimeInterval * 100.f) % 100 ) / 100.f ;
    
    //设置进度条进度
    [self.bespeakAnimateView.labeledProgressView setProgress:progress animated:NO];
}

- (void) closeCntViewController
{
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.bespeakCompletion) {
            self.bespeakCompletion();
        }
    }];
}

#pragma mark - getter method

- (UIView *)bespeakAnimateView
{
    if (!_bespeakAnimateView) {
        _bespeakAnimateView = [[CQBesPeakAnimateView alloc] initWithFrame:__Rect(0, 0, __SCALE(205.f), __SCALE(203.f))];
        _bespeakAnimateView.backgroundColor = UIColorFromRGB(0xfffdf4);
        _bespeakAnimateView.center = CGPointMake(self.view.center.x, SCREEN_HEIGHT * .55f);
        _bespeakAnimateView.flagLbl.hidden = YES;
    }
    return _bespeakAnimateView;
}

- (UIView *)bespeakImgView
{
    if (!_bespeakImgView) {
        _bespeakImgView = [[CQBesPeakImgView alloc] initWithFrame:__Rect(0, 0, __SCALE(205.f), __SCALE(203.f))];
        _bespeakImgView.backgroundColor = UIColorFromRGB(0xfffdf4);
        _bespeakImgView.center = CGPointMake(self.view.center.x, SCREEN_HEIGHT * .55f);
    }
    return _bespeakImgView;
}

- (CALayer *)bgImgLayer
{
    if (!_bgImgLayer) {
        _bgImgLayer = [CALayer layer];
        _bgImgLayer.frame = self.view.frame;
    }
    return _bgImgLayer ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

@implementation CQBesPeakAnimateView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10.f;
        [self addSubview:self.bottomImgView];
        
        self.labeledProgressView = [[DALabeledCircularProgressView alloc] initWithFrame:CGRectMake(0.f, 0.0f, __Obj_Bounds_Width(self) / 3.f, __Obj_Bounds_Width(self) / 3.f)];
        self.labeledProgressView.innerTintColor = UIColorFromRGB(0xfffdf4);
        self.labeledProgressView.trackTintColor = UIColorFromRGB(0xdcdcdc);
        self.labeledProgressView.center = CGPointMake(__Obj_Bounds_Width(self) / 2.f, 0);
        self.labeledProgressView.roundedCorners = YES;
        self.labeledProgressView.thicknessRatio = .2f;
        self.labeledProgressView.progressTintColor = CQ_BESPEAK_RED_COLOR;
        [self addSubview:self.labeledProgressView];
        [self addSubview:self.flagLbl];
        [self addSubview:self.msgLbl];
        [self.layer addSublayer:self.successLayer];
        
    }
    return self;
}

- (CALayer *)successLayer
{
    if (!_successLayer) {
        _successLayer = [CALayer layer];
        _successLayer.frame = __Rect(__Obj_Frame_X(self.labeledProgressView) + (__Obj_Bounds_Width(self.labeledProgressView) -  __SCALE(35.f)) / 2.f, __Obj_Frame_Y(self.labeledProgressView) + (__Obj_Bounds_Height(self.labeledProgressView) -  __SCALE(24.f)) / 2.f, __SCALE(35.f), __SCALE(24.f));
        _successLayer.contents = (id)[UIImage imageNamed:@"BespeakSuccess"].CGImage;
        _successLayer.hidden = YES;
    }
    return _successLayer;
}

- (UILabel *)flagLbl
{
    if (!_flagLbl) {
        AllocNormalLabel(_flagLbl, @"", FONT_SCALE(13), NSTextAlignmentCenter, CQ_BESPEAK_RED_COLOR, __Rect(0, __Obj_Frame_Y(self.bottomImgView) - __SCALE(40), __Obj_Bounds_Width(self), __SCALE(30)))
        
    }
    return _flagLbl;
}

- (UILabel *)msgLbl
{
    if (!_msgLbl) {
        CGFloat msg_y = __Obj_Bounds_Height(self.labeledProgressView) / 2.f + 10.f;
        AllocNormalLabel(_msgLbl, @"", FONT_SCALE(19), NSTextAlignmentCenter, UIColorFromRGB(0x333333), __Rect(20, msg_y , __Obj_Bounds_Width(self) - 40.f, __Obj_Frame_Y(self.flagLbl) - msg_y))
        _msgLbl.numberOfLines = 0;
        _msgLbl.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _msgLbl;
}

- (UIImageView *)bottomImgView
{
    if (!_bottomImgView) {
        _bottomImgView = [[UIImageView alloc] initWithFrame:__Rect(0, 0, __SCALE(141.f) , __SCALE(82.f))];
        _bottomImgView.center = CGPointMake(__Obj_Bounds_Width(self) / 2.f, __Obj_Bounds_Height(self) / 3.f * 2.f);
        _bottomImgView.image = [UIImage imageNamed:@"LotteryStoreImg"];
    }
    return _bottomImgView;
}


@end

@implementation CQBesPeakImgView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10.f;
        [self addSubview:self.bottomImgView];
        [self addSubview:self.flagLbl];
        [self addSubview:self.msgLbl];
    }
    return self;
}

- (UILabel *)flagLbl
{
    if (!_flagLbl) {
        AllocNormalLabel(_flagLbl, @"", FONT_SCALE(18), NSTextAlignmentCenter, CQ_BESPEAK_RED_COLOR, __Rect(0, __SCALE(20), __Obj_Bounds_Width(self), __SCALE(30)))
    }
    return _flagLbl;
}

- (UILabel *)msgLbl
{
    if (!_msgLbl) {
        AllocNormalLabel(_msgLbl, @"", FONT_SCALE(13), NSTextAlignmentCenter, UIColorFromRGB(0x333333), __Rect(0, __Obj_YH_Value(self.flagLbl), __Obj_Bounds_Width(self), __Obj_Frame_Y(self.bottomImgView) - __Obj_YH_Value(self.flagLbl)))
        _msgLbl.numberOfLines = 0;
        _msgLbl.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _msgLbl;
}

- (UIImageView *)bottomImgView
{
    if (!_bottomImgView) {
        _bottomImgView = [[UIImageView alloc] initWithFrame:__Rect(0, 0, __SCALE(141.f) , __SCALE(82.f))];
        _bottomImgView.center = CGPointMake(__Obj_Bounds_Width(self) / 2.f, __Obj_Bounds_Height(self) / 3.f * 2.f);
        _bottomImgView.image = [UIImage imageNamed:@"LotteryStoreImg"];
    }
    return _bottomImgView;
}

@end



@implementation CLBespeakLotteryModel
@end
