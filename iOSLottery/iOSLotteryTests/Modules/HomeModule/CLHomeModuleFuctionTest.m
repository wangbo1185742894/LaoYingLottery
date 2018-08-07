//
//  CLHomeModuleFuctionTest.m
//  iOSLottery
//
//  Created by 小铭 on 2017/8/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//  1.4版 首页功能TestCase

#import <XCTest/XCTest.h>
#import "CLHomeAPI.h"
#import "CLHomeViewHandler.h"
#define WAIT do {\
[self expectationForNotification:@"RSBaseTest" object:nil handler:nil];\
[self waitForExpectationsWithTimeout:20 handler:nil];\
} while (0);

#define NOTIFY \
[[NSNotificationCenter defaultCenter]postNotificationName:@"RSBaseTest" object:nil];

@interface CLHomeModuleFuctionTest : XCTestCase<CLRequestCallBackDelegate>

@property (nonatomic, strong) CLHomeAPI *request;
@property (nonatomic, strong) CLHomeViewHandler *hander;
@end

@implementation CLHomeModuleFuctionTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _request = [[CLHomeAPI alloc] init];
    _request.delegate = self;
    _hander = [[CLHomeViewHandler alloc] init];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
/** 空数据处理Case */
- (void)testEmptyData {
    /** hander 接收数据为空处理 */
    [_hander homeDataDealingWithDict:nil];
    /* 焦点图 */
    XCTAssertTrue(!_hander.banners || _hander.reports.count == 0,@"Banner图数据为空，需加空数据判断处理");
    /* 跑马灯 */
    XCTAssertTrue(!_hander.reports || _hander.reports.count == 0,@"跑马灯数据为空，需要加空数据处理");
    
    /* 列表UI */
    XCTAssertTrue(!_hander.homeData || _hander.homeData.count == 0,@"首页列表数据为空");
    /** 请求暴漏API 空数据Case */
    [_request dealingWithHomeData:nil];
    XCTAssertNil(_request.bannerData,@"焦点图数据为空");
    XCTAssertNil(_request.reports,@"跑马灯数据为空");
}

/** 测试接口 */
- (void)testRequest {
    XCTAssertNotNil(_request,@"接口为空~");
    XCTAssertNotNil(_request.delegate,@"代理回调未设置");
    XCTAssertTrue([_request respondsToSelector:@selector(start)],@"网络请求配置错误");
    [_request start];
    WAIT;
}

/** 测试接口返回 */
- (void)testRequstBack {
    /** 接口返回 校验hander */
    /* 焦点图 */
    XCTAssertNotNil(_hander.banners,@"Banner图数据为空，需加空数据判断处理");
    /* 跑马灯 */
    XCTAssertNotNil(_hander.reports,@"跑马灯数据为空，需要加空数据处理");
    
    /* 列表UI */
    XCTAssertNotNil(_hander.homeData,@"首页列表数据为空");
    /** hander处理数据 是否正确 */
}

/** 网络请求代理 */
- (void)requestFinished:(CLBaseRequest *)request
{
    NOTIFY;
    if (request.urlResponse.success) {
        [_hander homeDataDealingWithDict:request.urlResponse.resp];
        
        [self testPerformanceExample];
    }
}

- (void)requestFailed:(CLBaseRequest *)request{
    NOTIFY;
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [_hander homeDataDealingWithDict:_request.urlResponse.resp];
    }];
}

@end
