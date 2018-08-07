//
//  CLSelectDateView.m
//  日期控制器
//
//  Created by 任鹏杰 on 2017/4/19.
//  Copyright © 2017年 任鹏杰. All rights reserved.
//

#import "SLDrawNoticeDateSelectView.h"
#import "SLConfigMessage.h"
#import "SLDrawNoticeDateModel.h"

#import "SLBasicAnimation.h"

@interface SLDrawNoticeDateSelectView ()<UIPickerViewDelegate,UIPickerViewDataSource,CAAnimationDelegate>

/**
 内容视图
 */
@property (nonatomic, strong) UIView *contentView;

/**
 标题label
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 回到今日按钮
 */
@property (nonatomic, strong) UIButton *goToday;

/**
 日期控件
 */
@property (nonatomic, strong) UIPickerView *dataPicker;

/**
 取消按钮
 */
@property (nonatomic, strong) UIButton *cancelBtn;

/**
 确定按钮
 */
@property (nonatomic, strong) UIButton *sureBtn;

/**
 蒙版Layer
 */
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, assign) NSInteger indexOfMonth;

@property (nonatomic, assign) NSInteger indexOfDay;


@end

@implementation SLDrawNoticeDateSelectView


- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.maskView];

        [self addSubviews];
        [self addConstraints];
        
        self.frame = CGRectMake(0, 0, SL_SCREEN_WIDTH, SL_SCREEN_HEIGHT);

        self.maskView.bounds = self.frame;
    }

    return self;
}


- (void)addSubviews
{
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.goToday];
    [self.contentView addSubview:self.dataPicker];
    [self.contentView addSubview:self.cancelBtn];
    [self.contentView addSubview:self.sureBtn];
    
}

- (void)addConstraints
{

    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.centerY.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView.mas_top).offset(SL__SCALE(13.f));

        make.centerX.equalTo(self.contentView);
    }];
    
    [self.goToday mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.contentView.mas_right).offset(SL__SCALE(-20.f));
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [self.dataPicker mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.titleLabel.mas_bottom).offset(SL__SCALE(13.f));
        make.right.left.equalTo(self.contentView);
        make.height.mas_equalTo(SL__SCALE(150.f));
        make.bottom.equalTo(self.cancelBtn.mas_top).offset(SL__SCALE(-43.f));
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.dataPicker.mas_bottom).offset(SL__SCALE(13.f));
        make.left.equalTo(self.contentView.mas_left).offset(SL__SCALE(20.f));
        make.width.mas_equalTo(SL__SCALE(140.f));
        make.height.mas_equalTo(SL__SCALE(35.f));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(SL__SCALE(-12.f));
        
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.cancelBtn.mas_right).offset(SL__SCALE(20.f));
        make.right.equalTo(self.contentView.mas_right).offset(SL__SCALE(-20.f));
        make.centerY.width.height.equalTo(self.cancelBtn);
    }];

}

- (void)showInWindow
{

    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [self goToSelectedDay:_indexOfMonth day:_indexOfDay];
    
    [self.contentView.layer addAnimation:[SLBasicAnimation alertContentAppearGruopAnimation] forKey:@"groupAnimation"];
    
    [self.maskView.layer addAnimation:[SLBasicAnimation alertMaskAppearAppearAnimation] forKey:@"animation"];
    
}


#pragma mark --- Button Click ---

- (void)goToSelectedDay:(NSInteger)month day:(NSInteger)day{
    
    
    [self.dataPicker selectRow:month inComponent:0 animated:YES];
    
    [self.dataPicker reloadComponent:1];
    
    [self.dataPicker selectRow:day inComponent:1 animated:YES];
}

- (void)gotoTodayClick
{

    _indexOfMonth = self.dataArray.count - 1;
    
    SLDrawNoticeDateModel *model = self.dataArray[_indexOfMonth];
    
    _indexOfDay = model.daysArray.count - 1;
    
    [self goToSelectedDay:_indexOfMonth day:_indexOfDay];
}


- (void)cancelBtnClick
{
    
    
    
    [self startDisMissAnimation];

}

- (void)didSelectDate
{
    
    SLDrawNoticeDateModel *model = self.dataArray[[self.dataPicker selectedRowInComponent:0]];
    
    if ([self.dataPicker selectedRowInComponent:1] >= model.daysArray.count) return;
    
    self.sureBtnClock ? self.sureBtnClock([self getStringOfSelectedDate]) : nil;
    
    [self recordCurrentSelectedDate];

    [self startDisMissAnimation];
}

- (void)tapClick
{

    [self startDisMissAnimation];
}


//开始取消动画
- (void)startDisMissAnimation
{

    [self.maskView.layer addAnimation:[SLBasicAnimation alertMaskDisAppearAnimation] forKey:@"didmiss"];
    
    CAAnimationGroup *groupAnimation = [SLBasicAnimation alertContentDisAppearGroupAnimation];
    
    groupAnimation.delegate = self;
    
    [self.contentView.layer addAnimation:groupAnimation forKey:@"didmiss"];
}

#pragma mark --- CAAnimationDelegate ---

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{

    [self.contentView.layer removeAllAnimations];
    [self.maskView.layer removeAllAnimations];
    
    [self removeFromSuperview];
}


//获取当前选中的日期字符串
- (NSString *)getStringOfSelectedDate
{

    SLDrawNoticeDateModel *model = self.dataArray[[self.dataPicker selectedRowInComponent:0]];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@%@",model.titleName,model.daysArray[[self.dataPicker selectedRowInComponent:1]]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    
    NSDate *date = [formatter dateFromString:dateStr];
    
    formatter.dateFormat = @"yyyy-MM-dd";
    
    dateStr = [formatter stringFromDate:date];
    
    return dateStr;
    
}

