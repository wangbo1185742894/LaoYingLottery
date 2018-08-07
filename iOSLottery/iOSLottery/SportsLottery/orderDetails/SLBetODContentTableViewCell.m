//
//  CQBetODTableViewCell.m
//  caiqr
//
//  Created by huangyuchen on 16/7/22.
//  Copyright © 2016年 Paul. All rights reserved.
//

//思路：不同cell用不同内部类创建 根据ID获取不同类的cell复用

#import "SLBetODContentTableViewCell.h"
#import "CQDefinition.h"
#import "CQSideLineLabel.h"
#import "CQDoubleView.h"
#import "UILabel+SLAttributeLabel.h"
#import "SLBODAllModel.h"

#import "SLConfigMessage.h"

#import "DisplayView.h"
#import "CQLabelButtonImageView.h"

#import "CTUnit.h"
#import "CTFrameParser.h"

#define SessionW (__SCALE(40)) //场次的宽度
#define PlayerW (__SCALE(90)) //比赛双方的宽度
#define GameW (__SCALE(75)) //玩法的宽度
#define BetW (__SCALE(75)) //投注内容的宽度
#define AmidithionW (CGRectGetWidth([[UIScreen mainScreen] bounds]) - SessionW - PlayerW - GameW - BetW) //赛果的宽度

#pragma mark - cell类  中间的订单详情
@interface SLBetODContentTableViewCell ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *sessionButton;
@property (nonatomic, strong) CQSideLineLabel *playerLabel;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) CQBODProgrammeInfoModel *programmeInfoModel;
@property (nonatomic, strong) NSString *lotteryCode;

/**
 赛事取消label
 */
@property (nonatomic, strong) UILabel *cancelLabel;

@end

@implementation SLBetODContentTableViewCell
#pragma mark - 创建订单详情cell
+ (instancetype)createBODContentTableViewCellWithTableView:(UITableView *)tableView
                                                      Data:(id)data
                                                Identifier:(NSString *)cellID
                                               lotteryCode:(NSString *)lotteryCode
{
    SLBetODContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[SLBetODContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];

    }
    
    cell.lotteryCode = lotteryCode;
    [cell assignCellWithData:data];
    return cell;
}
#pragma mark - 重写init方法
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.mainTableView];
        [self.contentView addSubview:self.sessionButton];
        [self.contentView addSubview:self.playerLabel];
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.userInteractionEnabled = YES;
        self.layer.borderColor = SL_SEPARATORCOLOR.CGColor;
        self.layer.borderWidth = .26f;
    }
    return self;
}
#pragma mark - 配置data数据源
- (void)assignCellWithData:(id)data{
    
    self.programmeInfoModel = data;
    //为子View配置数据
    [self configDataSource];
    //重设frame
    [self updateFrame];
    //刷新列表
    [self.mainTableView reloadData];
}
#pragma mark - 更新frame
- (void)updateFrame{
    
    self.sessionButton.frame = __Rect(self.sessionButton.frame.origin.x, self.sessionButton.frame.origin.y, self.sessionButton.frame.size.width, self.programmeInfoModel.programmeInfoHeight);
    self.playerLabel.frame = __Rect(self.playerLabel.frame.origin.x, self.playerLabel.frame.origin.y, self.playerLabel.frame.size.width, self.programmeInfoModel.programmeInfoHeight);
    self.mainTableView.frame = __Rect(self.mainTableView.frame.origin.x, self.mainTableView.frame.origin.y, self.mainTableView.frame.size.width, self.programmeInfoModel.programmeInfoHeight);
    
    
    //赛事取消
    if (self.programmeInfoModel.ifMatchCancel == 1) {
        
        [self.contentView addSubview:self.cancelLabel];
        
        self.cancelLabel.frame = SL__Rect(SL_SCREEN_WIDTH - AmidithionW, 0, AmidithionW, self.programmeInfoModel.programmeInfoHeight);
        
        UIView *line = [[UIView alloc] initWithFrame:(CGRectMake(SL_SCREEN_WIDTH - AmidithionW, 0, 0.26, CGRectGetHeight(self.cancelLabel.frame)) )];
        
        line.backgroundColor = SL_SEPARATORCOLOR;
        [self addSubview:line];

    }
    
}
#pragma mark - 配置数据
- (void)configDataSource{
    //配置各部分数据
    //1.配置场次数据
    [self configSessionData];
    //2.配置比赛双方数据
    [self configPlayerData];
}
#pragma mark - 配置 场次 数据
- (void)configSessionData{
    //1.先确认换行
    NSRange range = [self.programmeInfoModel.matchIssueCn rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]];
    if (range.location != NSNotFound) {
        //若需要换行
        NSMutableString *mStr = [NSMutableString stringWithString:self.programmeInfoModel.matchIssueCn];
        [mStr insertString:@"\n" atIndex:range.location];
        [self.sessionButton setTitle:mStr forState:UIControlStateNormal];
        [self.sessionButton setTitle:mStr forState:UIControlStateDisabled];
        NSMutableAttributedString* attributedStr = [[NSMutableAttributedString alloc] initWithString:mStr];
        //创建NSMutableParagraphStyle实例
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        //设置行距
        [style setLineSpacing:__SCALE(5)];
        //根据给定长度与style设置attStr式样
        [attributedStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, mStr.length)];
        self.sessionButton.titleLabel.attributedText = attributedStr;

    }else{
        //不需要换行
        [self.sessionButton setTitle:self.programmeInfoModel.matchIssueCn forState:UIControlStateNormal];
        [self.sessionButton setTitle:self.programmeInfoModel.matchIssueCn forState:UIControlStateDisabled];
    }
    //判断场次按钮是否可以被点击
    if (self.programmeInfoModel.bottomPage && self.programmeInfoModel.bottomPage.length > 0) {
        
        self.sessionButton.enabled = YES;
    }else{
    
        self.sessionButton.enabled = NO;
    }
}

