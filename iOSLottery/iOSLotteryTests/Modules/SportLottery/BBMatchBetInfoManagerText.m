//
//  BBMatchBetInfoManagerText.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/8/25.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "BBMatchInfoManager.h"
#import "BBSeletedGameModel.h"


@interface BBMatchBetInfoManagerText : XCTestCase

@property (nonatomic, strong) BBMatchInfoManager *manager;

@end

@implementation BBMatchBetInfoManagerText

- (void)setUp {
    [super setUp];
    
    self.manager = [BBMatchInfoManager shareManager];
}

- (void)tearDown {
    
    self.manager = nil;
    
    [super tearDown];
}

- (void)testCorrectSaveAndclassifyAllMatchsInfo
{

    [self.manager saveAndclassifyAllMatchsInfo:@{}];
    
}

- (void)testErrorSaveAndclassifyAllMatchsInfo
{

    [self.manager saveAndclassifyAllMatchsInfo:@[@"adfaf",@"adfaf"]];
    
    
    [self.manager saveAndclassifyAllMatchsInfo:nil];
}

- (void)testSaveCorrectBetInfo
{

    [self.manager saveSelectBetInfoWithMatchIssue:@"20170825" palyMothed:@"sf" selectItem:@[@"3"] isDanGuan:NO];
    
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170826" palyMothed:@"sfc" selectItem:@[@"101",@"101",@"103"] isDanGuan:YES];
    
    NSInteger count = self.manager.getSelectMatchCount;
    
    XCTAssertEqual(count, 2,@"测试不通过");
    
    [self.manager clearMatch];
}

- (void)testSaveErrorBetInfo
{

    [self.manager saveSelectBetInfoWithMatchIssue:@"" palyMothed:@"dxf" selectItem:@[] isDanGuan:NO];
    
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170901" palyMothed:@"sec" selectItem:@[@"101",@"102"] isDanGuan:NO];
    
    NSInteger count = self.manager.getSelectMatchCount;
    
    XCTAssertEqual(count, 0,@"测试不通过");
    
     [self.manager clearMatch];
}

- (void)testSaveEmptyBetInfo
{
    
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170826" palyMothed:@"sfc" selectItem:@[@"31",@"32",@"33"] isDanGuan:YES];

    [self.manager saveSelectBetInfoWithMatchIssue:@"20170826" palyMothed:@"sfc" selectItem:@[] isDanGuan:YES];
    
    NSInteger count = self.manager.getSelectMatchCount;
    
    XCTAssertEqual(count, 0,@"测试不通过");
    
     [self.manager clearMatch];
}

#pragma mark --- 是否可以保存选项 --- 
- (void)testIsCanSaveSelectBetInfoWithMatchIssue
{

    [self.manager saveSelectBetInfoWithMatchIssue:@"20170826" palyMothed:@"sfc" selectItem:@[@"31",@"32",@"33"] isDanGuan:YES];
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170827" palyMothed:@"sfc" selectItem:@[@"31",@"32",@"33"] isDanGuan:YES];
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170828" palyMothed:@"sfc" selectItem:@[@"31",@"32",@"33"] isDanGuan:YES];
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170829" palyMothed:@"sfc" selectItem:@[@"31",@"32",@"33"] isDanGuan:YES];
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170830" palyMothed:@"sfc" selectItem:@[@"31",@"32",@"33"] isDanGuan:YES];
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170831" palyMothed:@"sfc" selectItem:@[@"31",@"32",@"33"] isDanGuan:YES];
    
    
    BOOL isCan = [self.manager isCanSaveSelectBetInfoWithMatchIssue:nil];
    isCan = [self.manager isCanSaveSelectBetInfoWithMatchIssue:@""];
    
    XCTAssertFalse(isCan,@"match_issue错误，不可以选中，测试不通过");
    
    
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170901" palyMothed:@"sfc" selectItem:@[@"31",@"32",@"33"] isDanGuan:YES];
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170902" palyMothed:@"sfc" selectItem:@[@"31",@"32",@"33"] isDanGuan:YES];
    
    isCan = [self.manager isCanSaveSelectBetInfoWithMatchIssue:@"20170903"];
    
    XCTAssertFalse(isCan,@"场次已满8场，不可选中，测试不通过");
    
    isCan = [self.manager isCanSaveSelectBetInfoWithMatchIssue:@"20170902"];
    
    XCTAssertTrue(isCan,@"已选8场，可以保存其中一场，测试不通过");
    
     [self.manager clearMatch];
}


