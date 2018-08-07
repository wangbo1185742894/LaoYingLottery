//
//  SLAllOddsHalfOverallCell.m
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLAllOddsHalfOverallCell.h"
#import "SLOddsButton.h"
#import "SLConfigMessage.h"
#import "SLBQCModel.h"
#import "SLBetInfoManager.h"
#import "SLBetSelectInfo.h"
@interface SLAllOddsHalfOverallCell ()

@property (nonatomic, strong) UILabel *halfOverallLabel;
@property (nonatomic, strong) UIImageView *danGuanImageView;
@property (nonatomic, strong) NSMutableArray *buttonsArray;
@property (nonatomic, strong) NSArray *tagArray;

@end


@implementation SLAllOddsHalfOverallCell

+ (instancetype)createAllOddsHalfOverCellWithTableView:(UITableView *)tableView
{
    static NSString *idcell = @"SLAllOddsHalfOverallCell";
    
    SLAllOddsHalfOverallCell *cell = [[SLAllOddsHalfOverallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idcell];

    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = SL_UIColorFromRGB(0xfaf8f6);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
        
    }
    return self;
}
- (void)configUI{
    
    [self.contentView addSubview:self.halfOverallLabel];
    [self.contentView addSubview:self.danGuanImageView];
    
    CGSize strSize = [self.halfOverallLabel.text sizeWithAttributes:@{NSFontAttributeName : SL_FONT_SCALE(12.f)}];
    
    self.halfOverallLabel.frame = SL__Rect(SL__SCALE(10.f), SL__SCALE(10.f), SL__SCALE(strSize.width + 1), SL__SCALE(14.f));
    
    self.danGuanImageView.frame = SL__Rect(CGRectGetMaxX(self.halfOverallLabel.frame) + SL__SCALE(5.f), CGRectGetMinY(self.halfOverallLabel.frame) + SL__SCALE(2.f), SL__SCALE(22.f), SL__SCALE(10.f));
    
    [self addButton];
}


