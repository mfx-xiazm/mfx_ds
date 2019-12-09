//
//  DSApplyRefundVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSApplyRefundVC.h"
#import "DSBannerCell.h"
#import "DSApplyRefundCell.h"
#import <ZLCollectionViewVerticalLayout.h>
#import <ZLPhotoActionSheet.h>
#import <AFNetworking.h>

static NSString *const ApplyRefundCell = @"ApplyRefundCell";
@interface DSApplyRefundVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/** 已选择的数组 */
@property (nonatomic,strong) NSMutableArray *selectedAssets;
/** 已选择的数组 */
@property (nonatomic,strong) NSMutableArray *selectedPhotos;
/** 是否原图 */
@property (nonatomic, assign) BOOL isOriginal;
/** 模型数组 */
@property (nonatomic,strong) NSMutableArray *showData;
@end

@implementation DSApplyRefundVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"申请退款"];
    [self setUpCollectionView];
}
-(NSMutableArray *)showData
{
    if (_showData == nil) {
        _showData = [NSMutableArray array];
    }
    return _showData;
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
     是否允许相册内部拍照 ，设置相册内部显示拍照按钮 默认YES
     */
    actionSheet.configuration.allowTakePhotoInLibrary = YES;
    /**
     是否在相册内部拍照按钮上面实时显示相机俘获的影像 默认 YES
     */
    actionSheet.configuration.showCaptureImageOnTakePhotoBtn = NO;
    /**
     是否允许滑动选择 默认 YES （预览界面不受该参数影响）
     */
    actionSheet.configuration.allowSlideSelect = YES;
    /**
     编辑图片后是否保存编辑后的图片至相册，默认YES
     */
    actionSheet.configuration.saveNewImageAfterEdit = NO;
    
    /**
     回调时候是否允许框架解析图片，默认YES
     如果选择了大量图片，框架一下解析大量图片会耗费一些内存，开发者此时可置为NO，拿到assets数组后自行解析，该值为NO时，回调的图片数组为nil
     */
    actionSheet.configuration.shouldAnialysisAsset = YES;
    
    /**
     是否允许选择照片 默认YES (为NO只能选择视频)
     */
    actionSheet.configuration.allowSelectImage = YES;
    /**
     是否允许选择视频 默认YES
     */
    actionSheet.configuration.allowSelectVideo = NO;
    /**
     是否允许选择Gif，只是控制是否选择，并不控制是否显示，如果为NO，则不显示gif标识 默认YES （此属性与是否允许选择照片相关联，如果可以允许选择照片那就会展示gif[前提是照片中存在gif]）
     */
    actionSheet.configuration.allowSelectGif = NO;
    /**
     是否允许编辑图片，选择一张时候才允许编辑，默认YES
     */
    actionSheet.configuration.allowEditImage = YES;
    /**
     是否允许录制视频(当useSystemCamera为YES时无效)，默认YES
     */
    actionSheet.configuration.allowRecordVideo = NO;
    /**
     设置照片最大选择数 默认10张
     */
    actionSheet.configuration.maxSelectCount = 4;
    
    // -- required
    /**
     必要参数！required！ 如果调用的方法没有传sender，则该属性必须提前赋值
     */
    actionSheet.sender = self;
    /**
     已选择的图片数组
     */
    actionSheet.arrSelectedAssets = self.selectedAssets;
    /**
     选择照片回调，回调解析好的图片、对应的asset对象、是否原图
     pod 2.2.6版本之后 统一通过selectImageBlock回调
     */
    @zl_weakify(self);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        @zl_strongify(self);
        [self.showData removeAllObjects];
        [self.showData addObjectsFromArray:images];
        
        self.selectedAssets = assets.mutableCopy;
        self.isOriginal = isOriginal;
        self.selectedPhotos = images.mutableCopy;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
    return actionSheet;
}
-(void)setUpCollectionView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    flowLayout.header_suspension = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DSApplyRefundCell class]) bundle:nil] forCellWithReuseIdentifier:ApplyRefundCell];
}
#pragma mark -- 点击事件
- (IBAction)upLoadClicked:(UIButton *)sender {
    [[self getPas] showPhotoLibrary];
}
-(void)submitBtnClicked:(UIButton *)btn
{
    if (self.showData.count >1) {
        hx_weakify(self);
        [self runUpLoadImages:self.showData completedCall:^(NSMutableArray *result) {
            hx_strongify(weakSelf);
            [strongSelf submitSuggestRequest:btn imageUrls:result];
        }];
    }else{
        [self submitSuggestRequest:btn imageUrls:nil];
    }
}
#pragma mark -- 接口
-(void)submitSuggestRequest:(UIButton *)btn imageUrls:(NSArray *)imageUrls
{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"suggestion_type"] = self.selectType.suggestion_type;//反馈类型
//    parameters[@"suggestion_content"] = self.remarkText.text;//反馈内容
//    if (imageUrls) {
//        parameters[@"suggestion_imgs"] = [imageUrls componentsJoinedByString:@","];//建议图片多个用逗号隔开
//    }else{
//        parameters[@"suggestion_imgs"] = @"";//建议图片多个用逗号隔开
//    }
//
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:@"admin/submitSuggest" parameters:parameters success:^(id responseObject) {
//        hx_strongify(weakSelf);
//        [btn stopLoading:@"提交" image:nil textColor:nil backgroundColor:nil];
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//            [strongSelf.navigationController popViewControllerAnimated:YES];
//        }else{
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        [btn stopLoading:@"提交" image:nil textColor:nil backgroundColor:nil];
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//    }];
}
-(void)getSuggestTypeRequest
{
//    hx_weakify(self);
//    [HXNetworkTool POST:HXRC_M_URL action:@"admin/getSuggestType" parameters:@{} success:^(id responseObject) {
//        hx_strongify(weakSelf);
//        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
//            strongSelf.suggestionTypes = [NSArray yy_modelArrayWithClass:[GXSuggestionType class] json:responseObject[@"data"]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [strongSelf.typeCollectionView reloadData];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    strongSelf.typeViewHeight.constant = 35.f + strongSelf.typeCollectionView.contentSize.height;
//                });
//            });
//        }else{
//            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
//    }];
}
/**
 *  图片批量上传方法
 */
