//
//  UIColor+Extension.m
//  RCMultipeerConnectivity
//
//  Created by RongCheng on 16/7/29.
//  Copyright © 2016年 RongCheng. All rights reserved.
//

#import "UIColor+Extension.h"
/**
 *  参照了相关资料
 */
@implementation UIColor (Extension)



+(UIColor*)colorWithHexString:(NSString*)string
{
    NSString*cString=[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if([cString length]< 6)
        return [UIColor whiteColor];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor whiteColor];
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)green:((float) g / 255.0f)blue:((float) b / 255.0f)alpha:1.0f];
}


@end
