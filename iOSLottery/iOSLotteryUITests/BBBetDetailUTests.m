//
//  BBBetDetailUTests.m
//  iOSLottery
//
//  Created by 小铭 on 2017/8/22.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface BBBetDetailUTests : XCTestCase

@end

@implementation BBBetDetailUTests

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
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testBetDetailAddMatchOrDelete {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tablesQuery = app.tables;
    
    [tablesQuery.staticTexts[@"竞彩篮球"] tap];
    XCUIElementQuery *cellsQuery = [tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"\u5468\u4e09301"];
    [[[cellsQuery childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:4] tap];
    
    XCUIElementQuery *cellsQuery2 = [tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"\u5468\u4e09302"];
    [[[cellsQuery2 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:5] tap];
    [cellsQuery2.buttons[@"\u5c55\u5f00\u80dc\u5206\u5dee\u73a9\u6cd5"] swipeUp];
    
    XCUIElementQuery *cellsQuery3 = [tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"\u5468\u4e09303"];
    [[[cellsQuery3 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:1] tap];
    [[[cellsQuery3 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:5] swipeUp];
    [[[cellsQuery2 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0] swipeDown];
    [[[cellsQuery childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0] tap];
    
    XCUIElement *button = app.buttons[@"\u786e\u5b9a"];
    [button tap];
    [[tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"\u5468\u4e09303"].buttons[@"bet details detele"] tap];
    [button tap];
    [app.buttons[@"\u6dfb\u52a0/\u7f16\u8f91\u8d5b\u4e8b"] tap];
    
    [button tap];
    [[[XCUIApplication alloc] init].buttons[@"\u6dfb\u52a0/\u7f16\u8f91\u8d5b\u4e8b"] tap];
    
    [[[[app.tables.cells containingType:XCUIElementTypeStaticText identifier:@"\u5468\u4e09303"] childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:1] tap];
    [app.buttons[@"\u786e\u5b9a"] tap];
    
    XCUIElement *element = [[[[[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element;
    [[[[[element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:2] childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0] tap];
    
    XCUIElement *button1 = app.buttons[@"2\u4e321"];
    [button1 tap];
    
    XCUIElement *button2 = app.buttons[@"3\u4e321"];
    [button2 tap];
    [button1 tap];
    [button2 tap];
    [button1 tap];
    
    XCUIElement *element2 = [[element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:3];
    XCUIElement *textField = [element2 childrenMatchingType:XCUIElementTypeTextField].element;
    [textField tap];
    
    XCUIElement *key = app.keys[@"5"];
    [key tap];
    [key tap];
    [textField typeText:@"5"];
    [textField typeText:@"55"];
    [key tap];
    [app typeText:@"55"];
    [[[element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1] tap];
    
    [app.buttons[@"\u6e05\u7a7a\u5217\u8868"] tap];
    [app.buttons[@"\u786e\u5b9a"] tap];
    
    
}

- (void)testBetDetailMoreBetViewAdd {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tablesQuery = app.tables;
    
    [tablesQuery.staticTexts[@"竞彩篮球"] tap];
    
    [[[[tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"\u5468\u4e09301"] childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0] tap];
    [[[[tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"\u5468\u4e09302"] childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:1] tap];
    [[[[tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"\u5468\u4e09303"] childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:5] tap];
    
    XCUIElement *button = app.buttons[@"\u786e\u5b9a"];
    [button tap];
    [tablesQuery.staticTexts[@"\u4e3b\u8d1f  "] tap];
    
    XCUIElement *element = [[[[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1] childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1];
    [[[[[element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:3] childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0] tap];
    [[[[[element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:2] childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:1] tap];
    
    XCUIElement *element2 = [[element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:4];
    [[[element2 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:1] tap];
    [[[element2 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0] tap];
    
    XCUIElement *element3 = [[element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:5];
    [[[element3 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0] tap];
    [[[element3 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:3] tap];
    [[[element3 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:1] tap];
    [[[element3 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:4] tap];
    [[[element3 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:5] tap];
    [[[element3 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:2] tap];
    [[[element3 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:8] tap];
    [[[element3 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:7] tap];
    
    XCUIElement *button2 = [[element3 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:10];
    [button2 tap];
    [[[element3 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:9] tap];
    [[[element3 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:6] tap];
    [[[element3 childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:11] tap];
    [element swipeUp];
    [button2 tap];
    [button tap];
    
    [tablesQuery.staticTexts[@"\u8ba9\u4e3b\u80dc  "] swipeUp];
    
    [[[[XCUIApplication alloc] init].tables.cells containingType:XCUIElementTypeStaticText identifier:@"\u5468\u4e09302"].staticTexts[@"\u8ba9\u4e3b\u8d1f  "] tap];
    
    XCUIElement *window = [[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0];
    [[[[[[[[[window childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1] childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1] childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:3] childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0] tap];
    [app.buttons[@"\u786e\u5b9a"] tap];
    [[[window childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:2].buttons[@"\u786e\u5b9a"] tap];
    [app.buttons[@"\u6e05\u7a7a\u5217\u8868"] tap];
    [app.buttons[@"\u786e\u5b9a"] tap];
    
}

- (void)testBetDetailMoreBetViewDelete {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tablesQuery = app.tables;
    
    [tablesQuery.staticTexts[@"竞彩篮球"] tap];
}

@end
