//
//  SLAllOddsScoreCell.m
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/13.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLAllOddsScoreCell.h"
#import "SLConfigMessage.h"
#import "SLOddsButton.h"
#import "SLBFModel.h"
#import "SLBetSelectInfo.h"
#import "SLBetInfoManager.h"
@interface SLAllOddsScoreCell ()

/**
 比分Label
 */
@property (nonatomic, strong) UILabel *scoreLabel;

/**
 串关标签Image
 */
@property (nonatomic, strong) UIImageView *danGuanImageView;

@property (nonatomic, strong) NSMutableArray *oddButtonsArray;

@property (nonatomic, strong) NSArray *tagArray;

@end

@implementation SLAllOddsScoreCell

+ (instancetype)createAllOddsScoreCellWithTableView:(UITableView *)tableView
{

    static NSString *idcell = @"SLAllOddsScoreCell";
    
    SLAllOddsScoreCell *cell = [[SLAllOddsScoreCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:idcell];
    
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
    
    [self.contentView addSubview:self.scoreLabel];
    [self.contentView addSubview:self.danGuanImageView];
    
    CGSize strSize = [self.scoreLabel.text sizeWithAttributes:@{NSFontAttributeName : SL_FONT_SCALE(12.f)}];
    
    self.scoreLabel.frame = SL__Rect(SL__SCALE(10.f), SL__SCALE(10.f), SL__SCALE(strSize.width + 1), SL__SCALE(14.f));
    
    self.danGuanImageView.frame = SL__Rect(CGRectGetMaxX(self.scoreLabel.frame) + SL__SCALE(5.f), CGRectGetMinY(self.scoreLabel.frame) + SL__SCALE(2.f), SL__SCALE(22.f), SL__SCALE(10.f));
    
    [self addButtons];
}

- (void)addButtons
{
    /******  胜  ******/
    UILabel *winLabel = [self createLabelWithText:@"胜" textColor:SL_UIColorFromRGB(0xfc5548)];
    
    winLabel.frame = SL__Rect(SL__SCALE(10.f), CGRectGetMaxY(self.scoreLabel.frame) + SL__SCALE(6.f), SL__SCALE(20.f), SL__SCALE(80.f));
    
    
    
    CGFloat btnW = SL__SCALE(43.f);
    CGFloat btnH = SL__SCALE(40.f);
    
    int row = 0,col = 0;
    
    for (int i = 0; i < 13; i ++) {
        
        SLOddsButton *button = [self createButtonShowRightLine:(i == 6) ||(i == 12) showBottomLine:NO];
        
        row = i / 7;
        col = i % 7;
        
        button.frame = SL__Rect(CGRectGetMaxX(winLabel.frame) + col * btnW, CGRectGetMinY(winLabel.frame) + row * btnH, i == 12 ? 2 * btnW : btnW, btnH);
        
        [self.oddButtonsArray addObject:button];
    }
    
    /******  平  ******/
    UILabel *plabel = [self createLabelWithText:@"平" textColor:SL_UIColorFromRGB(0x45a2f7)];
    
    plabel.frame = SL__Rect(CGRectGetMinX(winLabel.frame), CGRectGetMaxY(winLabel.frame), SL__SCALE(20.f), SL__SCALE(40.f));
    
    for (int i = 0; i < 5; i ++) {
        
        SLOddsButton *button = [self createButtonShowRightLine:(i == 4) showBottomLine:NO];
        
        button.frame = SL__Rect(CGRectGetMaxX(plabel.frame) + i * btnW,CGRectGetMinY(plabel.frame) , i == 4 ? btnW * 3 : btnW, btnH);
        
        [self.oddButtonsArray addObject:button];
    }
    
    
    
    
    /******  负  ******/
    UILabel *flabel = [self createLabelWithText:@"负" textColor:SL_UIColorFromRGB(0x2bc57c)];
    
    flabel.frame = SL__Rect(CGRectGetMinX(plabel.frame), CGRectGetMaxY(plabel.frame), SL__SCALE(20.f), SL__SCALE(80.f));
    
    
    //添加底线
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = SL_UIColorFromRGB(0xece5dd);
    
    bottomLineView.frame = SL__Rect(CGRectGetMinX(flabel.frame), CGRectGetMaxY(flabel.frame), SL__SCALE(20.f), 0.51f);
    
    
    for (int i = 0; i < 13; i ++) {
        
        row = i / 7;
        col = i % 7;
        
        SLOddsButton *button = [self createButtonShowRightLine:(i == 6) ||(i == 12) showBottomLine:row == 1];
    
        button.frame = SL__Rect(CGRectGetMaxX(flabel.frame) + col * btnW, CGRectGetMinY(flabel.frame) + row * btnH, i == 12 ? 2 * btnW : btnW, btnH);
        
        
        [self.oddButtonsArray addObject:button];
        
    }
    
    
    [self.oddButtonsArray enumerateObjectsUsingBlock:^(SLOddsButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [btn addTarget:self action:@selector(buttonOnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        btn.tag = [self.tagArray[idx] integerValue];
    }];
}

- (UILabel *)createLabelWithText:(NSString *)text textColor:(UIColor *)color{
    
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = color;
    label.font = SL_FONT_SCALE(11);
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = SL_UIColorFromRGB(0xffffff);
    [self.contentView addSubview:label];
    [self addLeftAndTopLineWithView:label];
    return label;
}
- (SLOddsButton *)createButtonShowRightLine:(BOOL)showRightLine showBottomLine:(BOOL)showBottomLine{
    
    SLOddsButton *button = [[SLOddsButton alloc] initWithType:SLOddsButtonTypeVertical];
    button.playMothedLabel.text = @"";
    button.oddsLabel.text = @"";
    button.showLeftLine = YES;
    button.showTopLine = YES;
    button.showRightLine = showRightLine;
    button.showBottomLine = showBottomLine;
    [self.contentView addSubview:button];
    return button;
}

- (void)addLeftAndTopLineWithView:(UIView *)view
{
        
    UIView *leftLineView = [[UIView alloc] init];
    leftLineView.backgroundColor = SL_UIColorFromRGB(0xece5dd);
    [self.contentView addSubview:leftLineView];
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.bottom.equalTo(view);
        make.width.mas_equalTo(0.51f);
    }];
    UIView *topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = SL_UIColorFromRGB(0xece5dd);
    [self.contentView addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(view);
        make.height.mas_equalTo(0.51f);
    }];
    
}




