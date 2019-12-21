//
//  DSDynamicDetailFooter.m
//  DS
//
//  Created by 夏增明 on 2019/11/19.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSDynamicDetailFooter.h"
#import "DSDynamicDetail.h"

@interface DSDynamicDetailFooter ()
@property (weak, nonatomic) IBOutlet UIButton *delete;
@property (weak, nonatomic) IBOutlet UIButton *thumb;
@property (weak, nonatomic) IBOutlet UIButton *share;

@end
@implementation DSDynamicDetailFooter

-(void)awakeFromNib
{
    [super awakeFromNib];
}
-(void)setInfo:(DSDynamicInfo *)info
{
    _info = info;
    self.delete.hidden = [[MSUserManager sharedInstance].curUserInfo.uid isEqualToString:_info.uid]?NO:YES;
    [self.thumb setTitle:_info.praise_num forState:UIControlStateNormal];
    self.thumb.selected = _info.is_praise;
}
- (IBAction)detailTypeClicked:(UIButton *)sender {
    if (self.footerTypeCall) {
        self.footerTypeCall(sender.tag,sender);
    }
}

@end
