//
//  UIColor+Extend.h
//  PPLoan
//
//  Created by L on 16/3/16.
//  Copyright © 2016年 PPmoneyJD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extend)
+ (UIColor *)hexColorWithString:(NSString *)string;
+ (UIColor *)hexColorWithString:(NSString *)string alpha:(float)alpha;
@end
