//
//  DSPublishDynamicVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSPublishDynamicVC.h"
#import "DSPublishDynamicCell.h"
#import "DSPublishDynamicHeader.h"
#import "DSPuslishDynamicData.h"
#import "DSPublishDynamicFooter.h"
#import <ZLPhotoActionSheet.h>
#import <AFNetworking.h>

static NSString *const PublishDynamicCell = @"PublishDynamicCell";
@interface DSPublishDynamicVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
/** tableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 发布数据 */
@property (nonatomic,strong) NSMutableArray *publishData;
/* 头视图 */
@property(nonatomic,strong) DSPublishDynamicHeader *header;
/* 尾视图 */
@property(nonatomic,strong) DSPublishDynamicFooter *footer;
@end

@implementation DSPublishDynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"发布动态"];
    self.hbd_barStyle = UIBarStyleDefault;
    self.hbd_barTintColor = [UIColor whiteColor];
    self.hbd_tintColor = [UIColor blackColor];
    self.hbd_barShadowHidden = NO;
    self.hbd_titleTextAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName: [UIColor.blackColor colorWithAlphaComponent:1.0]};
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(publishClicked) title:@"发布" font:[UIFont systemFontOfSize:15] titleColor:HXControlBg highlightedColor:HXControlBg titleEdgeInsets:UIEdgeInsetsZero];
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 50.f);
    self.footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 50.f);
}
- (ZLPhotoActionSheet *)getPas
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    /**
     导航条颜色
     */
    actionSheet.configuration.navBarColor = HXControlBg;
    actionSheet.configuration.bottomViewBgColor = HXControlBg;
    actionSheet.configuration.indexLabelBgColor = HXControlBg;
    // -- optional
    //以下参数为自定义参数，均可不设置，有默认值
    /**
     是否升序排列，预览界面不受该参数影响，默认升序 YES
     */
    actionSheet.configuration.sortAscending = NO;
    /**
     是否允许选择照片 默认YES (为NO只能选择视频)
     */
    actionSheet.configuration.allowSelectImage = YES;
    /**
     是否允许选择Gif，只是控制是否选择，并不控制是否显示，如果为NO，则不显示gif标识 默认YES （此属性与是否允许选择照片相关联，如果可以允许选择照片那就会展示gif[前提是照片中存在gif]）
     */
    actionSheet.configuration.allowSelectGif = NO;
    /**
     * 是否允许选择Live Photo，只是控制是否选择，并不控制是否显示，如果为NO，则不显示Live Photo标识 默认NO
     * @warning ios9 以上系统支持 （备注同上）
     */
    actionSheet.configuration.allowSelectLivePhoto = NO;
    /**
     是否允许相册内部拍照 ，设置相册内部显示拍照按钮 默认YES
     */
    actionSheet.configuration.allowTakePhotoInLibrary = YES;
    /**
     是否在相册内部拍照按钮上面实时显示相机俘获的影像 默认 YES
     */
    actionSheet.configuration.showCaptureImageOnTakePhotoBtn = YES;
    /**
     是否允许编辑图片，选择一张时候才允许编辑，默认YES
     */
    actionSheet.configuration.allowEditImage = YES;
    /**
     是否允许选择视频 默认YES
     */
    actionSheet.configuration.allowSelectVideo = NO;
    /**
     是否允许滑动选择 默认 YES （预览界面不受该参数影响）
     */
    actionSheet.configuration.allowSlideSelect = YES;
    /**
     编辑图片后是否保存编辑后的图片至相册，默认YES
     */
    actionSheet.configuration.saveNewImageAfterEdit = NO;
    /**
     设置照片最大选择数 默认10张
     */
    actionSheet.configuration.maxSelectCount = 9;
    /**
     回调时候是否允许框架解析图片，默认YES
     
     如果选择了大量图片，框架一下解析大量图片会耗费一些内存，开发者此时可置为NO，拿到assets数组后自行解析，该值为NO时，回调的图片数组为nil
     */
    actionSheet.configuration.shouldAnialysisAsset = YES;
    /**
     是否允许录制视频(当useSystemCamera为YES时无效)，默认YES
     */
    actionSheet.configuration.allowRecordVideo = NO;
    // -- required
    /**
     必要参数！required！ 如果调用的方法没有传sender，则该属性必须提前赋值
     */
    actionSheet.sender = self;
    
    /**
     选择照片回调，回调解析好的图片、对应的asset对象、是否原图
     pod 2.2.6版本之后 统一通过selectImageBlock回调
     */
    @zl_weakify(self);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        @zl_strongify(self);
        for (UIImage *image in images) {
            DSPuslishDynamicData *pd = [[DSPuslishDynamicData alloc] init];
            pd.uiStyle = DSPuslishDynamicPicture;
            pd.picture = image;
            [self.publishData addObject:pd];
        }
        [self.tableView reloadData];
        
    }];
    return actionSheet;
}
-(DSPublishDynamicHeader *)header
{
    if (_header == nil) {
        _header = [DSPublishDynamicHeader loadXibView];
        _header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 50.f);
    }
    return _header;
}
-(DSPublishDynamicFooter *)footer
{
    if (_footer == nil) {
        _footer = [DSPublishDynamicFooter loadXibView];
        _footer.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 50.f);
        hx_weakify(self);
        _footer.footerHandleCall = ^(NSInteger index,UIButton *btn) {
            hx_strongify(weakSelf);
            if (index == 1) {
                DSPuslishDynamicData *pt = [[DSPuslishDynamicData alloc] init];
                pt.uiStyle = DSPuslishDynamicWord;
                [strongSelf.publishData addObject:pt];
                [strongSelf.tableView reloadData];
            }else if (index == 2) {
                ZLPhotoActionSheet *a = [strongSelf getPas];
                [a showPhotoLibrary];
            }else{
//                [btn BindingBtnJudgeBlock:^BOOL{
//                    if (![strongSelf.header.dynamicTitle hasText]){
//                        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入标题"];
//                        return NO;
//                    }
//                    if (!strongSelf.publishData.count) {
//                        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"至少要有一条内容"];
//                        return NO;
//                    }
//                    NSMutableArray *tempData = [NSMutableArray arrayWithArray:strongSelf.publishData];
//                    [strongSelf.publishData enumerateObjectsUsingBlock:^(DSPuslishDynamicData *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                        if (obj.uiStyle == DSPuslishDynamicWord && !obj.word.length) {
//                            [tempData removeObject:obj];
//                        }
//                    }];
//                    if (!tempData.count) {
//                        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"至少要有一条内容"];
//                        return NO;
//                    }
//                    return YES;
//                } ActionBlock:^(UIButton * _Nullable button) {
//                    hx_strongify(weakSelf);
//                    [strongSelf publishClicked:button];
//                }];
            }
        };
    }
    return _footer;
}
-(NSMutableArray *)publishData
{
    if (_publishData == nil) {
        _publishData = [NSMutableArray array];
        DSPuslishDynamicData *pt = [[DSPuslishDynamicData alloc] init];
        pt.uiStyle = DSPuslishDynamicWord;
        [_publishData addObject:pt];
    }
    return _publishData;
}
#pragma mark -- 视图相关
/**
 初始化tableView
 */
