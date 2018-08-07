//
//  CLATManagerText.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/28.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CLATManager.h"

@interface CLATManagerText : XCTestCase

@property (nonatomic, strong) CLATManager *manager;

@end

@implementation CLATManagerText

- (void)setUp {
    [super setUp];
    
    _manager = [CLATManager shareManager];
}

- (void)testSaveOptionsWithGroup
{

    [self.manager setCurrentPlayMethod:(CLATPlayMothedTypeOne)];
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    
    [self.manager saveOneOptions:@"6" withGroupTag:@"2"];
    
    BOOL result = [self.manager hasSelectedOptionsOfCurrentPlayMethod];
    
    XCTAssertTrue(result,@"当前玩法有选项，测试不通过");
    
    [self.manager removeOneOptions:@"0" withGroupTag:@"0"];
    
    [self.manager removeOneOptions:@"0" withGroupTag:@"0"];
    
    [self.manager removeOneOptions:@"6" withGroupTag:@"2"];
    
    BOOL result2 = [self.manager hasSelectedOptionsOfCurrentPlayMethod];
    
    XCTAssertFalse(result2,@"当前玩法没有选项，测试不通过");
    
    [self.manager clearCurrentPlayMethodSelectedOptions];
    

    //切换组三单式
    [self.manager setCurrentPlayMethod:(CLATPlayMothedTypeTwo)];
    
    BOOL result3 = [self.manager hasSelectedOptionsOfCurrentPlayMethod];
    
    XCTAssertFalse(result3,@"当前玩法没有选项，测试不通过");

    [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"1"];
    
    BOOL result4 = [self.manager hasSelectedOptionsOfCurrentPlayMethod];
    
    XCTAssertTrue(result4,@"当前玩法有选项，测试不通过");
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    
    [self.manager removeOneOptions:@"0" withGroupTag:@"0"];
    
    result = [self.manager hasSelectedOptionsOfCurrentPlayMethod];
    
    XCTAssertFalse(result,@"当前玩法没有选项，测试不通过");
    
    [self.manager clearCurrentPlayMethodSelectedOptions];
    
    //切换组三复式
    [self.manager setCurrentPlayMethod:CLATPlayMothedTypeThree];
    
    result = [self.manager hasSelectedOptionsOfCurrentPlayMethod];
    
    XCTAssertFalse(result,@"当前玩法没有选项，测试不通过");
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    
    result = [self.manager hasSelectedOptionsOfCurrentPlayMethod];
    
    XCTAssertTrue(result,@"当前玩法有选项，测试不通过");
    
    [self.manager clearCurrentPlayMethodSelectedOptions];
    
    
    //切换组六
    [self.manager setCurrentPlayMethod:CLATPlayMothedTypeFour];
    
    [self.manager removeOneOptions:@"0" withGroupTag:@"0"];
    
    result = [self.manager hasSelectedOptionsOfCurrentPlayMethod];
    
    XCTAssertFalse(result3,@"当前玩法没有选项，测试不通过");
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    
    result = [self.manager hasSelectedOptionsOfCurrentPlayMethod];
    
    XCTAssertTrue(result,@"当前玩法有选项，测试不通过");
    
    [self.manager clearCurrentPlayMethodSelectedOptions];
    
    
    //切换未知模式
    [self.manager setCurrentPlayMethod:5];
    
     [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    
    [self.manager removeOneOptions:@"0" withGroupTag:@"0"];
    
    result = [self.manager hasSelectedOptionsOfCurrentPlayMethod];
    
    XCTAssertFalse(result,@"当前玩法没有选项，测试不通过");
    
    [self.manager clearOptions];
}

#pragma mark ------ 测试清除功能 ------
- (void)testClearCurrentPlayMethod
{

    //测试直选
    [self.manager setCurrentPlayMethod:CLATPlayMothedTypeOne];
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"0" withGroupTag:@"1"];
    [self.manager saveOneOptions:@"0" withGroupTag:@"2"];
    
    [self.manager clearCurrentPlayMethodSelectedOptions];
    
    BOOL result = [self.manager hasSelectedOptionsOfCurrentPlayMethod];
    
    XCTAssertFalse(result,@"当前玩法没有选项，测试不通过");
    
    //测试组三单式
    [self.manager setCurrentPlayMethod:CLATPlayMothedTypeTwo];
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"0" withGroupTag:@"1"];

    [self.manager clearCurrentPlayMethodSelectedOptions];
    
    result = [self.manager hasSelectedOptionsOfCurrentPlayMethod];
    
    XCTAssertFalse(result,@"当前玩法没有选项，测试不通过");
    
    
    //组三复式
    [self.manager setCurrentPlayMethod:CLATPlayMothedTypeThree];
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"8" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"9" withGroupTag:@"0"];
    
    
    [self.manager clearCurrentPlayMethodSelectedOptions];
    
    result = [self.manager hasSelectedOptionsOfCurrentPlayMethod];
    
    XCTAssertFalse(result,@"当前玩法没有选项，测试不通过");
    
    
    //测试组六
    [self.manager setCurrentPlayMethod:CLATPlayMothedTypeFour];
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"8" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"2" withGroupTag:@"0"];
    
    [self.manager clearCurrentPlayMethodSelectedOptions];
    
    result = [self.manager hasSelectedOptionsOfCurrentPlayMethod];
    
    XCTAssertFalse(result,@"当前玩法没有选项，测试不通过");
    
    //切换未知模式
    [self.manager setCurrentPlayMethod:5];
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    
    [self.manager removeOneOptions:@"0" withGroupTag:@"0"];
    
    [self.manager clearCurrentPlayMethodSelectedOptions];
    
    result = [self.manager hasSelectedOptionsOfCurrentPlayMethod];
    
    XCTAssertFalse(result,@"当前玩法没有选项，测试不通过");
    
    [self.manager clearOptions];
}


