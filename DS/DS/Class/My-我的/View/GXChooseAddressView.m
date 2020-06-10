//
//  GXChooseAddressView.m
//  GX
//
//  Created by 夏增明 on 2019/10/2.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GXChooseAddressView.h"
#import "SPPickerView.h"
#import "SPPageMenu.h"
#import "GXAddressCell.h"
#import "GXSelectRegion.h"

static NSString *const AddressCell = @"AddressCell";

@interface GXChooseAddressView ()<SPPickerViewDatasource,SPPickerViewDelegate, SPPageMenuDelegate>
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *pickerContentView;

@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) SPPickerView *pickerView;

@property (nonatomic, assign) NSInteger numerOfComponents;
@end
@implementation GXChooseAddressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 默认1列
        self.numerOfComponents = 1;
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    // 默认1列
    self.numerOfComponents = 1;
    [self.menuView addSubview:self.pageMenu];
    [self.pickerContentView addSubview:self.pickerView];
}
-(void)setRegion:(GXSelectRegion *)region
{
    _region = region;
    
    [self.pickerView sp_reloadAllComponents];
}
- (IBAction)cancelClicked:(UIButton *)sender {
    if (self.lastComponentClickedBlock) {
        self.lastComponentClickedBlock(0,nil);
    }
}
-(void)getRegionRequestWithPid:(NSString *)pid pIndex:(NSInteger)pindex completedCall:(void(^)(void))completedCall
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"pid"] = pid;

    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"address_region_list_get" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if (pindex == 0) {
                strongSelf.region.selectRegion.children = [NSArray yy_modelArrayWithClass:[GXRegionCity class] json:responseObject[@"result"][@"list"]];
            } else if (pindex == 1) {
                strongSelf.region.selectCity.children = [NSArray yy_modelArrayWithClass:[GXRegionArea class] json:responseObject[@"result"][@"list"]];;
            }else {
                strongSelf.region.selectArea.children = [NSArray yy_modelArrayWithClass:[GXRegionDistrict class] json:responseObject[@"result"][@"list"]];;
            }
            completedCall();
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
#pragma mark - SPPageMenuDelegate

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    [self.pickerView sp_scrollToComponent:index atComponentScrollPosition:SPPickerViewComponentScrollPositionDefault animated:YES];
}

#pragma mark - SPPickerViewDatasource,SPPickerViewDelegate
// 返回多少列
- (NSInteger)sp_numberOfComponentsInPickerView:(SPPickerView *)pickerView {
    return self.numerOfComponents;
}

// 每一列返回多少行
- (NSInteger)sp_pickerView:(SPPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.region.regions.count;
    } else if (component == 1) {
        return self.region.selectRegion.children.count;
    } else if (component == 2) {
        return self.region.selectCity.children.count;
    }else {
        return self.region.selectArea.children.count;
    }
}

// 每一列每一行的cell，参数systemCell是系统自带的cell，如果想自定义cell，需要先调用- sp_registerClass: forComponent:方法进行注册
- (UITableViewCell *)sp_pickerView:(SPPickerView *)pickerView cellForRow:(NSInteger)row forComponent:(NSInteger)component systemCell:(UITableViewCell *)systemCell {
    // 从缓存池里取出cell，如果取不到会创建新的
    GXAddressCell *cell = [pickerView sp_dequeueReusableCellAtRow:row atComponent:component];
    if (component == 0) { // 第1列
        GXRegion *province = self.region.regions[row];
        cell.titleLabel.text = province.area_alias;
        cell.titleLabel.textColor = [province.area_alias isEqualToString:self.region.selectRegion.area_alias]?HXControlBg:[UIColor blackColor];
        return cell;
    } else if (component == 1) { // 第2列直接使用系统的cell
        GXRegionCity *city = self.region.selectRegion.children[row];
        cell.titleLabel.text = city.area_alias;
        cell.titleLabel.textColor = [city.area_alias isEqualToString:self.region.selectCity.area_alias]?HXControlBg:[UIColor blackColor];
        return cell;
    }else if (component == 2){// 第3列的cell自定义，xib创建的cell
        GXRegionArea *district = self.region.selectCity.children[row];
        cell.titleLabel.text = district.area_alias;
        cell.titleLabel.textColor = [district.area_alias isEqualToString:self.region.selectArea.area_alias]?HXControlBg:[UIColor blackColor];
        return cell;
    }else{
        GXRegionDistrict *town = self.region.selectArea.children[row];
        cell.titleLabel.text = town.area_alias;
        cell.titleLabel.textColor = [town.area_alias isEqualToString:self.region.selectDistrict.area_alias]?HXControlBg:[UIColor blackColor];
        return cell;
    }
}
// 行高
- (CGFloat)sp_pickerView:(SPPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}
// 行宽
- (CGFloat)sp_pickerView:(SPPickerView *)pickerView rowWidthForComponent:(NSInteger)component {
    return kScreenWidth;
}

