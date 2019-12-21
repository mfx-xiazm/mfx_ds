//
//  DSMyCard.h
//  DS
//
//  Created by 夏增明 on 2019/12/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSMyCard : NSObject
@property (nonatomic, copy) NSString *order_no;
@property (nonatomic, copy) NSString *logo_img;
@property (nonatomic, copy) NSString *card_code;
@property (nonatomic, copy) NSString *card_code_id;
@property (nonatomic, copy) NSString *deadline;
@property (nonatomic, copy) NSString *product_name;

@end

NS_ASSUME_NONNULL_END
