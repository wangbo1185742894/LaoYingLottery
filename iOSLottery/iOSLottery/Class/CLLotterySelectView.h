//
//  CLLotterySelectView.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/7.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLLotterySelectView : UIView

@property (nonatomic, strong) UIImageView* lotteryIconImgView;
@property (nonatomic, strong) UILabel* lotteryNameLbl;
@property (nonatomic, strong) UILabel* lotteryDesLbl;
//@property (nonatomic, strong) UILabel *lotteryCutDownLbl;
@property (nonatomic, strong) UIImageView *rightTopImageView;
//@property (nonatomic, readwrite) BOOL addNotifi;
@property (nonatomic, assign) BOOL isTag;
@property (nonatomic, copy) void(^tapBlock)(void);
- (void)setTag:(BOOL)tag color:(NSString *)color;

- (void) addTarget:(id)target selector:(SEL)sel;

@end
