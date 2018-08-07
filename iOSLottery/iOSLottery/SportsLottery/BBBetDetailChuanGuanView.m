//
//  BBBetDetailChuanGuanView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/16.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBBetDetailChuanGuanView.h"

#import "SLConfigMessage.h"
#import "BBBetDetailsInfoManager.h"
#import "BBMatchInfoManager.h"
#import "SLChuanGuanModel.h"


@interface BBBetDetailChuanGuanView ()


@property (nonatomic, strong) UILabel *chuanGuanExplainLabel;//串关说明label
@property (nonatomic, strong) UIButton *twoChuanOneButton;//2串1是什么意思
@property (nonatomic, strong) NSMutableArray *buttonArray;//按钮数组

@end


@implementation BBBetDetailChuanGuanView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.chuanGuanExplainLabel];
        [self addSubview:self.twoChuanOneButton];
    }
    return self;
}

- (void)setChoosableChuanGuan{
    
    NSArray *chuanGuanArray = [BBBetDetailsInfoManager getChuanGuan];
    for (UIButton *btn in self.buttonArray) {
        [btn removeFromSuperview];
    }
    [self.buttonArray removeAllObjects];
    
    if (chuanGuanArray && chuanGuanArray.count > 0){
        
        //计算每个按钮的宽度
        CGFloat buttonWidth = (SL_SCREEN_WIDTH - SL__SCALE(15 * 2) - SL__SCALE(10 * 3)) / 4.0;
        
        NSInteger row = (chuanGuanArray.count / 4) + 1; // 行数
        NSInteger column = chuanGuanArray.count % 4; //列数
        if (column == 0) {
            row = row - 1;
            column = 4;
        }
        
        UIButton *rowButton = nil;
        for (NSInteger i = 0; i < row; i++) {
            NSInteger tempColumn = (i == row - 1) ? column : 4;
            UIButton *columnButton = nil;
            for (NSInteger j = 0; j < tempColumn; j++) {
                
                SLChuanGuanModel *model = chuanGuanArray[i * 4 + j];
                UIButton *button = [[UIButton alloc] init];
                button.tag = [model.chuanGuanTag integerValue];
                button.titleLabel.font = SL_FONT_SCALE(14);
                [button setTitle:model.chuanGuanTitle forState:UIControlStateNormal];
                [button addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitleColor:SL_UIColorFromRGB(0x333333) forState:UIControlStateNormal];
                button.layer.cornerRadius = 4.f;
                button.layer.borderWidth = 0.5;
                button.layer.borderColor = SL_UIColorFromRGB(0xece5dd).CGColor;
                button.backgroundColor = SL_UIColorFromRGB(0xffffff);
                button.layer.masksToBounds = YES;
                button.adjustsImageWhenHighlighted = NO;
                [self setButton:button select:model.isSelect];
                [self addSubview:button];
                [self.buttonArray addObject:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    if (columnButton) {
                        make.left.equalTo(columnButton.mas_right).offset(SL__SCALE(10.f));
                    }else{
                        make.left.equalTo(self).offset(SL__SCALE(15.f));
                    }
                    if (rowButton) {
                        make.top.equalTo(rowButton.mas_bottom).offset(SL__SCALE(16.f));
                    }else{
                        make.top.equalTo(self).offset(10.f);
                    }
                    make.width.mas_equalTo(buttonWidth);
                    make.height.mas_equalTo(SL__SCALE(30.f));
                }];
                columnButton = button;
            }
            rowButton = columnButton;
            columnButton = nil;
        }
        
        [self.chuanGuanExplainLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self).offset(SL__SCALE(15.f));
            make.top.equalTo(rowButton.mas_bottom).offset(SL__SCALE(13.f));
            make.bottom.equalTo(self).offset(SL__SCALE(- 10.f));
        }];
        [self.twoChuanOneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self).offset(SL__SCALE(- 15.f));
            make.centerY.equalTo(self.chuanGuanExplainLabel);
        }];
    }else{
        
        [self.chuanGuanExplainLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self).offset(SL__SCALE(15.f));
            make.top.equalTo(self);
            make.bottom.equalTo(self).offset(SL__SCALE(- 10.f));
        }];
    }
    
    [self layoutIfNeeded];
    
}

#pragma mark ------------ event Response ------------
- (void)buttonOnClick:(UIButton *)btn{
    
    [self setButton:btn select:!btn.selected];
    !self.buttonOnClickBlock ? : self.buttonOnClickBlock();
}

- (void)setButton:(UIButton *)btn select:(BOOL)select{
    
    btn.selected = select;
    btn.layer.borderColor = btn.selected ? SL_UIColorFromRGB(0xe63222).CGColor : SL_UIColorFromRGB(0xece5dd).CGColor;
    [btn setTitleColor:btn.selected ? SL_UIColorFromRGB(0xe63222) : SL_UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    //记录选择的串关
    if (btn.selected) {
        [[BBMatchInfoManager shareManager] saveSelectChuanGuan:[NSString stringWithFormat:@"%zi", btn.tag]];
    }else{
        [[BBMatchInfoManager shareManager] removeSelectChuanGuan:[NSString stringWithFormat:@"%zi", btn.tag]];
    }
    
}

- (void)twoChuanGuanOnClick:(UIButton *)btn{
    
    !self.twoChuanOneBlock ? : self.twoChuanOneBlock();
}

#pragma mark ------------ getter Mothed ------------
- (UILabel *)chuanGuanExplainLabel{
    
    if (!_chuanGuanExplainLabel) {
        _chuanGuanExplainLabel = [[UILabel alloc] init];
        _chuanGuanExplainLabel.text = @"胜分差最高支持4串1";
        _chuanGuanExplainLabel.textColor = SL_UIColorFromRGB(0x8f6e51);
        _chuanGuanExplainLabel.font = SL_FONT_SCALE(12);
    }
    
    return _chuanGuanExplainLabel;
}

- (UIButton *)twoChuanOneButton{
    
    if (!_twoChuanOneButton) {
        _twoChuanOneButton = [[UIButton alloc] init];
        [_twoChuanOneButton setTitle:@"2串1是什么意思？" forState:UIControlStateNormal];
        [_twoChuanOneButton setTitleColor:SL_UIColorFromRGB(0x45a2f7) forState:UIControlStateNormal];
        [_twoChuanOneButton addTarget:self action:@selector(twoChuanGuanOnClick:) forControlEvents:UIControlEventTouchUpInside];
        _twoChuanOneButton.titleLabel.font = SL_FONT_SCALE(12);
    }
    return _twoChuanOneButton;
}
- (NSMutableArray *)buttonArray{
    
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _buttonArray;
}


@end
