




/********************* 有任何问题欢迎反馈给我 liuweiself@126.com ****************************************/
/***************  https://github.com/waynezxcv/Gallop 持续更新 ***************************/
/******************** 正在不断完善中，谢谢~  Enjoy ******************************************************/










#import "MomentsViewController.h"
#import "LWImageBrowser.h"
#import "TableViewCell.h"
#import "TableViewHeader.h"
#import "StatusModel.h"
#import "CellLayout.h"
#import "CommentView.h"
#import "CommentModel.h"
#import "LWAlertView.h"
#import "DiscribMessageViewController.h"
#import "MJReportMessageViewController.h"
//#import "MJSports-Swift.h"
#import "CLAppContext.h"
#import "CLCheckProgessManager.h"
#import "CLUserBaseInfo.h"
@interface MomentsViewController ()

<UITableViewDataSource,UITableViewDelegate, DiscribMessageViewControllerDelegate>

@property (nonatomic,strong) NSArray* fakeDatasource;
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) NSMutableArray* dataSource;
@property (nonatomic,strong) TableViewHeader* tableViewHeader;
@property (nonatomic,strong) CommentView* commentView;
@property (nonatomic,strong) CommentModel* postComment;
@property (nonatomic,assign,getter = isNeedRefresh) BOOL needRefresh;
@property (nonatomic,assign) BOOL displaysAsynchronously;//是否异步绘制
@property (nonatomic,assign) BOOL isFirstLoad;


//MJ Add
@property (nonatomic, strong) NSMutableArray* vendorsMessages;

@end



const CGFloat kRefreshBoundary = 170.0f;




@implementation MomentsViewController

#pragma mark - ViewControllerLifeCycle

- (void)publishData {
//    LWLayout* layout = [self layoutWithStatusModel:data index:0];
//    [self.dataSource insertObject:layout atIndex:0];
//    [self.tableView reloadData];

    [self refreshBegin];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"圈子";
    self.social_id = @"1";
    self.isFirstLoad = NO;
    [self.navigationController.navigationBar setTranslucent:NO];
    self.automaticallyAdjustsScrollViewInsets = true;
    self.vendorsMessages = [NSMutableArray arrayWithCapacity:0];
    [self setupUI];
    UIButton* doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [doneBtn setTitle:@"发布消息" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [doneBtn addTarget:self action:@selector(makeSure) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    
}

- (void) makeSure {
    
    
    //检查是否登录
    [[CLCheckProgessManager shareCheckProcessManager] checkIsLoginWithCallBack:^{
        DiscribMessageViewController* vc = [[DiscribMessageViewController alloc] init];
        vc.socialID = self.social_id;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:vc];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidAppearNotifications:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHidenNotifications:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.isFirstLoad) {
        [self refreshBegin];
    }
    
    [self.tableViewHeader updateHeadImg];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellLayout* layout = self.dataSource[indexPath.row];
    return layout.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"cellIdentifier";
    TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [self confirgueCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)confirgueCell:(TableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.displaysAsynchronously = self.displaysAsynchronously;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    CellLayout* cellLayout = self.dataSource[indexPath.row];
    cell.cellLayout = cellLayout;
    [self callbackWithCell:cell];
}

- (void)callbackWithCell:(TableViewCell *)cell {
    
    __weak typeof(self) weakSelf = self;
    cell.clickedLikeButtonCallback = ^(TableViewCell* cell,BOOL isLike) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself tableViewCell:cell didClickedLikeButtonWithIsLike:isLike];
    };
    cell.clickedReportButtonCallback = ^(TableViewCell* cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself reportWithCell:cell];
    };
    cell.clickedCommentButtonCallback = ^(TableViewCell* cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself commentWithCell:cell];
    };
    
    cell.clickedReCommentCallback = ^(TableViewCell* cell,CommentModel* model) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself reCommentWithCell:cell commentModel:model];
    };
    
    cell.clickedOpenCellCallback = ^(TableViewCell* cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself openTableViewCell:cell];
    };
    
    cell.clickedCloseCellCallback = ^(TableViewCell* cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself closeTableViewCell:cell];
    };
    
    cell.clickedAvatarCallback = ^(TableViewCell* cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself showAvatarWithCell:cell];
    };
    
    cell.clickedImageCallback = ^(TableViewCell* cell,NSInteger imageIndex) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself tableViewCell:cell showImageBrowserWithImageIndex:imageIndex];
    };
}