#pragma mark ------ 测试获取注数 ------
- (void)testGetNoteNumber
{

    //测试直选注数
    [self.manager setCurrentPlayMethod:CLATPlayMothedTypeOne];
    
    [self.manager saveOneOptions:@"4" withGroupTag:@"0"];
    
    [self.manager saveOneOptions:@"6" withGroupTag:@"1"];
    
    [self.manager saveOneOptions:@"2" withGroupTag:@"2"];
    
    NSInteger number = [self.manager getNoteNumber];
    
    XCTAssertEqual(number, 1,@"测试不通过");
    
    [self.manager saveOneOptions:@"5" withGroupTag:@"2"];
    
    [self.manager saveOneOptions:@"4" withGroupTag:@"1"];
    
    number = [self.manager getNoteNumber];
    
    XCTAssertEqual(number, 4,@"测试不通过");
    
    [self.manager clearCurrentPlayMethodSelectedOptions];
    
    
    //测试组三单线
    
    [self.manager setCurrentPlayMethod:CLATPlayMothedTypeTwo];
    
    [self.manager saveOneOptions:@"3" withGroupTag:@"0"];
    
    [self.manager saveOneOptions:@"3" withGroupTag:@"1"];
    
    number = [self.manager getNoteNumber];
    
    XCTAssertEqual(number, 0,@"测试不通过");
    
    [self.manager saveOneOptions:@"4" withGroupTag:@"0"];
    
    number = [self.manager getNoteNumber];
    
    XCTAssertEqual(number, 1,@"测试不通过");
    
    [self.manager saveOneOptions:@"8" withGroupTag:@"0"];
    
    [self.manager saveOneOptions:@"1" withGroupTag:@"0"];
    
    [self.manager saveOneOptions:@"7" withGroupTag:@"1"];
    
    [self.manager saveOneOptions:@"6" withGroupTag:@"1"];
    
    number = [self.manager getNoteNumber];
    
    XCTAssertEqual(number, 1,@"测试不通过");
    
    [self.manager clearCurrentPlayMethodSelectedOptions];
    
    
    //测试组三复式
    [self.manager setCurrentPlayMethod:CLATPlayMothedTypeThree];
    
    [self.manager saveOneOptions:@"3" withGroupTag:@"0"];
    
    number = [self.manager getNoteNumber];
    
    XCTAssertEqual(number, 0,@"测试不通过");
    
    [self.manager saveOneOptions:@"4" withGroupTag:@"0"];
    
     number = [self.manager getNoteNumber];
    
    XCTAssertEqual(number, 2,@"测试不通过");
    
    [self.manager saveOneOptions:@"8" withGroupTag:@"0"];
    
    [self.manager saveOneOptions:@"9" withGroupTag:@"0"];
    
    number = [self.manager getNoteNumber];
    
    XCTAssertEqual(number, 12,@"测试不通过");
    
    [self.manager clearCurrentPlayMethodSelectedOptions];
    
    //测试组六
    [self.manager setCurrentPlayMethod:(CLATPlayMothedTypeFour)];
    
    [self.manager saveOneOptions:@"4" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"5" withGroupTag:@"0"];
    
    
    number = [self.manager getNoteNumber];
    
    XCTAssertEqual(number, 0,@"测试不通过");
    
    [self.manager saveOneOptions:@"7" withGroupTag:@"0"];
    
    
    number = [self.manager getNoteNumber];
    
    XCTAssertEqual(number, 1,@"测试不通过");
    
    [self.manager saveOneOptions:@"8" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"9" withGroupTag:@"0"];
    
    
    number = [self.manager getNoteNumber];
    
    XCTAssertEqual(number, 10,@"测试不通过");
    
    [self.manager clearCurrentPlayMethodSelectedOptions];
    
    
    //切换未知模式
    [self.manager setCurrentPlayMethod:5];
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"1"];
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"2"];
    
    number = [self.manager getNoteNumber];
    
    XCTAssertEqual(number, 0,@"测试不通过");
    
    [self.manager clearOptions];
    
}

