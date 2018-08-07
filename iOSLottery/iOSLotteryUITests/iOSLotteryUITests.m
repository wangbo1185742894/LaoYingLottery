//
//  iOSLotteryUITests.m
//  iOSLotteryUITests
//
//  Created by 彩球 on 16/10/31.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+Coding.h"
@interface iOSLotteryUITests : XCTestCase

@end

@implementation iOSLotteryUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tablesQuery = app.tables;
    [tablesQuery.staticTexts[@"竞彩篮球"] tap];
    
    XCUIElementQuery *cellsQuery = [app.tables.cells containingType:XCUIElementTypeStaticText identifier:@"\u5468\u4e09301"];
    [[[cellsQuery childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0] tap];
    [[[cellsQuery childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:4] tap];
    [[[cellsQuery childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:5] tap];
    [[[cellsQuery childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:1] tap];
    [[[cellsQuery childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:2] tap];
    [[[cellsQuery childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:6] tap];
    [cellsQuery.buttons[@"\u5c55\u5f00\u80dc\u5206\u5dee\u73a9\u6cd5"] tap];
    
    XCUIElement *element2 = [[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1];
    XCUIElement *element = [[element2 childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1];
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0] tap];
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:1] tap];
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:2] tap];
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:5] tap];
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:4] tap];
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:3] tap];
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:6] tap];
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:7] tap];
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:8] tap];
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:11] tap];
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:10] tap];
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:9] tap];
    [element2.buttons[@"\u786e\u5b9a"] tap];
    
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