#pragma mark - Actions
//开始举报
- (void)reportWithCell:(TableViewCell *)cell  {
    [[CLCheckProgessManager shareCheckProcessManager] checkIsLoginWithCallBack:^{
        MJReportMessageViewController* vc = [[MJReportMessageViewController alloc] init];
        [self.navigationController pushViewController:vc animated:vc];
    }];
    
}
//开始评论
- (void)commentWithCell:(TableViewCell *)cell  {
    
    //检查是否登录
    [[CLCheckProgessManager shareCheckProcessManager] checkIsLoginWithCallBack:^{
        self.postComment.from = [CLAppContext context].userMessage.user_info.nick_name;
        self.postComment.to = @"";
        self.postComment.index = cell.indexPath.row;
        self.commentView.placeHolder = @"评论";
        if (![self.commentView.textView isFirstResponder]) {
            [self.commentView.textView becomeFirstResponder];
        }
    }];
    
    
}

//开始回复评论
- (void)reCommentWithCell:(TableViewCell *)cell commentModel:(CommentModel *)commentModel {
    
    [[CLCheckProgessManager shareCheckProcessManager] checkIsLoginWithCallBack:^{
        self.postComment.from = [CLAppContext context].userMessage.user_info.nick_name;
        self.postComment.to = commentModel.to;
        self.postComment.index = commentModel.index;
        self.commentView.placeHolder = [NSString stringWithFormat:@"回复%@:",commentModel.to];
        if (![self.commentView.textView isFirstResponder]) {
            [self.commentView.textView becomeFirstResponder];
        }
    }];
    
    
}

//点击查看大图
- (void)tableViewCell:(TableViewCell *)cell showImageBrowserWithImageIndex:(NSInteger)imageIndex {
    NSMutableArray* tmps = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < cell.cellLayout.imagePostions.count; i ++) {
        LWImageBrowserModel* model = [[LWImageBrowserModel alloc]
                                      initWithplaceholder:nil
                                      thumbnailURL:[NSURL URLWithString:[cell.cellLayout.statusModel.imgs objectAtIndex:i]]
                                      HDURL:[NSURL URLWithString:[cell.cellLayout.statusModel.imgs objectAtIndex:i]]
                                      containerView:cell.contentView
                                      positionInContainer:CGRectFromString(cell.cellLayout.imagePostions[i])
                                      index:i];
        [tmps addObject:model];
    }
    LWImageBrowser* browser = [[LWImageBrowser alloc] initWithImageBrowserModels:tmps
                                                                    currentIndex:imageIndex];
    
    [browser show];
}

//查看头像
- (void)showAvatarWithCell:(TableViewCell *)cell {
//    [LWAlertView shoWithMessage:[NSString stringWithFormat:@"点击了头像:%@",cell.cellLayout.statusModel.name]];
}


/* 由于是异步绘制，而且为了减少View的层级，整个显示内容都是在同一个UIView上面，所以会在刷新的时候闪一下，这里可以先把原先Cell的内容截图覆盖在Cell上，
 延迟0.25s后待刷新完成后，再将这个截图从Cell上移除 */
- (void)coverScreenshotAndDelayRemoveWithCell:(UITableViewCell *)cell cellHeight:(CGFloat)cellHeight {
    
    UIImage* screenshot = [GallopUtils screenshotFromView:cell];
    
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:[self.tableView convertRect:cell.frame toView:self.tableView]];
    
    imgView.frame = CGRectMake(imgView.frame.origin.x,
                               imgView.frame.origin.y,
                               imgView.frame.size.width,
                               cellHeight);
    
    imgView.contentMode = UIViewContentModeTop;
    imgView.backgroundColor = [UIColor whiteColor];
    imgView.image = screenshot;
    [self.tableView addSubview:imgView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imgView removeFromSuperview];
    });
    
}