#pragma mark ----- 测试随机号 -----
- (void)testGetRandomNumber
{

    //测试直选
    [self.manager setCurrentPlayMethod:CLATPlayMothedTypeOne];
    
    NSArray *array = [self.manager getRandomNumber];
    
    XCTAssertTrue(array.count == 3,@"测试不通过");
    
    NSString *text = [self.manager getToastText];
    
    XCTAssertTrue([text isEqualToString:@""],@"测试不通过");
    
    [self.manager clearCurrentPlayMethodSelectedOptions];

    //测试组三单式
    [self.manager setCurrentPlayMethod:CLATPlayMothedTypeTwo];
    
    array = [self.manager getRandomNumber];
    
    XCTAssertTrue(array.count == 2,@"测试不通过");
    
    text = [self.manager getToastText];
    
    XCTAssertTrue([text isEqualToString:@""],@"测试不通过");
    
    [self.manager clearCurrentPlayMethodSelectedOptions];
    
    //组三复式
    [self.manager setCurrentPlayMethod:CLATPlayMothedTypeThree];
    
    array = [self.manager getRandomNumber];
    
    XCTAssertTrue(array.count == 2,@"测试不通过");
    
    text = [self.manager getToastText];
    
    XCTAssertTrue([text isEqualToString:@""],@"测试不通过");
    
    [self.manager clearCurrentPlayMethodSelectedOptions];
    
    
    //测试组六
    [self.manager setCurrentPlayMethod:CLATPlayMothedTypeFour];
    
    array = [self.manager getRandomNumber];
    
    XCTAssertTrue(array.count == 3,@"测试不通过");
    
    text = [self.manager getToastText];
    
    XCTAssertTrue([text isEqualToString:@""],@"测试不通过");
    
    [self.manager clearCurrentPlayMethodSelectedOptions];
    
    
    //未知玩法
    [self.manager setCurrentPlayMethod:6];
    
    array = [self.manager getRandomNumber];
    
    XCTAssertTrue(array.count == 0,@"测试不通过");
    
    text = [self.manager getToastText];
    
    XCTAssertTrue([text isEqualToString:@"当前玩法不存在"],@"测试不通过");
    
    [self.manager clearOptions];
}

