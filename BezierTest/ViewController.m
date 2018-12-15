//
//  ViewController.m
//  BezierTest
//
//  Created by Cavan on 2017/9/24.
//  Copyright © 2017年 Signalmust. All rights reserved.
//

#import "ViewController.h"
#import "BeizerView.h"

@interface ViewController ()
///
@property (nonatomic, strong)BeizerView *beizerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.beizerView = [[BeizerView alloc] initWithFrame:CGRectMake(10, 20, 365, 200)];
    
    self.beizerView.x_names = [NSMutableArray arrayWithArray:@[@"2017.06.13", @"2017.08.09", @"2017.05.23", @"2017.11.12"]];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:@[@"-196.07", @"-206.07", @"-278.22", @"-348.22", @"-339.49", @"735.37", @"3200.37", @"-711.79", @"257.49", @"-1525.74"]];
    [self.beizerView drawLineChartViewWithValues:arr lineType:LineType_Curve];
    [self.view addSubview:self.beizerView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
