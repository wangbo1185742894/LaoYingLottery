//
//  PZFocusImageLoop.m
//  SSLTlottery
//
//  Created by Paul on 15-1-5.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "PZFocusImageLoop.h"
#import "CQDefinition.h"
#import "UIImageView+CQWebImage.h"

#define pageControlWidth (__SCALE(6.f))

#pragma mark PZFocusImageLoop (Extension)

@interface PZFocusImageLoop ()
{
    NSTimer* __loopTimer;
}

@property (nonatomic, strong) UIScrollView* focusLoopView;
@property (nonatomic, strong) PZPageControl* pageView;
@property (nonatomic, assign) NSInteger currentLoopPage;


- (void)loopScroll;
- (void)loopTapGesture;
- (void)__createLoopAndPageView;

@end

#pragma mark - PZFocusImageLoop

@implementation PZFocusImageLoop



- (void)setAutoLoop:(BOOL)autoLoop
{
    
    if ([self focusCount] < 2) {
        return;
    }
    
    _autoLoop = autoLoop;
    if (_autoLoop)
    {
        //开启自动滚动
        if (!__loopTimer) {
            NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(loopScroll) userInfo:nil repeats:YES];
            __loopTimer = timer;
            timer = nil;
        }
    }
    else
    {
        //关闭自动滚动
        if (__loopTimer) {
            [__loopTimer invalidate];
            __loopTimer = nil;
        }
    }
}

#pragma mark -refresh scroll Image

- (void) reloadFocusImage {
    
    [self __createLoopAndPageView];
}

#pragma mark -geting method

- (UIScrollView *)focusLoopView
{
    if (!_focusLoopView) {
        [__loopTimer invalidate];
        __loopTimer = nil;
        
        _focusLoopView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _focusLoopView.delegate = self;
        _focusLoopView.pagingEnabled = YES;
        _focusLoopView.bounces = NO;
        _focusLoopView.showsHorizontalScrollIndicator = NO;
        _focusLoopView.scrollsToTop = NO;
        UITapGestureRecognizer* loopTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loopTapGesture)];
        [_focusLoopView addGestureRecognizer:loopTapGesture];
        
        NSInteger __count = [self focusCount];
        
        _focusLoopView.scrollEnabled = (__count > 1);
        
        for (int idx = 0; idx < __count + 2; idx++)
        {
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(idx * _focusLoopView.bounds.size.width, 0, _focusLoopView.bounds.size.width, _focusLoopView.bounds.size.height)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            
            NSString* __imgUrl = nil;
            
            if (idx == 0)
            {
                if ([self.delegate respondsToSelector:@selector(focusImageUrlAtIndex:)]) {
                    __imgUrl = [self.delegate focusImageUrlAtIndex:__count - 1];
                }
                [imageView setImageWithURL:[NSURL URLWithString:__imgUrl] placeholderImage:nil];
                
            }
            else if (idx == __count + 1)
            {
                if ([self.delegate respondsToSelector:@selector(focusImageUrlAtIndex:)]) {
                    __imgUrl = [self.delegate focusImageUrlAtIndex:0];
                }
                [imageView setImageWithURL:[NSURL URLWithString:__imgUrl] placeholderImage:nil];
            }
            else
            {
                if ([self.delegate respondsToSelector:@selector(focusImageUrlAtIndex:)]) {
                    __imgUrl = [self.delegate focusImageUrlAtIndex:idx - 1];
                }
                [imageView setImageWithURL:[NSURL URLWithString:__imgUrl] placeholderImage:nil];
            }
            
            [_focusLoopView addSubview:imageView];
        }
        
        _focusLoopView.contentSize = CGSizeMake(_focusLoopView.bounds.size.width * (__count + 2), _focusLoopView.bounds.size.height);
        _focusLoopView.contentOffset = CGPointMake(_focusLoopView.bounds.size.width, 0);
        
        if (__count >= 2)
        {
            NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(loopScroll) userInfo:nil repeats:YES];
            __loopTimer = timer;
            timer = nil;
        }
        
        
    }
    return _focusLoopView;
}

