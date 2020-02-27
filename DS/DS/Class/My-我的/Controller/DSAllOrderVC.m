//
//  DSAllOrderVC.m
//  DS
//
//  Created by 夏增明 on 2020/2/17.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSAllOrderVC.h"
#import "DSMyAfterOrderVC.h"
#import "DSMyOrderVC.h"
#import "UIView+WZLBadge.h"

@interface DSAllOrderVC ()
@property (weak, nonatomic) IBOutlet UIImageView *noPayItem;
@property (weak, nonatomic) IBOutlet UIImageView *noDeItem;
@property (weak, nonatomic) IBOutlet UIImageView *noTakeItem;
@property (weak, nonatomic) IBOutlet UIImageView *completedItem;
@property (weak, nonatomic) IBOutlet UIImageView *refundItem;
@end

@implementation DSAllOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"全部订单"];
    self.noPayItem.badgeBgColor = HXControlBg;
    self.noDeItem.badgeBgColor = HXControlBg;
    self.noTakeItem.badgeBgColor = HXControlBg;
    self.completedItem.badgeBgColor = HXControlBg;
    self.refundItem.badgeBgColor = HXControlBg;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getOrderNumRequest];
}
-(void)getOrderNumRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"all_order_statics_get" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if ([responseObject[@"result"][@"orderCnt"] isKindOfClass:[NSArray class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray *arr = [NSArray arrayWithArray:responseObject[@"result"][@"orderCnt"]];
                    for (NSDictionary *dict in arr) {
                        if ([dict[@"status"] isEqualToString:@"待付款"]) {
                            [strongSelf.noPayItem showBadgeWithStyle:WBadgeStyleNumber value:[dict[@"cnt"] integerValue] animationType:WBadgeAnimTypeNone];
                        }else if ([dict[@"status"] isEqualToString:@"待发货"]) {
                            [strongSelf.noDeItem showBadgeWithStyle:WBadgeStyleNumber value:[dict[@"cnt"] integerValue] animationType:WBadgeAnimTypeNone];
                        }else if ([dict[@"status"] isEqualToString:@"待收货"]) {
                            [strongSelf.noTakeItem showBadgeWithStyle:WBadgeStyleNumber value:[dict[@"cnt"] integerValue] animationType:WBadgeAnimTypeNone];
                        }else if ([dict[@"status"] isEqualToString:@"已完成"]) {
                            [strongSelf.completedItem showBadgeWithStyle:WBadgeStyleNumber value:[dict[@"cnt"] integerValue] animationType:WBadgeAnimTypeNone];
                        }else{
                            [strongSelf.refundItem showBadgeWithStyle:WBadgeStyleNumber value:[dict[@"cnt"] integerValue] animationType:WBadgeAnimTypeNone];
                        }
                    }
                });
            }
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
- (IBAction)myOrderClicked:(UIButton *)sender {
    if (sender.tag == 5){
        DSMyAfterOrderVC *dvc = [DSMyAfterOrderVC new];
        [self.navigationController pushViewController:dvc animated:YES];
    }else{
        DSMyOrderVC *ovc = [DSMyOrderVC new];
        ovc.selectIndex = sender.tag;
        [self.navigationController pushViewController:ovc animated:YES];
    }
}

@end