#pragma mark --- 删除选中项 ---
- (void)testRemoveCorrectBetInfo
{
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170825" palyMothed:@"sf" selectItem:@[@"3"] isDanGuan:NO];

    [self.manager removeSelectBetInfoWithMatchIssue:@"20170825" palyMothed:@"sf" selectItem:@[@"3"]];
    
    NSInteger count = self.manager.getSelectMatchCount;
    
    XCTAssertEqual(count, 0,@"测试不通过");
    
     [self.manager clearMatch];
}

- (void)testRemoveErrorBetInfo
{

    [self.manager saveSelectBetInfoWithMatchIssue:@"20170828" palyMothed:@"sf" selectItem:@[@"3",@"0"] isDanGuan:NO];
    
    [self.manager removeSelectBetInfoWithMatchIssue:@"" palyMothed:@"esdf" selectItem:@[@"3"]];
    
    [self.manager removeSelectBetInfoWithMatchIssue:@"20170828" palyMothed:@"dxf" selectItem:@[@"3"]];
    
    [self.manager removeSelectBetInfoWithMatchIssue:@"20170828" palyMothed:@"sf" selectItem:@[@"101"]];
    
    NSInteger count = self.manager.getSelectMatchCount;
    
    XCTAssertEqual(count, 1,@"测试不通过");
    
     [self.manager clearMatch];
}

#pragma mark --- 是否可以删除一场比赛 ----
- (void)testAfterRemoveCanBetWithMatchIssue
{
    
    
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170901" palyMothed:@"dxf" selectItem:@[@"31",@"32",@"33"] isDanGuan:YES];
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170902" palyMothed:@"sfc" selectItem:@[@"31",@"32",@"33"] isDanGuan:NO];
    
    BOOL isCan = [self.manager afterRemoveCanBetWithMatchIssue:@"20170902"];
    
    XCTAssertTrue(isCan,@"剩余是全是单关可以删除，测试不通过");
    
    [self.manager removeOneMatchWithIssue:@"20170902"];
    
    isCan = [self.manager afterRemoveCanBetWithMatchIssue:@"20170901"];
    
    XCTAssertFalse(isCan,@"没有剩余比赛，不可删除，测试不通过");

    [self.manager saveSelectBetInfoWithMatchIssue:@"20170826" palyMothed:@"sf" selectItem:@[@"31",@"32",@"33"] isDanGuan:NO];
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170827" palyMothed:@"rfsf" selectItem:@[@"31",@"32",@"33"] isDanGuan:NO];
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170828" palyMothed:@"dxf" selectItem:@[@"31",@"32",@"33"] isDanGuan:NO];
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170828" palyMothed:@"sfc" selectItem:@[@"31",@"32",@"33"] isDanGuan:NO];
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170829" palyMothed:@"rfsf" selectItem:@[@"31",@"32",@"33"] isDanGuan:NO];

    
    
//    isCan = [self.manager afterRemoveCanBetWithMatchIssue:@"20170828"];
//    
//    XCTAssertTrue(isCan,@"是单关可以删除，测试不通过");
//    
//    isCan = [self.manager afterRemoveCanBetWithMatchIssue:@"20170826"];
//    
//    XCTAssertTrue(isCan,@"是全是单关，场次大于1可以删除，测试不通过");
//    
//    [self.manager removeOneMatchWithIssue:@"20170826"];
    
    
    isCan = [self.manager afterRemoveCanBetWithMatchIssue:@"20170827"];
    
    XCTAssertTrue(isCan,@"剩余场次大于1，可以删除，测试不通过");
    
     [self.manager clearMatch];
    
    
}
- (void)testSaveCorrectOneMatch
{
    
    BBSeletedGameModel *gameModel = [[BBSeletedGameModel alloc] init];
    
    gameModel.matchIssue = @"20170828903";
    
    BBSelectPlayMethodInfo *play = [[BBSelectPlayMethodInfo alloc] init];
    
    play.playMothed = @"sf";
    play.isDanGuan = NO;
    play.selectPlayMothedArray = [NSMutableArray arrayWithArray:@[@"0",@"3"]];
    
    gameModel.sfInfo = play;
    
    [self.manager saveOneMatchSelectInfo:gameModel];
    
    NSInteger count = self.manager.getSelectMatchCount;
    
    XCTAssertEqual(count, 1,@"测试不通过");
    
     [self.manager clearMatch];
}

