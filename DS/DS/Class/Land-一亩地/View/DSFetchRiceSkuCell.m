//
//  DSFetchRiceSkuCell.m
//  DS
//
//  Created by huaxin-01 on 2020/8/4.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSFetchRiceSkuCell.h"
#import "DSGranary.h"

@interface DSFetchRiceSkuCell()
@property (weak, nonatomic) IBOutlet UITextField *numField;
@property (weak, nonatomic) IBOutlet UILabel *specs_attrs;

@end
@implementation DSFetchRiceSkuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setSku:(DSGranaryGoodSku *)sku
{
    _sku = sku;
    self.specs_attrs.text = _sku.specs_attrs;
    self.numField.text = [NSString stringWithFormat:@"%zd",_sku.fetch_num];
}
- (IBAction)addClicked:(UIButton *)sender {
    if ([self.numField.text integerValue]+1 > _sku.stock) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"库存不足"];
        return;
    }
    self.numField.text = [NSString stringWithFormat:@"%zd",[self.numField.text integerValue]+1];
    self.sku.fetch_num = [self.numField.text intValue];
    if (self.fetchNumCall) {
        self.fetchNumCall();
    }
}
- (IBAction)cutClicked:(UIButton *)sender {
    if ([self.numField.text isEqualToString:@"0"]) {
        return;
    }
    self.numField.text = [NSString stringWithFormat:@"%zd",[self.numField.text integerValue]-1];
    self.sku.fetch_num = [self.numField.text intValue];
    if (self.fetchNumCall) {
        self.fetchNumCall();
    }
}
@end
