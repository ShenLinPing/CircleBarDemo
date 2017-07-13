//
//  ViewController.m
//  CircleBarDemo
//
//  Created by ShenMu on 2017/7/12.
//  Copyright © 2017年 ShenMu. All rights reserved.
//

#import "ViewController.h"
#import "TDPieChartView.h"
#import "TDChartDataUnit.h"

@interface ViewController ()
{
    NSInteger _count;
}

@property (nonatomic, strong) TDPieChartView *pieChartView;
@property (weak, nonatomic) IBOutlet UISlider *countSlider;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratioLabel;

@property (nonatomic, strong) NSMutableArray<TDChartDataUnit *> *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"sin -- %f", sinf((0.25)*M_PI*2));
    NSLog(@"sin -- %f", sinf((0.5)*M_PI*2));
    NSLog(@"sin -- %f", sinf((0.75)*M_PI*2));
    
    NSLog(@"sin -- %f", cosf((0.25)*M_PI*2));
    NSLog(@"sin -- %f", cosf((0.5)*M_PI*2));
    NSLog(@"sin -- %f", cosf((0.75)*M_PI*2));
    
    NSLog(@"sin -- %f", asin(1));
    
    TDPieChartView *pie = [[TDPieChartView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 400) strokeWidth:30 color:UIColor.yellowColor];
    [self.view addSubview:pie];
    self.pieChartView = pie;
    
    self.dataArray = [NSMutableArray array];
    [self createDataByCount:5];
}

- (IBAction)controlRatioDicChange:(id)sender {
    NSInteger ratio = (NSInteger)([(UISlider *)sender value] * 20);
    ratio = ratio ?: 1;
    
    _ratioLabel.text = [NSString stringWithFormat:@"%ld", ratio];
    self.pieChartView.controlRatio = ratio;
    [self.pieChartView reloadData];
}

- (IBAction)sliderValueDidChange:(id)sender {
    _count = (NSInteger)(_countSlider.value * 30);
    [self createDataByCount:_count];
}

- (void)createDataByCount:(NSInteger)count {
    _countSlider.value = (CGFloat)count / 30.0;
    _countLabel.text = [NSString stringWithFormat:@"%ld", count];
    
    [self.dataArray removeAllObjects];
    
    CGFloat total = 0;
    for (int i = 0; i < count; i++) {
        TDChartDataUnit *unit = [[TDChartDataUnit alloc] init];
        unit.unitMoney = arc4random() % 58431;
        total += unit.unitMoney;
        [self.dataArray addObject:unit];
    }
    
    [self.dataArray enumerateObjectsUsingBlock:^(TDChartDataUnit * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.totalMoney = total;
    }];
    
    self.pieChartView.dataSet = self.dataArray;
    [self.pieChartView reloadData];
}

@end