//点赞
- (void)tableViewCell:(TableViewCell *)cell didClickedLikeButtonWithIsLike:(BOOL)isLike {
    [[CLCheckProgessManager shareCheckProcessManager] checkIsLoginWithCallBack:^{
        CellLayout* layout = [self.dataSource objectAtIndex:cell.indexPath.row];
        NSMutableArray* newLikeList = [[NSMutableArray alloc] initWithArray:layout.statusModel.likeList];
        if (isLike) {
            [newLikeList addObject:[CLAppContext context].userMessage.user_info.nick_name];
        } else {
            [newLikeList removeObject:[CLAppContext context].userMessage.user_info.nick_name];
        }
        
        StatusModel* statusModel = layout.statusModel;
        statusModel.likeList = newLikeList;
        statusModel.isLike = isLike;
        layout = [self layoutWithStatusModel:statusModel index:cell.indexPath.row];
        
        [self coverScreenshotAndDelayRemoveWithCell:cell cellHeight:layout.cellHeight];
        
        [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:layout];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.indexPath.row inSection:0]]
                              withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    
    
}


//展开Cell
- (void)openTableViewCell:(TableViewCell *)cell {
    CellLayout* layout =  [self.dataSource objectAtIndex:cell.indexPath.row];
    StatusModel* model = layout.statusModel;
    CellLayout* newLayout = [[CellLayout alloc] initContentOpendLayoutWithStatusModel:model
                                                                                index:cell.indexPath.row
                                                                        dateFormatter:self.dateFormatter];
    
    [self coverScreenshotAndDelayRemoveWithCell:cell cellHeight:newLayout.cellHeight];
    
    
    [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:newLayout];
    [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath]
                          withRowAnimation:UITableViewRowAnimationNone];
}

//折叠Cell
- (void)closeTableViewCell:(TableViewCell *)cell {
    CellLayout* layout =  [self.dataSource objectAtIndex:cell.indexPath.row];
    StatusModel* model = layout.statusModel;
    CellLayout* newLayout = [[CellLayout alloc] initWithStatusModel:model
                                                              index:cell.indexPath.row
                                                      dateFormatter:self.dateFormatter];
    
    [self coverScreenshotAndDelayRemoveWithCell:cell cellHeight:newLayout.cellHeight];
    
    
    [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:newLayout];
    [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath]
                          withRowAnimation:UITableViewRowAnimationNone];
}

//发表评论
- (void)postCommentWithCommentModel:(CommentModel *)model {
    
    CellLayout* layout = [self.dataSource objectAtIndex:model.index];
    NSMutableArray* newCommentLists = [[NSMutableArray alloc] initWithArray:layout.statusModel.commentList];
    NSDictionary* newComment = @{@"from":model.from,
                                 @"to":@"",
                                 @"content":model.content};
    [newCommentLists addObject:newComment];
    StatusModel* statusModel = layout.statusModel;
    statusModel.commentList = newCommentLists;
    CellLayout* newLayout = [self layoutWithStatusModel:statusModel index:model.index];
    
    
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:model.index inSection:0]];
    [self coverScreenshotAndDelayRemoveWithCell:cell cellHeight:newLayout.cellHeight];
    
    [self.dataSource replaceObjectAtIndex:model.index withObject:newLayout];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:model.index inSection:0]]
                          withRowAnimation:UITableViewRowAnimationNone];
    
    
    
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.commentView endEditing:YES];
    CGFloat offset = scrollView.contentOffset.y;
    [self.tableViewHeader loadingViewAnimateWithScrollViewContentOffset:offset];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    if (offset <= -kRefreshBoundary) {
        [self refreshBegin];
    }
}

#pragma mark - Keyboard

- (void)tapView:(id)sender {
    [self.commentView endEditing:YES];
}

- (void)keyboardDidAppearNotifications:(NSNotification *)notifications {
    NSDictionary *userInfo = [notifications userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat keyboardHeight = keyboardSize.height;
    self.commentView.frame = CGRectMake(0.0f, SCREEN_HEIGHT - 44.0f - keyboardHeight, SCREEN_WIDTH, 44.0f);
}

- (void)keyboardDidHidenNotifications:(NSNotification *)notifications {
    self.commentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44.0f);
}

#pragma mark - Data

//模拟下拉刷新
- (void)refreshBegin {
    [UIView animateWithDuration:0.2f animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(kRefreshBoundary, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        [self.tableViewHeader refreshingAnimateBegin];
        [self fakeDownload];
    }];
}

