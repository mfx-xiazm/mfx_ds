//
//  DSFetchRiceConfirmView.m
//  DS
//
//  Created by huaxin-01 on 2020/7/29.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "DSFetchRiceConfirmView.h"
#import "DSGranary.h"
#import "DSFetchRiceConfirmCell.h"

static NSString *const FetchRiceConfirmCell = @"FetchRiceConfirmCell";
@interface DSFetchRiceConfirmView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *fetch_num;

@end
@implementation DSFetchRiceConfirmView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;//预估高度
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DSFetchRiceConfirmCell class]) bundle:nil] forCellReuseIdentifier:FetchRiceConfirmCell];
    
}
-(void)setGranary:(DSGranary *)granary
{
    _granary = granary;
    self.fetch_num.text = [NSString stringWithFormat:@"%zd张",_granary.pick_num];
    [self.tableView reloadData];
}
- (IBAction)confirmBtnClicked:(UIButton *)sender {
    if (self.confirmBtnClickedCall) {
        self.confirmBtnClickedCall(sender.tag);
    }
}
#pragma mark -- UITableView数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.granary.goods.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DSFetchRiceConfirmCell *cell = [tableView dequeueReusableCellWithIdentifier:FetchRiceConfirmCell forIndexPath:indexPath];
    //无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DSGranaryGoods *goods = self.granary.goods[indexPath.row];
    cell.goods = goods;
    return cell;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    DSGranaryGoods *goods = self.granary.goods[indexPath.row];
//    return 30.f + (goods.row_num * 105.f);
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