#pragma mark - 配置比赛双方数据
- (void)configPlayerData
{
    
    NSString *str = [NSString stringWithFormat:@"%@\n%@\n%@",self.programmeInfoModel.hostTeam,self.programmeInfoModel.score,self.programmeInfoModel.awayTeam];

    //设置比分VS
    SLAttributedTextParams *vs_params = [SLAttributedTextParams attributeRange:NSMakeRange(self.programmeInfoModel.hostTeam.length + 1, self.programmeInfoModel.score.length) Color:SL_UIColorFromStr(_programmeInfoModel.scoreColor) Font:SL_FONT_SCALE(12)];
    
    [self.playerLabel sl_attributeWithText:str controParams:@[vs_params]];
    
    NSRange range1 = [str rangeOfString:@"^"];
    
    if (range1.location == NSNotFound) return;
    
    NSRange range2 = [str rangeOfString:@"&"];
    
    
    //设置全场比分
    SLAttributedTextParams *all_params = [SLAttributedTextParams attributeRange:NSMakeRange(range1.location , range2.location - range1.location) Color:SL_UIColorFromStr(_programmeInfoModel.scoreColor) Font:SL_FONT_SCALE(12)];
    
    //设置半场比分
    SLAttributedTextParams *half_params = [SLAttributedTextParams attributeRange:NSMakeRange(self.programmeInfoModel.hostTeam.length, range1.location - self.programmeInfoModel.hostTeam.length) Color:SL_UIColorFromRGB(0x333333) Font:SL_FONT_SCALE(12)];
    
    
    str = [str stringByReplacingOccurrencesOfString:@"^" withString:@" "];
    
    str = [str stringByReplacingOccurrencesOfString:@"&" withString:@" "];
    
    [self.playerLabel sl_attributeWithText:str controParams:@[all_params,half_params]];
    
    
}
#pragma mark - 赛事点击事件的触发
- (void)sessionBtnOnClick:(UIButton *)btn{
    NSLog(@"点击了赛事按钮触发事件");
    if (self.sessionBlock) {
        self.sessionBlock(self.programmeInfoModel.bottomPage);
    }
}
#pragma mark - tableView的delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.programmeInfoModel.betMaps.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.programmeInfoModel.betMaps[indexPath.row].bettingInfoHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SLBETODSubOrderDetailCell *cell = [SLBETODSubOrderDetailCell createBODSubOrderDetailCellWithTableView:tableView Data:self.programmeInfoModel.betMaps[indexPath.row]];
    if (indexPath.row == self.programmeInfoModel.betMaps.count - 1) {
        //最后一条cell不需要底边线
        cell.has_BottomLine = NO;
    }else{
        cell.has_BottomLine = YES;
    }
    return cell;
}

