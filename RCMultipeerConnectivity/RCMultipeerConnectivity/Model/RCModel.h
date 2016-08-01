//
//  RCModel.h
//  RCMultipeerConnectivity
//
//  Created by RongCheng on 16/7/29.
//  Copyright © 2016年 RongCheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface RCModel : NSObject
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *icon;
@property (nonatomic,assign) CGFloat width ;
@property (nonatomic,assign) CGFloat height ;

+ (RCModel*)modelWithDic:(NSDictionary*)dic;
- (instancetype) initWithDic:(NSDictionary *)Dic;
@end