//记录当前选中的日期
- (void)recordCurrentSelectedDate
{

    _indexOfMonth  = [self.dataPicker selectedRowInComponent:0];
    _indexOfDay = [self.dataPicker selectedRowInComponent:1];
        
}

#pragma mark --- UIPickerViewDelegate ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{

    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0){
    
        return self.dataArray.count;
        
    }else{
    
        SLDrawNoticeDateModel *model = self.dataArray[_indexOfMonth];
    
        return model.daysArray.count;
    }

}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{

    if (component == 0) return SL__SCALE(180.f);

    return SL__SCALE(70.f);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{

    return SL__SCALE(50.f);
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    if (component == 0) {
        
        //_indexOfMonth = row;
        
        [self.dataPicker reloadComponent:1];
        
        [self.dataPicker selectRow:_indexOfDay inComponent:1 animated:NO];
        
    }else{
    
        //_indexOfDay = row;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    [self changeSpearatorLineColor];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    
    contentLabel.backgroundColor = [UIColor clearColor];
    
    if (component == 0) {
        
        SLDrawNoticeDateModel *model = self.dataArray[row];
        
        contentLabel.text = model.titleName;
        
        return contentLabel;
        
    }else{
        
        SLDrawNoticeDateModel *model = self.dataArray[_indexOfMonth];
        
        contentLabel.text = model.daysArray[row];
        
        return contentLabel;
    }
    
}

- (void)changeSpearatorLineColor
{
    for(UIView *speartorView in self.dataPicker.subviews)
    {
        if (speartorView.frame.size.height < 1)//取出分割线view
        {
            speartorView.backgroundColor = SL_UIColorFromRGB(0xEEEEEE);//隐藏分割线
        }
    }
}
#pragma mark --setter
- (void)setDataArray:(NSArray *)dataArray{
    
    if (_dataArray.count == 0) {
        
        if (self.defaultSelectDate && self.defaultSelectDate.length) {
            [dataArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(SLDrawNoticeDateModel * _Nonnull dayObj, NSUInteger didx, BOOL * _Nonnull mstop) {
                [dayObj.daysArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *dateStr = [NSString stringWithFormat:@"%@%@",dayObj.titleName,obj];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"yyyy年MM月dd日";
                    NSDate *date = [formatter dateFromString:dateStr];
                    formatter.dateFormat = @"yyyy-MM-dd";
                    dateStr = [formatter stringFromDate:date];
                    if ([dateStr isEqualToString:self.defaultSelectDate]) {
                        _indexOfMonth = didx;
                        _indexOfDay = idx;
                        *mstop = YES;
                    }
                }];
            }];
            
        }else{
            SLDrawNoticeDateModel *model = dataArray[dataArray.count - 1];
            _indexOfMonth = dataArray.count - 1;
            _indexOfDay = model.daysArray.count - 1;
        }
    }
    _dataArray = dataArray;
    
    
}

#pragma mark --- lazyLoad ---

- (UIButton *)sureBtn
{
    if (_sureBtn == nil) {
        
        _sureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        [_sureBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        
        _sureBtn.titleLabel.font = SL_FONT_SCALE(16.f);
        
        [_sureBtn setBackgroundColor:SL_UIColorFromRGB(0xE63222)];
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius = 3.f;
        [_sureBtn addTarget:self action:@selector(didSelectDate) forControlEvents:(UIControlEventTouchUpInside)];
    }

    return _sureBtn;

}

- (UIButton *)cancelBtn
{

    if (_cancelBtn == nil) {
        
        _cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [_cancelBtn setTitleColor:SL_UIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        
        _cancelBtn.titleLabel.font = SL_FONT_SCALE(16.f);
        
        _cancelBtn.layer.masksToBounds = YES;
        _cancelBtn.layer.cornerRadius = 3.f;
        _cancelBtn.layer.borderWidth = 1.f;
        _cancelBtn.layer.borderColor = SL_UIColorFromRGB(0xEEEEEE).CGColor;
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }

    return _cancelBtn;

}

- (UIPickerView *)dataPicker
{

    if (_dataPicker == nil) {
        
        _dataPicker = [[UIPickerView alloc] init];
        
        _dataPicker.delegate = self;
        _dataPicker.dataSource = self;
    
    }
    return _dataPicker;
}

- (UIButton *)goToday
{
  
    if (_goToday == nil) {
        
        _goToday = [UIButton buttonWithType:(UIButtonTypeCustom)];

        [_goToday setTitle:@"回到今日" forState:(UIControlStateNormal)];
        [_goToday setTitleColor:SL_UIColorFromRGB(0x45A2F7) forState:(UIControlStateNormal)];
        
        _goToday.titleLabel.font = SL_FONT_SCALE(14.f);
        
        [_goToday addTarget:self action:@selector(gotoTodayClick) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    
    return _goToday;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"·选择比赛日期·";
        _titleLabel.font = SL_FONT_SCALE(16.f);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;

}

- (UIView *)contentView
{
    if (_contentView == nil) {
        
        _contentView = [[UIView alloc] init];
        
        _contentView.layer.masksToBounds = YES;

        _contentView.layer.cornerRadius = 5.f;
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    
    return _contentView;

}

- (UIView *)maskView
{
    
    if (_maskView == nil) {
        
        _maskView = [[UIView alloc] init];
        
        _maskView.backgroundColor = SL_UIColorFromRGBandAlpha(0x000000, 0.7);
        
        _maskView.layer.anchorPoint = CGPointMake(0, 0);
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
//        
//        [_maskView addGestureRecognizer:tap];

    }
    return _maskView;
}

@end
