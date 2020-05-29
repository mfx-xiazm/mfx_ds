//
//  NSURL+Expand.m
//  DS
//
//  Created by 夏增明 on 2020/3/3.
//  Copyright © 2020 夏增明. All rights reserved.
//

#import "NSURL+Expand.h"

@implementation NSURL (Expand)
/**

获取url的所有参数

@return NSDictionary

*/

-(NSDictionary *)paramerWithURL {

    NSMutableDictionary *paramer = [[NSMutableDictionary alloc]init];

    //创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:self.absoluteString];

    //遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [paramer setObject:obj.value forKey:obj.name];
        if ([obj.name isEqualToString:@"taobao_goods_url"]) {
            *stop = YES;
        }
    }];

    return paramer;
}
@end
