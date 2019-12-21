//
//  DSHomeCateVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSHomeCateVC.h"
#import "DSCateGoodsChildVC.h"
#import <JXCategoryTitleView.h>
#import <JXCategoryIndicatorLineView.h>
#import "DSHomeData.h"

@interface DSHomeCateVC ()<JXCategoryViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet JXCategoryTitleView *categoryView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/** 子控制器数组 */
@property (nonatomic,strong) NSArray *childVCs;
/* 二级分类 */
@property(nonatomic,strong) NSArray *subCates;
@end

@implementation DSHomeCateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"商品列表"];
    [self setUpCategoryView];
    [self startShimmer];
    [self getSubCateRequest];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
    //self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
-(NSArray *)childVCs
{
    if (_childVCs == nil) {
        NSMutableArray *vcs = [NSMutableArray array];
        for (int i=0;i<self.categoryView.titles.count;i++) {
            DSCateGoodsChildVC *cvc0 = [DSCateGoodsChildVC new];
            DSHomeCate *cate = self.subCates[i];
            cvc0.cate_id = cate.cate_id;
            cvc0.cate_mode = cate.cate_mode;
            [self addChildViewController:cvc0];
            [vcs addObject:cvc0];
        }
        _childVCs = vcs;
    }
    return _childVCs;
}
-(void)setUpCategoryView
{
    _categoryView.backgroundColor = [UIColor whiteColor];
    _categoryView.titleLabelZoomEnabled = NO;
    _categoryView.titleFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    _categoryView.titleColor = [UIColor blackColor];
    _categoryView.titleSelectedColor = HXControlBg;
//    _categoryView.defaultSelectedIndex = self.selectIndex;
    _categoryView.delegate = self;
    _categoryView.contentScrollView = self.scrollView;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.verticalMargin = 5.f;
    lineView.indicatorColor = HXControlBg;
    _categoryView.indicators = @[lineView];
    
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
}
#pragma mark - JXCategoryViewDelegate
// 滚动和点击选中
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index
{
    // 处理侧滑手势
    //self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    
    if (self.childVCs.count <= index) {return;}
    
    UIViewController *targetViewController = self.childVCs[index];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(HX_SCREEN_WIDTH * index, 0, HX_SCREEN_WIDTH, self.scrollView.hxn_height);
    
    [self.scrollView addSubview:targetViewController.view];
}
#pragma mark -- 接口获取二级分类
-(void)getSubCateRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"cate_id"] = self.cate_id;//一级分类id
    parameters[@"cate_mode"] = self.cate_mode;//分类方式：1袋鼠自营商品分类；2京东自营商品分类；3京东联盟商品分类；4淘宝商品分类

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"sub_cate_get" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"status"] integerValue] == 1) {
            strongSelf.subCates = [NSArray yy_modelArrayWithClass:[DSHomeCate class] json:responseObject[@"result"][@"sub_cate"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableArray *titles = [NSMutableArray array];
                for (DSHomeCate *cate in strongSelf.subCates) {
                    [titles addObject:cate.cate_name];
                }
                strongSelf.categoryView.titles = titles;
                [strongSelf.categoryView reloadData];
                
                strongSelf.scrollView.contentSize = CGSizeMake(HX_SCREEN_WIDTH*strongSelf.childVCs.count, 0);
                
                // 加第一个视图
                UIViewController *targetViewController = strongSelf.childVCs.firstObject;
                targetViewController.view.frame = CGRectMake(0, 0, HX_SCREEN_WIDTH, strongSelf.scrollView.hxn_height);
                [strongSelf.scrollView addSubview:targetViewController.view];
            });
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
@end
