//
//  BeizerView.m
//  BezierTest
//
//  Created by Cavan on 2017/9/24.
//  Copyright © 2017年 Signalmust. All rights reserved.
//

#import "BeizerView.h"

#define HEIGHT (self.frame.size.height)
#define WIDTH  (self.frame.size.width)

#define SPACE  50

@implementation BeizerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self doInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }
    return self;
}

- (void)doInit
{
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5;
    
}

// 画基础标线
- (void)drawHorizontalLine {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, SPACE)];
    [path addLineToPoint:CGPointMake(WIDTH, SPACE)];
    
    [path moveToPoint:CGPointMake(0, HEIGHT / 2)];
    [path addLineToPoint:CGPointMake(WIDTH, HEIGHT / 2)];
    
    [path moveToPoint:CGPointMake(0, HEIGHT - SPACE)];
    [path addLineToPoint:CGPointMake(WIDTH, HEIGHT - SPACE)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    shapeLayer.borderWidth = 1.0;
    [self.layer addSublayer:shapeLayer];
    
}
-(void)drawLineChartViewWithValues:(NSMutableArray *)values lineType:(LineType)type {
    
    if (type == LineType_Straight) {
        [self drawHorizontalLine];
    }
    
    // 将数组取反
    NSMutableArray *newValues = [NSMutableArray array];
    for (NSString *numStr in values) {
        float x = numStr.floatValue;
        [newValues addObject:[NSString stringWithFormat:@"%f", (-x)]];
    }
    // 找出数组中最大值、最小值
    float xmax = -MAXFLOAT;
    float xmin = MAXFLOAT;
    for (NSString *numStr in newValues) {
        float x = numStr.floatValue;
        if (x < xmin) xmin = x;
        if (x > xmax) xmax = x;
    }
    
    // 计算高度差值和 View 自身高度比例 并进行折算
    CGFloat rate = (xmax - xmin) / (HEIGHT - 2 * SPACE);
    NSMutableArray *chartValues = [NSMutableArray array];
    for (NSString *numStr in newValues) {
        float value = (numStr.floatValue - xmin) / rate;
        [chartValues addObject:@(value)];
        
    }
    
    // 创建点
    NSMutableArray *allPoints = [NSMutableArray array];
    for (int i=0; i<chartValues.count; i++) {
        
        CGFloat X = (WIDTH - 2 * SPACE) / (chartValues.count - 1) * i + SPACE;
        CGFloat Y = [chartValues[i] floatValue] + SPACE;
        CGPoint point = CGPointMake(X,Y);
        NSLog(@"%.2f, %.2f\n", X, Y);
        [allPoints addObject:[NSValue valueWithCGPoint:point]];
    }
    
    // 连线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:[allPoints[0] CGPointValue]];
    CGPoint PrePonit;
    
    
    switch (type) {
        case LineType_Straight: //直线
            for (int i =1; i<allPoints.count; i++) {
                CGPoint point = [allPoints[i] CGPointValue];
                [path addLineToPoint:point];
            }
            break;
        case LineType_Curve:   //曲线
            for (int i =0; i<allPoints.count; i++) {
                if (i==0) {
                    PrePonit = [allPoints[0] CGPointValue];
                }else{
                    CGPoint NowPoint = [allPoints[i] CGPointValue];
                    [path addCurveToPoint:NowPoint controlPoint1:CGPointMake((PrePonit.x+NowPoint.x)/2, PrePonit.y) controlPoint2:CGPointMake((PrePonit.x+NowPoint.x)/2, NowPoint.y)]; //三次曲线
                    PrePonit = NowPoint;
                }
            }
            break;
    }
    
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor greenColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 2.0;
    [self.layer addSublayer:shapeLayer];
    
    // 连线动画
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = allPoints.count*0.4;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    [shapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    shapeLayer.strokeEnd = 1.0;
    
    
    
    if (type == LineType_Straight) {
        
        // 创建圆圈
        for (int i=0; i< allPoints.count; i++) {
            
            CGPoint point = [allPoints[i] CGPointValue];
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 8, 8)];
            view.center = point;
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = 4;
            view.layer.borderWidth = 1;
            view.layer.borderColor = [UIColor greenColor].CGColor;
            view.backgroundColor = [UIColor whiteColor];
            [self addSubview:view];
        }
        
        // 创建 X 轴文字
        for (int i=0; i < self.x_names.count; i++) {
            
            CGFloat W = (WIDTH - SPACE) / self.x_names.count;
            CGFloat X = SPACE / 2 + W * i;
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(X, HEIGHT - SPACE, W, SPACE)];
            textLabel.numberOfLines = 0;
            textLabel.text = self.x_names[i];
            textLabel.font = [UIFont systemFontOfSize:10];
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.textColor = [UIColor blueColor];
            [self addSubview:textLabel];
        }
    }
    
    
    
}


@end
