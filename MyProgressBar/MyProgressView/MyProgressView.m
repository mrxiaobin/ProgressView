//
//  MyProgressView.m
//  MyProgressBar
//
//  Created by 祝小斌 on 16/3/13.
//  Copyright © 2016年 祝小斌. All rights reserved.
//

#import "MyProgressView.h"
#define DEFAULTPROGRESSBARHEIGHT 10

/**
 *  注意，如果想要进度条随着父视图的frame变化而变化，一定要重写父视图的layoutSubviews方法，在该方法中设置进度条的位置，
 *  否则父视图大小发生变化时，进度条的frame不会随之而变，具体请参考TestView中的调用方法。
 */
@interface MyProgressView()

@property (nonatomic, assign, readonly) CGFloat progressBarH;
@property (nonatomic, assign, readonly) CGFloat slidePointR;
@property (nonatomic, strong) UIBezierPath *progressPath;
@property (nonatomic, strong) NSMutableArray *paths;
@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, strong)UIButton *slidePointBtn; // 拖动的点

@end

@implementation MyProgressView
- (NSMutableArray *)paths
{
    if (_paths == nil) {
        _paths = [NSMutableArray array];
    }
    
    return _paths;
}

- (NSMutableArray *)points
{
    if (_points == nil) {
        _points = [NSMutableArray array];
    }
    
    return _points;
}

-(UIButton*)slidePointBtn {
    if (!_slidePointBtn) {
        _slidePointBtn = [[UIButton alloc]init];
        _slidePointBtn.enabled = NO;
        _slidePointBtn.layer.cornerRadius = _slidePointR;
        [_slidePointBtn setBackgroundColor:[UIColor redColor]];
        [self addSubview:_slidePointBtn];
    }
    return _slidePointBtn;
}

/**
 *  用frame初始化
 *
 *  @param frame 进度条的位置，大小
 *
 *  @return 返回初始化的进度条
 */
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        _progressBarH = frame.size.height;
        _slidePointR = _progressBarH * 1.2;
    }
    return self;
}

/**
 *  用默认的大小初始化进度条
 *
 *  @return 返回初始化的进度条
 */
-(instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        _progressBarH = DEFAULTPROGRESSBARHEIGHT;
        _slidePointR = _progressBarH * 1.2;
    }
    return self;
}

-(void)makePointWithprogress:(CGFloat)progress andColor:(UIColor *)color {
    NSMutableDictionary *pointDic = [[NSMutableDictionary alloc]initWithCapacity:1];
    [pointDic setObject:[NSNumber numberWithFloat:progress] forKey:@"progress"];
    [pointDic setObject:color forKey:@"color"];
    [self.points addObject:pointDic];
}

-(void)drawPointsWithPoints:(NSArray *)pointsArray{
    [self.paths removeAllObjects];
    for (int i = 0; i < _points.count; i++) {
        NSDictionary *dic = _points[i];
        CGFloat progress = [[dic objectForKey:@"progress"] floatValue];
        CGFloat x = (self.frame.size.width - _slidePointR * 2) * progress;
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, 0, _progressBarH, _progressBarH)];
        [self.paths addObject:path];
    }
}

-(void)setProgress:(CGFloat)progress {
    _progress = progress;
    if (_progress > 1) {
        _progress = 1;
    } else if (_progress < 0){
        _progress = 0;
    }
    CGRect frame = self.slidePointBtn.frame;
    frame.origin.x = (self.frame.size.width - _slidePointR * 2) * _progress;
    _slidePointBtn.frame = frame;
    
    [self drawToProgress:_progress];
}

-(void)drawToProgress:(CGFloat)progress {
    UIBezierPath *path = [UIBezierPath bezierPath];
    _progressPath = path;
    [path moveToPoint:CGPointMake(0, _progressBarH * 0.5)];
    CGFloat x = (self.frame.size.width - _slidePointR) * _progress;
    [_progressPath addLineToPoint:CGPointMake(x, _progressBarH * 0.5)];
    [self setNeedsDisplay];
}

- (CGPoint)pointWithTouches:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    
    return [touch locationInView:self];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint pos = [self pointWithTouches:touches];
    self.progress = pos.x / self.frame.size.width;
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint pos = [self pointWithTouches:touches];

    self.progress = pos.x / self.frame.size.width;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

-(void)layoutSubviews {
    [super layoutSubviews];
    self.slidePointBtn.frame = CGRectMake((self.frame.size.width - _slidePointR * 2) * _progress, _progressBarH * 0.5  - _slidePointR, _slidePointR * 2, _slidePointR * 2);
    [self drawPointsWithPoints:_points];
    [self drawToProgress:_progress];
}

- (void)drawRect:(CGRect)rect {
    _progressPath.lineWidth = _progressBarH;
    
    [[UIColor greenColor] set];
    [_progressPath stroke];
    
    // 遍历所有的点路径绘制
    for (int i = 0; i < self.paths.count; i++) {
        UIBezierPath *path = (UIBezierPath*)self.paths[i];
        NSDictionary *pointDic = self.points[i];
        UIColor *color = [pointDic objectForKey:@"color"];
        [color set];
        [path fill];
    }
}


@end
