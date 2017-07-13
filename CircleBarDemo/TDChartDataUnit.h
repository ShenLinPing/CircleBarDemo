//
//  TDChartUnitModel.h
//  CircleBarDemo
//
//  Created by ShenMu on 2017/7/12.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TDChartDataUnit : NSObject

/// 分类名称
@property (nonatomic, copy) NSString *legendName;
/// 占比
@property (nonatomic, assign) CGFloat chartPercent;
/// 当前分类金额
@property (nonatomic, assign) CGFloat unitMoney;
/// 所有分类的总金额
@property (nonatomic, assign) CGFloat totalMoney;

@property (nonatomic, assign) BOOL showLabel;

@end
