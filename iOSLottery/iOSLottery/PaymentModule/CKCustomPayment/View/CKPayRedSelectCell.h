//
//  CKPayRedSelectCell.h
//  caiqr
//
//  Created by huangyuchen on 2017/4/27.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKPayRedSelectCell : UITableViewCell

@property (nonatomic, assign) BOOL isSelectState;
@property (nonatomic, strong) NSString *redAmount;
@property (nonatomic, strong) NSString *descString;
@property (nonatomic, strong) NSString *descColorString;
@end
