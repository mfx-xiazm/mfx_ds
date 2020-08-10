//
//  DSChooseClassCell.m
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSChooseClassCell.h"
#import "DSGoodsDetail.h"
#import "DSLandDetail.h"

@interface DSChooseClassCell ()
@property (weak, nonatomic) IBOutlet UILabel *spec_name;

@end
@implementation DSChooseClassCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setAttrs:(DSGoodsAttrs *)attrs
{
    _attrs = attrs;
    self.spec_name.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    self.spec_name.layer.cornerRadius = 15.f;
    self.spec_name.layer.masksToBounds = YES;
    self.spec_name.text = _attrs.attr_name;
    if (_attrs.isSelected) {
        self.spec_name.textColor = [UIColor whiteColor];
        self.spec_name.backgroundColor = HXControlBg;
    }else{
        self.spec_name.textColor = [UIColor blackColor];
        self.spec_name.backgroundColor = UIColorFromRGB(0xEEEEEE);
    }
}
-(void)setLandSku:(DSLandGoodsSku *)landSku
{
    _landSku = landSku;
    
    self.spec_name.layer.cornerRadius = 5.f;
    self.spec_name.layer.masksToBounds = YES;
    self.spec_name.layer.borderWidth = 1/[UIScreen mainScreen].scale;

    self.spec_name.text = _landSku.specs_attrs;
    
    if (_landSku.isSelected) {
        self.spec_name.textColor = [UIColor whiteColor];
        self.spec_name.layer.borderColor = [UIColor colorWithHexString:@"#48B664"].CGColor;
        self.spec_name.backgroundColor = [UIColor colorWithHexString:@"#48B664"];
    }else{
        self.spec_name.textColor = UIColorFromRGB(0x333333);
        self.spec_name.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
        self.spec_name.backgroundColor = [UIColor whiteColor];
    }
}
@end
