//
//  CQSideLineLabel.h
//  caiqr
//
//  Created by huangyuchen on 16/7/23.
//  Copyright © 2016年 Paul. All rights reserved.
//带左右边线的label

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CQLabelSideLineType) {
    
    CQLabelSideLineTypeNone = 0,
    CQLabelSideLineTypeOnlyLeft = 1,
    CQLabelSideLineTypeOnlyRight,
    CQLabelSideLineTypeLeftRight
    
};
@interface CQSideLineLabel : UILabel

@property (nonatomic, assign) CQLabelSideLineType labelSideLineType;
@property (nonatomic, assign) CGFloat cqLineSpacing;//行间距
@end