- (void)assignDataWithNormalData:(SLBFModel *)bfModel matchIssue:(NSString *)matchIssue{
    
    self.bfModel = bfModel;
    self.matchIssue = matchIssue;
    self.scoreSelectPlayMothedInfo = [[SLBetSelectPlayMothedInfo alloc] init];
    self.scoreSelectPlayMothedInfo.playMothed = BF;
    self.scoreSelectPlayMothedInfo.isDanGuan = bfModel.danguan == 1;
    SLBetSelectSingleGameInfo *selectedInfo = [SLBetInfoManager getSingleMatchSelectInfoWithMatchIssue:matchIssue];
    
    SLBetSelectPlayMothedInfo *playInfo = nil;
    
    for (SLBetSelectPlayMothedInfo *existPlayInfo in selectedInfo.singleBetSelectArray) {
        if ([existPlayInfo.playMothed isEqualToString:BF]) {
            playInfo = existPlayInfo;
        }
    }
    for (NSString *odds in playInfo.selectPlayMothedArray) {
        [self.scoreSelectPlayMothedInfo.selectPlayMothedArray addObject:odds];
    }
    for (SLOddsButton *button in self.oddButtonsArray) {
        
        button.selected = [playInfo.selectPlayMothedArray containsObject:[NSString stringWithFormat:@"%02zi", button.tag]];
    }
}

