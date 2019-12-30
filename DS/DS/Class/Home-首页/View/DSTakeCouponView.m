//
//  DSTakeCouponView.m
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSTakeCouponView.h"
#import "DSTakeCouponCell.h"

static NSString *const TakeCouponCell = @"TakeCouponCell";
@interface DSTakeCouponView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DSTakeCouponView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setUpTableView];
}
-(void)setUpTableView
{
    self.tableView.rowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景色为clear
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DSTakeCouponCell class]) bundle:nil] forCellReuseIdentifier:TakeCouponCell];
}
- (IBAction)closeClicked:(UIButton *)sender {
    if (self.couponClickedCall) {
        self.couponClickedCall(0);
    }
}

#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSTakeCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:TakeCouponCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.discount.text = [NSString stringWithFormat:@"%.1f折",[self.discount floatValue]];
    cell.discoutName.text = [NSString stringWithFormat:@"%.1f折券",[self.discount floatValue]];
    cell.validDay.text = [NSString stringWithFormat:@"有效期：%@天",self.valid_days];
    hx_weakify(self);
    cell.getCouponCall = ^{
        hx_strongify(weakSelf);
        if (strongSelf.couponClickedCall) {
            strongSelf.couponClickedCall(1);
        }
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 返回这个模型对应的cell高度
    return 100.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
