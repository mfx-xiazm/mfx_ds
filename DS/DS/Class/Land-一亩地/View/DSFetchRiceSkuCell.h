//
//  DSFetchRiceSkuCell.h
//  DS
//
//  Created by huaxin-01 on 2020/8/4.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DSGranaryGoodSku;
typedef void(^fetchNumCall)(void);
@interface DSFetchRiceSkuCell : UICollectionViewCell
@property (nonatomic, strong) DSGranaryGoodSku *sku;
@property (nonatomic, copy) fetchNumCall fetchNumCall;
@end

NS_ASSUME_NONNULL_END