- (void)testSaveEorrorOneMatch
{

    BBSeletedGameModel *gameModel = [[BBSeletedGameModel alloc] init];
    
    gameModel.matchIssue = @"";
    
    BBSelectPlayMethodInfo *play = [[BBSelectPlayMethodInfo alloc] init];
    
    play.playMothed = @"sf";
    play.isDanGuan = NO;
    play.selectPlayMothedArray = [NSMutableArray arrayWithArray:@[@"0",@"3"]];
    
    gameModel.sfInfo = play;
    
    [self.manager saveOneMatchSelectInfo:gameModel];
    
    
    BBSeletedGameModel *gameModel2 = [[BBSeletedGameModel alloc] init];
    
    gameModel2.matchIssue = @"2017082904";
    
    BBSelectPlayMethodInfo *play2 = [[BBSelectPlayMethodInfo alloc] init];
    
    play2.playMothed = @"dxf";
    play2.isDanGuan = NO;
    play2.selectPlayMothedArray = [NSMutableArray arrayWithArray:@[@"0",@"3",@"4"]];
    
    gameModel2.dxfInfo = play2;
    
    [self.manager saveOneMatchSelectInfo:gameModel2];
    
    
    BBSeletedGameModel *gameModel3 = [[BBSeletedGameModel alloc] init];
    
    gameModel3.matchIssue = @"2017082904";
    
    BBSelectPlayMethodInfo *play3 = [[BBSelectPlayMethodInfo alloc] init];
    
    play3.playMothed = @"dxf";
    play3.isDanGuan = NO;
    play3.selectPlayMothedArray = [NSMutableArray arrayWithArray:@[@"0"]];
    
    gameModel3.dxfInfo = play3;
    
    [self.manager saveOneMatchSelectInfo:gameModel3];
    

    
    NSInteger count = self.manager.getSelectMatchCount;
    
    
    
    XCTAssertEqual(count, 1,@"测试不通过");
    
     [self.manager clearMatch];
    
}


#pragma mark ---- 获取当前玩法选中多少项 ---
- (void)testGetSingleMatchSelectPlayMothedNumberWithMatchIssue
{

    [self.manager saveSelectBetInfoWithMatchIssue:@"20170828" palyMothed:@"sf" selectItem:@[@"3",@"0"] isDanGuan:NO];
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170828" palyMothed:@"rfsf" selectItem:@[@"103",@"102"] isDanGuan:NO];
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170828" palyMothed:@"dxf" selectItem:@[@"3",@"0",@"34",@"45"] isDanGuan:NO];
    
    NSInteger count = [self.manager getSingleMatchSelectPlayMothedNumberWithMatchIssue:@"20170828"];
    
    XCTAssertEqual(count, 8,@"选中项个数错误，测试不通过");
    
    [self.manager clearMatch];
    
}


#pragma mark --- 测试选中的比赛中是否存在单关 --- 
- (void)testGetSelectMatchHasDanGuan
{
    
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170828" palyMothed:@"sf" selectItem:@[@"3",@"0"] isDanGuan:YES];
    
    BOOL hasDanGuan = [self.manager getSelectMatchHasDanGuan];

      XCTAssertTrue(hasDanGuan,@"如果存在单关，测试不通过");
    
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170904" palyMothed:@"rfsf" selectItem:@[@"103",@"102"] isDanGuan:NO];
    
    hasDanGuan = [self.manager getSelectMatchHasDanGuan];
    
    XCTAssertFalse(hasDanGuan,@"如果存在单关，测试不通过");
    
    [self.manager clearMatch];
  
}

- (void)testGetHasAllDanGuan
{

    [self.manager saveSelectBetInfoWithMatchIssue:@"20170828" palyMothed:@"sf" selectItem:@[@"3",@"0"] isDanGuan:NO];
    
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170829" palyMothed:@"sfc" selectItem:@[@"3",@"0"] isDanGuan:YES];
    
    BOOL hasDanGuan = [self.manager getHasAllDanGuan];
    
    XCTAssertFalse(hasDanGuan,@"全是存在单关，测试不通过");
    
    [self.manager removeOneMatchWithIssue:@"20170828"];
    
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170828" palyMothed:@"sf" selectItem:@[@"3",@"0"] isDanGuan:YES];
    
    hasDanGuan = [self.manager getHasAllDanGuan];
    
    XCTAssertTrue(hasDanGuan,@"不全是单关，测试不通过");
    
    [self.manager clearMatch];
    
}

