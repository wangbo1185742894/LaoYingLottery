//
//  SLAllOddsGoalCell.m
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLAllOddsGoalCell.h"
#import "SLOddsButton.h"
#import "SLConfigMessage.h"
#import "SLJPSModel.h"
#import "SLBetSelectInfo.h"
#import "SLBetInfoManager.h"
@interface SLAllOddsGoalCell ()

/**
 总进球label
 */
@property (nonatomic, strong) UILabel *goalsLabel;


@property (nonatomic, strong) UIImageView *danGuanImageView;
@property (nonatomic, strong) NSMutableArray *buttonsArray;
@property (nonatomic, strong) NSArray *tagArray;

@end

@implementation SLAllOddsGoalCell

+ (instancetype)createAllOddsGoalCellWithTableView:(UITableView *)tableView
{

    static NSString *idcell = @"SLAllOddsGoalCell";
    
    SLAllOddsGoalCell *cell = [[SLAllOddsGoalCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:idcell];
    
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
    
    [self.contentView addSubview:self.goalsLabel];
    [self.contentView addSubview:self.danGuanImageView];
    
    CGSize strSize = [self.goalsLabel.text sizeWithAttributes:@{NSFontAttributeName : SL_FONT_SCALE(12.f)}];
    
    self.goalsLabel.frame = SL__Rect(SL__SCALE(10.f), SL__SCALE(10.f), SL__SCALE(strSize.width + 1), SL__SCALE(14.f));
    
    self.danGuanImageView.frame = SL__Rect(CGRectGetMaxX(self.goalsLabel.frame) + SL__SCALE(5.f), CGRectGetMinY(self.goalsLabel.frame) + SL__SCALE(2.f), SL__SCALE(22.f), SL__SCALE(10.f));
    
    [self addButton];
}


- (void)addButton
{
    CGFloat btnW = SL__SCALE(80.f);
    CGFloat btnH = SL__SCALE(27.f);
    
    int row = 0,col = 0;

    for (int i = 0; i < 8; i++) {
        
        row = i / 4;
        col = i % 4;
        
        SLOddsButton *button = [self createButtonShowRightLine:(i == 3) || (i == 7) showBottomLine:row == 1];
        
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
    button.playMothedLabel.text = @"0";
    button.oddsLabel.text = @"0.00";
    button.showLeftLine = YES;
    button.showTopLine = YES;
    button.showRightLine = showRightLine;
    button.showBottomLine = showBottomLine;
    [self.contentView addSubview:button];
    
    return button;
}

- (void)assignDataWithNormalData:(SLJPSModel *)jqsModel matchIssue:(NSString *)matchIssue{
    
    self.jqsModel = jqsModel;
    self.matchIssue = matchIssue;
    self.jqsSelectPlayMothedInfo = [[SLBetSelectPlayMothedInfo alloc] init];
    self.jqsSelectPlayMothedInfo.playMothed = ZJQ;
    self.jqsSelectPlayMothedInfo.isDanGuan = jqsModel.danguan == 1;
    SLBetSelectSingleGameInfo *selectedInfo = [SLBetInfoManager getSingleMatchSelectInfoWithMatchIssue:matchIssue];
    SLBetSelectPlayMothedInfo *playInfo = nil;
    for (SLBetSelectPlayMothedInfo *existPlayInfo in selectedInfo.singleBetSelectArray) {
        if ([existPlayInfo.playMothed isEqualToString:ZJQ]) {
            playInfo = existPlayInfo;
        }
    }
    for (NSString *odds in playInfo.selectPlayMothedArray) {
        [self.jqsSelectPlayMothedInfo.selectPlayMothedArray addObject:odds];
    }
    for (SLOddsButton *button in self.buttonsArray) {
        
        button.selected = [playInfo.selectPlayMothedArray containsObject:[NSString stringWithFormat:@"%zi", button.tag]];
    }
}

#pragma mark ------------ event Response ------------
- (void)buttonOnClick:(SLOddsButton *)btn{
    
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.jqsSelectPlayMothedInfo.selectPlayMothedArray addObject:[NSString stringWithFormat:@"%zi", btn.tag]];
    }else{
        [self.jqsSelectPlayMothedInfo.selectPlayMothedArray removeObject:[NSString stringWithFormat:@"%zi", btn.tag]];
    }
}
#pragma mark ------------ setter Mothed ------------
- (void)setJqsModel:(SLJPSModel *)jqsModel{
    
    if (!jqsModel) {
        return;
    }
    self.danGuanImageView.hidden = (jqsModel.danguan != 1);
    
    NSArray *array = @[@{@"bf": @"0", @"odds": jqsModel.sp.sp_0},
                       @{@"bf": @"1", @"odds": jqsModel.sp.sp_1},
                       @{@"bf": @"2", @"odds": jqsModel.sp.sp_2},
                       @{@"bf": @"3", @"odds": jqsModel.sp.sp_3},
                       @{@"bf": @"4", @"odds": jqsModel.sp.sp_4},
                       @{@"bf": @"5", @"odds": jqsModel.sp.sp_5},
                       @{@"bf": @"6", @"odds": jqsModel.sp.sp_6},
                       @{@"bf": @"7+", @"odds": jqsModel.sp.sp_7},
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

#pragma mark ------------ getter Mothed ------------
- (UILabel *)goalsLabel{
    
    if (!_goalsLabel) {
        _goalsLabel = [[UILabel alloc] init];
        _goalsLabel.text = @"总进球";
        _goalsLabel.textColor = SL_UIColorFromRGB(0x333333);
        _goalsLabel.font = SL_FONT_SCALE(12.f);
    }
    return _goalsLabel;
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
    
    return @[@"100",@"101",@"102",@"103",@"104",@"105",@"106", @"107"];
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
