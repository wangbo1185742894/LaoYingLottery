//
//  SLAllOddsSPFCell.m
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/13.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLAllOddsSPFCell.h"
#import "SLConfigMessage.h"
#import "SLSPFPlayView.h"
#import "SLSPFModel.h"
#import "SLBetInfoManager.h"
#import "SLBetSelectInfo.h"

#import "SLBetDetailDataManager.h"

#import "SLExternalService.h"

@interface SLAllOddsSPFCell ()
/**
 胜平负/让球胜平负
 */
@property (nonatomic, strong) UILabel *desLabel;

/**
 普通胜平负
 */
@property (nonatomic, strong) SLSPFPlayView *normalPlayView;

/**
 让球胜平负
 */
@property (nonatomic, strong) SLSPFPlayView *concedePlayView;

@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, strong) UIView *rightLineView;


@end

@implementation SLAllOddsSPFCell

+ (instancetype)createAllOddsSPFCellWithTableView:(UITableView *)tableView
{

    static NSString *idCell = @"SLAllOddsSPFCell";
    
    SLAllOddsSPFCell *cell = [[SLAllOddsSPFCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:idCell];
    
    return cell;
    
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = SL_UIColorFromRGB(0xfaf8f6);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.desLabel];
        [self.contentView addSubview:self.normalPlayView];
        [self.contentView addSubview:self.concedePlayView];
        [self.contentView addSubview:self.rightLineView];
        [self.contentView addSubview:self.bottomLineView];
        
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).offset(SL__SCALE(10.f));
            make.top.equalTo(self.contentView).offset(SL__SCALE(10.f));
        }];
        [self.normalPlayView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.desLabel);
            make.top.equalTo(self.desLabel.mas_bottom).offset(SL__SCALE(6.f));
            make.right.equalTo(self.contentView).offset(SL__SCALE(-10.f));
        }];
        
        [self.concedePlayView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.desLabel);
            make.top.equalTo(self.normalPlayView.mas_bottom);
            make.right.equalTo(self.contentView).offset(SL__SCALE(-10.f));
            make.bottom.equalTo(self.contentView);
        }];
        
        [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.normalPlayView);
            make.bottom.equalTo(self.concedePlayView);
            make.right.equalTo(self.normalPlayView.mas_right);
            make.width.mas_equalTo(0.5f);
        }];
        [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.concedePlayView.mas_bottom);
            make.left.right.equalTo(self.concedePlayView);
            make.height.mas_equalTo(0.5f);
        }];
        
    }
    return self;
}


