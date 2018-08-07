//
//  CLJournalRecordCell.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/25.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLJournalRecordCell : UITableViewCell

@property (strong, nonatomic) UILabel *timeLbl;
@property (strong, nonatomic) UILabel *descLbl;
@property (strong, nonatomic) UILabel *journalLbl;

- (void)configureJournalData:(id)data;

@end
