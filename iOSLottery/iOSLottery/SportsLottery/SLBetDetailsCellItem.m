//
//  SLBetDetailsCellItem.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/18.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBetDetailsCellItem.h"
#import "SLConfigMessage.h"
#import "SLBetDetailsModel.h"
#import "UILabel+SLAttributeLabel.h"
#import "NSString+SLString.h"
@interface SLBetDetailsCellItem ()

@property (nonatomic, strong) UILabel *playName;

@property (nonatomic, strong) UILabel *betName;

@end

@implementation SLBetDetailsCellItem

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubviews];
        [self addConstraints];
        self.backgroundColor = SL_UIColorFromRGB(0xFAF8F6);
        
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 0.25;
        self.layer.borderColor = SL_UIColorFromRGB(0xECE5DD).CGColor;
        
    }

    return self;
}

- (void)addSubviews
{
    
    [self addSubview:self.playName];
    [self addSubview:self.betName];
}

- (void)addConstraints
{

    [self.playName mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(SL__SCALE(20.f));
        make.top.equalTo(self.mas_top).offset(SL__SCALE(6.f));
        make.height.mas_equalTo(SL__SCALE(17.f));
    }];
    
    [self.betName mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.playName.mas_top);
        make.left.equalTo(self.playName.mas_right).offset(SL__SCALE(5.f));
        make.right.equalTo(self.mas_right).offset(SL__SCALE(-6.f));
        make.bottom.equalTo(self.mas_bottom).offset(SL__SCALE(-7.f));
    }];
}

- (void)setItemModel:(SLBetDetailsItemModel *)itemModel
{

    _itemModel = itemModel;
    
    [self setUpPlayName:itemModel.playName];
    
    NSMutableString *str = [NSMutableString string];
    NSMutableArray  *strArr = [NSMutableArray array];
    for (NSString *temp in itemModel.betArray) {
        NSString *tempString = [NSString stringWithFormat:@"%@  ",temp];
        [str appendFormat:@"%@",tempString];
        CGFloat itemStringW = [str boundingRectFontOptionWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) Font:SL_FONT_SCALE(14)].size.width;
        if (itemStringW > SL__SCALE(220)) {
            [strArr addObject:[str substringToIndex:[str rangeOfString:tempString].location]];
            str = [NSMutableString stringWithString:tempString];
        }
    }
    if (str && str.length) {
        [strArr addObject:str];
    }
    NSString *betString = [strArr componentsJoinedByString:@"\n"];
    if (strArr.count > 1) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:betString];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:SL__SCALE(5.5)];
        paragraphStyle.lineBreakMode = NSLineBreakByClipping;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [betString length])];
        self.betName.attributedText = attributedString;
    }else{
        self.betName.text = betString;
    }
//    [self updateConstraintsIfNeeded];
    
}

- (void)setUpPlayName:(NSString *)str
{
    
    NSString *playName = [NSString stringWithFormat:@"%@:", str];
    //获取“+"的range
    if ([playName rangeOfString:@"+"].location != NSNotFound) {
        
        [self setTextColorWithStr:playName tag:@"+" color:SL_UIColorFromRGB(0xFC5548)];
    }else if ([playName rangeOfString:@"-"].location != NSNotFound){
        
        [self setTextColorWithStr:playName tag:@"-" color:SL_UIColorFromRGB(0x2BC57C)];
    }else{
        
        self.playName.text = playName;
    }
}
- (void)setTextColorWithStr:(NSString *)str tag:(NSString *)tag color:(UIColor *)color{
    
    NSRange zRange = [str rangeOfString:tag];
    
    SLAttributedTextParams *attr = [SLAttributedTextParams attributeRange:NSMakeRange(zRange.location, str.length - zRange.location - 1) Color:color];
    [self.playName sl_attributeWithText:str controParams:@[attr]];
}



#pragma mark --- Get Method ---

- (UILabel *)playName
{


    if (_playName == nil) {
        
        _playName = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _playName.text = @"胜平负：";
        _playName.textColor = SL_UIColorFromRGB(0x8F6E51);
        _playName.font = SL_FONT_SCALE(14);
        [_playName setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_playName setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    return _playName;
}

- (UILabel *)betName
{

    if (_betName == nil) {
        
        _betName = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _betName.text = @"主胜  客胜  主负";
        _betName.textColor = SL_UIColorFromRGB(0x151515);
        _betName.font = SL_FONT_SCALE(14);
        
        _betName.numberOfLines = 0;
        _betName.lineBreakMode = NSLineBreakByWordWrapping;
    }

    return _betName;
}

@end
