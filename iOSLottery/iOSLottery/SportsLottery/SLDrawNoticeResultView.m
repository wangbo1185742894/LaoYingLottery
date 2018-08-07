//
//  SLMatchResultView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/19.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLDrawNoticeResultView.h"
#import "SLConfigMessage.h"

@interface SLDrawNoticeResultView ()

/**
 赛事信息异常View
 */
@property (nonatomic, strong) UIView *dataExceptionView;

/**
 赛事信息异常Label
 */
@property (nonatomic, strong) UILabel *dataExceptionLabel;


@end

@implementation SLDrawNoticeResultView

- (void)setDataWithArray:(NSArray *)dataArray isCancel:(NSInteger)isCancel;
{
   
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //赛事是否取消
    if (isCancel == 1) {
        
        self.dataExceptionLabel.text = @"赛事取消";
        
        [self addSubview:self.dataExceptionView];
        
        [self.dataExceptionView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.right.bottom.top.equalTo(self);
            make.height.mas_offset(SL__SCALE(60.f));
            
        }];
        return;
    }
    

    //数据校验，数组长度不等于5代表数据错误
    if (!(dataArray && dataArray.count == 5)){
    
        self.dataExceptionLabel.text = @"暂无数据";
        
        [self addSubview:self.dataExceptionView];
        
        [self.dataExceptionView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.right.bottom.top.equalTo(self);
            make.height.mas_offset(SL__SCALE(60.f));
        }];
        return;
    }
    
    SLDrawNoticeResultItem *lastItem;
    
    for (int i = 0; i < dataArray.count; i++) {
        
        SLDrawNoticeResultItem *item = [[SLDrawNoticeResultItem alloc] initWithFrame:(CGRectZero)];
        
        //设置item数据
        [item setUpItemDataWithString:dataArray[i]];
        
        [self addSubview:item];
        
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
           
            if (lastItem) {
                
                make.left.equalTo(lastItem.mas_right);
                
            }else{
            
                make.left.equalTo(self);
            }
            
            make.top.bottom.equalTo(self);
            
            if (i == dataArray.count - 1) {
                
                make.right.equalTo(self.mas_right);
            }
            
        }];
        
        lastItem = item;
    }

}


- (UIView *)dataExceptionView
{

    if (_dataExceptionView == nil) {
        
        _dataExceptionView = [[UIView alloc] initWithFrame:(CGRectZero)];
        
        [_dataExceptionView addSubview:self.dataExceptionLabel];
        
        [self.dataExceptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.centerY.equalTo(_dataExceptionView);
        }];
        
        
        UIView *leftLine = [[UIView alloc] initWithFrame:(CGRectZero)];
        leftLine.backgroundColor = SL_UIColorFromRGB(0xDDDDDD);
        
        [_dataExceptionView addSubview:leftLine];
        
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.width.mas_equalTo(SL__SCALE(80.f));
            make.height.mas_equalTo(1);
            make.centerY.equalTo(self.dataExceptionLabel);
            make.right.equalTo(self.dataExceptionLabel.mas_left).offset(SL__SCALE(-5.f));
        }];
        
        UIView *rightLine = [[UIView alloc] initWithFrame:(CGRectZero)];
        rightLine.backgroundColor = SL_UIColorFromRGB(0xDDDDDD);
        
        [_dataExceptionView addSubview:rightLine];
        
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.dataExceptionLabel.mas_right).offset(SL__SCALE(5.f));
            make.centerY.width.height.equalTo(leftLine);
        }];
        
    }
    return _dataExceptionView;
}

- (UILabel *)dataExceptionLabel
{

    if (_dataExceptionLabel == nil) {
        
        _dataExceptionLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _dataExceptionLabel.text = @"赛事数据异常";
        _dataExceptionLabel.textColor = SL_UIColorFromRGB(0x999999);
        _dataExceptionLabel.font = SL_FONT_SCALE(12.f);
    }
    return _dataExceptionLabel;
}


@end


@implementation SLDrawNoticeResultItem

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubviews];
        [self addConstraints];
    }
    
    return self;
}

- (void)addSubviews
{
    
    [self addSubview:self.playLabel];
    [self addSubview:self.oddsLabel];
}

- (void)addConstraints
{
    
    [self.playLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(SL__SCALE(9.f));
        make.width.mas_equalTo(SL__SCALE(75.f));
        make.left.right.equalTo(self);
        make.height.mas_offset(SL__SCALE(17.f));
    }];
    
    [self.oddsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.playLabel.mas_bottom).offset(SL__SCALE(9.f));
        make.left.right.equalTo(self);
        make.width.mas_equalTo(SL__SCALE(75.f));
        make.height.mas_offset(SL__SCALE(17));
        make.bottom.equalTo(self.mas_bottom).offset(SL__SCALE(-9.f));
        
    }];
    
}

- (void)setUpItemDataWithString:(NSString *)str
{
    
    //根据"_"字符切割字符串
    NSArray *arr = [str componentsSeparatedByString:@"_"];
    
    //数据校验
    if (arr && arr.count == 2) { //数据正确
        
        self.playLabel.text = arr[0];
        self.oddsLabel.text = arr[1];
        
    }else{ //数据错误
        
        self.playLabel.text = @"-";
        self.oddsLabel.text = @"-";
    }
}

#pragma mark --- Get Method ---

- (UILabel *)playLabel
{
    
    if (_playLabel == nil) {
        
        _playLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _playLabel.text = @"玩法名";
        _playLabel.textColor = SL_UIColorFromRGB(0x999999);
        _playLabel.textAlignment = NSTextAlignmentCenter;
        _playLabel.font = SL_FONT_SCALE(14.f);
    }
    
    return _playLabel;
    
}

- (UILabel *)oddsLabel
{
    
    if (_oddsLabel == nil) {
        
        _oddsLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _oddsLabel.text = @"赔率";
        _oddsLabel.textColor = SL_UIColorFromRGB(0x333333);
        _oddsLabel.textAlignment = NSTextAlignmentCenter;
        _oddsLabel.font = SL_FONT_SCALE(14.f);
    }
    
    return _oddsLabel;
}


@end