- (void)addButton
{

    CGFloat btnW = SL__SCALE(107.f);
    CGFloat btnH = SL__SCALE(30.f);
    
    int row = 0,col = 0;
    
    for (int i = 0; i < 9; i++) {
        
        row = i / 3;
        col = i % 3;
        
        SLOddsButton *button = [self createButtonShowRightLine:(i == 2) || (i == 5) ||(i == 8) showBottomLine:row == 2];
        
    
        button.frame = SL__Rect(SL__SCALE(10.f) + col * btnW, SL__SCALE(30.f) + row * btnH, btnW, btnH);
        
        [self.buttonsArray addObject:button];
        
    }
    
    [self.buttonsArray enumerateObjectsUsingBlock:^(SLOddsButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [btn addTarget:self action:@selector(buttonOnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        btn.tag = [self.tagArray[idx] integerValue];
        
    }];
    
}

- (SLOddsButton *)createButtonShowRightLine:(BOOL)showRightLine showBottomLine:(BOOL)showBottomLine
{
    SLOddsButton *button = [[SLOddsButton alloc] initWithType:SLOddsButtonTypeHorizontal];
    button.playMothedLabel.text = @"胜胜";
    button.oddsLabel.text = @"10.00";
    button.showLeftLine = YES;
    button.showTopLine = YES;
    button.showRightLine = showRightLine;
    button.showBottomLine = showBottomLine;
    [self.contentView addSubview:button];
    
    return button;
}

- (void)setBqcModel:(SLBQCModel *)bqcModel{
    
    if (!bqcModel) return;
    self.danGuanImageView.hidden = (bqcModel.danguan != 1);
    
    NSArray *array = @[@{@"bf": @"胜胜", @"odds": bqcModel.sp.sp_3_3},
                       @{@"bf": @"胜平", @"odds": bqcModel.sp.sp_3_1},
                       @{@"bf": @"胜负", @"odds": bqcModel.sp.sp_3_0},
                       @{@"bf": @"平胜", @"odds": bqcModel.sp.sp_1_3},
                       @{@"bf": @"平平", @"odds": bqcModel.sp.sp_1_1},
                       @{@"bf": @"平负", @"odds": bqcModel.sp.sp_1_0},
                       @{@"bf": @"负胜", @"odds": bqcModel.sp.sp_0_3},
                       @{@"bf": @"负平", @"odds": bqcModel.sp.sp_0_1},
                       @{@"bf": @"负负", @"odds": bqcModel.sp.sp_0_0}
                       ];
    
    if (self.buttonsArray.count == array.count) {
        for (NSInteger i = 0 ; i < self.buttonsArray.count; i++) {
            
            SLOddsButton *button = self.buttonsArray[i];
            NSDictionary *dic = array[i];
            button.playMothedLabel.text = dic[@"bf"];
            button.oddsLabel.text = BetOddsTransitionString(dic[@"odds"]);
        }
    }
}

- (void)assignDataWithNormalData:(SLBQCModel *)bqcModel matchIssue:(NSString *)matchIssue{
    
    self.bqcModel = bqcModel;
    self.matchIssue = matchIssue;
    
    self.bqcSelectPlayMothedInfo = [[SLBetSelectPlayMothedInfo alloc] init];
    self.bqcSelectPlayMothedInfo.playMothed = BQC;
    self.bqcSelectPlayMothedInfo.isDanGuan = bqcModel.danguan == 1;
    
    SLBetSelectSingleGameInfo *selectedInfo = [SLBetInfoManager getSingleMatchSelectInfoWithMatchIssue:matchIssue];
    
    SLBetSelectPlayMothedInfo *playInfo = nil;
    
    for (SLBetSelectPlayMothedInfo *existPlayInfo in selectedInfo.singleBetSelectArray) {
        if ([existPlayInfo.playMothed isEqualToString:BQC]) {
            playInfo = existPlayInfo;
        }
    }
    for (NSString *odds in playInfo.selectPlayMothedArray) {
        [self.bqcSelectPlayMothedInfo.selectPlayMothedArray addObject:odds];
    }
    for (SLOddsButton *button in self.buttonsArray) {
        
        button.selected = [playInfo.selectPlayMothedArray containsObject:[NSString stringWithFormat:@"%zi", button.tag]];
    }
}

#pragma mark ------------ event Response ------------
- (void)buttonOnClick:(SLOddsButton *)btn{
    
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.bqcSelectPlayMothedInfo.selectPlayMothedArray addObject:[NSString stringWithFormat:@"%zi", btn.tag]];
    }else{
        [self.bqcSelectPlayMothedInfo.selectPlayMothedArray removeObject:[NSString stringWithFormat:@"%zi", btn.tag]];
    }
}

#pragma mark ------------ getter Mothed ------------
- (UILabel *)halfOverallLabel{
    
    if (!_halfOverallLabel) {
        _halfOverallLabel = [[UILabel alloc] init];
        _halfOverallLabel.text = @"半全场";
        _halfOverallLabel.textColor = SL_UIColorFromRGB(0x333333);
        _halfOverallLabel.font = SL_FONT_SCALE(12.f);
    }
    return _halfOverallLabel;
}
- (UIImageView *)danGuanImageView{
    
    if (!_danGuanImageView) {
        _danGuanImageView = [[UIImageView alloc] init];
        _danGuanImageView.contentMode = UIViewContentModeScaleAspectFit;
        _danGuanImageView.image = [UIImage imageNamed:@"allOddsDanGuan.png"];
    }
    return _danGuanImageView;
}

- (NSMutableArray *)buttonsArray{
    
    if (!_buttonsArray) {
        _buttonsArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _buttonsArray;
}

- (NSArray *)tagArray{
    
    return @[@"1033", @"1031", @"1030", @"1013", @"1011", @"1010", @"1003", @"1001", @"1000"];
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
