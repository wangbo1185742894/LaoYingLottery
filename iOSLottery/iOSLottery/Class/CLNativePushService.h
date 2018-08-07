//
//  CLNativePushService.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/20.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 //首页
 eaglegames://eagleNative?page=home
 //追号详情
 eaglegames://eagleNative?page=followDetail&followId=XXXX
 
 //订单详情
 eaglegames://eagleNative?page=orderDetail&orderId=XXXX
 
 //追号列表
 eaglegames://eagleNative?page=followList
 
 //数字彩订单列表
 eaglegames://eagleNative?page=numOrderList
 
 //跳转某个彩种选号页面
 eaglegames://eagleNative?page=game&gameEn=xxxx
 
 //我-个人中心页
 eaglegames://eagleNative?page=myhome
 
 //我的红包页
 eaglegames://eagleNative?page=myhb
 
 //购买红包页
 eaglegames://eagleNative?page=buyhb
 
 //充值页面
 eaglegames://eagleNative?page=chongzhi
 
 //活动列表
 eaglecp://eagleNative?page=userCenterActivity
 
 //登录页面
 eaglegames://eagleNative?page=login
 跳转投注详情
 eaglecp://eagleNative?page=betDetail&gameEn=ssq&betNumber=01 02 03 04 05 06:01,06 05 04 03 02 01:07&period=10&multiple=2&additional=1
 说明：
 betNumber：投注号码，前区后去用“:”分隔, 号码之前“空格”分隔
 period：追期期数
 multiple：倍数
 additional：大乐透是否追加 0 表示不追加 1 表示追加
 
 
 跳转对应彩种的对应玩法
 eaglecp://eagleNative?page=game&gameEn=ssq&playType=0
 说明：
 playType:彩种玩法
 双色球 ： 0：普通玩法
 1：胆拖玩法
 大乐透 ： 0：普通玩法
 1：胆拖玩法
 快三：	0：和值
 1：三同号
 2：二同号
 3：三不同号
 4：二不同号
 5：三不同号胆拖
 6：二不同号胆拖
 D11:	0：任选二
 1：任选三
 2：任选四
 3：任选五
 4：任选六
 5：任选七
 6：任选八
 7：前一
 8：前二直选
 9：前二组选
 10：前三直选
 11：前三组选
 12：任选二胆拖
 13：任选三胆拖
 14：任选四胆拖
 15：任选五胆拖
 16：任选六胆拖
 17：任选七胆拖
 18：任选八胆拖
 19：前二组选
 20：前三组选
 H5活动页
 url       标识当前活动链接地址
 need_login 是否需要登录 0不需要登录 1需要登录
 share_url 分享的链接地址
 share_title 分享的标题
 share_describe 分享的描述
 is_login  是否支持分享  0支持 1不支持
 （share_title,share_describe 文字内容需做urlEncode处理）
 eaglegames://eagleNative?page=wap&url=http://xxx.html&need_login=0&share_url=http://xxx.html&share_title=%E6%B5%8B%E8%AF%95&share_describe=%E6%B5%8B%E8%AF%95
 */

@interface CLNativePushService : NSObject

+ (void)pushNativeUrl:(NSString *)url;

@end
