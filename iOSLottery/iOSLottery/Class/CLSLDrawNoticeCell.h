//
//  CLSLAwardNoticeCell.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/5/19.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLAwardVoModel;

@interface CLSLDrawNoticeCell : UITableViewCell

@property (nonatomic, strong) CLAwardVoModel *drawNoticeModel;

+ (CLSLDrawNoticeCell *)createSLDrawNoticeCellWithTableView:(UITableView *)tableView;


@end

@interface CLSLAwardNoticeResult : UIView

@property (nonatomic, assign) NSInteger isCancel;

- (void)setDateWithString:(NSString *)str;

@end
