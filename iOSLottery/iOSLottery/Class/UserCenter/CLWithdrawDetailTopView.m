//
//  CLWithdrawDetailTopView.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLWithdrawDetailTopView.h"
#import "CLConfigMessage.h"
#import "CLOrderStatusLineView.h"
#import "CLOrderStatusViewModel.h"
#import "CLWithdrawFollowModel.h"

@interface CLWithdrawDetailTopView ()

@property (nonatomic, strong) CLOrderStatusLineView* lineView;
@property (nonatomic, strong) UIView* sepview;
@property (nonatomic, strong) UILabel* titleLbl;
@property (nonatomic, strong) UILabel* cashLbl;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation CLWithdrawDetailTopView

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.lineView = [[CLOrderStatusLineView alloc] init];
        
        
        self.sepview = [[UIView alloc] init];
        self.sepview.backgroundColor = UIColorFromRGB(0xF5F5F5);
        
        self.bottomLineView = [[UIView alloc] init];
        self.bottomLineView.backgroundColor = UIColorFromRGB(0xefefef);
        
        self.titleLbl = [[UILabel alloc] init];
        self.titleLbl.backgroundColor = [UIColor clearColor];
        self.titleLbl.font = FONT_FIX(13);
        self.titleLbl.textColor = UIColorFromRGB(0x333333);
        
        self.cashLbl = [[UILabel alloc] init];
        self.cashLbl.backgroundColor = [UIColor clearColor];
        self.cashLbl.font = FONT_FIX(20);
        self.cashLbl.textColor = UIColorFromRGB(0x333333);
        self.cashLbl.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:self.lineView];
        [self addSubview:self.sepview];
        [self addSubview:self.titleLbl];
        [self addSubview:self.cashLbl];
        [self addSubview:self.bottomLineView];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(20);
            make.centerX.equalTo(self);
            make.width.mas_equalTo(SCREEN_WIDTH + __SCALE(100.f));
            make.height.mas_equalTo(__SCALE(50));
        }];
        
        [self.sepview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.lineView.mas_bottom);
            make.height.mas_equalTo(5);
        }];
        
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self.sepview.mas_bottom);
            make.right.equalTo(self.cashLbl.mas_left);
            make.height.mas_equalTo(40);
        }];
        
        [self.cashLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLbl.mas_right);
            make.top.equalTo(self.titleLbl);
            make.right.equalTo(self).offset(-20);
            make.width.equalTo(self.titleLbl.mas_width);
            make.height.equalTo(self.titleLbl);
        }];
        
        [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.titleLbl);
            make.right.equalTo(self.cashLbl);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(0.5f);
        }];
        self.titleLbl.text = @"提现金额:";
        
        
        
    }
    return self;
}

- (void) configureWithdrawDetailData:(CLWithdrawFollowModel*)data {
    
    self.cashLbl.text = [NSString stringWithFormat:@"￥%@元",data.amount];
    
    __block NSMutableArray* __lineParams = [NSMutableArray arrayWithCapacity:0];
    __block NSMutableArray* __dotParams = [NSMutableArray arrayWithCapacity:0];
    [data.ratify_status_group enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0) {
            NSInteger before_true = [((NSDictionary*)data.ratify_status_group[idx - 1])[@"is_true"] integerValue];
            NSInteger cnt_true = [obj[@"is_true"] integerValue];
            
            CLOrderStatusViewModel *line = [CLOrderStatusViewModel new];
            line.statusType = CLOrderStatusTypeLine;
            line.lineLight = (cnt_true == 1 && before_true == 1);
            [__lineParams addObject:line];
        }
        NSInteger dot_true = [obj[@"is_true"] integerValue];
        NSInteger dot_status = [obj[@"status"] integerValue];
        if (dot_status < 0) {
            //失败
            CLOrderStatusViewModel *dot = [CLOrderStatusViewModel new];
            dot.statusType = CLOrderStatusTypeDot;
            dot.dotType = CLOrderStatusDotTypeFail;
            dot.dotTitle = [obj objectForKey:@"name"];
            [__dotParams addObject:dot];
        }else{
            //成功
            if (dot_true == 1) {
                CLOrderStatusViewModel *dot = [CLOrderStatusViewModel new];
                dot.statusType = CLOrderStatusTypeDot;
                dot.dotType = CLOrderStatusDotTypeSuccess;
                dot.dotTitle = [obj objectForKey:@"name"];
                [__dotParams addObject:dot];
            }else{
                CLOrderStatusViewModel *dot = [CLOrderStatusViewModel new];
                dot.statusType = CLOrderStatusTypeDot;
                dot.dotType = CLOrderStatusDotTypeDark;
                dot.dotText = [NSString stringWithFormat:@"%zi", dot_status + 1];
                dot.dotTitle = [obj objectForKey:@"name"];
                [__dotParams addObject:dot];
            }
        }
    }];
    
    self.lineView.lineParams = __lineParams;
    self.lineView.dotParams = __dotParams;
    [self.lineView setNeedsDisplay];

    
}



@end