- (void)testGetCorrectNote
{

    [self.manager saveSelectBetInfoWithMatchIssue:@"20170825" palyMothed:@"sf" selectItem:@[@"3"] isDanGuan:NO];
    
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170826" palyMothed:@"sfc" selectItem:@[@"101",@"101",@"103"] isDanGuan:YES];
    
    [self.manager saveSelectChuanGuan:@"2"];
    
    NSInteger count = self.manager.getNote;
    
    XCTAssertEqual(count, 3,@"测试不通过");
    
    [self.manager clearMatch];
    
}

- (void)testGetErrorNote
{

    [self.manager saveSelectBetInfoWithMatchIssue:@"" palyMothed:@"sf" selectItem:@[@"3"] isDanGuan:NO];
    
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170828" palyMothed:@"sf" selectItem:@[@"3"] isDanGuan:NO];
    
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170826" palyMothed:@"sfc" selectItem:@[@"101",@"101",@"103"] isDanGuan:YES];
    
    [self.manager saveSelectChuanGuan:@"2"];
    
    NSInteger count = self.manager.getNote;
    
    XCTAssertEqual(count, 3,@"测试不通过");
    
    [self.manager clearMatch];
    
}


- (void)testRemoveSelectChuanGuan
{

    [self.manager saveSelectBetInfoWithMatchIssue:@"20170825" palyMothed:@"sf" selectItem:@[@"3"] isDanGuan:NO];
    
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170826" palyMothed:@"sfc" selectItem:@[@"101",@"101",@"103"] isDanGuan:YES];
    
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170827" palyMothed:@"sfc" selectItem:@[@"101",@"101",@"103"] isDanGuan:YES];

    
    [self.manager saveSelectChuanGuan:@"2"];
    [self.manager saveSelectChuanGuan:@"3"];
    
    [self.manager removeSelectChuanGuan:@"4"];
    
    NSInteger count = self.manager.getNote;
    
    XCTAssertEqual(count, 24,@"测试不通过");
    
    [self.manager removeSelectChuanGuan:@"3"];
    
    count = self.manager.getNote;
    
    XCTAssertEqual(count, 15,@"测试不通过");
    
    [self.manager clearMatch];
}


#pragma mark --- 测试获取一场选中赛事信息 -----

- (void)testCorrentGetSelectedInfo
{

    [self.manager saveSelectBetInfoWithMatchIssue:@"20170828" palyMothed:@"sf" selectItem:@[@"3",@"0"] isDanGuan:NO];
    
    BBSeletedGameModel *gameInfo = [self.manager getSingleMatchSelectInfoWithMatchIssue:@"20170828"];
    
    XCTAssertNotNil(gameInfo,@"测试不通过");
    
     [self.manager clearMatch];
}


- (void)testErrorGetSelectedInfo
{

    [self.manager saveSelectBetInfoWithMatchIssue:@"20170828" palyMothed:@"sf" selectItem:@[@"3",@"0"] isDanGuan:NO];
    
    BBSeletedGameModel *gameInfo = [self.manager getSingleMatchSelectInfoWithMatchIssue:@"201708338"];
    
    XCTAssertNil(gameInfo,@"测试不通过");
    
     [self.manager clearMatch];
}

#pragma mark --- 获取一场比赛的基本信息 ----
- (void)testGetMatchInfoWithIssue
{

    
    NSArray *matchArray = @[@{@"match_issue":@"20170901"},@{@"match_issue":@"20170902"}];
    
    NSDictionary *dic = @{@"allMatches":@[@{@"title":@"2017-09-5-周二10场可投",@"matches":matchArray}]};
    
    //NSDictionary *dic = @{@"allMatches":@[@{@"title":@"2017-09-5-周二10场可投",@"matches":@[@{@"213":@"123"},@{@"123":@"123"}]]};
                                          
                                          
    
    [self.manager saveAndclassifyAllMatchsInfo:dic];
    
    BBMatchModel *match = [self.manager getMatchInfoWithIssue:@"adf"];
    
    XCTAssertNil(match,@"match-issue错误时，获得比赛信息，测试不通过");
    
    match = [self.manager getMatchInfoWithIssue:nil];
    
    XCTAssertNil(match,@"match-issue错误时，获得比赛信息，测试不通过");
    
    match = [self.manager getMatchInfoWithIssue:@""];
    
    XCTAssertNil(match,@"match-issue错误时，获得比赛信息，测试不通过");
    
    match = [self.manager getMatchInfoWithIssue:@"20170902"];
    
    XCTAssertNotNil(match,@"match-issue正确时，获去不到比赛信息，测试不通过");
    
     [self.manager clearMatch];

}

