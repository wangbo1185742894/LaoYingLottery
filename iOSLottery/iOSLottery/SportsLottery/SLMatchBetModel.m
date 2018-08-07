//
//  SLMatchBetModel.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLMatchBetModel.h"
#import "SLSPFModel.h"
#import "SLBFModel.h"
#import "SLJPSModel.h"
#import "SLBQCModel.h"
@interface SLMatchBetModel ()

@property (nonatomic, strong) NSMutableDictionary *oddsDictionary;


@end

@implementation SLMatchBetModel

- (CGFloat)getOddsWithTag:(NSString *)tag{
    
    NSString *value = [[self oddsDictionary] valueForKey:tag];
    if (value && value.length > 0) {
        return [[self oddsDictionary][tag] floatValue];
    }else{
        return 0;
    }
}

- (void)mj_keyValuesDidFinishConvertingToObject{
    
    self.spf.isSale = (self.spf_sale_status == 1);
    self.rqspf.isSale = (self.rqspf_sale_status == 1);
    self.bqc.isSale = (self.bqc_sale_status == 1);
    self.jqs.isSale = (self.jqs_sale_status == 1);
    self.bifen.isSale = (self.bifen_sale_status == 1);
}



- (NSMutableDictionary *)oddsDictionary{
    
    if (!_oddsDictionary) {
        
        _oddsDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
        if (self.spf && self.spf.sp) {
            
            if (self.spf.sp.win) {
            
                [_oddsDictionary setObject:self.spf.sp.win forKey:@"3"];
            }
            if (self.spf.sp.draw) {
                
                [_oddsDictionary setObject:self.spf.sp.draw forKey:@"1"];
            }
            if (self.spf.sp.loss) {
                
                [_oddsDictionary setObject:self.spf.sp.loss forKey:@"0"];
            }
        }
        if (self.rqspf && self.rqspf.sp) {
            
            if (self.rqspf.sp.win) {
                
                [_oddsDictionary setObject:self.rqspf.sp.win forKey:@"10003"];
            }
            if (self.rqspf.sp.draw) {
                
                [_oddsDictionary setObject:self.rqspf.sp.draw forKey:@"10001"];
            }
            if (self.rqspf.sp.loss) {
                
                [_oddsDictionary setObject:self.rqspf.sp.loss forKey:@"10000"];
            }
        }
        if (self.bqc && self.bqc.sp) {
            
            if (self.bqc.sp.sp_3_3) {
                
                [_oddsDictionary setObject:self.bqc.sp.sp_3_3 forKey:@"1033"];
            }
            if (self.bqc.sp.sp_3_1) {
                
                [_oddsDictionary setObject:self.bqc.sp.sp_3_1 forKey:@"1031"];
            }
            if (self.bqc.sp.sp_3_0) {
                
                [_oddsDictionary setObject:self.bqc.sp.sp_3_0 forKey:@"1030"];
            }
            if (self.bqc.sp.sp_1_3) {
                
                [_oddsDictionary setObject:self.bqc.sp.sp_1_3 forKey:@"1013"];
            }
            if (self.bqc.sp.sp_1_1) {
                
                [_oddsDictionary setObject:self.bqc.sp.sp_1_1 forKey:@"1011"];
            }
            if (self.bqc.sp.sp_1_0) {
                
                [_oddsDictionary setObject:self.bqc.sp.sp_1_0 forKey:@"1010"];
            }
            if (self.bqc.sp.sp_0_3) {
                
                [_oddsDictionary setObject:self.bqc.sp.sp_0_3 forKey:@"1003"];
            }
            if (self.bqc.sp.sp_0_1) {
                
                [_oddsDictionary setObject:self.bqc.sp.sp_0_1 forKey:@"1001"];
            }
            if (self.bqc.sp.sp_0_0) {
                
                [_oddsDictionary setObject:self.bqc.sp.sp_0_0 forKey:@"1000"];
            }
        }
        if (self.jqs && self.jqs.sp) {
            if (self.jqs.sp.sp_0) {
                [_oddsDictionary setObject:self.jqs.sp.sp_0 forKey:@"100"];
            }
            if (self.jqs.sp.sp_1) {
                [_oddsDictionary setObject:self.jqs.sp.sp_1 forKey:@"101"];
            }
            if (self.jqs.sp.sp_2) {
                [_oddsDictionary setObject:self.jqs.sp.sp_2 forKey:@"102"];
            }
            if (self.jqs.sp.sp_3) {
                [_oddsDictionary setObject:self.jqs.sp.sp_3 forKey:@"103"];
            }
            if (self.jqs.sp.sp_4) {
                [_oddsDictionary setObject:self.jqs.sp.sp_4 forKey:@"104"];
            }
            if (self.jqs.sp.sp_5) {
                [_oddsDictionary setObject:self.jqs.sp.sp_5 forKey:@"105"];
            }
            if (self.jqs.sp.sp_6) {
                [_oddsDictionary setObject:self.jqs.sp.sp_6 forKey:@"106"];
            }
            if (self.jqs.sp.sp_7) {
                [_oddsDictionary setObject:self.jqs.sp.sp_7 forKey:@"107"];
            }
        }
        if (self.bifen && self.bifen.sp) {
            if (self.bifen.sp.sp_1_0) {
                [_oddsDictionary setObject:self.bifen.sp.sp_1_0 forKey:@"10"];
            }
            if (self.bifen.sp.sp_2_0) {
                [_oddsDictionary setObject:self.bifen.sp.sp_2_0 forKey:@"20"];
            }
            if (self.bifen.sp.sp_2_1) {
                [_oddsDictionary setObject:self.bifen.sp.sp_2_1 forKey:@"21"];
            }
            if (self.bifen.sp.sp_3_0) {
                [_oddsDictionary setObject:self.bifen.sp.sp_3_0 forKey:@"30"];
            }
            if (self.bifen.sp.sp_3_1) {
                [_oddsDictionary setObject:self.bifen.sp.sp_3_1 forKey:@"31"];
            }
            if (self.bifen.sp.sp_3_2) {
                [_oddsDictionary setObject:self.bifen.sp.sp_3_2 forKey:@"32"];
            }
            if (self.bifen.sp.sp_4_0) {
                [_oddsDictionary setObject:self.bifen.sp.sp_4_0 forKey:@"40"];
            }
            if (self.bifen.sp.sp_4_1) {
                [_oddsDictionary setObject:self.bifen.sp.sp_4_1 forKey:@"41"];
            }
            if (self.bifen.sp.sp_4_2) {
                [_oddsDictionary setObject:self.bifen.sp.sp_4_2 forKey:@"42"];
            }
            if (self.bifen.sp.sp_5_0) {
                [_oddsDictionary setObject:self.bifen.sp.sp_5_0 forKey:@"50"];
            }
            if (self.bifen.sp.sp_5_1) {
                [_oddsDictionary setObject:self.bifen.sp.sp_5_1 forKey:@"51"];
            }
            if (self.bifen.sp.sp_5_2) {
                [_oddsDictionary setObject:self.bifen.sp.sp_5_2 forKey:@"52"];
            }
            if (self.bifen.sp.sp_9_0) {
                [_oddsDictionary setObject:self.bifen.sp.sp_9_0 forKey:@"90"];
            }
            if (self.bifen.sp.sp_0_0) {
                [_oddsDictionary setObject:self.bifen.sp.sp_0_0 forKey:@"00"];
            }
            if (self.bifen.sp.sp_1_1) {
                [_oddsDictionary setObject:self.bifen.sp.sp_1_1 forKey:@"11"];
            }
            if (self.bifen.sp.sp_2_2) {
                [_oddsDictionary setObject:self.bifen.sp.sp_2_2 forKey:@"22"];
            }
            if (self.bifen.sp.sp_3_3) {
                [_oddsDictionary setObject:self.bifen.sp.sp_3_3 forKey:@"33"];
            }
            if (self.bifen.sp.sp_9_9) {
                [_oddsDictionary setObject:self.bifen.sp.sp_9_9 forKey:@"99"];
            }
            if (self.bifen.sp.sp_0_1) {
                [_oddsDictionary setObject:self.bifen.sp.sp_0_1 forKey:@"01"];
            }
            if (self.bifen.sp.sp_0_2) {
                [_oddsDictionary setObject:self.bifen.sp.sp_0_2 forKey:@"02"];
            }
            if (self.bifen.sp.sp_1_2) {
                [_oddsDictionary setObject:self.bifen.sp.sp_1_2 forKey:@"12"];
            }
            if (self.bifen.sp.sp_0_3) {
                [_oddsDictionary setObject:self.bifen.sp.sp_0_3 forKey:@"03"];
            }
            if (self.bifen.sp.sp_1_3) {
                [_oddsDictionary setObject:self.bifen.sp.sp_1_3 forKey:@"13"];
            }
            if (self.bifen.sp.sp_2_3) {
                [_oddsDictionary setObject:self.bifen.sp.sp_2_3 forKey:@"23"];
            }
            if (self.bifen.sp.sp_0_4) {
                [_oddsDictionary setObject:self.bifen.sp.sp_0_4 forKey:@"04"];
            }
            if (self.bifen.sp.sp_1_4) {
                [_oddsDictionary setObject:self.bifen.sp.sp_1_4 forKey:@"14"];
            }
            if (self.bifen.sp.sp_2_4) {
                [_oddsDictionary setObject:self.bifen.sp.sp_2_4 forKey:@"24"];
            }
            if (self.bifen.sp.sp_0_5) {
                [_oddsDictionary setObject:self.bifen.sp.sp_0_5 forKey:@"05"];
            }
            if (self.bifen.sp.sp_1_5) {
                [_oddsDictionary setObject:self.bifen.sp.sp_1_5 forKey:@"15"];
            }
            if (self.bifen.sp.sp_2_5) {
                [_oddsDictionary setObject:self.bifen.sp.sp_2_5 forKey:@"25"];
            }
            if (self.bifen.sp.sp_0_9) {
                [_oddsDictionary setObject:self.bifen.sp.sp_0_9 forKey:@"09"];
            }
        }
    }
    return _oddsDictionary;
}

@end
