//
//  SLAllOddsSPFCell.h
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/13.
//  Copyright © 2017年 caiqr. All rights reserved.
// 展开全部赔率  胜平负 cell

#import <UIKit/UIKit.h>
@class SLSPFModel, SLBetSelectPlayMothedInfo;

@interface SLAllOddsSPFCell : UITableViewCell

@property (nonatomic, strong) NSString *matchIssue;
@property (nonatomic, strong) SLBetSelectPlayMothedInfo *spfSelectPlayMothedInfo;
@property (nonatomic, strong) SLBetSelectPlayMothedInfo *rqspfSelectPlayMothedInfo;

+ (instancetype)createAllOddsSPFCellWithTableView:(UITableView *)tableView;

- (void)assignDataWithNormalData:(SLSPFModel *)normalModel concedeData:(SLSPFModel *)concedeModel matchIssue: (NSString *)matchIssue;

@end