- (void)assignDataWithNormalData:(SLSPFModel *)normalModel concedeData:(SLSPFModel *)concedeModel matchIssue: (NSString *)matchIssue{
    
    self.normalPlayView.spfModel = normalModel;
    self.concedePlayView.spfModel = concedeModel;
    self.matchIssue = matchIssue;
    self.spfSelectPlayMothedInfo = [[SLBetSelectPlayMothedInfo alloc] init];
    self.rqspfSelectPlayMothedInfo = [[SLBetSelectPlayMothedInfo alloc] init];
    self.spfSelectPlayMothedInfo.playMothed = SPF;
    self.spfSelectPlayMothedInfo.isDanGuan = normalModel.danguan == 1;
    self.rqspfSelectPlayMothedInfo.playMothed = RQSPF;
    self.rqspfSelectPlayMothedInfo.rangQiuCount = concedeModel.handicap;
    self.rqspfSelectPlayMothedInfo.isDanGuan = concedeModel.danguan == 1;
    
    SLBetSelectSingleGameInfo *selectedInfo = [SLBetInfoManager getSingleMatchSelectInfoWithMatchIssue:matchIssue];
    self.normalPlayView.hostWinBtn.selected = NO;
    self.normalPlayView.dogfallBtn.selected = NO;
    self.normalPlayView.guestWinBtn.selected = NO;
    self.concedePlayView.hostWinBtn.selected = NO;
    self.concedePlayView.dogfallBtn.selected = NO;
    self.concedePlayView.guestWinBtn.selected = NO;
    for (SLBetSelectPlayMothedInfo *playMothedInfo in selectedInfo.singleBetSelectArray) {
        
        if ([playMothedInfo.playMothed isEqualToString:SPF]) {
            
            if ([playMothedInfo.selectPlayMothedArray containsObject:@"3"]) {
                self.normalPlayView.hostWinBtn.selected = YES;
                [self.spfSelectPlayMothedInfo.selectPlayMothedArray addObject:@"3"];
            }else{
                self.normalPlayView.hostWinBtn.selected = NO;
            }
            if ([playMothedInfo.selectPlayMothedArray containsObject:@"1"]) {
                self.normalPlayView.dogfallBtn.selected = YES;
                [self.spfSelectPlayMothedInfo.selectPlayMothedArray addObject:@"1"];
            }else{
                self.normalPlayView.dogfallBtn.selected = NO;
            }
            if ([playMothedInfo.selectPlayMothedArray containsObject:@"0"]) {
                self.normalPlayView.guestWinBtn.selected = YES;
                [self.spfSelectPlayMothedInfo.selectPlayMothedArray addObject:@"0"];
            }else{
                self.normalPlayView.guestWinBtn.selected = NO;
            }
        }
        if ([playMothedInfo.playMothed isEqualToString:RQSPF]) {
            
            if ([playMothedInfo.selectPlayMothedArray containsObject:@"10003"]) {
                self.concedePlayView.hostWinBtn.selected = YES;
                [self.rqspfSelectPlayMothedInfo.selectPlayMothedArray addObject:@"10003"];
            }else{
                self.concedePlayView.hostWinBtn.selected = NO;
            }
            if ([playMothedInfo.selectPlayMothedArray containsObject:@"10001"]) {
                self.concedePlayView.dogfallBtn.selected = YES;
                [self.rqspfSelectPlayMothedInfo.selectPlayMothedArray addObject:@"10001"];
            }else{
                self.concedePlayView.dogfallBtn.selected = NO;
            }
            if ([playMothedInfo.selectPlayMothedArray containsObject:@"10000"]) {
                self.concedePlayView.guestWinBtn.selected = YES;
                [self.rqspfSelectPlayMothedInfo.selectPlayMothedArray addObject:@"10000"];
            }else{
                self.concedePlayView.guestWinBtn.selected = NO;
            }
        }
    }
    
}

#pragma mark ------------ getter Mothed ------------
- (UILabel *)desLabel{
    
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.text = @"胜平负/让球胜平负";
        _desLabel.textColor = SL_UIColorFromRGB(0x333333);
        _desLabel.font = SL_FONT_SCALE(12);
    }
    return _desLabel;
}

- (SLSPFPlayView *)normalPlayView{
    
    if (!_normalPlayView) {
        WS_SL(_weakSelf)
        _normalPlayView = [[SLSPFPlayView alloc] initWithFrame:CGRectZero];
        
        _normalPlayView.clickButtonBlock = ^(BOOL isSelect, NSInteger selectNumber) {
                       
            if (isSelect) {
                [_weakSelf.spfSelectPlayMothedInfo.selectPlayMothedArray addObject:[NSString stringWithFormat:@"%zi", selectNumber]];
            }else{
                [_weakSelf.spfSelectPlayMothedInfo.selectPlayMothedArray removeObject:[NSString stringWithFormat:@"%zi", selectNumber]];
            }
            
        };
    }
    return _normalPlayView;
}

- (SLSPFPlayView *)concedePlayView{
    
    if (!_concedePlayView) {
        WS_SL(_weakSelf)
        _concedePlayView = [[SLSPFPlayView alloc] initWithFrame:CGRectZero];
        _concedePlayView.clickButtonBlock = ^(BOOL isSelect, NSInteger selectNumber) {
           
            if (isSelect) {
                [_weakSelf.rqspfSelectPlayMothedInfo.selectPlayMothedArray addObject:[NSString stringWithFormat:@"1000%zi", selectNumber]];
            }else{
                [_weakSelf.rqspfSelectPlayMothedInfo.selectPlayMothedArray removeObject:[NSString stringWithFormat:@"1000%zi", selectNumber]];
            }
        };
    }
    return _concedePlayView;
}
- (UIView *)bottomLineView{
    
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = SL_UIColorFromRGB(0xece5dd);
    }
    return _bottomLineView;
}

- (UIView *)rightLineView{
    
    if (!_rightLineView) {
        _rightLineView = [[UIView alloc] init];
        _rightLineView.backgroundColor = SL_UIColorFromRGB(0xece5dd);
    }
    return _rightLineView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