//模拟下载数据
- (void)fakeDownload {
    if (self.needRefresh) {

        
//        [MJVendorsRequest getVendorsListWithSocial_id:self.social_id last_id:@"" callback:^(NSArray* objc, BOOL state) {
//
//
//
//
//            if ([objc count] > 0) {
//                [self.dataSource removeAllObjects];
//                [self.vendorsMessages removeAllObjects];
//            }
//
//            [self.vendorsMessages addObjectsFromArray:objc];
//
//            for (MJVendorsMessage* msg in self.vendorsMessages) {
//                StatusModel* model = [[StatusModel alloc] initWithMessage:msg];
//
//                NSInteger i = [self.vendorsMessages indexOfObject:msg];
//                LWLayout* layout = [self layoutWithStatusModel:model index:i];
//                if (self.isFirstLoad) {
//                    [self.dataSource insertObject:layout atIndex:i];
//                } else {
//                    [self.dataSource addObject:layout];
//                }
//            }
//
//            if (!self.isFirstLoad) {
//                self.isFirstLoad = YES;
//            }
//
//            [self refreshComplete];
//
//        }];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            NSInteger count = 0;
            if (!self.isFirstLoad) {
                count = 20;
            } else {
                count = arc4random() % 5;
            }
            for (NSInteger i = 0 ; i < count; i ++) {//让数据更多

                StatusModel* model = [[StatusModel alloc] init];
                [model createModel];

                LWLayout* layout = [self layoutWithStatusModel:model index:i];
                if (self.isFirstLoad) {
                    [self.dataSource insertObject:layout atIndex:i];
                } else {
                    [self.dataSource addObject:layout];
                }

            }

            if (!self.isFirstLoad) {
                self.isFirstLoad = YES;
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshComplete];
            });
        });
    }
    
}

//模拟刷新完成
- (void)refreshComplete {
    [self.tableViewHeader refreshingAnimateStop];
    [self.tableView reloadData];
    [UIView animateWithDuration:0.35f animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(64.0f, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        self.needRefresh = YES;
    }];
}


- (CellLayout *)layoutWithStatusModel:(StatusModel *)statusModel index:(NSInteger)index {
    CellLayout* layout = [[CellLayout alloc] initWithStatusModel:statusModel
                                                           index:index
                                                   dateFormatter:self.dateFormatter];
    return layout;
}

- (void)segmentControlIndexChanged:(UISegmentedControl *)segmentedControl {
    NSInteger idx = segmentedControl.selectedSegmentIndex;
    switch (idx) {
        case 0:
            self.displaysAsynchronously = YES;
            break;
        case 1:
            self.displaysAsynchronously = NO;
            break;
    }
}

#pragma mark - Getter

- (void)setupUI {
    self.needRefresh = YES;
    self.displaysAsynchronously = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"异步绘制开",@"异步绘制关"]];
//    segmentedControl.selectedSegmentIndex = 0;
//    [segmentedControl addTarget:self
//                         action:@selector(segmentControlIndexChanged:)
//               forControlEvents:UIControlEventValueChanged];
//    self.navigationItem.titleView = segmentedControl;
  
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.commentView];
}


- (CommentView *)commentView {
    if (_commentView) {
        return _commentView;
    }
    __weak typeof(self) wself = self;
    _commentView = [[CommentView alloc]
                    initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 54.0f)
                    sendBlock:^(NSString *content) {
                        __strong  typeof(wself) swself = wself;
                        swself.postComment.content = content;
                        [swself postCommentWithCommentModel:swself.postComment];
                    }];
    return _commentView;
}

- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                              style:UITableViewStylePlain];
    _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64- 49);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = self.tableViewHeader;
    return _tableView;
}

- (TableViewHeader *)tableViewHeader {
    if (_tableViewHeader) {
        return _tableViewHeader;
    }
    _tableViewHeader =
    [[TableViewHeader alloc] initWithFrame:CGRectMake(0.0f,
                                                      0.0f,
                                                      SCREEN_WIDTH,
                                                      150.0f)];
    return _tableViewHeader;
}

- (NSMutableArray *)dataSource {
    if (_dataSource) {
        return _dataSource;
    }
    _dataSource = [[NSMutableArray alloc] init];
    return _dataSource;
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter* dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日 hh:mm"];
    });
    return dateFormatter;
}

- (CommentModel *)postComment {
    if (_postComment) {
        return _postComment;
    }
    _postComment = [[CommentModel alloc] init];
    return _postComment;
}

- (NSArray *)fakeDatasource {
    if (_fakeDatasource) {
        return _fakeDatasource;
    }
    _fakeDatasource = @[];
    
    return _fakeDatasource;
}

@end