- (PZPageControl *)pageView
{
    if (!_pageView) {
        
        NSInteger __count = [self focusCount];
        CGFloat pageView_Width = (__count * pageControlWidth) + ((__count - 1) * 5.f);
        _pageView = [[PZPageControl alloc] initWithFrame:CGRectMake((self.bounds.size.width - pageView_Width) / 2, self.bounds.size.height - __SCALE(17), pageView_Width, pageControlWidth) ItemCount:__count];
        _pageView.center = CGPointMake(self.bounds.size.width / 2, _pageView.center.y);
        _pageView.hidden = (__count == 1);
        _pageView.selectIndex = 0;
    }
    return _pageView;
}


#pragma mark -private method

//创建view
- (void)__createLoopAndPageView{
    
    if (_focusLoopView) {
        [_focusLoopView removeFromSuperview];
        _focusLoopView = nil;
    }
    if (_pageView) {
        [_pageView removeFromSuperview];
        _pageView = nil;
    }
    
    [self addSubview:self.focusLoopView];
    [self addSubview:self.pageView];
    self.currentLoopPage = 1;
    
}

//loopview 自动滚动
- (void)loopScroll
{
    self.currentLoopPage++;

    [UIView animateWithDuration:0.4f animations:^{
        self.focusLoopView.contentOffset = CGPointMake(self.currentLoopPage * self.focusLoopView.bounds.size.width, 0);
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:self.focusLoopView];
    }];
    
}

//点击loopview
- (void)loopTapGesture
{
    
    if ((self.currentLoopPage - 1) >= [self focusCount]) {
        self.currentLoopPage = 1;
    }
    
    if ([self.delegate respondsToSelector:@selector(focusImageSelectAtIndex:)]) {
        [self.delegate focusImageSelectAtIndex:self.currentLoopPage - 1];
    }
}

//获取bannar图个数
- (NSInteger) focusCount {
    NSInteger __count = 0;
    if ([self.delegate respondsToSelector:@selector(focusImageLoopCount)]) {
        __count = [self.delegate focusImageLoopCount];
    }
    return __count;
}


#pragma mark -scrollview delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageIndex = scrollView.contentOffset.x / scrollView.bounds.size.width;
    if (pageIndex == 0)
    {
        scrollView.contentOffset = CGPointMake([self focusCount] * scrollView.bounds.size.width, 0);
    }
    else if (pageIndex == [self focusCount] + 1)
    {
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    }
    else if (pageIndex > [self focusCount] + 1)
    {
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    }
    
    self.currentLoopPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    self.pageView.selectIndex = self.currentLoopPage - 1;
}

#pragma mark -@override

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    [__loopTimer invalidate];
    __loopTimer = nil;
}

- (void)dealloc
{
    self.delegate = nil;
}

@end

#pragma mark - PZPageControl

@implementation PZPageControl
{
    NSInteger       __itemCount;
    NSMutableArray* __layerItems;
    
}

- (instancetype)initWithFrame:(CGRect)frame ItemCount:(NSInteger)count
{
    self = [super initWithFrame:frame];
    if (self)
    {
        __itemCount = count;
        __layerItems = [[NSMutableArray alloc] init];
        [self pageControlCreateView];
    }
    return self;
}

- (void)pageControlCreateView
{
    float middleSpace = 5.f;
    for (int i = 0; i < __itemCount; i++) {
        CALayer *layer = [[CALayer alloc] init];
        layer.frame = CGRectMake(i * (pageControlWidth + middleSpace), 0, pageControlWidth, pageControlWidth);
        layer.cornerRadius = pageControlWidth / 2;
        [__layerItems addObject:layer];
        layer.backgroundColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:layer];
        
    }
}


- (void)setSelectIndex:(NSInteger)selectIndex
{
    if (selectIndex > __itemCount - 1) {
        return;
    }
    _selectIndex = selectIndex;
    [__layerItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[CALayer class]])
        {
            ((CALayer*)obj).backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f].CGColor;
        }
        
    }];

    id obj = __layerItems[selectIndex];
    
    if ([obj isKindOfClass:[CALayer class]])
    {
        ((CALayer*)obj).backgroundColor = [UIColor whiteColor].CGColor; //UIColorFromRGB(0x004986).CGColor;
    }
    
}

-(void)dealloc
{
//    NSLog(@"%@ | dealloc",[self description]);
}

@end

#pragma mark - FocusImageInfo

@implementation FocusImageInfo

+ (FocusImageInfo*)createFocusImageInfo:(NSDictionary*)dictionary
{
    return [FocusImageInfo mj_objectWithKeyValues:dictionary];
}

MJCodingImplementation

@end
