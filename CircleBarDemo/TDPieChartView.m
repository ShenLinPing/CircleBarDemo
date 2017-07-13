//
//  TDPieChartView.m
//  CircleBarDemo
//
//  Created by ShenMu on 2017/7/12.
//  Copyright © 2017年 ShenMu. All rights reserved.
//



#import "TDPieChartView.h"

@interface TDPieChartView()
{
    // 半径
    CGFloat _radius;
}

@property (nonatomic, strong) NSMutableArray *legendArray;

@end

@implementation TDPieChartView

- (instancetype)initWithFrame:(CGRect)frame
                  strokeWidth:(CGFloat )width
                        color:(UIColor *)color {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultSetting];
        _strokeWidth = width;
        _percentColor = color;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self defaultSetting];
    }
    return self;
}

- (void)defaultSetting {
    _layerArray = [[NSMutableArray alloc]init];
    _strokeWidth = 20;
    _percentColor = UIColor.yellowColor;
    
    CGPoint centerPoint = CGPointMake(self.bounds.size.width /2, self.bounds.size.height /2);
    _radius = getScaleWidth(100);
    _circlePath = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                 radius:_radius
                                             startAngle:3 * M_PI_2
                                               endAngle:- M_PI_2 clockwise:NO];
}

// Public Method
- (void)reloadData {
    if(self.dataSet == nil || self.dataSet.count == 0) {
        return;
    }
    
    [self removeAllSubLayers];
    [self.legendArray removeAllObjects];
    self.layerArray = [NSMutableArray array];
    
    // sort Data
    [self sortDataSet];
    
    // draw layers
    [self drawPieChartLayers];
}



// Private Method
- (void)removeAllSubLayers {
    [self.bgCircleLayer removeFromSuperlayer];
    self.bgCircleLayer = nil;
    
    while (self.layer.sublayers.count) {
        [self.layer.sublayers.lastObject removeFromSuperlayer];
    }
    [self.layer removeAllAnimations];
}

