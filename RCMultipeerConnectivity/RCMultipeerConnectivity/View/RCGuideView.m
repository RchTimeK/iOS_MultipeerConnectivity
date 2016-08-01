//
//  RCGuideView.m
//  RCMultipeerConnectivity
//
//  Created by RongCheng on 16/7/29.
//  Copyright © 2016年 RongCheng. All rights reserved.
//

#import "RCGuideView.h"

@implementation RCGuideView

+(instancetype)guideView {
    
     
    return [[[NSBundle mainBundle]loadNibNamed:@"RCGuideView" owner:self options:nil] lastObject];
}
- (IBAction)cancelBtnClick:(id)sender {
    [self removeFromSuperview];
}

@end