#pragma mark ------ 测试提示文字 -------
- (void)testGetToastText
{
    //测试直选
    [self.manager setCurrentPlayMethod:CLATPlayMothedTypeOne];
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"0" withGroupTag:@"1"];
    
    
    NSString *text = [self.manager getToastText];
    
    XCTAssertTrue([text isEqualToString:@"每位至少选择1个号码"],@"测试不通过");
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"2"];
    
    text = [self.manager getToastText];
    
    XCTAssertTrue([text isEqualToString:@""],@"测试不通过");
    
    [self.manager clearCurrentPlayMethodSelectedOptions];
    
    
    //测试组三单式
    [self.manager setCurrentPlayMethod:CLATPlayMothedTypeTwo];
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    
    text = [self.manager getToastText];
    
    XCTAssertTrue([text isEqualToString:@"至少选择1个重号和1个单号"],@"测试不通过");
    
    [self.manager saveOneOptions:@"2" withGroupTag:@"1"];

    text = [self.manager getToastText];
    
   XCTAssertTrue([text isEqualToString:@""],@"测试不通过");
    
    [self.manager clearCurrentPlayMethodSelectedOptions];
    
    
    
    //组三复式
    [self.manager setCurrentPlayMethod:CLATPlayMothedTypeThree];
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    
    text = [self.manager getToastText];
    
    XCTAssertTrue([text isEqualToString:@"至少选择2个号码"],@"测试不通过");

    [self.manager saveOneOptions:@"2" withGroupTag:@"0"];
    
    text = [self.manager getToastText];
    
    XCTAssertTrue([text isEqualToString:@""],@"测试不通过");
    
    [self.manager clearCurrentPlayMethodSelectedOptions];
    
    
    //测试组六
    [self.manager setCurrentPlayMethod:CLATPlayMothedTypeFour];
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    
    text = [self.manager getToastText];
    
    XCTAssertTrue([text isEqualToString:@"至少选择3个号码"],@"测试不通过");

    
    [self.manager saveOneOptions:@"2" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"5" withGroupTag:@"0"];
    
    text = [self.manager getToastText];
    
    XCTAssertTrue([text isEqualToString:@""],@"测试不通过");
    
    [self.manager clearOptions];
}

#pragma mark ----- 测试生成投注项 ------
- (void)testSaveOneGroupBetOptions
{
    [self.manager setLotteryGame:@"pl3"];
    
    //直选
    [self.manager setCurrentPlayMethod:(CLATPlayMothedTypeOne)];
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"4" withGroupTag:@"1"];
    [self.manager saveOneOptions:@"5" withGroupTag:@"2"];

    [self.manager saveOneGroupBetOptionsOfReplaceIndex:-1];
    
    [self.manager clearOptions];
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"4" withGroupTag:@"1"];
    [self.manager saveOneOptions:@"5" withGroupTag:@"2"];
    [self.manager saveOneOptions:@"6" withGroupTag:@"2"];
    
    [self.manager saveOneGroupBetOptionsOfReplaceIndex:-1];
    
    [self.manager clearCurrentPlayMethodSelectedOptions];
    
    
    //组三单式
    [self.manager setCurrentPlayMethod:(CLATPlayMothedTypeTwo)];
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"4" withGroupTag:@"1"];
    
    [self.manager clearCurrentPlayMethodSelectedOptions];
    
    [self.manager clearOptions];
    
    
    //组三复式
    [self.manager setCurrentPlayMethod:(CLATPlayMothedTypeThree)];
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"4" withGroupTag:@"0"];
    
    [self.manager clearCurrentPlayMethodSelectedOptions];
    
    [self.manager clearOptions];
    
    //组六
    [self.manager setCurrentPlayMethod:(CLATPlayMothedTypeFour)];
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"4" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"5" withGroupTag:@"0"];
    
    [self.manager clearCurrentPlayMethodSelectedOptions];
    
    [self.manager clearOptions];
    
}

#pragma mark ----- 测试遗漏数据 -----
- (void)testGetOmissionData
{

    NSDictionary *dic = @{@"ZHIXUAN_S":@[],
                          @"ZUXUAN3_S":@[@"2",@"1",@"3",@"2",@"1",@"3",@"2",@"1",@"3",@"4",
                                         @"2",@"1",@"3",@"2",@"1",@"3",@"2",@"1",@"3",@"4"],
                          @"ZUXUAN3_M":@[@"2",@"1",@"3",@"2",@"1",@"3",@"2",@"1"],
                          @"ZUXUAN6_S":@[]};
    
    [[CLATManager shareManager] setOmissionMessageWithData:dic];
    
    [[CLATManager shareManager] setCurrentPlayMethod:(CLATPlayMothedTypeOne)];
    
    NSArray *array = [[CLATManager shareManager] getOmissionMessageOfCurrentPlayMethod];
    
    XCTAssertEqual(array.count, 3,@"测试不通过");
    
    [[CLATManager shareManager] setCurrentPlayMethod:CLATPlayMothedTypeTwo];
    
    array = [[CLATManager shareManager] getOmissionMessageOfCurrentPlayMethod];
    
    XCTAssertEqual(array.count, 2,@"测试不通过");
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
