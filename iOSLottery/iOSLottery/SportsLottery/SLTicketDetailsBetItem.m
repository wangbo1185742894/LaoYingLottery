//
//  CLTicketDetailsBetItem.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/4/24.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLConfigMessage.h"

#import "SLTicketDetailsBetItem.h"

@implementation SLTicketDetailsBetItem

- (void)setItemArray:(NSArray *)itemArray
{

    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    __block SLTicketDetailsItem *tempItem;
    
    for (int i = 0; i < itemArray.count; i++) {
        
        SLTicketDetailsItem *item = [[SLTicketDetailsItem alloc] initWithFrame:(CGRectZero)];
        
        [item setUpMessageWithString:itemArray[i]];
        
        [self addSubview:item];
        
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (!tempItem) {
                
                make.top.equalTo(self.mas_top);
                
            }else{
            
                make.top.equalTo(tempItem.mas_bottom).offset(SL__SCALE(5.f));
            
            }
            
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            //make.height.mas_offset(SL__SCALE(20.f));
//            if (i == itemArray.count - 1) {
//                
//                make.bottom.equalTo(self.mas_bottom);
//            }
        }];
        
        tempItem = item;
    }
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(tempItem.mas_bottom);
    }];
}

@end

@interface SLTicketDetailsItem ()

/**
 场次label
 */
@property (nonatomic, strong) UILabel *round;

/**
 玩法名label
 */
@property (nonatomic, strong) UILabel *playMethod;

@end

@implementation SLTicketDetailsItem


- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.round];
        [self addSubview:self.playMethod];
                
        [self.round mas_makeConstraints:^(MASConstraintMaker *make) {
            

            make.left.top.bottom.equalTo(self);
            
            make.height.mas_equalTo(SL__SCALE(15.f));
            
            make.width.mas_equalTo(SL__SCALE(60));
            
        }];
        
        [self.playMethod mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.round.mas_right).offset(SL__SCALE(5)).priority(1000);
            
            make.centerY.equalTo(self.round);
            
            make.right.equalTo(self);
        }];
        
    }

    return self;
}

- (void)setUpMessageWithString:(NSString *)string
{

    NSArray *dataArray = [string componentsSeparatedByString:@"_"];
    
    if (dataArray.count != 2) return;
    
    self.round.text = dataArray[0];
    self.playMethod.text = [self disposeTextNumberOfLine:dataArray[1]];
}

- (NSString *)disposeTextNumberOfLine:(NSString *)str
{

    NSString *strReplac = [str stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
    
    return strReplac;
    
}

- (UILabel *)round
{

    if (_round == nil) {
        
        _round = [[UILabel alloc] init];
        _round.textColor = SL_UIColorFromRGB(0x333333);
        _round.textAlignment = NSTextAlignmentLeft;
        _round.font = SL_FONT_SCALE(14.f);
    }
    return _round;
}

- (UILabel *)playMethod
{
    
    if (_playMethod == nil) {
        
        _playMethod = [[UILabel alloc] init];
        _playMethod.textColor = SL_UIColorFromRGB(0x333333);
        _playMethod.textAlignment = NSTextAlignmentLeft;
        _playMethod.font = SL_FONT_SCALE(14.f);
        
        _playMethod.numberOfLines = 0;

    }
    return _playMethod;
}


@end
