//
//  BeizerView.h
//  BezierTest
//
//  Created by Cavan on 2017/9/24.
//  Copyright © 2017年 Signalmust. All rights reserved.
//

#import <UIKit/UIKit.h>

// 线条类型
typedef NS_ENUM(NSInteger, LineType) {
    LineType_Straight, // 折线
    LineType_Curve     // 曲线
};


@interface BeizerView : UIView

///
@property (nonatomic, strong)NSMutableArray *x_names;
- (instancetype)initWithFrame:(CGRect)frame;

-(void)drawLineChartViewWithValues:(NSMutableArray *)values lineType:(LineType)type;

@end
