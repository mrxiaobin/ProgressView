//
//  ViewController.m
//  MyProgressBar
//
//  Created by 祝小斌 on 16/3/13.
//  Copyright © 2016年 祝小斌. All rights reserved.
//

#import "ViewController.h"
#import "MyProgressView.h"

#define TOTALSECONDS 200
#define progressPerSecond 1.0 / TOTALSECONDS

@interface ViewController () <MyProgressViewDelegate> {
    MyProgressView *_progressView;
}
@property (weak, nonatomic) IBOutlet UILabel *nowLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MyProgressView *testProgressView1 = [[MyProgressView alloc]initWithFrame:CGRectMake(20, 100, 200, 40)];
    [self.view addSubview: testProgressView1];
    self.totalLabel.text = [NSString stringWithFormat:@"%02d:%02d", TOTALSECONDS / 60, TOTALSECONDS % 60];
    
    [testProgressView1 makePointWithprogress:0.5 andColor:[UIColor yellowColor]];
    [testProgressView1 makePointWithprogress:0.2 andColor:[UIColor blueColor]];
    [testProgressView1 makePointWithprogress:0.8 andColor:[UIColor blackColor]];
    [testProgressView1 makePointWithprogress:1 andColor:[UIColor purpleColor]];
    testProgressView1.delegate = self;
    _progressView = testProgressView1;
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addsecond) userInfo:nil repeats:YES];
}

-(void)myProgressViewdidChange:(MyProgressView *)myProgressView {
    NSLog(@"progress%f", myProgressView.progress);
    CGFloat progress = myProgressView.progress;
    int min = (int)(TOTALSECONDS * progress) / 60;
    int sec = (int)(TOTALSECONDS * progress) % 60;
    self.nowLabel.text = [NSString stringWithFormat:@"%02d:%02d", min, sec];
}

-(void)addsecond {
    CGFloat progress = _progressView.progress + progressPerSecond;
    [_progressView setProgress:progress];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