- (void)setBfModel:(SLBFModel *)bfModel{
    
    if (!bfModel) return;
    
    self.danGuanImageView.hidden = (bfModel.danguan != 1);
    
    NSArray *array = @[@{@"bf": @"1:0", @"odds": bfModel.sp.sp_1_0},
                       @{@"bf": @"2:0", @"odds": bfModel.sp.sp_2_0},
                       @{@"bf": @"2:1", @"odds": bfModel.sp.sp_2_1},
                       @{@"bf": @"3:0", @"odds": bfModel.sp.sp_3_0},
                       @{@"bf": @"3:1", @"odds": bfModel.sp.sp_3_1},
                       @{@"bf": @"3:2", @"odds": bfModel.sp.sp_3_2},
                       @{@"bf": @"4:0", @"odds": bfModel.sp.sp_4_0},
                       @{@"bf": @"4:1", @"odds": bfModel.sp.sp_4_1},
                       @{@"bf": @"4:2", @"odds": bfModel.sp.sp_4_2},
                       @{@"bf": @"5:0", @"odds": bfModel.sp.sp_5_0},
                       @{@"bf": @"5:1", @"odds": bfModel.sp.sp_5_1},
                       @{@"bf": @"5:2", @"odds": bfModel.sp.sp_5_2},
                       @{@"bf": @"胜其他", @"odds": bfModel.sp.sp_9_0},
                       @{@"bf": @"0:0", @"odds": bfModel.sp.sp_0_0},
                       @{@"bf": @"1:1", @"odds": bfModel.sp.sp_1_1},
                       @{@"bf": @"2:2", @"odds": bfModel.sp.sp_2_2},
                       @{@"bf": @"3:3", @"odds": bfModel.sp.sp_3_3},
                       @{@"bf": @"平其他", @"odds": bfModel.sp.sp_9_9},
                       @{@"bf": @"0:1", @"odds": bfModel.sp.sp_0_1},
                       @{@"bf": @"0:2", @"odds": bfModel.sp.sp_0_2},
                       @{@"bf": @"1:2", @"odds": bfModel.sp.sp_1_2},
                       @{@"bf": @"0:3", @"odds": bfModel.sp.sp_0_3},
                       @{@"bf": @"1:3", @"odds": bfModel.sp.sp_1_3},
                       @{@"bf": @"2:3", @"odds": bfModel.sp.sp_2_3},
                       @{@"bf": @"0:4", @"odds": bfModel.sp.sp_0_4},
                       @{@"bf": @"1:4", @"odds": bfModel.sp.sp_1_4},
                       @{@"bf": @"2:4", @"odds": bfModel.sp.sp_2_4},
                       @{@"bf": @"0:5", @"odds": bfModel.sp.sp_0_5},
                       @{@"bf": @"1:5", @"odds": bfModel.sp.sp_1_5},
                       @{@"bf": @"2:5", @"odds": bfModel.sp.sp_2_5},
                       @{@"bf": @"负其他", @"odds": bfModel.sp.sp_0_9},
                       ];
    
    if (self.oddButtonsArray.count == array.count) {
        for (NSInteger i = 0 ; i < self.oddButtonsArray.count; i++) {
            
            SLOddsButton *button = self.oddButtonsArray[i];
            NSDictionary *dic = array[i];
            button.playMothedLabel.text = dic[@"bf"];
            button.oddsLabel.text = BetOddsTransitionString(dic[@"odds"]);
        }
    }
    
    
}
#pragma mark ------------ event Response ------------
- (void)buttonOnClick:(SLOddsButton *)btn{
    
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.scoreSelectPlayMothedInfo.selectPlayMothedArray addObject:[NSString stringWithFormat:@"%02zi", btn.tag]];
    }else{
        [self.scoreSelectPlayMothedInfo.selectPlayMothedArray removeObject:[NSString stringWithFormat:@"%02zi", btn.tag]];
    }
}

#pragma mark ------------ getter Mothed ------------
- (UILabel *)scoreLabel{
    
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.text = @"比分";
        _scoreLabel.textColor = SL_UIColorFromRGB(0x333333);
        _scoreLabel.font = SL_FONT_SCALE(12.f);
    }
    return _scoreLabel;
}

- (NSMutableArray *)oddButtonsArray{
    
    if (!_oddButtonsArray) {
        _oddButtonsArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _oddButtonsArray;
}

- (UIImageView *)danGuanImageView{
    
    if (!_danGuanImageView) {
        _danGuanImageView = [[UIImageView alloc] init];
        _danGuanImageView.contentMode = UIViewContentModeScaleAspectFit;
        _danGuanImageView.image = [UIImage imageNamed:@"allOddsDanGuan.png"];
    }
    return _danGuanImageView;
}

- (NSArray *)tagArray{
    
    return @[@"10", @"20", @"21", @"30", @"31", @"32", @"40", @"41", @"42", @"50", @"51", @"52", @"90", @"00", @"11", @"22", @"33", @"99", @"01", @"02", @"12", @"03", @"13", @"23", @"04", @"14", @"24", @"05", @"15", @"25", @"09",];
    
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
