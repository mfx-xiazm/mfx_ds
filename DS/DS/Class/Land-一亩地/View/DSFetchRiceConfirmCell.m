//
//  DSFetchRiceConfirmCell.m
//  DS
//
//  Created by huaxin-01 on 2020/8/4.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSFetchRiceConfirmCell.h"
#import "DSGranary.h"

@interface DSFetchRiceConfirmCell ()
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *specs_attrs;
@property (weak, nonatomic) IBOutlet UILabel *fetch_num;

@end
@implementation DSFetchRiceConfirmCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setGoods:(DSGranaryGoods *)goods
{
    _goods = goods;
    self.goods_name.text = [NSString stringWithFormat:@"%@：",_goods.goods_name];
    
    NSMutableString *specs_attrs = [NSMutableString string];
    NSMutableString *fetch_num = [NSMutableString string];
    for (DSGranaryGoodSku *sku in _goods.sku) {
        if (specs_attrs.length) {
            [specs_attrs appendFormat:@"\n%@",sku.specs_attrs];
            [fetch_num appendFormat:@"\n%zd袋",sku.fetch_num];
        }else{
            [specs_attrs appendFormat:@"%@",sku.specs_attrs];
            [fetch_num appendFormat:@"%zd袋",sku.fetch_num];
        }
    }
    [self.specs_attrs setTextWithLineSpace:5.f withString:specs_attrs withFont:[UIFont systemFontOfSize:14]];
    [self.fetch_num setTextWithLineSpace:5.f withString:fetch_num withFont:[UIFont systemFontOfSize:14]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
