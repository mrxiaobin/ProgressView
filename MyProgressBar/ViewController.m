//
//  ViewController.m
//  MyProgressBar
//
//  Created by 祝小斌 on 16/3/13.
//  Copyright © 2016年 祝小斌. All rights reserved.
//

#import "ViewController.h"
#import "MyProgressView.h"
#import "TestView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet TestView *testView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    MyProgressView *testProgressView1 = [[MyProgressView alloc]initWithFrame:CGRectMake(20, 40, 200, 20)];
    [self.view addSubview: testProgressView1];
    
    [testProgressView1 makePointWithprogress:0.5 andColor:[UIColor yellowColor]];
    [testProgressView1 makePointWithprogress:0.2 andColor:[UIColor blueColor]];
    [testProgressView1 makePointWithprogress:0.8 andColor:[UIColor blackColor]];
    [testProgressView1 makePointWithprogress:1 andColor:[UIColor purpleColor]];

}

- (IBAction)bigBtn:(id)sender {
    CGRect frame = self.testView.frame;
    frame.size.width += 10;
    frame.size.height += 10;
    self.testView.frame = frame;
}
- (IBAction)smallBtn:(id)sender {
    CGRect frame = self.testView.frame;
    frame.size.width -= 10;
    frame.size.height -= 10;
    self.testView.frame = frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
