//
//  TDPieChartView.h
//  CircleBarDemo
//
//  Created by ShenMu on 2017/7/12.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDChartDataUnit.h"
#import "UIColor+Extend.h"

#define getScaleWidth(x)  x * Screen_Width / 750.0
#define getScaleHeight(x) x * Screen_Height / 1334.0
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define colorHex(str) [UIColor hexColorWithString:str]

@interface TDPieChartView : UIView

@property (assign) NSInteger controlRatio;

@property (strong,nonatomic) CAShapeLayer *bgCircleLayer;
@property (strong,nonatomic) UIBezierPath *circlePath;

@property (strong,nonatomic) CAShapeLayer *percentLayer;

@property (nonatomic) CGFloat strokeWidth;
@property (strong,nonatomic) UIColor *percentColor;

@property (strong,nonatomic) NSArray *perArray;
@property (strong,nonatomic) NSMutableArray *layerArray;

@property (strong,nonatomic) NSMutableArray<TDChartDataUnit *> *dataSet;

@property (strong , nonatomic) UILabel *allMoneyStrLabel;

@property BOOL isAnimation;

- (instancetype)initWithFrame:(CGRect)frame
                  strokeWidth:(CGFloat )width
                        color:(UIColor *)color;

- (void)reloadData;

@end