-(void)setUpTableView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DSPublishDynamicCell class]) bundle:nil] forCellReuseIdentifier:PublishDynamicCell];
    
    self.tableView.tableHeaderView = self.header;
    self.tableView.tableFooterView = self.footer;
}
#pragma mark --  点击
-(void)publishClicked
{
    if (![self.header.dynamicTitle hasText]){
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入标题"];
        return;
    }
    if (!self.publishData.count) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"至少要有一条内容"];
        return;
    }
    NSMutableArray *tempData = [NSMutableArray arrayWithArray:self.publishData];
    [self.publishData enumerateObjectsUsingBlock:^(DSPuslishDynamicData *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.uiStyle == DSPuslishDynamicWord && !obj.word.length) {
            [tempData removeObject:obj];
        }
    }];
    if (!tempData.count) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"至少要有一条内容"];
        return;
    }
    
    NSMutableArray *images = [NSMutableArray array];
    [self.publishData enumerateObjectsUsingBlock:^(DSPuslishDynamicData *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.uiStyle == DSPuslishDynamicPicture && obj.picture) {
            [images addObject:obj];
        }
    }];
    if (images.count) {
        hx_weakify(self);
        [self runUpLoadImages:images handle:^{
            hx_strongify(weakSelf);
            [strongSelf publishRequest:^(BOOL isSuccess) {
                if (isSuccess) {
                    if (strongSelf.publishActionCall) {
                        strongSelf.publishActionCall();
                    }
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                }
            }];
        }];
    }else{
        hx_weakify(self);
        [self publishRequest:^(BOOL isSuccess) {
            hx_strongify(weakSelf);
            if (isSuccess) {
                if (strongSelf.publishActionCall) {
                    strongSelf.publishActionCall();
                }
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}
#pragma mark -- 业务逻辑
/**
 *  图片批量上传方法
 */
- (void)runUpLoadImages:(NSMutableArray *)imageArr handle:(void(^)(void))completeandle
{
    // 准备保存结果的数组，元素个数与上传的图片个数相同，先用 NSNull 占位
    NSMutableArray* result = [NSMutableArray array];
    for (int i=0;i<imageArr.count;i++) {
        [result addObject:[NSNull null]];
    }
    
    // 生成一个请求组
    dispatch_group_t group = dispatch_group_create();
    for (NSInteger i = 0; i < imageArr.count; i++) {
        DSPuslishDynamicData *pt = imageArr[i];
        dispatch_group_enter(group);
        NSURLSessionUploadTask* uploadTask = [self uploadTaskWithImage:pt.picture completion:^(NSURLResponse *response, NSDictionary* responseObject, NSError *error) {
            if (error) {
                //HXLog(@"第 %d 张图片上传失败: %@", (int)i + 1, error);
                dispatch_group_leave(group);
            } else {
                //HXLog(@"第 %d 张图片上传成功: %@", (int)i + 1, responseObject);
                @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                    NSString *state = [NSString stringWithFormat:@"%@",responseObject[@"status"]];
                    if ([state isEqualToString:@"1"]){
                        // 将上传完成返回的图片链接存入数组
                        NSDictionary *dict = ((NSArray *)responseObject[@"result"]).firstObject;
                        pt.word = [NSString stringWithFormat:@"%@",dict[@"relative_url"]];
                    }else{
                        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
                    }
                }
                dispatch_group_leave(group);
            }
        }];
        [uploadTask resume];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //HXLog(@"上传完成!");
        completeandle();// 完成回调
    });
}
/**
 *  生成图片批量上传的上传请求方法
 *
 *  @param image           上传的图片
 *  @param completionBlock 包装成的请求回调
 *
 *  @return 上传请求
 */

- (NSURLSessionUploadTask*)uploadTaskWithImage:(UIImage*)image completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock {
    // 上传接口参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = [MSUserManager sharedInstance].curUserInfo.token;

    // 构造 NSURLRequest
    NSError* error = NULL;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@",HXRC_M_URL,@"multifileupload"] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //把本地的图片转换为NSData类型的数据
        NSData* imageData = UIImageJPEGRepresentation(image, 0.6);
        [formData appendPartWithFileData:imageData name:@"filename" fileName:@"file.jpg" mimeType:@"image/jpeg"];
    } error:&error];
    
    // 可在此处配置验证信息
    // 将 NSURLRequest 与 completionBlock 包装为 NSURLSessionUploadTask
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
    } completionHandler:completionBlock];
    
    return uploadTask;
}
-(void)publishRequest:(void(^)(BOOL))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"treads_title"] = self.header.dynamicTitle.text;//帖子标题
    
    NSMutableArray *uploadArr = [NSMutableArray arrayWithCapacity:0];
    for (DSPuslishDynamicData *pt in self.publishData){
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithCapacity:0];
        if(pt.word.length) {
            if (pt.uiStyle == DSPuslishDynamicWord){
                [tempDict setObject:@"1" forKey:@"type"];
                [tempDict setObject:pt.word forKey:@"content"];
            }else{
                [tempDict setObject:@"2" forKey:@"type"];
                [tempDict setObject:pt.word forKey:@"content"];
            }
            [uploadArr addObject:tempDict];
        }
    }
    if (uploadArr != nil){
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:uploadArr options:NSJSONWritingPrettyPrinted error:&parseError];
        parameters[@"treads_content"] = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        parameters[@"treads_content"] = @"";
    }
    
    [HXNetworkTool POST:HXRC_M_URL action:@"treads_set" parameters:parameters success:^(id responseObject) {
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"发布成功"];
            completedCall(YES);
        }else{
            completedCall(NO);
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.publishData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSPublishDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:PublishDynamicCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DSPuslishDynamicData *pd = self.publishData[indexPath.row];
    cell.pd = pd;
    hx_weakify(self);
    cell.deleteCallBack = ^{
        hx_strongify(weakSelf);
        [strongSelf.publishData removeObject:pd];
        [tableView reloadData];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    DSPuslishDynamicData *pt = self.publishData[indexPath.row];
    if (pt.uiStyle == DSPuslishDynamicWord) {
        return 10.f + 150.f;
    }else{
        return 10.f + 90.f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
