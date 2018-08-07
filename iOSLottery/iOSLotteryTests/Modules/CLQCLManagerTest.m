//
//  CLQCLManagerTest.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/23.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CLQLCManager.h"

@interface CLQCLManagerTest : XCTestCase

@property (nonatomic, strong) CLQLCManager *manager;

@end

@implementation CLQCLManagerTest

- (void)setUp {
    [super setUp];
    
    self.manager = [CLQLCManager shareManager];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    self.manager = nil;
    
    [super tearDown];
}

#pragma mark ----- 测试保存一个选项 -----
- (void)testSaveOneOptions
{

    [self.manager setCurrentPlayMethod:CLQLCPlayMothedTypeNormal];
    
    [self.manager saveOneOptions:@"2" withGroupTag:@"0"];
    
    BOOL result = [self.manager hasSelectedOptionsOfCurrentPlayMethod];
    
    XCTAssertTrue(result,@"测试不通过");
    
    [self.manager removeOneOptions:@"2" withGroupTag:@"0"];
    
    result = [self.manager hasSelectedOptionsOfCurrentPlayMethod];
    
    XCTAssertFalse(result,@"测试不通过");
    
    [self.manager setCurrentPlayMethod:CLQLCPlayMothedTypeDanTuo];
    
    result = [self.manager hasSelectedOptionsOfCurrentPlayMethod];
    
    XCTAssertFalse(result,@"测试不通过");
    
    [self.manager removeOneOptions:@"2" withGroupTag:@"0"];
    
    [self.manager removeOneOptions:@"2" withGroupTag:@"0"];
    
    [self.manager removeOneOptions:@"2" withGroupTag:@"0"];
    
    [self.manager clearOptions];
}

#pragma mark ----- 测试计算注数 ------
- (void)testGetNoteNumber
{

    //普通玩法
    [self.manager setCurrentPlayMethod:CLQLCPlayMothedTypeNormal];
    
    [self.manager saveOneOptions:@"1" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"2" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"3" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"4" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"5" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"6" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"7" withGroupTag:@"0"];
    
    NSInteger note = [self.manager getNoteNumber];
    
    XCTAssertEqual(note, 1,@"测试不通过");
    
    [self.manager saveOneOptions:@"8" withGroupTag:@"0"];
    
    note  = [self.manager getNoteNumber];
    
    XCTAssertEqual(note, 8,@"测试不通过");
    
    [self.manager saveOneOptions:@"9" withGroupTag:@"0"];
    
    note  = [self.manager getNoteNumber];
    
    XCTAssertEqual(note, 36,@"测试不通过");
    
    
    //胆拖玩法
    [self.manager setCurrentPlayMethod:CLQLCPlayMothedTypeDanTuo];
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"1" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"2" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"3" withGroupTag:@"0"];
    
    [self.manager saveOneOptions:@"4" withGroupTag:@"1"];
    [self.manager saveOneOptions:@"5" withGroupTag:@"1"];
    
    note = [self.manager getNoteNumber];
    
    XCTAssertEqual(note, 1,@"测试不通过");
    
    [self.manager clearOptions];
}


- (void)testGetToastText
{
    [self.manager setCurrentPlayMethod:CLQLCPlayMothedTypeNormal];

    [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"1" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"2" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"3" withGroupTag:@"0"];
    
    NSString *text = [self.manager getToastText];
    
    XCTAssertTrue([text isEqualToString:@"至少选择7个号码"],@"测试不通过");
    
    [self.manager saveOneOptions:@"4" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"5" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"6" withGroupTag:@"0"];
    
    text = [self.manager getToastText];
    
    XCTAssertTrue([text isEqualToString:@""],@"测试不通过");
    
    [self.manager setCurrentPlayMethod:CLQLCPlayMothedTypeDanTuo];
    
    [self.manager saveOneOptions:@"4" withGroupTag:@"0"];
    
    text = [self.manager getToastText];
    
    XCTAssertTrue([text isEqualToString:@"至少选择一注"],@"测试不通过");
    
    [self.manager clearOptions];
    
}


#pragma mark ----- 测试清空当前玩法选中项 -----
- (void)testClearCurrentPlayMethodSelectedOptions
{

    [self.manager setCurrentPlayMethod:CLQLCPlayMothedTypeNormal];
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"1" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"2" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"3" withGroupTag:@"0"];
    
    BOOL result = [self.manager hasSelectedOptionsOfCurrentPlayMethod];
    
    XCTAssertTrue(result,@"测试不通过");
    
    [self.manager clearCurrentPlayMethodSelectedOptions];
    
    result = [self.manager hasSelectedOptionsOfCurrentPlayMethod];
    
    XCTAssertFalse(result,@"测试不通过");
    
    [self.manager setCurrentPlayMethod:CLQLCPlayMothedTypeDanTuo];
    
    [self.manager saveOneOptions:@"0" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"1" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"2" withGroupTag:@"0"];
    [self.manager saveOneOptions:@"3" withGroupTag:@"0"];
    
    [self.manager saveOneOptions:@"5" withGroupTag:@"1"];
    [self.manager saveOneOptions:@"6" withGroupTag:@"1"];
    [self.manager saveOneOptions:@"7" withGroupTag:@"1"];
    [self.manager saveOneOptions:@"8" withGroupTag:@"1"];
    
    result = [self.manager hasSelectedOptionsOfCurrentPlayMethod];
    
    XCTAssertTrue(result,@"测试不通过");
    
    [self.manager clearCurrentPlayMethodSelectedOptions];
    
    result = [self.manager hasSelectedOptionsOfCurrentPlayMethod];
    
    XCTAssertFalse(result,@"测试不通过");
    
    [self.manager clearOptions];
    
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