#pragma mark - getterMothed
- (UIButton *)sessionButton
{
    if (!_sessionButton) {
        
        _sessionButton = [[UIButton alloc] initWithFrame:__Rect(0, 0, SessionW, 100)];
        
        [_sessionButton addTarget:self action:@selector(sessionBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        _sessionButton.enabled = NO;
        
        [_sessionButton setTitleColor:SL_UIColorFromRGB(0x9f8269) forState:UIControlStateNormal];
        [_sessionButton setTitleColor:SL_UIColorFromRGB(0x9f8269) forState:UIControlStateDisabled];
        
        _sessionButton.titleLabel.font = SL_FONT_SCALE(14.f);
        _sessionButton.titleLabel.numberOfLines = 0;
    }
    return _sessionButton;
}
- (CQSideLineLabel *)playerLabel{
    if (!_playerLabel) {
        _playerLabel = [[CQSideLineLabel alloc] initWithFrame:__Rect(CGRectGetMaxX(self.sessionButton.frame), 0, PlayerW, CGRectGetHeight(self.sessionButton.frame))];
        _playerLabel.labelSideLineType = CQLabelSideLineTypeOnlyLeft;
        
        _playerLabel.textAlignment = NSTextAlignmentCenter;
        _playerLabel.textColor = SL_UIColorFromRGB(0x333333);
        _playerLabel.font = SL_FONT_SCALE(14.f);
        
        _playerLabel.numberOfLines = 0;
    }
    return _playerLabel;
}
- (UITableView *)mainTableView{
    if (!_mainTableView) {
        
        _mainTableView = [[UITableView alloc] initWithFrame:__Rect(CGRectGetMaxX(self.playerLabel.frame), 0, GameW + BetW + AmidithionW, CGRectGetHeight(self.sessionButton.frame))];
        
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        
        _mainTableView.allowsSelection = NO;
        
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsVerticalScrollIndicator = NO;
        
        _mainTableView.backgroundColor = SL_UIColorFromRGB(0xffffff);
        
        _mainTableView.scrollEnabled = NO;
    }
    return _mainTableView;
}

- (UILabel *)cancelLabel
{

    if (_cancelLabel == nil) {
        
        _cancelLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        
        _cancelLabel.text = @"赛事\n取消";
        _cancelLabel.textColor = SL_UIColorFromRGB(0xFC5548);
        _cancelLabel.textAlignment = NSTextAlignmentCenter;
        
        _cancelLabel.font = SL_FONT_SCALE(14.f);
        
        _cancelLabel.backgroundColor = [UIColor whiteColor];
        _cancelLabel.numberOfLines = 0;
    }
    return _cancelLabel;
}

@end


#pragma mark - cell类  下方的信息
@interface CQBetODMessageTableViewCell ()

@property (nonatomic, strong) CQDoubleView *mainView;
@property (nonatomic, strong) SLBODOrderMessageModel *orderMessageModel;
@property (nonatomic, strong) CQLabelButtonImageView *refundView;
@property (nonatomic, strong) UITableView *longGestuerTable;
@end
@implementation CQBetODMessageTableViewCell
#pragma mark - 创建下方信息类cell
+ (instancetype)createBODMessageTableViewCellWithTableView:(UITableView *)tableView
                                                    Data:(id)data
                                              Identifier:(NSString *)cellID{
    CQBetODMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[CQBetODMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.longGestuerTable = tableView;
    [cell assignCellWithData:data];
  
    return cell;
}
#pragma mark - 重写init方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.mainView];
    }
    return self;
}
#pragma mark - 配置cell数据
- (void)assignCellWithData:(id)data{
    [CATransaction setDisableActions:YES];//关闭隐式动画
    //获取数据
    self.orderMessageModel = data;
    //更新frame
    self.mainView.frame = __Rect(0, 0, SCREEN_WIDTH, self.orderMessageModel.messageHeight);
    CGRect frame = self.mainView.frame;
    frame.size.height = self.orderMessageModel.messageHeight;
    self.mainView.frame = frame;
    
    self.mainView.leftLabelTitle = self.orderMessageModel.title;
    self.mainView.rightLabelTitle = self.orderMessageModel.content;
    //如果有退款说明添加退款说明 或者 奖金优化 出票详情
    [self createRefundButton];
}

- (void)betContentLongGestuerClick:(UILongPressGestureRecognizer *)gestuer
{
    
    if (self.contentLongBlock) {
        
        [self becomeFirstResponder];
        
        self.mainView.rightLabel.backgroundColor = SL_UIColorFromRGB(0xd9d9d9);
        
        self.contentLongBlock([self.longGestuerTable rectForRowAtIndexPath:[self.longGestuerTable indexPathForCell:self]],self.mainView.rightLabel);
    }
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

#pragma mark - 添加 退款说明 按钮
- (void)createRefundButton{
    /**
     *  添加 退款说明 按钮
        添加 奖金优化 按钮
        添加 详情  按钮
     */
    //现移除已有的View，防止重复添加
    [self.refundView removeFromSuperview];
    
    WS(_weakSelf)
    self.refundView.frame = __Rect(0, 0, SCREEN_WIDTH - __SCALE(100), self.orderMessageModel.messageHeight);

    self.refundView.contentImage = [UIImage imageNamed:@"nextPage.png"];
    //区分是退款按钮还是详情按钮
    if (self.orderMessageModel.is_Click == 10) {
        self.refundView.labelText = self.orderMessageModel.content;
        self.refundView.buttonText = @"退款说明";
        self.refundView.contentBtnBlock = ^(){
            NSLog(@"点击了退款说明按钮");
            if (_weakSelf.refundBlock) {
                //如果存在block 且 当前是退款说明按钮
                _weakSelf.refundBlock();
            }
        };
        self.mainView.rightSubView = self.refundView;
    }else if (self.orderMessageModel.is_Click == 11){
        self.refundView.labelText = self.orderMessageModel.content;
        self.refundView.buttonText = @"详情";
        self.refundView.contentBtnBlock = ^(){
            NSLog(@"点击了奖金优化 详情按钮");
            if (_weakSelf.awardOptimizeBlock) {
                //如果存在block 且 当前是奖金优化按钮
                _weakSelf.awardOptimizeBlock();
            }
        };
        self.mainView.rightSubView = self.refundView;
    }else if ([self.orderMessageModel.title isEqualToString:@"出票方:"] && self.orderMessageModel.messageHeight > 0){
        
        NSArray *dataArray = [self.orderMessageModel.content componentsSeparatedByString:@"_"];
        
        if (dataArray.count != 2) return;
        
        self.refundView.labelText = dataArray[0];

        self.refundView.labelTextFont = SL_FONT_SCALE(13.f);
        
        self.refundView.buttonText = dataArray[1];
        self.refundView.buttonTextColor = SL_UIColorFromRGB(0x45A2F7);
        self.refundView.contentBtnBlock = ^(){
            NSLog(@"点击了点击查看按钮");
            if (_weakSelf.drawerBlock) {
                _weakSelf.drawerBlock();
            }
        };
        self.mainView.rightSubView = self.refundView;
    }

}
- (CQLabelButtonImageView *)refundView{
    if (!_refundView) {
        _refundView = [[CQLabelButtonImageView alloc] initWithFrame:__Rect(0, 0, SCREEN_WIDTH - __SCALE(100), 0)];
    }
    return _refundView;
}
#pragma mark - getterMothed
- (CQDoubleView *)mainView{
    if (!_mainView) {
        _mainView = [[CQDoubleView alloc] initWithFrame:__Rect(0, 0, [[UIScreen mainScreen] bounds].size.width, 0)];
        
        _mainView.leftFont = SL_FONT_SCALE(12.f);
        _mainView.leftTextColor = SL_UIColorFromRGB(0x8F6E51);
        _mainView.leftTextAlignment = NSTextAlignmentCenter;
        
        _mainView.rightFont = SL_FONT_SCALE(12.f);
        _mainView.rightTextColor = SL_UIColorFromRGB(0x8F6E51);
        
        UILongPressGestureRecognizer *contentLongPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(betContentLongGestuerClick:)];
        contentLongPressGesture.minimumPressDuration = 0.8f;
        //    contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _mainView.rightLabel.userInteractionEnabled = YES;
        [_mainView.rightLabel addGestureRecognizer:contentLongPressGesture];
  
    }
    return _mainView;
}


@end

#pragma mark - cell类  最上方的标题
#define TitleCellHeight 30 //标题cell的高度
@interface SLBetODTitleTableViewCell ()

@end
@implementation SLBetODTitleTableViewCell
#pragma mark - 创建上方标题cell
+ (instancetype)createBODTitleTableViewCellWithTableView:(UITableView *)tableView
{
    
    static NSString *cellID = @"SLtitleTableViewCell";
    SLBetODTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[SLBetODTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.borderColor = SL_SEPARATORCOLOR.CGColor;
        cell.layer.borderWidth = .5f;
        [cell assignCellWithData];
    }
    return cell;
}
+ (CGFloat)cellHeight{
    return SL__SCALE(TitleCellHeight);
}
#pragma mark - 配置cell
- (void)assignCellWithData
{
    NSArray *titleArr = @[@"场次",@"比赛双方",@"玩法",@"投注内容",@"赛果"];
    //创建宽度数组
    NSArray *widthArr = @[@(SessionW), @(PlayerW), @(GameW), @(BetW), @(AmidithionW)];
    //根据宽度数组创建label的X值的数组
    CGFloat labelX = 0;
    NSMutableArray *XArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < widthArr.count; i++) {
        [XArr addObject:@(labelX)];
        labelX += [widthArr[i] floatValue];
    }
    ;
    //根据数据创建View
    for (NSInteger i = 0; i < widthArr.count; i++) {
                
        CQSideLineLabel *label = [[CQSideLineLabel alloc] initWithFrame:__Rect([XArr[i] floatValue], 0, [widthArr[i] floatValue], SL__SCALE(TitleCellHeight))];
        label.labelSideLineType = CQLabelSideLineTypeOnlyRight;
        label.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            label.labelSideLineType = CQLabelSideLineTypeNone;
        }
        if (i == 1) {
            label.labelSideLineType = CQLabelSideLineTypeOnlyLeft;
        }
        if (i == 2) {
            label.labelSideLineType = CQLabelSideLineTypeLeftRight;
        }
        if (i == widthArr.count - 2) {
            label.labelSideLineType = CQLabelSideLineTypeNone;
        }
        if (i == widthArr.count - 1) {
            label.labelSideLineType = CQLabelSideLineTypeOnlyLeft;
        }
        label.font = SL_FONT_SCALE(14.f);
        label.text = titleArr[i];
        label.textColor = SL_UIColorFromRGB(0x999999);
        [self addSubview:label];
    }
}

