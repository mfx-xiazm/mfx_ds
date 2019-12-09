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
    [self setUpTableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.header.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 50.f);
    self.footer.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 130.f);
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
        _footer.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, 130.f);
        hx_weakify(self);
        _footer.footerHandleCall = ^(NSInteger index) {
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
                HXLog(@"发布");
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