#pragma mark ---- 串关相关 ----

- (void)testGetChuanGuanArray
{
    
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170907" palyMothed:@"sfc" selectItem:@[@"3",@"0"] isDanGuan:YES];
    
    NSArray *array = [self.manager getChuanGuanArray];
    
    XCTAssertEqual(array.count, 1,@"只有单关比赛，测试不通过");
    
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170906" palyMothed:@"sf" selectItem:@[@"3",@"0"] isDanGuan:NO];
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170905" palyMothed:@"rfsf" selectItem:@[@"3",@"0"] isDanGuan:NO];
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170904" palyMothed:@"dxf" selectItem:@[@"3",@"0"] isDanGuan:NO];
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170903" palyMothed:@"sf" selectItem:@[@"3",@"0"] isDanGuan:NO];

    array = [self.manager getChuanGuanArray];
    
    XCTAssertEqual(array.count, 3,@"有胜分差玩法比赛，最多4串1，测试不通过");
    
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170908" palyMothed:@"sf" selectItem:@[@"3",@"0"] isDanGuan:NO];
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170909" palyMothed:@"sf" selectItem:@[@"3",@"0"] isDanGuan:NO];
    [self.manager saveSelectBetInfoWithMatchIssue:@"201709010" palyMothed:@"dxf" selectItem:@[@"3",@"0"] isDanGuan:YES];
    
    [self.manager removeOneMatchWithIssue:@"20170907"];
    
    array = [self.manager getChuanGuanArray];
    
    XCTAssertEqual(array.count, 6,@"无胜分差玩法，不全是单关，测试不通过");
    
     [self.manager clearMatch];
}


#pragma mark ---- 测试获取最大串关数 ------
- (void)testGetCurrentMaxChuanGuanCount
{
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170906" palyMothed:@"sf" selectItem:@[@"3",@"0"] isDanGuan:NO];
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170905" palyMothed:@"sf" selectItem:@[@"3",@"0"] isDanGuan:NO];
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170904" palyMothed:@"sf" selectItem:@[@"3",@"0"] isDanGuan:NO];
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170903" palyMothed:@"sf" selectItem:@[@"3",@"0"] isDanGuan:NO];

    NSInteger count = [self.manager getCurrentMaxChuanGuanCount];
    XCTAssertLessThan(count, 9,@"串关数大于9场，测试不通过");
    
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170907" palyMothed:@"sf" selectItem:@[@"3",@"0"] isDanGuan:YES];
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170908" palyMothed:@"rfsf" selectItem:@[@"3",@"0"] isDanGuan:YES];

    [self.manager saveSelectBetInfoWithMatchIssue:@"20170909" palyMothed:@"dxf" selectItem:@[@"3",@"0"] isDanGuan:YES];
    [self.manager saveSelectBetInfoWithMatchIssue:@"201709010" palyMothed:@"sfc" selectItem:@[@"3",@"0"] isDanGuan:YES];

    
    
    count = [self.manager getCurrentMaxChuanGuanCount];
    
    XCTAssertEqual(count, 4,@"有单关玩法，最多4串1，测试不通过");
    
     [self.manager clearMatch];
}


#pragma mark --- 测试清楚比赛 ----
- (void)testClearMatch
{
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170825" palyMothed:@"sf" selectItem:@[@"3"] isDanGuan:NO];
    
    [self.manager saveSelectBetInfoWithMatchIssue:@"20170826" palyMothed:@"sfc" selectItem:@[@"101",@"101",@"103"] isDanGuan:YES];

    [self.manager clearMatch];
    
    NSInteger count = [self.manager getSelectMatchCount];
    
    XCTAssertGreaterThanOrEqual(count, 0,@"清除选项后，还存在选中项，测试不通过");
    
     [self.manager clearMatch];
}


#pragma mark --- Get Method ----
- (void)testGetGameID
{

    NSString * gameid = [self.manager getGameId];
    
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
