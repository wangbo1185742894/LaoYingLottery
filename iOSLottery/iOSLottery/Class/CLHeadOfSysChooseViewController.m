//
//  CLHeadOfSysChooseViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLHeadOfSysChooseViewController.h"
#import "CQHeadImgCollectionViewCell.h"
#import "CQHeadImgSectionCollectionReusableView.h"


#import "CLSystemHeadListAPI.h"
#import "CLChangeHeadUpdateAPI.h"
#import "CLSystemHeadHandler.h"
#import "CLPersonalMsgHandler.h"

@interface CLHeadOfSysChooseViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,CLRequestCallBackDelegate,CLRequestParamSource>

@property (nonatomic, strong) UICollectionView * headImgCollecView;
@property (nonatomic, strong) NSMutableArray* headImgListDataArrays;
@property (nonatomic, strong) NSString* userCurSelectImgUrl;
@property (nonatomic, strong) NSIndexPath* historySelectIndexPath;

@property (nonatomic, strong) UIButton* confirmButton;

@property (nonatomic, strong) CLSystemHeadListAPI* systemListAPI;
@property (nonatomic, strong) CLChangeHeadUpdateAPI* updateAPI;
@end

@implementation CLHeadOfSysChooseViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navTitleText = @"头像选择";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.confirmButton];
    [self.view addSubview:self.headImgCollecView];
    // Do any additional setup after loading the view.
   
    [self.systemListAPI start];
}


- (void)confirmEvent:(id)sender
{
    
    if (self.historySelectIndexPath.section == -1 ||
        self.historySelectIndexPath.row == -1)
    {
        [self show:@"未选择任何头像"];
        return;
    }
    
    CLHeadImgViewModel* history = [((CLHeadImgTypeViewModel*)(self.headImgListDataArrays[self.historySelectIndexPath.section])).img_list objectAtIndex:self.historySelectIndexPath.row];
    self.updateAPI.headImgUrl = history.img_url;
    [self.updateAPI start];
}

#pragma mark - CLRequestCallBackDelegate


- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request == self.systemListAPI) {
        //列表
        (self.headImgListDataArrays == 0)?:[self.headImgListDataArrays removeAllObjects];
        [self.headImgListDataArrays addObjectsFromArray:[CLSystemHeadHandler dealingWithSystemHeadImgFromDict:request.urlResponse.resp]];
        NSIndexPath* tempSelect = [CLSystemHeadHandler searchSelectedHeadImg:[CLPersonalMsgHandler personalHeadImgStr] FromArray:self.headImgListDataArrays];
        if (tempSelect) self.historySelectIndexPath = tempSelect;
        
        [self.headImgCollecView reloadData];
        
    } else if (request == self.updateAPI) {
        
        //完成后需要回调headUrl或设置单例中个人头像
        if (request.urlResponse.success) {
            //成功 更新个人信息单例数据
            [[CLPersonalMsgHandler sharedPersonal] updatePersonalMesssageFrom:[request.urlResponse.resp firstObject]];
            [self show:@"修改完成"];
            
            DELAY(1.f, ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [self show:request.urlResponse.errorMessage];
        }
        
    }
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
    if (request.urlResponse.responseObject) {
        [self show:request.urlResponse.errorMessage];
    }
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.headImgListDataArrays.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    CLHeadImgTypeViewModel* type = [self.headImgListDataArrays objectAtIndex:section];
    return type.img_list.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        CQHeadImgSectionCollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CQHeadImgSectionCollectionReusableViewId" forIndexPath:indexPath];
        
        CLHeadImgTypeViewModel* type = [self.headImgListDataArrays objectAtIndex:indexPath.section];
        view.sectionTitleLabel.text = type.img_type_name;
        return view;
    }
    return nil;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CQHeadImgCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CQHeadImgCollectionViewCellId" forIndexPath:indexPath];
    CLHeadImgTypeViewModel* type = [self.headImgListDataArrays objectAtIndex:indexPath.section];
    CLHeadImgViewModel* content = [type.img_list objectAtIndex:indexPath.row];
    cell.headImgUrl = content.img_url;
    cell.headImgSelect = content.selectStatus;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CLHeadImgTypeViewModel* type = [self.headImgListDataArrays objectAtIndex:indexPath.section];
    CLHeadImgViewModel* content = [type.img_list objectAtIndex:indexPath.row];
    if (content.selectStatus) {
        return;
    }
    else
    {
        content.selectStatus = YES;
        //检测历史选择是否存在
        if (self.historySelectIndexPath.section != -1 &&
            self.historySelectIndexPath.row != -1)
        {
            CLHeadImgViewModel* history = [((CLHeadImgTypeViewModel*)(self.headImgListDataArrays[self.historySelectIndexPath.section])).img_list objectAtIndex:self.historySelectIndexPath.row];
            history.selectStatus = NO;
        }
        //将当前选择位置保存
        self.historySelectIndexPath = indexPath;
    }
    [self.headImgCollecView reloadData];
}

#pragma mark - getting method

- (UICollectionView *)headImgCollecView
{
    if (!_headImgCollecView) {
        UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
        flowLayout.minimumLineSpacing = 0.0;//行间距(最小值)
        flowLayout.minimumInteritemSpacing = 0.0;//item间距(最小值)
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 4.f, SCREEN_WIDTH / 4.f);
        flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH - 20, __SCALE(35.0f));
        
        
        
        _headImgCollecView = [[UICollectionView alloc] initWithFrame:__Rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_HEIGHT) collectionViewLayout:flowLayout];
        _headImgCollecView.delegate = self;
        _headImgCollecView.dataSource = self;
        _headImgCollecView.backgroundColor = [UIColor whiteColor];
        [_headImgCollecView registerNib:[UINib nibWithNibName:@"CQHeadImgCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CQHeadImgCollectionViewCellId"];
        
        [_headImgCollecView registerNib:[UINib nibWithNibName:@"CQHeadImgSectionCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CQHeadImgSectionCollectionReusableViewId"];
        
        
    }
    return _headImgCollecView;
}

- (NSMutableArray *)headImgListDataArrays
{
    if(!_headImgListDataArrays)
    {
        _headImgListDataArrays = [NSMutableArray new];
    }
    return _headImgListDataArrays;
}

- (NSIndexPath *)historySelectIndexPath
{
    if (!_historySelectIndexPath) {
        _historySelectIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
    }
    return _historySelectIndexPath;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame = __Rect(0, 0, 50, 30);
        _confirmButton.titleLabel.font = FONT_SCALE(14);
        [_confirmButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_confirmButton setTitle:@"完成" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

#pragma mark - api

- (CLSystemHeadListAPI *)systemListAPI {
    
    if (!_systemListAPI) {
        _systemListAPI = [[CLSystemHeadListAPI alloc] init];
        _systemListAPI.delegate = self;
    }
    return _systemListAPI;
}

- (CLChangeHeadUpdateAPI *)updateAPI {
    
    if (!_updateAPI) {
        _updateAPI = [[CLChangeHeadUpdateAPI alloc] init];
        _updateAPI.delegate = self;
    }
    return _updateAPI;
}

#pragma mark -

- (void)dealloc {
    
    if (_systemListAPI) {
        _systemListAPI.delegate = nil;
        [_systemListAPI cancel];
    }
   
    if (_updateAPI) {
        _updateAPI.delegate = nil;
        [_updateAPI cancel];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

