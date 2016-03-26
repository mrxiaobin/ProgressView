//
//  MyProgressView.m
//  MyProgressBar
//
//  Created by 祝小斌 on 16/3/13.
//  Copyright © 2016年 祝小斌. All rights reserved.
//

#import "MyProgressView.h"
#define PROGRESSBARHEIGHT 20
#define PROGRESSLINEHEIGHT 5

@interface MyProgressView()

@property (nonatomic, strong) UIBezierPath *progressPath;//进度条已走部分
@property (nonatomic, strong) UIBezierPath *progressPathRight;//进度条剩余部分
@property (nonatomic, strong) NSMutableArray *paths; //要打的点
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
        _slidePointBtn.layer.cornerRadius = PROGRESSBARHEIGHT * 0.5;
        _slidePointBtn.layer.borderWidth = 0.3;
        _slidePointBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [_slidePointBtn setBackgroundColor:[UIColor whiteColor]];
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
    frame.size.height = PROGRESSBARHEIGHT;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.progress = 0;
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
        CGFloat x = (self.frame.size.width - PROGRESSBARHEIGHT - PROGRESSLINEHEIGHT) * progress + PROGRESSBARHEIGHT * 0.5;
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x, (PROGRESSBARHEIGHT - PROGRESSLINEHEIGHT) * 0.5, PROGRESSLINEHEIGHT, PROGRESSLINEHEIGHT)];
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
    frame.origin.x = (self.frame.size.width - PROGRESSBARHEIGHT) * _progress;
    _slidePointBtn.frame = frame;
    [self dragToChangeProgress];
    [self drawToProgress:_progress];
}

-(void)drawToProgress:(CGFloat)progress {
    UIBezierPath *path = [UIBezierPath bezierPath];
    _progressPath = path;
    [path moveToPoint:CGPointMake(PROGRESSBARHEIGHT * 0.5, PROGRESSBARHEIGHT * 0.5)];
    CGFloat x = (self.frame.size.width - PROGRESSLINEHEIGHT * 0.5) * _progress;
    [_progressPath addLineToPoint:CGPointMake(x, PROGRESSBARHEIGHT * 0.5)];
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    _progressPathRight = path1;
    [path1 moveToPoint:CGPointMake(x, PROGRESSBARHEIGHT * 0.5)];
    [_progressPathRight addLineToPoint:CGPointMake(self.frame.size.width - PROGRESSBARHEIGHT * 0.5, PROGRESSBARHEIGHT * 0.5)];
    
    [self setNeedsDisplay];
}

- (CGPoint)pointWithTouches:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint pos = [touch locationInView:self];
    pos.x -= PROGRESSBARHEIGHT * 0.5;
    
    return pos;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint pos = [self pointWithTouches:touches];
    
    self.progress = pos.x / (self.frame.size.width - PROGRESSBARHEIGHT);
    [self dragToChangeProgress];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint pos = [self pointWithTouches:touches];

    self.progress = pos.x / (self.frame.size.width - PROGRESSBARHEIGHT);
    [self dragToChangeProgress];
}

-(void)dragToChangeProgress {
    if ([self.delegate respondsToSelector:@selector(myProgressViewdidChange:)]) {
        [self.delegate myProgressViewdidChange:self];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.slidePointBtn.frame = CGRectMake((self.frame.size.width - PROGRESSBARHEIGHT) * _progress, 0, PROGRESSBARHEIGHT, PROGRESSBARHEIGHT);
    [self drawPointsWithPoints:_points];
    [self drawToProgress:_progress];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //绘制进度条已走的部分颜色
    _progressPath.lineWidth = PROGRESSLINEHEIGHT;
    [[UIColor lightGrayColor] set];
    [_progressPath stroke];
    
    //绘制进度条剩余部分颜色
    _progressPathRight.lineWidth = PROGRESSLINEHEIGHT;
    [[UIColor darkGrayColor] set];
    [_progressPathRight stroke];
    
    // 遍历所有要打的点路径绘制
    for (int i = 0; i < self.paths.count; i++) {
        UIBezierPath *path = (UIBezierPath*)self.paths[i];
        NSDictionary *pointDic = self.points[i];
        UIColor *color = [pointDic objectForKey:@"color"];
        [color set];
        [path fill];
    }
}

@end
