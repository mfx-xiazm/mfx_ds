//
//  DSDynamicCell.m
//  DS
//
//  Created by 夏增明 on 2019/11/18.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "DSDynamicCell.h"
#import "SDWeiXinPhotoContainerView.h"
#import "DSDynamicLayout.h"

@interface DSDynamicCell ()
/** 头像 */
@property (nonatomic , strong) UIImageView *avatarView;
/** 昵称 */
@property (nonatomic , strong) YYLabel *nickName;
/** 时间 */
@property (nonatomic , strong) YYLabel *createTime;
/** 文本内容 */
@property (nonatomic , strong) YYLabel *textContent;
/** 九宫格 */
@property (nonatomic , strong) SDWeiXinPhotoContainerView *picContainerView;
/** 点赞 */
@property (nonatomic , strong) UIButton *thumb;
/** 分享 */
@property (nonatomic , strong) UIButton *share;
/** 删除 */
@property (nonatomic , strong) UIButton *delete;
/** 分割线 */
@property (nonatomic , strong) UIView *dividingLine;
@end

@implementation DSDynamicCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"DynamicCell";
    DSDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 创建子控件
        [self setUpSubViews];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - 创建子控制器
- (void)setUpSubViews
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.avatarView];
    [self.contentView addSubview:self.nickName];
    [self.contentView addSubview:self.createTime];
    [self.contentView addSubview:self.textContent];
    [self.contentView addSubview:self.picContainerView];
    [self.contentView addSubview:self.thumb];
    [self.contentView addSubview:self.share];
    [self.contentView addSubview:self.delete];
    [self.contentView addSubview:self.dividingLine];
}
-(UIImageView *)avatarView
{
    if(!_avatarView){
        _avatarView = [UIImageView new];
        _avatarView.userInteractionEnabled = YES;
        _avatarView.backgroundColor = HXGlobalBg;
        _avatarView.contentMode = UIViewContentModeScaleToFill;
        _avatarView.layer.cornerRadius = 22.5f;
        _avatarView.layer.masksToBounds = YES;
        //UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatarClicked)];
        //[_avatarView addGestureRecognizer:tapGR];
    }
    return _avatarView;
}
-(YYLabel *)nickName
{
    if (!_nickName) {
        _nickName = [YYLabel new];
        _nickName.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
        _nickName.textColor = UIColorFromRGB(0x222222);
        _nickName.userInteractionEnabled = YES;
        //UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nickNameClicked)];
        //[_nickName addGestureRecognizer:tapGR];
    }
    return _nickName;
}
-(YYLabel *)createTime
{
    if (!_createTime) {
        _createTime = [[YYLabel alloc] init];
        _createTime.font = [UIFont systemFontOfSize:13.0f];
        _createTime.textAlignment = NSTextAlignmentLeft;
        _createTime.textColor = UIColorFromRGB(0x666666);
    }
    return _createTime;
}
-(YYLabel *)textContent
{
    if (!_textContent) {
        _textContent = [YYLabel new];
        _textContent.backgroundColor = HXGlobalBg;
    }
    return _textContent;
}
-(SDWeiXinPhotoContainerView *)picContainerView
{
    if (!_picContainerView) {
        _picContainerView = [SDWeiXinPhotoContainerView new];
        _picContainerView.hidden = YES;
    }
    return _picContainerView;
}
-(UIButton *)thumb
{
    if (!_thumb) {
        _thumb = [UIButton buttonWithType:UIButtonTypeCustom];
        [_thumb setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
        [_thumb setImage:HXGetImage(@"未点赞") forState:UIControlStateNormal];
        [_thumb setImage:HXGetImage(@"已点赞") forState:UIControlStateSelected];
        [_thumb setTitle:@"23" forState:UIControlStateNormal];
        _thumb.titleLabel.font = [UIFont systemFontOfSize:13];
        _thumb.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4);
        _thumb.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
        [_thumb addTarget:self action:@selector(thumbClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _thumb;
}
-(UIButton *)share
{
    if (!_share) {
        _share = [UIButton buttonWithType:UIButtonTypeCustom];
        [_share setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
        [_share setImage:HXGetImage(@"分享") forState:UIControlStateNormal];
        [_share setTitle:@"分享" forState:UIControlStateNormal];
        _share.titleLabel.font = [UIFont systemFontOfSize:13];
        _share.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        [_share addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _share;
}
-(UIButton *)delete
{
    if (!_delete) {
        _delete = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delete setTitleColor:UIColorFromRGB(0xFF0000) forState:UIControlStateNormal];
        [_delete setTitle:@"删除" forState:UIControlStateNormal];
        _delete.titleLabel.font = [UIFont systemFontOfSize:13];
        [_delete addTarget:self action:@selector(deleteClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delete;
}
-(UIView *)dividingLine
{
    if (!_dividingLine) {
        _dividingLine = [UIView new];
        _dividingLine.backgroundColor = UIColorFromRGB(0xf5f5f5);
    }
    return _dividingLine;
}
#pragma mark - Setter
-(void)setDynamicLayout:(DSDynamicLayout *)dynamicLayout
{
    _dynamicLayout = dynamicLayout;
    
    UIView * lastView;
    DSDynamic *dynamic = _dynamicLayout.dynamic;
    
    /*
     #define kMomentTopPadding 15 // 顶部间隙
     #define kMomentMarginPadding 10 // 内容间隙
     #define kMomentPortraitWidthAndHeight 45 // 头像高度
     #define kMomentLineSpacing 5 // 文本行间距
     #define kMomentHandleButtonHeight 30 // 可操作的按钮高度
     */
   
    //头像
    _avatarView.hxn_x = kMomentMarginPadding;
    _avatarView.hxn_y = kMomentTopPadding;
    _avatarView.hxn_size = CGSizeMake(kMomentPortraitWidthAndHeight, kMomentPortraitWidthAndHeight);
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:dynamic.portrait] placeholderImage:HXGetImage(@"avatar")];
    
    //昵称
    _nickName.text = dynamic.nick;
    _nickName.hxn_y = kMomentTopPadding + (kMomentPortraitWidthAndHeight-kMomentHandleButtonHeight)/2.0;
    _nickName.hxn_x = _avatarView.hxn_right + kMomentMarginPadding;
    CGSize nameSize = [_nickName sizeThatFits:CGSizeZero];
    _nickName.hxn_width = nameSize.width;
    _nickName.hxn_height = kMomentHandleButtonHeight;
    
    //时间
    _createTime.text = dynamic.creatTime;
    _createTime.hxn_y = kMomentTopPadding + (kMomentPortraitWidthAndHeight-kMomentHandleButtonHeight)/2.0;
    CGSize timeSize = [_createTime sizeThatFits:CGSizeZero];
    _createTime.hxn_width = timeSize.width;
    _createTime.hxn_x = HX_SCREEN_WIDTH - kMomentMarginPadding - timeSize.width;
    _createTime.hxn_height = kMomentHandleButtonHeight;
    
    //文本内容
    _textContent.hxn_x = kMomentMarginPadding;
    _textContent.hxn_y = _avatarView.hxn_bottom + kMomentMarginPadding;
    _textContent.hxn_width = HX_SCREEN_WIDTH - kMomentMarginPadding * 2;
    _textContent.hxn_height = _dynamicLayout.textLayout.textBoundingSize.height;
    _textContent.textLayout = _dynamicLayout.textLayout;
    lastView = _textContent;
    
    //图片集
    if (dynamic.photos.count != 0) {
        _picContainerView.hidden = NO;
        _picContainerView.hxn_x = kMomentMarginPadding;
        _picContainerView.hxn_y = lastView.hxn_bottom + kMomentMarginPadding;
        _picContainerView.hxn_width = _dynamicLayout.photoContainerSize.width;
        _picContainerView.hxn_height = _dynamicLayout.photoContainerSize.height;
        //_picContainerView.targetVc = self.targetVc;
        _picContainerView.picPathStringsArray = dynamic.photos;
        
        lastView = _picContainerView;
    }else{
        _picContainerView.hidden = YES;
    }
    //分享
    _share.hxn_y = lastView.hxn_bottom + kMomentMarginPadding;
    _share.hxn_x = HX_SCREEN_WIDTH - 70 - 10;
    _share.hxn_width = 70;
    _share.hxn_height = kMomentHandleButtonHeight;
    
    //点赞
    _thumb.hxn_y = lastView.hxn_bottom + kMomentMarginPadding;
    _thumb.hxn_x = HX_SCREEN_WIDTH - 70*2 - 10*2;
    _thumb.hxn_width = 70;
    _thumb.hxn_height = kMomentHandleButtonHeight;
    [_thumb setTitle:dynamic.praise_num forState:UIControlStateNormal];
    _thumb.selected = dynamic.is_praise;
    
    //删除
    _delete.hxn_y = lastView.hxn_bottom + kMomentMarginPadding;
    _delete.hxn_x = HX_SCREEN_WIDTH - 70*3 - 10*3;
    _delete.hxn_width = 70;
    _delete.hxn_height = kMomentHandleButtonHeight;
    _delete.hidden = [[MSUserManager sharedInstance].curUserInfo.uid isEqualToString:dynamic.uid]?NO:YES;
    //分割线
    _dividingLine.hxn_x = 0;
    _dividingLine.hxn_height = .5;
    _dividingLine.hxn_width = HX_SCREEN_WIDTH;
    _dividingLine.hxn_bottom = _dynamicLayout.height - .5;
}
#pragma mark - 事件处理
- (void)thumbClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickThumbInCell:)]) {
        [self.delegate didClickThumbInCell:self];
    }
}
- (void)shareClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickShareInCell:)]) {
        [self.delegate didClickShareInCell:self];
    }
}
-(void)deleteClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickDeleteInCell:)]) {
        [self.delegate didClickDeleteInCell:self];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
