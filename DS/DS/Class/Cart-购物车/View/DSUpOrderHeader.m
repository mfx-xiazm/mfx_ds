//
//  DSUpOrderHeader.m
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSUpOrderHeader.h"

@interface DSUpOrderHeader ()
@property (weak, nonatomic) IBOutlet UILabel *receiver;
@property (weak, nonatomic) IBOutlet UILabel *receiver_phone;
@property (weak, nonatomic) IBOutlet UILabel *address;
@end
@implementation DSUpOrderHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}

@end