// 点击了哪一列的哪一行
- (void)sp_pickerView:(SPPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        self.region.selectRegion = self.region.regions[row];
//        self.selectedCity = [self.selectedProvince.children firstObject];
//        self.selectedDistrict = [self.selectedCity.children firstObject];
        //[self.pickerView sp_reloadComponent:1];
        //[self.pickerView sp_reloadComponent:2];
        
        self.numerOfComponents = 2;
        if (self.region.selectRegion.children.count) {
            [pickerView sp_reloadAllComponents]; // 列数改变一定要刷新所有列才生效
            [self setupPageMenuWithName:self.region.selectRegion.area_alias atComponent:component];
        }else {
            hx_weakify(self);
            [self getRegionRequestWithPid:self.region.selectRegion.area_id pIndex:component completedCall:^{
                hx_strongify(weakSelf);
                [pickerView sp_reloadAllComponents]; // 列数改变一定要刷新所有列才生效
                [strongSelf setupPageMenuWithName:strongSelf.region.selectRegion.area_alias atComponent:component];
            }];
        }
        
    } else if (component == 1) {
        
        self.region.selectCity = self.region.selectRegion.children[row];
//        self.selectedDistrict = [self.selectedCity.children firstObject];
        //[self.pickerView sp_reloadComponent:2];
        self.numerOfComponents = 3;
        if (self.region.selectCity.children.count) {
            [pickerView sp_reloadAllComponents]; // 列数改变一定要刷新所有列才生效
            [self setupPageMenuWithName:self.region.selectCity.area_alias atComponent:component];
        }else {
            hx_weakify(self);
            [self getRegionRequestWithPid:self.region.selectCity.area_id pIndex:component completedCall:^{
                hx_strongify(weakSelf);
                [pickerView sp_reloadAllComponents]; // 列数改变一定要刷新所有列才生效
                [strongSelf setupPageMenuWithName:strongSelf.region.selectCity.area_alias atComponent:component];
            }];
        }

//        if (self.region.selectCity.children.count) {
//            self.numerOfComponents = 3;
//            [pickerView sp_reloadAllComponents]; // 列数改变一定要刷新所有列才生效
//            [self setupPageMenuWithName:self.region.selectCity.area_alias atComponent:component];
//        }else{
//            [self.pageMenu setTitle:self.region.selectCity.area_alias forItemAtIndex:component];
//
//            [pickerView sp_reloadAllComponents]; // 列数改变一定要刷新所有列才生效
//
//            self.pageMenu.selectedItemIndex = component;
//
//            if (self.lastComponentClickedBlock) {
//                self.lastComponentClickedBlock(1,self.region);
//            }
//        }
    }else  if (component == 2){
        self.region.selectArea = self.region.selectCity.children[row];
        
        self.numerOfComponents = 4;
        if (self.region.selectArea.children.count) {
            [pickerView sp_reloadAllComponents]; // 列数改变一定要刷新所有列才生效
            [self setupPageMenuWithName:self.region.selectArea.area_alias atComponent:component];
        }else {
            hx_weakify(self);
            [self getRegionRequestWithPid:self.region.selectArea.area_id pIndex:component completedCall:^{
                hx_strongify(weakSelf);
                [pickerView sp_reloadAllComponents]; // 列数改变一定要刷新所有列才生效
                [strongSelf setupPageMenuWithName:strongSelf.region.selectArea.area_alias atComponent:component];
            }];
        }
        
//        if (self.region.selectCity.children.count) {
//            self.numerOfComponents = 4;
//            [pickerView sp_reloadAllComponents]; // 列数改变一定要刷新所有列才生效
//
//            [self setupPageMenuWithName:self.region.selectArea.area_alias atComponent:component];
//        }else{
//            [self.pageMenu setTitle:self.region.selectArea.area_alias forItemAtIndex:component];
//
//            [pickerView sp_reloadAllComponents]; // 列数改变一定要刷新所有列才生效
//
//            self.pageMenu.selectedItemIndex = component;
//
//            if (self.lastComponentClickedBlock) {
//                self.lastComponentClickedBlock(1,self.region);
//            }
//        }
    }else{
        self.region.selectDistrict = self.region.selectArea.children[row];
        
        [self.pageMenu setTitle:self.region.selectDistrict.area_alias forItemAtIndex:component];
        
        [pickerView sp_reloadComponent:component]; // 刷新当前列

        self.pageMenu.selectedItemIndex = component;

        if (self.lastComponentClickedBlock) {
            self.lastComponentClickedBlock(1,self.region);
        }
    }
}

