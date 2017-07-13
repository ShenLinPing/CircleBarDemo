//
//  UIColor+Extend.m
//  PPLoan
//
//  Created by L on 16/3/16.
//  Copyright © 2016年 PPmoneyJD. All rights reserved.
//

#import "UIColor+Extend.h"

@implementation UIColor (Extend)
+ (UIColor *)hexColorWithString:(NSString *)string {
    return [UIColor hexColorWithString:string alpha:1.0f];
}

+ (UIColor *)hexColorWithString:(NSString *)string alpha:(float)alpha {
    NSString *l_string = string;
    
    if ([l_string hasPrefix:@"#"]) {
        l_string = [l_string substringFromIndex:1];
    }
    
    NSString *pureHexString = [[l_string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([pureHexString length] != 6) {
        return [UIColor whiteColor];
    }
    
    NSRange range;
    range.location    = 0;
    range.length      = 2;
    NSString *rString = [pureHexString substringWithRange:range];
    
    range.location   += range.length;
    NSString *gString = [pureHexString substringWithRange:range];
    
    range.location   += range.length;
    NSString *bString = [pureHexString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

@end