- (void)sortDataSet {
    [self.dataSet sortUsingComparator:^NSComparisonResult(TDChartDataUnit * _Nonnull obj1, TDChartDataUnit *  _Nonnull obj2) {
        if (obj1.unitMoney < obj2.unitMoney) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
}

- (void)drawPieChartLayers {
    [self.layer addSublayer:self.bgCircleLayer];
    
    __block NSInteger leftLegendCount = 0;
    __block NSInteger rightLegnedCount = 0;
    __block CGFloat percent = 0;
    [self.dataSet enumerateObjectsUsingBlock:^(TDChartDataUnit * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.chartPercent = obj.unitMoney / obj.totalMoney;
        if (percent + obj.chartPercent/2.0 <= 0.5) {
            leftLegendCount ++;
        } else {
            rightLegnedCount ++;
        }
        
        percent += obj.chartPercent;
    }];
    
    CGFloat center_x = self.frame.size.width/2;
    CGFloat center_y = self.frame.size.height/2;
    CGFloat startPer = 0;
    
    CGFloat radius_line = _radius + _strokeWidth / 2.0f + 25;
    CGFloat legendbeginY = center_y - radius_line + 25;
    CGFloat legnedContentHeight = (center_y - legendbeginY) * 2;
    CGFloat rightLegendUnitHeight = rightLegnedCount ? legnedContentHeight / rightLegnedCount: 0;
    CGFloat leftLegendunitHeight = leftLegendCount ? (legnedContentHeight - getScaleWidth(10.0)) / leftLegendCount: 0;
    
    CGPoint centerPoint = CGPointMake(self.bounds.size.width /2, self.bounds.size.height /2);
    UIBezierPath * testPath =  [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                              radius:radius_line
                                                          startAngle:3 * M_PI_2
                                                            endAngle:- M_PI_2 clockwise:NO];
    
    CAShapeLayer *testCircle = [CAShapeLayer layer];
    testCircle.path          = testPath.CGPath;
    testCircle.strokeColor   = UIColor.blackColor.CGColor;
    testCircle.fillColor     = [UIColor clearColor].CGColor;
    [self.layer addSublayer:testCircle];
    
    NSArray<UIColor *> *colorArray = [self colorArray];
    for (int i = 0; i < self.dataSet.count; i++) {
        TDChartDataUnit *unit = self.dataSet[i];
        
        // Unit YValue
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path          = _circlePath.CGPath;
        layer.strokeColor   = colorArray[i%(colorArray.count - 1)].CGColor;
        layer.fillColor     = [UIColor clearColor].CGColor;
        layer.lineWidth     = _strokeWidth;
        layer.strokeStart   = startPer;
        layer.strokeEnd     = startPer + unit.chartPercent;
        [self.layer addSublayer:layer];
        
        // Unit XValue
//        CGFloat radius_line = _radius + _strokeWidth / 2.0f;    //圆弧半径
        
        CGFloat markPer = startPer + unit.chartPercent / 2.0f;
        if (self.dataSet.count == 1) {
            markPer = 0;
        }
        
        // Legend Label
        CGFloat labelX = 0;
        CGFloat labelY = 0;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        label.textAlignment = NSTextAlignmentRight;
        label.text = [NSString stringWithFormat:@"%@ %.2f%%", unit.legendName, unit.chartPercent];
        label.font = [UIFont systemFontOfSize:getScaleWidth(15.0)];
        label.textColor = colorArray[i%(colorArray.count - 1)];
        [label sizeToFit];
        [self addSubview:label];
        
        if (markPer <= 0.5) {
            labelY = legendbeginY + i * leftLegendunitHeight;
            labelX = - sqrt(radius_line * radius_line - (center_y - labelY) * (center_y - labelY)) - label.frame.size.width + center_x;
        } else {
            labelY = (rightLegnedCount - (i - leftLegendCount) - 0.5) * rightLegendUnitHeight + legendbeginY;
            labelX = sqrt(radius_line * radius_line - (center_y - labelY) * (center_y - labelY)) + center_x;
        }
        label.frame = CGRectMake(labelX, labelY, label.frame.size.width, label.frame.size.height);
        
        // 抛物线坐标
        CGFloat x_angle = sinf(M_PI*2*(1 - markPer));
        CGFloat y_angle = -cosf(M_PI*2*(1 - markPer));
        CGFloat pieRadius = _radius + _strokeWidth / 2.0;
        CGFloat x = (pieRadius * x_angle) + center_x;
        CGFloat y = (pieRadius * y_angle) + center_y;
        CGFloat curve_beginW = getScaleWidth(2);     //抛物线开始位置间距
        CGFloat curve_endW   = getScaleWidth(2);     //抛物线结束位置间距
        CGFloat curve_beginX = x + curve_beginW * x_angle;     //抛物线开始位置X
        CGFloat curve_beginY = y + curve_beginW * y_angle;     //抛物线开始位置Y
        CGFloat curve_endX   = 0;     //抛物线结束位置X
        CGFloat curve_endY   = 0;     //抛物线结束位置Y
        if (markPer <= 0.5) {
            curve_endX = CGRectGetMaxX(label.frame) + curve_endW * x_angle;
            curve_endY = CGRectGetMidY(label.frame);
        } else {
            curve_endX = CGRectGetMinX(label.frame) + curve_endW * x_angle;
            curve_endY = CGRectGetMidY(label.frame);
        }
    
        // 控制点
//        CGFloat curve_cpx    = ((curve_beginX + curve_endX)/2 + curve_beginX) / 2; // X轴开始到结束的四分一
//        CGFloat curve_cpy    = curve_beginY < curve_endY ? (curve_beginY - fabs(curve_cpx - curve_beginX)): (curve_beginY + fabs(curve_cpx - curve_beginX));
        CGFloat curve_cpx    = curve_beginX + (curve_endX - curve_beginX) - (curve_endX - curve_beginX)/self.controlRatio; // X轴开始到结束的四分一
        CGFloat curve_cpy    = curve_beginY;
        
        // Draw Line
        CGMutablePathRef path = CGPathCreateMutable();
//        CGFloat cpx = ( + ) / 2;
//        CGFloat cpy = (curve_endY + curve_beginY) / 2;
        CGPathMoveToPoint(path, NULL, curve_beginX, curve_beginY);
        CGPathAddQuadCurveToPoint(path, NULL, curve_cpx, curve_cpy, curve_endX, curve_endY);
        
        CAShapeLayer *line = [CAShapeLayer layer];
        line.path          = path;
        line.fillColor     = [UIColor clearColor].CGColor;
        line.strokeColor   = colorArray[i%(colorArray.count - 1)].CGColor;
        line.strokeStart   = 0;
        line.strokeEnd     = 1;
        [self.layer addSublayer:line];
        
        [self percentAnimationEveryLayer: layer];
        startPer += unit.chartPercent;
    }
}

- (void)percentAnimationEveryLayer:(CAShapeLayer *)layer {
    //饼状图层动画
    CABasicAnimation *strokeEndAnimation = nil;
    strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.duration = 0.7f;
    strokeEndAnimation.fromValue = @(layer.strokeStart);
    strokeEndAnimation.toValue = @(layer.strokeEnd);
    strokeEndAnimation.autoreverses = NO; //无自动动态倒退效果
    [layer addAnimation:strokeEndAnimation forKey:@"strokeEnd"];
}

#pragma mark - Getter
- (CAShapeLayer *)bgCircleLayer {
    if (!_bgCircleLayer) {
        _bgCircleLayer = [CAShapeLayer layer];
        _bgCircleLayer.path = _circlePath.CGPath;
        _bgCircleLayer.strokeColor = [UIColor whiteColor].CGColor;
        _bgCircleLayer.fillColor = [UIColor clearColor].CGColor;
        _bgCircleLayer.lineWidth = _strokeWidth;
    }
    return _bgCircleLayer;
}

- (NSMutableArray *)legendArray {
    if (!_legendArray) {
        _legendArray = [NSMutableArray array];
    }
    return _legendArray;
}

- (NSArray<UIColor *> *)colorArray {
    return @[colorHex(@"#F14A1A"),colorHex(@"#F9B34A"),colorHex(@"11A7AD"),
             colorHex(@"4DB9EE"),colorHex(@"2F64AF"),colorHex(@"CCBA9B"),
             colorHex(@"7B443C"),colorHex(@"C63333")];
}

@end
