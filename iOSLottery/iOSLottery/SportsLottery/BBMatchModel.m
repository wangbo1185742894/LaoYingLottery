//
//  BBMatchModel.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBMatchModel.h"

#import "BBSFModel.h"
#import "BBRFSFModel.h"
#import "BBDXFModel.h"
#import "BBSFCModel.h"

@interface BBMatchModel ()

@property (nonatomic, strong) NSMutableDictionary *oddsDictionary;

@end

@implementation BBMatchModel

- (NSString *)getOddsWithTag:(NSString *)tag{
    
    NSString *value = [[self oddsDictionary] valueForKey:tag];
    if (value && value.length > 0) {
        return [self oddsDictionary][tag];
    }else{
        return @"";
    }
}

//- (void)mj_keyValuesDidFinishConvertingToObject{
//    
//    self.spf.isSale = (self.spf_sale_status == 1);
//    self.rqspf.isSale = (self.rqspf_sale_status == 1);
//    self.bqc.isSale = (self.bqc_sale_status == 1);
//    self.jqs.isSale = (self.jqs_sale_status == 1);
//    self.bifen.isSale = (self.bifen_sale_status == 1);
//}



- (NSMutableDictionary *)oddsDictionary{
    
    if (!_oddsDictionary) {
        
        _oddsDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
        
        if (self.sf && self.sf.sp) {
            
            if (self.sf.sp.win) {
                
                [_oddsDictionary setObject:self.sf.sp.win forKey:@"3"];
            }
            if (self.sf.sp.loss) {
                
                [_oddsDictionary setObject:self.sf.sp.loss forKey:@"0"];
            }

        }
        if (self.rfsf && self.rfsf.sp) {
            
            if (self.rfsf.sp.win) {
                
                [_oddsDictionary setObject:self.rfsf.sp.win forKey:@"1003"];
            }

            if (self.rfsf.sp.loss) {
                
                [_oddsDictionary setObject:self.rfsf.sp.loss forKey:@"1000"];
            }
        }
        if (self.dxf && self.dxf.sp) {
            
            if (self.dxf.sp.big) {
                
                [_oddsDictionary setObject:self.dxf.sp.big forKey:@"102"];
            }
            if (self.dxf.sp.small) {
                
                [_oddsDictionary setObject:self.dxf.sp.small forKey:@"101"];
            }
        }
        
        
        if (self.sfc && self.sfc.sp) {
            if (self.sfc.sp.host_1_5) {
                [_oddsDictionary setObject:self.sfc.sp.host_1_5 forKey:@"31"];
            }
            if (self.sfc.sp.host_6_10) {
                [_oddsDictionary setObject:self.sfc.sp.host_6_10 forKey:@"32"];
            }
            if (self.sfc.sp.host_11_15) {
                [_oddsDictionary setObject:self.sfc.sp.host_11_15 forKey:@"33"];
            }
            if (self.sfc.sp.host_16_20) {
                [_oddsDictionary setObject:self.sfc.sp.host_16_20 forKey:@"34"];
            }
            if (self.sfc.sp.host_21_25) {
                [_oddsDictionary setObject:self.sfc.sp.host_21_25 forKey:@"35"];
            }
            if (self.sfc.sp.host_26) {
                [_oddsDictionary setObject:self.sfc.sp.host_26 forKey:@"36"];
            }
            if (self.sfc.sp.away_1_5) {
                [_oddsDictionary setObject:self.sfc.sp.away_1_5 forKey:@"01"];
            }
            if (self.sfc.sp.away_6_10) {
                [_oddsDictionary setObject:self.sfc.sp.away_6_10 forKey:@"02"];
            }
            if (self.sfc.sp.away_11_15) {
                [_oddsDictionary setObject:self.sfc.sp.away_11_15 forKey:@"03"];
            }
            if (self.sfc.sp.away_16_20) {
                [_oddsDictionary setObject:self.sfc.sp.away_16_20 forKey:@"04"];
            }
            if (self.sfc.sp.away_21_25) {
                [_oddsDictionary setObject:self.sfc.sp.away_21_25 forKey:@"05"];
            }
            
            if (self.sfc.sp.away_26) {
                [_oddsDictionary setObject:self.sfc.sp.away_26 forKey:@"06"];
            }
        }
    
    }
    return _oddsDictionary;
}


@end
