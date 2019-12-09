//
//  DSOrderDetailHeader.m
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSOrderDetailHeader.h"

@interface DSOrderDetailHeader ()
@property (weak, nonatomic) IBOutlet UILabel *order_status;
@property (weak, nonatomic) IBOutlet UILabel *order_desc;
@property (weak, nonatomic) IBOutlet UILabel *order_tip;
@property (weak, nonatomic) IBOutlet UILabel *logistics_name;
@property (weak, nonatomic) IBOutlet UILabel *logistics_no;
@property (weak, nonatomic) IBOutlet UILabel *receiver;
@property (weak, nonatomic) IBOutlet UILabel *receive_address;
@end
@implementation DSOrderDetailHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}

@end
