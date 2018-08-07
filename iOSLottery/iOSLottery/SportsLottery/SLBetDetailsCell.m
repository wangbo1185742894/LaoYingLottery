//
//  SLBetListDetailsCell.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLBetDetailsCell.h"
#import "SLConfigMessage.h"
#import "SLMatchTitleView.h"
#import "SLBetDetailsCellItem.h"
#import "SLBetDetailsModel.h"

@interface SLBetDetailsCell ()

/**
 赛事编号
 */
@property (nonatomic, strong) UILabel *numberLabel;

/**
 赛事标题view
 */
@property (nonatomic, strong) SLMatchTitleView *titleView;

/**
 玩法view
 */
@property (nonatomic, strong) UIView *playMethodView;

/**
 删除按钮
 */
@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation SLBetDetailsCell


+ (SLBetDetailsCell *)createBetDetailsCellWithTableView:(UITableView *)tableView
{

    static NSString *ID = @"BetListDetailsCell";
    
    SLBetDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[SLBetDetailsCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self addSubviews];
        [self addConstraints];
        
        self.contentView.backgroundColor = SL_UIColorFromRGB(0xFFFFFF);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return self;
}

- (void)addSubviews
{

    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.titleView];
    [self.contentView addSubview:self.deleteBtn];
    [self.contentView addSubview:self.playMethodView];
    [self.contentView addSubview:self.bottomLine];
    
}

- (void)addConstraints
{
   [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      
       make.centerY.equalTo(self.contentView.mas_top).offset(SL__SCALE(20.f));
       make.left.equalTo(self.contentView.mas_left).offset(SL__SCALE(45.f));
   }];
    
   [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
      
       make.left.equalTo(self.numberLabel.mas_right);
       make.right.equalTo(self.playMethodView.mas_right);
       make.centerY.equalTo(self.numberLabel.mas_centerY);
   }];
    
   [self.playMethodView mas_makeConstraints:^(MASConstraintMaker *make) {
      
       make.left.equalTo(self.numberLabel.mas_left);
       make.top.equalTo(self.titleView.mas_bottom).offset(SL__SCALE(15.f));
       make.right.equalTo(self.contentView.mas_right).offset(SL__SCALE(-10.f));
       make.bottom.equalTo(self.contentView.mas_bottom).offset(SL__SCALE(-10));
   }];
    
   [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
      
       make.left.right.bottom.equalTo(self.contentView);
       make.height.mas_equalTo(0.5);
   }];
    
   [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      
       make.right.equalTo(self.playMethodView.mas_left).offset(SL__SCALE(-5.f));
       make.centerY.equalTo(self.playMethodView.mas_centerY);
       make.width.height.mas_equalTo(SL__SCALE(40.f));
       //21
   }];
}

- (void)returnDeleteClick:(BetDetailsBlock)block
{

    _deleteBlock = block;

}

- (void)returnEditBetClick:(BetDetailsBlock)block
{

    _editBetBlock = block;
}

#pragma mark --- ButtonClick ---
- (void)deleteBtnClick
{
 
    if (self.deleteBlock) {
        
        self.deleteBlock(self.betDetailModel.matchIssue);
    }
}

- (void)playMethodViewClick
{

    if (self.editBetBlock) {
        
        self.editBetBlock(self.betDetailModel.matchIssue);
    }
}

- (void)setBetDetailModel:(SLBetDetailsModel *)betDetailModel
{

    _betDetailModel = betDetailModel;
    
    SLBetDetailsCellItem *lastItem;
    
    [self.playMethodView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < betDetailModel.itemArray.count; i ++) {
        
        SLBetDetailsCellItem *item = [[SLBetDetailsCellItem alloc] initWithFrame:(CGRectZero)];
        
        item.itemModel = betDetailModel.itemArray[i];
        
        [self.playMethodView addSubview:item];
        
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
           
            if (lastItem) {
                
                make.top.equalTo(lastItem.mas_bottom);
                
            }else{
            
                make.top.equalTo(self.playMethodView.mas_top);
            }
    
            make.left.right.equalTo(self.playMethodView);
           
  
            
            if (i == betDetailModel.itemArray.count - 1) {
                
                make.bottom.equalTo(self.playMethodView.mas_bottom);
            }
            
        }];
        
        lastItem = item;
    }
    
    [self updateConstraintsIfNeeded];
    
    [self.titleView setleftTeamName:betDetailModel.hostName rightTeamName:betDetailModel.awayName];
    
    self.bottomLine.hidden = betDetailModel.isHiddenBottomLine;


    self.numberLabel.text = betDetailModel.matchSession;
}


#pragma mark --- Get Method ---

- (UILabel *)numberLabel
{

    if (_numberLabel == nil) {
        
        _numberLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _numberLabel.text = @"周六001";
        _numberLabel.textColor = SL_UIColorFromRGB(0x333333);
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.font = SL_FONT_SCALE(12);
    }

    return _numberLabel;
}

- (SLMatchTitleView *)titleView
{

    if (_titleView == nil) {
        
        _titleView = [[SLMatchTitleView alloc] initWithFrame:(CGRectZero)];
        
    }

    return _titleView;
}

- (UIButton *)deleteBtn
{

    if (_deleteBtn == nil) {
        
        _deleteBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_deleteBtn setImage:[UIImage imageNamed:@"bet_details_detele"] forState:(UIControlStateNormal)];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        
        [_deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(SL__SCALE(10), SL__SCALE(10), SL__SCALE(10), SL__SCALE(10))];
    }
    
    return _deleteBtn;
}

- (UIView *)playMethodView
{

    if (_playMethodView == nil) {
        
        _playMethodView = [[UIView alloc] initWithFrame:(CGRectZero)];
        _playMethodView.layer.masksToBounds = YES;
        _playMethodView.layer.borderWidth = 0.25f;
        _playMethodView.layer.borderColor = SL_UIColorFromRGB(0xECE5DD).CGColor;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playMethodViewClick)];
        
        [_playMethodView addGestureRecognizer:tap];
    }
    
    return _playMethodView;
}

- (UIView *)bottomLine
{

    if (_bottomLine == nil) {
        
        _bottomLine = [[UIView alloc] initWithFrame:(CGRectZero)];
        _bottomLine.backgroundColor = SL_UIColorFromRGB(0xECE5DD);
    }
    
    return _bottomLine;
}

@end
