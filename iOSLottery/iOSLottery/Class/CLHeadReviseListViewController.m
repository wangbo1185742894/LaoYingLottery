//
//  CLHeadReviseListViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLHeadReviseListViewController.h"
#import "CLUserCenterPageConfigure.h"
#import "Masonry.h"

@interface CLHeadReviseListViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView* groupTableView;

@property (nonatomic, strong) NSMutableArray* dataSource;

@property (nonatomic, assign) UIImagePickerControllerSourceType sourceType;

@property (nonatomic, strong) NSString* upLoadPicKey;

@end

@implementation CLHeadReviseListViewController
- (id)initWithRouterParams:(NSDictionary *)params{
    
    if (self = [self init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"选择头像";
    [self.view addSubview:self.groupTableView];
    
    
    [self.groupTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return (section == 0)?1.f:15.f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:__Rect(0, 0, SCREEN_WIDTH, 1.f)];
    return view;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:__Rect(0, 0, SCREEN_WIDTH, 1.f)];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0)?1.f:15.f;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"CLHeadReviseListCellId";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = FONT_FIX(12);
    }
    
    NSString* title = self.dataSource[indexPath.section][indexPath.row];
    cell.textLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        //选择默认头像
        
        [CLUserCenterPageConfigure pushChangeSystemHeadImgViewController];
//        [self.navigationController pushViewController:[CLUserCenterPageConfigure getChangeSystemHeadImgViewController] animated:YES];
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            //手机相册
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self chooseImg];
            }
        }
        else if (indexPath.row == 1)
        {
            //拍一张
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                self.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self chooseImg];
            }
        }
    }
}

- (void)chooseImg
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.navigationBar.barTintColor = UIColorFromRGB(0x1F1F1F);
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = self.sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

#pragma mark -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
//    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    //    userImageView.image = image;
    
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
    //    UIImage *compressedImage = [UIImage imageWithData:imageData];
    
    
    //上传图片
    
//    NSString* imgUrl = [NSString stringWithFormat:@"%@/HeadImg/%@-%@",[CQAppBaseConfig getUserDefault:CQUserDefaultName_UserLoginToken],CQ_Client_Type,[NSString getNowDataTimeString]];
//    
//    self.upLoadPicKey = [NSString stringWithFormat:@"%@%@",QINIU_PIC_HTTP_PREFIX,imgUrl];
//    QiniuFile *file = [[QiniuFile alloc] initWithFileData:imageData withKey:imgUrl];
//    
//    QiniuUploader *loader = [[QiniuUploader alloc] init];
//    [loader addFile:file];
//    
//    [loader setUploadOneFileSucceeded:^(AFHTTPRequestOperation *operation, NSInteger index, NSString *key){
//        NSLog(@"index:%ld key:%@",(long)index,key);
//    }];
//    
//    [loader setUploadOneFileProgress:^(AFHTTPRequestOperation *operation, NSInteger index, double percent){
//        NSLog(@"index:%ld percent:%@",(long)index,operation.responseObject);
//    }];
//    WS(_weakSelf);
//    
//    //上传成功
//    [loader setUploadAllFilesComplete:^(void){
//        NSLog(@"complete");
//        [_weakSelf headImgUrlToService];
//    }];
//    
//    
//    [loader setUploadOneFileFailed:^(AFHTTPRequestOperation *operation, NSInteger index, NSDictionary *error){
//        [CQErrorManager showErrorInfo:@"上传失败"];
//        _weakSelf.needToShowLoadingAnimate = NO;
//        NSLog(@"%@",error);
//    }];
//    //开始上传
//    self.needToShowLoadingAnimate = YES;
//    [loader startUpload];
}

- (void)headImgUrlToService
{
//    WS(_weakSelf)
//    [CQNetsAPIList userHeadImageChangeWithToken:[CQSingletonUserInfoStore sharedManager].userInfo.token HeadImageUrl:self.upLoadPicKey Block:^(id obj, NSError *error) {
//        _weakSelf.needToShowLoadingAnimate = NO;
//        if (!error) {
//            if (__AFREQ_SUCCESS(obj)) {
//                //成功
//                NSLog(@"修改头像成功  返回数据:%@",obj);
//                
//                //修改用户信息单例中头像信息
//                [CQSingletonUserInfoStore sharedManager].userInfo.userBaseInfo.head_img_url = self.upLoadPicKey;
//                
//                if (_weakSelf.headImgChangedComplete) {
//                    _weakSelf.headImgChangedComplete([CQPerfectUserInfoHandler userPerfectInformationDealForm:[REQ_FINISH_DATA(obj) firstObject]]);
//                }
//                
//                [_weakSelf.navigationController popViewControllerAnimated:YES];
//                
//            }
//            else
//            {
//                
//                if (REQ_CODE(obj) == UserCenterAccountOffline)
//                {
//                    [_weakSelf userOfflineAction:REQ_ERROR_MSG(obj)];
//                }
//                else
//                {
//                    [CQErrorManager showErrorInfo:REQ_ERROR_MSG(obj)];
//                }
//            }
//        }
//        else
//        {
//            [CQErrorManager showErrorInfo:error];
//        }
//    }];
}


#pragma mark -

- (UITableView *)groupTableView
{
    if (!_groupTableView) {
        _groupTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _groupTableView.delegate = self;
        _groupTableView.dataSource = self;
        
    }
    return _groupTableView;
}


- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithArray:@[@[@"选择默认头像"],@[@"从手机相册选择",@"拍一张"]]];
    }
    return _dataSource;
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
