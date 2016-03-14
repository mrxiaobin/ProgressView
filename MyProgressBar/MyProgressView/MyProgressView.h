//
//  MyProgressView.h
//  MyProgressBar
//
//  Created by 祝小斌 on 16/3/13.
//  Copyright © 2016年 祝小斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProgressView : UIView

/**
 *  进度条的进度 0 - 1 之间
 */
@property (nonatomic, assign)CGFloat progress;

/**
 *  在进度条上打点
 *
 *  @param progress 打点位置(0 - 1)
 *  @param color    点的颜色
 */
-(void)makePointWithprogress:(CGFloat)progress andColor:(UIColor*)color;

@end
