//
//  DSCashNoteDetailVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSCashNoteDetailVC.h"
#import "DSCashNoteDetail.h"

@interface DSCashNoteDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *apply_amount;
@property (weak, nonatomic) IBOutlet UILabel *deail_info;
@property (weak, nonatomic) IBOutlet UILabel *apply_status;
/* 详情 */
@property(nonatomic,strong) DSCashNoteDetail *noteDetail;
@end

@implementation DSCashNoteDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"记录详情"];
    [self startShimmer];
    [self getCashDetailRequest];
}

-(void)getCashDetailRequest
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"finance_apply_id"] = self.finance_apply_id;//提现id
   
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"apply_detail_get" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [strongSelf stopShimmer];
        if ([responseObject[@"status"] integerValue] == 1) {
            strongSelf.noteDetail = [DSCashNoteDetail yy_modelWithDictionary:responseObject[@"result"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf showNoteDetailInfo];
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
-(void)showNoteDetailInfo
{
    self.apply_amount.text = [NSString stringWithFormat:@"提现￥%@",self.noteDetail.apply_amount];
    if ([self.noteDetail.apply_status isEqualToString:@"1"]) {
        self.apply_status.text = @"待审核";
    }else if ([self.noteDetail.apply_status isEqualToString:@"2"]) {
        self.apply_status.text = @"已通过";
    }else{
        self.apply_status.text = @"未通过";
    }
    
    [self.deail_info setTextWithLineSpace:5.f withString:[NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",self.noteDetail.apply_no,self.noteDetail.create_time,self.noteDetail.bank_name,self.noteDetail.card_no,self.noteDetail.card_owner] withFont:[UIFont systemFontOfSize:13]];
}
@end
