//
//  CLSFCManagerTest.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/31.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CLSFCManager.h"

@interface CLSFCManagerTest : XCTestCase

@property (nonatomic, strong) CLSFCManager *manager;

@end

@implementation CLSFCManagerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.manager = [CLSFCManager shareManager];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSaveOptions
{

    [self.manager setCurrentPlayMethodWithLotteryName:@"sfc"];
    
    [self.manager saveOneOption:@"3" matchId:@"100"];
    [self.manager saveOneOption:@"1" matchId:@"101"];
    [self.manager saveOneOption:@"1" matchId:@"102"];

    
    NSInteger count = [self.manager getSelectOptionsCount];
    
    XCTAssertEqual(count, 3,@"测试不通过");
    
    [self.manager saveOneOption:@"3" matchId:@"100"];
    
    [self.manager removeOneOptions:@"3" matchId:@"100"];
    [self.manager removeOneOptions:@"1" matchId:@"101"];
    [self.manager removeOneOptions:@"1" matchId:@"102"];
    
    count = [self.manager getSelectOptionsCount];
    
    XCTAssertEqual(count, 0,@"测试不通过");
    
    [self.manager saveOneOption:@"0" matchId:nil];
    [self.manager saveOneOption:@"1" matchId:@""];
    
    XCTAssertEqual(count, 0,@"测试不通过");
    
    [self.manager saveOneOption:@"1" matchId:@"102"];
    
    [self.manager removeOneOptions:@"" matchId:nil];
    [self.manager removeOneOptions:@"1" matchId:@""];
    
    count = [self.manager getSelectOptionsCount];
    
    XCTAssertEqual(count, 1,@"测试不通过");
    
    [self.manager clearOptions];
}

- (void)testGetNoteNumber
{

    [self.manager setCurrentPlayMethodWithLotteryName:@"sfc"];
    
    [self.manager saveOneOption:@"0" matchId:@"100"];
    [self.manager saveOneOption:@"0" matchId:@"101"];
    [self.manager saveOneOption:@"0" matchId:@"102"];
    [self.manager saveOneOption:@"0" matchId:@"103"];
    [self.manager saveOneOption:@"0" matchId:@"104"];
    [self.manager saveOneOption:@"0" matchId:@"105"];
    [self.manager saveOneOption:@"0" matchId:@"106"];
    [self.manager saveOneOption:@"0" matchId:@"107"];
    [self.manager saveOneOption:@"0" matchId:@"108"];
    [self.manager saveOneOption:@"0" matchId:@"109"];
    [self.manager saveOneOption:@"0" matchId:@"110"];
    [self.manager saveOneOption:@"0" matchId:@"111"];
    [self.manager saveOneOption:@"0" matchId:@"112"];
    [self.manager saveOneOption:@"0" matchId:@"113"];
    
    NSInteger noteNumber = [self.manager getNoteNumber];
    
    XCTAssertEqual(noteNumber, 1,@"测试不通过");
    
    [self.manager saveOneOption:@"1" matchId:@"110"];
    [self.manager saveOneOption:@"1" matchId:@"111"];
    [self.manager saveOneOption:@"1" matchId:@"112"];
    [self.manager saveOneOption:@"1" matchId:@"113"];
    
    noteNumber = [self.manager getNoteNumber];
    
    XCTAssertEqual(noteNumber, 16,@"测试不通过");
    
    [self.manager clearOptions];
}

- (void)testGetRx9NoteNumber
{

    [self.manager setCurrentPlayMethodWithLotteryName:@"rx9"];
    
    
    [self.manager saveOneOption:@"0" matchId:@"100"];
    [self.manager saveOneOption:@"0" matchId:@"101"];
    [self.manager saveOneOption:@"0" matchId:@"102"];
    [self.manager saveOneOption:@"0" matchId:@"103"];
    [self.manager saveOneOption:@"0" matchId:@"104"];
    [self.manager saveOneOption:@"0" matchId:@"105"];
    [self.manager saveOneOption:@"0" matchId:@"106"];
    [self.manager saveOneOption:@"0" matchId:@"107"];
    [self.manager saveOneOption:@"0" matchId:@"108"];


    NSInteger note = [self.manager getNoteNumber];
    
    XCTAssertEqual(note, 1,@"测试不通过");
    
    [self.manager saveOneOption:@"1" matchId:@"107"];
    [self.manager saveOneOption:@"1" matchId:@"108"];
    [self.manager saveOneOption:@"3" matchId:@"107"];
    [self.manager saveOneOption:@"3" matchId:@"108"];
    
    note = [self.manager getNoteNumber];
    
    XCTAssertEqual(note, 9,@"测试不通过");

    [self.manager saveOneOption:@"0" matchId:@"109"];
    [self.manager saveOneOption:@"0" matchId:@"110"];
    [self.manager saveOneOption:@"0" matchId:@"111"];
    
    note = [self.manager getNoteNumber];
    
    XCTAssertEqual(note, 1360,@"测试不通过");
    
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
