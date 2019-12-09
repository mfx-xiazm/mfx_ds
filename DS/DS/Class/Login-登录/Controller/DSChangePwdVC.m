//
//  DSChangePwdVC.m
//  DS
//
//  Created by 夏增明 on 2019/11/12.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSChangePwdVC.h"

@interface DSChangePwdVC ()

@end

@implementation DSChangePwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:(self.dataType==1)?@"忘记密码":@"修改密码"];
}



@end
