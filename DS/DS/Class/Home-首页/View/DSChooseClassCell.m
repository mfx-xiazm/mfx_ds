//
//  DSChooseClassCell.m
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSChooseClassCell.h"
#import "DSGoodsDetail.h"

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
    
    self.spec_name.text = _attrs.attr_name;
    
    if (_attrs.isSelected) {
        self.spec_name.textColor = [UIColor whiteColor];
        self.spec_name.backgroundColor = HXControlBg;
    }else{
        self.spec_name.textColor = [UIColor blackColor];
        self.spec_name.backgroundColor = UIColorFromRGB(0xEEEEEE);
    }
}
@end
