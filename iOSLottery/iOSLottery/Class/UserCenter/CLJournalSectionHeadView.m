//
//  CLJournalSectionHeadView.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/25.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLJournalSectionHeadView.h"
#import "CQDefinition.h"
#import "CLConfigMessage.h"

@interface CLJournalSectionHeadView ()

@end

@implementation CLJournalSectionHeadView

- (instancetype) initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColorFromRGB(0xf1f1f1);
        self.timeLbl = [[UILabel alloc] init];
        self.timeLbl.backgroundColor = CLEARCOLOR;
        self.timeLbl.textColor = [UIColor blackColor];
        self.timeLbl.font = FONT_FIX(13);
        
        [self.contentView addSubview:self.timeLbl];
        
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.right.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10);
            
        }];
        
    }
    return self;
}

@end
