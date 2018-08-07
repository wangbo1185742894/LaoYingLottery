//
//  BBBetListUTests.m
//  iOSLottery
//
//  Created by 小铭 on 2017/8/22.
//  Copyright © 2017年 caiqr. All rights reserved.
//  篮球投注列表UTests

#import <XCTest/XCTest.h>

@interface BBBetListUTests : XCTestCase

@end

@implementation BBBetListUTests

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

- (void)testBetList {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tablesQuery = app.tables;
    [tablesQuery.staticTexts[@"竞彩篮球"] tap];
    
    XCUIElementQuery *cellsQuery = [tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"\u5468\u4e09301"];
    [[[cellsQuery childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:4] tap];
    [[[cellsQuery childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0] tap];
    [[[cellsQuery childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:1] tap];
    [[[cellsQuery childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:5] tap];
    [app.buttons[@"\u786e\u5b9a"] tap];
    
    XCUIElementQuery *cellsQuery2 = [tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"\u5468\u4e09302"];
    [[[cellsQuery2 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0] tap];
    [[[cellsQuery2 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:5] tap];
    [[[cellsQuery2 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:2] tap];
    [[[cellsQuery2 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:6] tap];
    
    XCUIElementQuery *cellsQuery3 = [app.tables.cells containingType:XCUIElementTypeStaticText identifier:@"\u5468\u4e09303"];
    [[[cellsQuery3 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:4] tap];
    [[[cellsQuery3 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:1] tap];
    [[[cellsQuery3 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:2] tap];
    [cellsQuery3.buttons[@"\u5c55\u5f00\u80dc\u5206\u5dee\u73a9\u6cd5"] tap];
    [app.buttons[@"\u53d6\u6d88"] tap];
    
}

- (void)testSFCBetView {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tablesQuery = app.tables;
    
    [tablesQuery.staticTexts[@"竞彩篮球"] tap];
    [[app.tables.cells containingType:XCUIElementTypeStaticText identifier:@"\u5468\u4e09301"].buttons[@"\u5c55\u5f00\u80dc\u5206\u5dee\u73a9\u6cd5"] tap];
    
    XCUIElement *element = [[[[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1] childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1];
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
    [app.buttons[@"\u53d6\u6d88"] tap];
}

- (void)testSFCBetConfirm {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tablesQuery = app.tables;
    
    [tablesQuery.staticTexts[@"竞彩篮球"] tap];
    XCUIElementQuery *tablesQuery1 = [[XCUIApplication alloc] init].tables;
    [[[[tablesQuery1.cells containingType:XCUIElementTypeStaticText identifier:@"\u5468\u4e09302"] childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:2] swipeUp];
    [[[[tablesQuery1.cells containingType:XCUIElementTypeStaticText identifier:@"\u5468\u4e09303"] childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0] swipeUp];
    
    XCUIElementQuery *cellsQuery = [app.tables.cells containingType:XCUIElementTypeStaticText identifier:@"\u5468\u4e09303"];
    [[[cellsQuery childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:4] tap];
    [cellsQuery.buttons[@"\u5c55\u5f00\u80dc\u5206\u5dee\u73a9\u6cd5"] tap];
    
    XCUIElement *element2 = [[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1];
    XCUIElement *element = [[element2 childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1];
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0] tap];
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:1] tap];
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:3] tap];
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:4] tap];
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:7] tap];
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:6] tap];
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:9] tap];
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:10] tap];
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:11] tap];
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:8] tap];
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:5] tap];
    [[[element childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:2] tap];
    [element2.buttons[@"\u786e\u5b9a"] tap];
    //    XCTAssertNil(tablesQuery.staticTexts[@"竞彩篮球"],@"没有篮球投注按钮");
    
    [[[[app.tables.cells containingType:XCUIElementTypeStaticText identifier:@"\u5468\u4e09302"] childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:4] tap];
    [app.buttons[@"\u786e\u5b9a"] tap];
    
}

@end
