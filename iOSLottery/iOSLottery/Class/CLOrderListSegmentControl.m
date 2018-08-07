//
//  CLOrderListSegmentControl.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/11.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLOrderListSegmentControl.h"
#import "Masonry.h"
#import "CLConfigMessage.h"

NSInteger __customButtonTagOffset = 1;

@interface CLOrderListSegmentControl ()

@property (nonatomic, strong) UIView* selectedLine;
@property (nonatomic, strong) UIView* bottomLine;
@property (nonatomic, strong) NSArray* segmentItems;

@end

@implementation CLOrderListSegmentControl

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        self.has_VerticalLine = NO;
         [self addSubview:self.bottomLine];
        [self addSubview:self.selectedLine];
       
    }
    return self;
}

- (void)setItems:(NSArray *)items {
    
    if (items.count == 0) {
        return;
    }
    if (self.segmentItems && self.segmentItems.count > 0) {
        return;
    }
    
    self.segmentItems = [items copy];
    UIButton* tmpButton = nil;
    for (int i = 0; i < items.count; i++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [button setTitle:items[i] forState:UIControlStateNormal];
        button.titleLabel.font = FONT_SCALE(14.f);
        button.tag = i + __customButtonTagOffset;
        [button addTarget:self action:@selector(selectedItemChange:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(self);
            } else {
                make.left.equalTo(tmpButton.mas_right);
                make.width.equalTo(tmpButton.mas_width);
            }
            
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            
            if (i == items.count - 1) {
                make.right.equalTo(self);
            }
            
        }];
        if (self.has_VerticalLine) {
            if (i != 0) {
                //添加竖线
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
                lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
                [self addSubview:lineView];
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(button);
                    make.top.equalTo(button).offset(5.f);
                    make.bottom.equalTo(button).offset(- 5.f);
                    make.width.mas_equalTo(.5f);
                }];
            }
        }
        tmpButton = button;
    }
    tmpButton = nil;
    
    
    tmpButton = [self viewWithTag:1];
    
    [self.selectedLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(2);
        make.bottom.equalTo(self);
        make.left.equalTo(tmpButton.mas_left).offset(10);
        make.right.equalTo(tmpButton.mas_right).offset(-10);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(0.5f);
    }];
}

- (void)selectedItemChange:(UIButton*)btn {
    
    _selectedIndex = btn.tag - __customButtonTagOffset;
    
    if ([self.delegate respondsToSelector:@selector(segmentControlSelectChange:)]) {
        [self.delegate segmentControlSelectChange:_selectedIndex];
    }    
    [self updateLineLocationAnimate:YES];
    
}

/** 更新底部Line位置 支持动画 */
- (void)updateLineLocationAnimate:(BOOL)animate {
    
    UIButton* tmpButton = [self viewWithTag:_selectedIndex + __customButtonTagOffset];
    
    [self.selectedLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1.5);
        make.bottom.equalTo(self);
        make.left.equalTo(tmpButton.mas_left).offset(10);
        make.right.equalTo(tmpButton.mas_right).offset(-10);
    }];
    
    [UIView animateWithDuration:(animate)?.3f:0.f animations:^{
        [self layoutIfNeeded];
    }];

    for (int i = 0; i < self.segmentItems.count; i++) {
        UIButton* btn = [self viewWithTag:(i + __customButtonTagOffset)];
        [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    }
    [tmpButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];

}


#pragma mark - setter

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    if (!self.segmentItems || self.segmentItems.count == 0) {
        _selectedIndex = -1;
    } else if (selectedIndex >= self.segmentItems.count) {
        _selectedIndex = 0;
    } else {
        _selectedIndex = selectedIndex;
    }
    
    [self updateLineLocationAnimate:NO];
}


#pragma mark - getter

- (UIView *)selectedLine {
    
    if (!_selectedLine) {
        _selectedLine = [[UIView alloc] initWithFrame:CGRectZero];
        _selectedLine.backgroundColor = THEME_COLOR;
    }
    return _selectedLine;
}

- (UIView *)bottomLine {
    
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = UIColorFromRGB(0xe5e5e5);
    }
    return _bottomLine;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
