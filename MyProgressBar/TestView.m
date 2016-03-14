//
//  TestView.m
//  MyProgressBar
//
//  Created by 祝小斌 on 16/3/14.
//  Copyright © 2016年 祝小斌. All rights reserved.
//

#import "TestView.h"
#import "MyProgressView.h"

@interface TestView ()

@property (nonatomic, strong)MyProgressView *progressView;

@end

@implementation TestView

-(void)awakeFromNib {
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fullScreen)];
    [doubleTap setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTap];
    
    MyProgressView *progressView = [[MyProgressView alloc]init]; //用默认大小初始化进度条
    [self addSubview:progressView];
    _progressView = progressView;
    
    [_progressView makePointWithprogress:0.5 andColor:[UIColor orangeColor]];
    [_progressView makePointWithprogress:0.1 andColor:[UIColor yellowColor]];
    [_progressView makePointWithprogress:0.3 andColor:[UIColor blueColor]];
    [_progressView makePointWithprogress:0.9 andColor:[UIColor blackColor]];
    [_progressView makePointWithprogress:0.6 andColor:[UIColor purpleColor]];
}

-(void)fullScreen {
    CGRect frame = self.frame;
    CGFloat scaleX = frame.size.width / [UIScreen mainScreen].bounds.size.width;
    CGFloat scaleY = frame.size.height / [UIScreen mainScreen].bounds.size.height;
    CGFloat scale = scaleX > scaleY ? scaleX : scaleY;
    
    frame.size.height = frame.size.height / scale;
    frame.size.width = frame.size.width / scale;
    self.frame = frame;
    self.center = self.window.center;
}

/**
 *  注意，在这里设置进度条的frame
 */
-(void)layoutSubviews {
    self.progressView.frame = CGRectMake(0, self.frame.size.height - 10, self.frame.size.width, 10);
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint current = [touch locationInView:self];
    CGPoint pre = [touch previousLocationInView:self];
    
    CGFloat offsetX = current.x - pre.x;
    CGFloat offsetY = current.y - pre.y;
    
    CGPoint center = self.center;
    center.x += offsetX;
    center.y += offsetY;
    
    self.center = center;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
