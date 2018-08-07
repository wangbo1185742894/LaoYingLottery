//
//  SLMatchsSelectCell.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLMatchsSelectCell.h"
#import "SLMatchSelectModel.h"
#import "BBLeagueModel.h"
#import "SLConfigMessage.h"

@interface SLMatchsSelectCell ()

@property (nonatomic, strong) UILabel *LeagueLabel;

@end

@implementation SLMatchsSelectCell

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.LeagueLabel];
    }

    return self;
}

- (void)layoutSubviews
{

    [super layoutSubviews];
    
    self.LeagueLabel.frame = self.bounds;
}

- (void)setSelectModel:(SLMatchSelectModel *)selectModel
{

    _selectModel = selectModel;
    
    NSLog(@"%ld",selectModel.leagueTotal);
    
    self.LeagueLabel.text = [NSString stringWithFormat:@"%@(%ld)",selectModel.titile,selectModel.leagueTotal];
    
    if (selectModel.isSelect == YES) {
        
        self.LeagueLabel.textColor = SL_UIColorFromRGB(0xe63222);
        self.LeagueLabel.layer.borderColor = SL_UIColorFromRGB(0xe63222).CGColor;
        
    }else{
    
        self.LeagueLabel.textColor = SL_UIColorFromRGB(0x333333);
        self.LeagueLabel.layer.borderColor = SL_UIColorFromRGB(0xEAE2D9).CGColor;;
    }
    
}

- (void)setSelectedBasModel:(BBLeagueModel *)selectedBasModel
{
    _selectedBasModel = selectedBasModel;
    self.LeagueLabel.text = [NSString stringWithFormat:@"%@(%ld)",selectedBasModel.titile,selectedBasModel.leagueTotal];
    
    if (selectedBasModel.isSelect == YES) {
        
        self.LeagueLabel.textColor = SL_UIColorFromRGB(0xe63222);
        self.LeagueLabel.layer.borderColor = SL_UIColorFromRGB(0xe63222).CGColor;
        
    }else{
        
        self.LeagueLabel.textColor = SL_UIColorFromRGB(0x333333);
        self.LeagueLabel.layer.borderColor = SL_UIColorFromRGB(0xEAE2D9).CGColor;;
    }
}

- (UILabel *)LeagueLabel
{

    if (_LeagueLabel == nil) {
        
        _LeagueLabel = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, SL__SCALE(100), SL__SCALE(30)))];
        _LeagueLabel.textColor = SL_UIColorFromRGB(0x333333);
        _LeagueLabel.font = SL_FONT_SCALE(14);
        _LeagueLabel.textAlignment = NSTextAlignmentCenter;
        _LeagueLabel.layer.masksToBounds = YES;
        _LeagueLabel.layer.cornerRadius = 4.f;
        _LeagueLabel.layer.borderWidth = 1.f;
        _LeagueLabel.layer.borderColor = SL_UIColorFromRGB(0xEAE2D9).CGColor;
    }

    return _LeagueLabel;
}

@end
