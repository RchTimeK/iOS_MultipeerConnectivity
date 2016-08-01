//
//  RCModel.m
//  RCMultipeerConnectivity
//
//  Created by RongCheng on 16/7/29.
//  Copyright © 2016年 RongCheng. All rights reserved.
//

#import "RCModel.h"

@implementation RCModel
- (instancetype)initWithDic:(NSDictionary *)Dic
{
    self = [super init];
    if (self) {
        _content = Dic [@"content" ];
        _icon = Dic [@"icon"];
    }
    return self;
}
+ (RCModel*)modelWithDic:(NSDictionary *)dic{
    return [[RCModel alloc]initWithDic:dic];
}
- (CGFloat)width{
    
    return  ceilf( [self.content boundingRectWithSize:CGSizeMake(WIDTH-160, 1000) options:NSStringDrawingUsesLineFragmentOrigin
        attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:16]}context:nil] .size.width );
}
- (CGFloat)height{
    return  ceilf( [self.content boundingRectWithSize:CGSizeMake(WIDTH-160, 1000) options:NSStringDrawingUsesLineFragmentOrigin
        attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:16]}context:nil] .size.height );
}

@end