- (void)setupPageMenuWithName:(NSString *)name atComponent:(NSInteger)component {
    NSString *title = [self.pageMenu titleForItemAtIndex:component];
    if ([title isEqualToString:@"请选择"]) {
        [self.pageMenu insertItemWithTitle:name atIndex:component animated:YES];
    } else {
        // 改变当前item的标题
        [self.pageMenu setTitle:name forItemAtIndex:component];
        // 将下一个置为“请选择”
        [self.pageMenu setTitle:@"请选择" forItemAtIndex:component+1];
        NSInteger itemCount = (self.pageMenu.numberOfItems-1);
        // 保留2个item，2个之后的全部删除
        for (int i = 0; i < itemCount-(component+1); i++) {
            [self.pageMenu removeItemAtIndex:self.pageMenu.numberOfItems-1 animated:YES];
        }
    }
    // 切换选中的item，会执行pageMenu的代理方法，
    self.pageMenu.selectedItemIndex = component+1;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.pageMenu.frame = self.menuView.bounds;
    self.pickerView.frame = self.pickerContentView.bounds;
}

- (SPPageMenu *)pageMenu {
    if (!_pageMenu) {
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectZero trackerStyle:SPPageMenuTrackerStyleLine];
        _pageMenu.backgroundColor = HXGlobalBg;
        _pageMenu.delegate = self;
        _pageMenu.dividingLine.backgroundColor = [UIColor clearColor];
        _pageMenu.tracker.backgroundColor = HXControlBg;
        [_pageMenu setItems:@[@"请选择"] selectedItemIndex:0];
        _pageMenu.itemTitleFont = [UIFont systemFontOfSize:14];
        _pageMenu.selectedItemTitleColor = HXControlBg;
        _pageMenu.unSelectedItemTitleColor = [UIColor blackColor];
        [_pageMenu setTrackerHeight:1 cornerRadius:0];
        _pageMenu.itemPadding = 30;
        _pageMenu.bridgeScrollView = self.pickerView.scrollView;
    }
    return  _pageMenu;
}
- (SPPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[SPPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        
        // 以下代码都可以放在设置代理之前
        [_pickerView sp_registerNib:[UINib nibWithNibName:NSStringFromClass([GXAddressCell class]) bundle:nil] forComponent:0]; // 注册第0列cell,xib
        [_pickerView sp_registerNib:[UINib nibWithNibName:NSStringFromClass([GXAddressCell class]) bundle:nil] forComponent:1]; // 注册第1列cell,xib
        [_pickerView sp_registerNib:[UINib nibWithNibName:NSStringFromClass([GXAddressCell class]) bundle:nil] forComponent:2]; // 注册第2列cell,xib
        [_pickerView sp_registerNib:[UINib nibWithNibName:NSStringFromClass([GXAddressCell class]) bundle:nil] forComponent:3]; // 注册第3列cell,xib

        //        [_pickerView sp_hideSeparatorLineForAllComponentls];
        //        [_pickerView sp_hideSeparatorLineForComponent:1];
        //        [_pickerView sp_showsVerticalScrollIndicatorForAllComponentls];
        //        [_pickerView sp_showsVerticalScrollIndicatorForComponent:2];
    }
    return  _pickerView;
}
@end
