//
//  CLLotteryChaseMultipleView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/21.
//  Copyright © 2016年 caiqr. All rights reserved.
//买期次 投倍数的View

#import <UIKit/UIKit.h>

@interface CLLotteryChaseMultipleView : UIView

//UI 相关
@property (nonatomic, strong) UITextField *periodTextField;//追期
@property (nonatomic, strong) UITextField *multipleTextField;//倍数
@property (nonatomic, strong) UILabel *buyLabel;//连续买
@property (nonatomic, strong) UILabel *periodLabel;//期
@property (nonatomic, strong) UILabel *betLabel;//投
@property (nonatomic, strong) UILabel *multipleLabel;//倍
@property (nonatomic, strong) UIImageView *lineImageView;//中间的线
@property (nonatomic, strong) UIButton *agreeImageButton;//对勾按钮
@property (nonatomic, strong) UIButton *questionButton;//提示说明按钮
@property (nonatomic, strong) UIView *awardTopLineView;//中奖后上方的横线
@property (nonatomic, strong) UIButton *awardButton;//中奖后停止追号
@property (nonatomic, strong) UIView *chaseLeftLineView;
@property (nonatomic, strong) UIView *chaseRightLineView;
@property (nonatomic, strong) UIView *bottomLineView;//快速追期上方的横线
@property (nonatomic, strong) UIView *awardBaseView;//中奖后停止追号
@property (nonatomic, strong) UIImageView *arrowImageView;//带箭头的ImageView

@property (nonatomic, strong) UIButton *chaseTenButton;//追10期  投10倍
@property (nonatomic, strong) UIButton *chaseTwentyButton;//追20期 投20倍
@property (nonatomic, strong) UIButton *chaseMoreButton;//追78期  投50倍

@property (nonatomic, strong) UIImageView *topLineImageView;//最上方的线
@property (nonatomic, strong) UILabel *additionalInfoLabel;//追加 文案
@property (nonatomic, strong) UIImageView *additionalImageView;//加奖图片
@property (nonatomic, copy) void(^additionalImageViewHidden)(BOOL isHidden);
//投注相关
@property (nonatomic, strong) NSString *gameEn;
@property (nonatomic, assign, readonly) BOOL isStopChase;//是否在中奖后停止追期
@property (nonatomic, strong, readonly) NSString *chasePeriod;//追期
@property (nonatomic, strong, readonly) NSString *chaseMultiple;//倍数

@property (nonatomic, assign) BOOL isShowAdditional;//是否展示追加按钮  默认不展示
@property (nonatomic, assign) BOOL setAdditional;//追加是否勾选

@property (nonatomic, copy) void(^additionalOnClickBlock)(BOOL);

- (void)lotteryChaseMultipleViewResignResponse;
@end