@end

#pragma mark - 二级tableView的子cell
@interface SLBETODSubOrderDetailCell ()

@property (nonatomic, strong) CQSideLineLabel *gameLabel;
@property (nonatomic, strong) DisplayView *betView;
@property (nonatomic, strong) CQSideLineLabel *AmidithionLabel;
@property (nonatomic, strong) CQBODBettingInfoModel *bettingInfoModel;
@property (nonatomic, strong) CALayer *bottomLineLayer;

@end

@implementation SLBETODSubOrderDetailCell

static CTFrameParserConfig* __config;
#pragma mark --- 创建cell ---
+(instancetype)createBODSubOrderDetailCellWithTableView:(UITableView *)tableView Data:(id)data
{
    static NSString *cellID = @"SLSubOrderDetailCell";
    
    SLBETODSubOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        
        cell = [[SLBETODSubOrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    [cell assignCellWithData:data];
    
    return cell;
}
#pragma mark - 重写init方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //添加View
        [self.contentView addSubview:self.gameLabel];
        [self.contentView addSubview:self.betView];
        [self.contentView addSubview:self.AmidithionLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
#pragma mark - 解析数据
- (void)assignCellWithData:(id)data
{
    //解析数据
    self.bettingInfoModel = data;
    //更新frame
    [self updateFrame];
    //重绘富文本，防止重复绘制，造成层叠
    [self.betView setNeedsDisplay];
    //配置数据
    [self configSubOrderDetailView];
    
}
#pragma mark - 更新frame
- (void)updateFrame{
    
    self.gameLabel.frame = __Rect(0, 0, GameW, self.bettingInfoModel.bettingInfoHeight);
    self.betView.frame = __Rect(CGRectGetMaxX(self.gameLabel.frame), 0, BetW, CGRectGetHeight(self.gameLabel.frame));
    self.AmidithionLabel.frame = __Rect(CGRectGetMaxX(self.betView.frame), 0, AmidithionW, CGRectGetHeight(self.gameLabel.frame));
    self.bottomLineLayer.frame = __Rect(0, CGRectGetMaxY(self.AmidithionLabel.frame), GameW + BetW + AmidithionW, .5f);
    
}
#pragma mark - 配置数据
- (void)configSubOrderDetailView{
    //配置玩法
    [self configGameData];
    //配置赛果
    self.AmidithionLabel.text = self.bettingInfoModel.matchResult;
    //配置投注内容
    [self configBetData];
}
#pragma mark - 配置玩法
- (void)configGameData
{
    
    //1.先用#分隔 若数组个数大于1个，则说明有需要换行
    NSArray *playArr = [self.bettingInfoModel.playTypeCn componentsSeparatedByString:@"_"];
    //2.拼接字符串
    NSString *playStr = [NSString new];
    
    playStr = playArr.count > 1 ? [playArr componentsJoinedByString:@"\n"] : playArr[0];
    
    //3.校验是否存在 “+”“—”  变色
    if ([playStr rangeOfString:@"+"].location !=NSNotFound) {

        //设置+
        [self setUpGameLabeltextWithTab:@"+" color:SL_UIColorFromRGB(0xFC5548) playStr:playStr];
        
    }else if ([playStr rangeOfString:@"-"].location !=NSNotFound) {
        
        //设置-
        [self setUpGameLabeltextWithTab:@"-" color:SL_UIColorFromRGB(0x2BC574) playStr:playStr];

    }else{
        self.gameLabel.text = playStr;
    }
}

//设置玩法内容
- (void)setUpGameLabeltextWithTab:(NSString *)tap color:(UIColor *)color playStr:(NSString *)playStr
{

    NSRange changeColorRange = [playStr rangeOfString:@"("];
    
    SLAttributedTextParams *prams = [SLAttributedTextParams attributeRange:NSMakeRange([playStr rangeOfString:tap].location, playStr.length - changeColorRange.location - 2) Color:color];
    
    [self.gameLabel sl_attributeWithText:playStr controParams:@[prams]];
    
}
#pragma mark - 配置投注内容（绘制富文本）
- (void)configBetData{
        
    NSMutableArray <__kindof CTUnit*> *content_units = [NSMutableArray new];
    
    BOOL isOffset = NO;
    
    for (NSInteger i = 0; i < self.bettingInfoModel.betItem.count; i++) {
        //1.做判断该条是否需要标红展示
        NSString *str = self.bettingInfoModel.betItem[i];
        NSString *finishStr = [NSString new];
        if ([str rangeOfString:@"^"].location != NSNotFound) {
            //如果需要 则去掉* 并标红
             str = [str stringByReplacingOccurrencesOfString:@"^" withString:@""];
             NSString *text = [str stringByReplacingOccurrencesOfString:@"&" withString:@""];
            //如果不是最后一个数据则需要拼接一个“\n”
            if (i != self.bettingInfoModel.betItem.count) {
                finishStr = [NSString stringWithFormat:@"%@\n",text];
            }
            
            if (i != self.bettingInfoModel.betItem.count && self.bettingInfoModel.betItem.count > 1) {
                
                finishStr = [NSString stringWithFormat:@"%@\n\n",text];
                
                isOffset = YES;
            }
            
            //赋值富文本
            CTUnit* unit1 = [[CTUnit alloc] init];
            unit1.color = SL_UIColorFromRGB(0xff4747);
            unit1.type = CTUnitTxtType;
            unit1.content = finishStr;
            [content_units addObject:unit1];
        }else{
            //如果不需要变色直接赋值富文本
            CTUnit* unit1 = [[CTUnit alloc] init];
            unit1.type = CTUnitTxtType;
            if (i != self.bettingInfoModel.betItem.count) {
                finishStr = [NSString stringWithFormat:@"%@\n",str];
            }
            
            if (i != self.bettingInfoModel.betItem.count && self.bettingInfoModel.betItem.count > 1) {
                
                finishStr = [NSString stringWithFormat:@"%@\n\n",str];
                
                isOffset = YES;
            }
            
            unit1.content = finishStr;
            [content_units addObject:unit1];
        }
    }
    /** 创建绘制数据源 */
    self.betView.data = [CTFrameParser parserCTUnits:content_units config:[SLBETODSubOrderDetailCell parserLeftConfig]];
    
    self.betView.isOffset = isOffset;
    
    /** 更新 重绘frame */
    self.betView.frame = CGRectMake(self.betView.frame.origin.x, (CGRectGetHeight(self.betView.frame) - self.betView.data.height) / 2, BetW, self.betView.data.height);
}

#pragma mark - 配置富文本属性
+ (CTFrameParserConfig*)parserLeftConfig
{
    @autoreleasepool {
        if (!__config) {
            __config = [[CTFrameParserConfig alloc] init];
        }
        
        __config.width = BetW;
        __config.lineSpace = 0.f;
        __config.fontSize = __SCALE(12.f);
        __config.textColor = SL_UIColorFromRGB(0x333333);
        __config.textAlignment = NSTextAlignmentCenter;
        return __config;
    }
}
#pragma mark - setterMothed
- (void)setHas_BottomLine:(BOOL)has_BottomLine{
    _has_BottomLine = has_BottomLine;
    if (_has_BottomLine) {
        [self.layer addSublayer:self.bottomLineLayer];
    }else{
        [self.bottomLineLayer removeFromSuperlayer];
    }
}
#pragma mark - getterMothed
- (CQSideLineLabel *)gameLabel{
    if (!_gameLabel) {
        _gameLabel = [[CQSideLineLabel alloc] initWithFrame:__Rect(0, 0, GameW, self.bettingInfoModel.bettingInfoHeight)];
        _gameLabel.labelSideLineType = CQLabelSideLineTypeLeftRight;
        _gameLabel.textAlignment = NSTextAlignmentCenter;
        _gameLabel.font = SL_FONT_SCALE(14.f);
        _gameLabel.numberOfLines = 0;
    }
    return _gameLabel;
}
- (DisplayView *)betView{
    if (!_betView) {
        _betView = [[DisplayView alloc] initWithFrame:__Rect(CGRectGetMaxX(self.gameLabel.frame), 0, BetW, CGRectGetHeight(self.gameLabel.frame))];
        
        _betView.backgroundColor = SL_CLEARCOLOR;
    }
    return _betView;
}
- (CQSideLineLabel *)AmidithionLabel{
    if (!_AmidithionLabel) {
        _AmidithionLabel = [[CQSideLineLabel alloc] initWithFrame:__Rect(CGRectGetMaxX(self.betView.frame), 0, AmidithionW, CGRectGetHeight(self.gameLabel.frame))];
        _AmidithionLabel.font = FONT_FIX(12);
        _AmidithionLabel.labelSideLineType = CQLabelSideLineTypeOnlyLeft;
        _AmidithionLabel.textAlignment = NSTextAlignmentCenter;
        _AmidithionLabel.numberOfLines = 0;
    }
    return _AmidithionLabel;
}
- (CALayer *)bottomLineLayer{
    if (!_bottomLineLayer) {
        _bottomLineLayer = [[CALayer alloc] init];
        _bottomLineLayer.frame = __Rect(0, CGRectGetMaxY(self.AmidithionLabel.frame), GameW + BetW + AmidithionW, .5f);
        _bottomLineLayer.backgroundColor = SL_SEPARATORCOLOR.CGColor;
    }
    return _bottomLineLayer;
}
@end

#pragma mark - 中奖怎么算cell
#define ImageViewWH 10 //图片的宽高
@interface SLBetODAwardTableViewCell ()

@property (nonatomic, strong) UILabel *awardLabel;
@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UIView *mainView;

@end
@implementation SLBetODAwardTableViewCell

+ (instancetype)createBODAwardCellWithTableView:(UITableView *)tableView Data:(id)data
{
   
    static NSString *cellID = @"SLawardTableViewCell";
    
    SLBetODAwardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[SLBetODAwardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell assignCellWithData:data];
    return cell;
    
}
#pragma mark - 重写init方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.mainView addSubview:self.awardLabel];
        [self.mainView addSubview:self.mainImageView];
        [self.contentView addSubview:self.mainView];
    }
    return self;
}
#pragma mark - 配置数据
- (void)assignCellWithData:(id)data{
    
    self.awardLabel.text = @"中奖怎么算?";
    self.mainImageView.image = [UIImage imageNamed:@"prizePrompt.png"];
    

}
#pragma mark - 点击事件
- (void)tapMainView:(UITapGestureRecognizer *)tap{
    if (self.winAwardBlock) {
        self.winAwardBlock();
    }
}
#pragma mark - getterMothed
- (UIView *)mainView{
    
    if (!_mainView) {
        
        _mainView = [[UIView alloc] initWithFrame:__Rect(SCREEN_WIDTH - __SCALE(82), __SCALE(5), __SCALE(76), __SCALE(20.f))];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMainView:)];
        [_mainView addGestureRecognizer:tap];

    }
    return _mainView;
}
- (UILabel *)awardLabel{
    if (!_awardLabel) {
        
        _awardLabel = [[UILabel alloc] initWithFrame:__Rect(CGRectGetMaxX(self.mainImageView.frame) + __SCALE(5), 0, __SCALE(65), __SCALE(15))];
        
        _awardLabel.textAlignment = NSTextAlignmentLeft;
        
        _awardLabel.font = SL_FONT_SCALE(12.f);
        
        _awardLabel.textColor = SL_UIColorFromRGB(0x45A2F7);

    }
    return _awardLabel;
}
- (UIImageView *)mainImageView
{
    if (!_mainImageView) {
        
        _mainImageView = [[UIImageView alloc] initWithFrame:__Rect(0, 0, __SCALE(ImageViewWH), __SCALE(ImageViewWH))];
        
        _mainImageView.center = CGPointMake(self.mainImageView.center.x, self.awardLabel.center.y);
    }
    return _mainImageView;
}
@end