- (void)runUpLoadImages:(NSArray *)imageArr completedCall:(void(^)(NSMutableArray* result))completedCall{
    // 需要上传的图片数据imageArr
    
    // 准备保存结果的数组，元素个数与上传的图片个数相同，先用 NSNull 占位
    NSMutableArray* result = [NSMutableArray array];
    for (int i=0;i<imageArr.count;i++) {
        [result addObject:[NSNull null]];
    }
    // 生成一个请求组
    dispatch_group_t group = dispatch_group_create();
    for (NSInteger i = 0; i < imageArr.count; i++) {
        dispatch_group_enter(group);
        NSURLSessionUploadTask *uploadTask = [self uploadTaskWithImage:imageArr[i] completion:^(NSURLResponse *response, NSDictionary* responseObject, NSError *error) {
            if (error) {
                // CBLog(@"第 %d 张图片上传失败: %@", (int)i + 1, error);
                dispatch_group_leave(group);
            } else {
                //CBLog(@"第 %d 张图片上传成功: %@", (int)i + 1, responseObject);
                @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                    if ([responseObject[@"status"] boolValue]){
                        // 将上传完成返回的图片链接存入数组
                        result[i] = responseObject[@"data"][@"path"];
                    }else{
                        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
                    }
                }
                dispatch_group_leave(group);
            }
        }];
        [uploadTask resume];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //HXLog(@"上传完成!");
        if (completedCall) {
            completedCall(result);//将图片链接数组传入
        }
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
    // 构造 NSURLRequest
    NSError* error = NULL;
    
    AFHTTPSessionManager *HTTPmanager = [AFHTTPSessionManager manager];
    //    HTTPmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    NSMutableURLRequest *request = [HTTPmanager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@admin/uploadFile",HXRC_M_URL]  parameters:@{} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //把本地的图片转换为NSData类型的数据
        NSData* imageData = UIImageJPEGRepresentation(image, 0.8);
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"file.png" mimeType:@"image/png"];
    } error:&error];
    
    // 可在此处配置验证信息
    // 将 NSURLRequest 与 completionBlock 包装为 NSURLSessionUploadTask
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
    } completionHandler:completionBlock];
    
    return uploadTask;
}

#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.showData.count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section {
    return ClosedLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section {
    return 4;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DSApplyRefundCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ApplyRefundCell forIndexPath:indexPath];
    cell.photoImg.image = self.showData[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    
    [[self getPas] previewSelectedPhotos:self.selectedPhotos assets:self.selectedAssets index:indexPath.row isOriginal:self.isOriginal];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (collectionView.hxn_width-10*4.f)/4.0;
    CGFloat height = width;
    return CGSizeMake(width, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(10, 0, 10, 10);
}

@end
