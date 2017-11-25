//
//  PlaceHolderImageView.m
//  照片浏览器
//
//  Created by Apple on 2017/8/29.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "RQPlaceHolderImageView.h"

@interface RQPlaceHolderImageView ()
/** 进度视图 */
@property(nonatomic, strong) RQProgressView *progressView;

@end

@implementation RQPlaceHolderImageView

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    _progressView.progress = progress;
}

#pragma mark - 构造函数
- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {

        [self setupUI];
    }
    
    return self;
}

#pragma mark - 懒加载控件
- (RQProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[RQProgressView alloc] init];
        _progressView.backgroundColor = [UIColor clearColor];
    }
    
    return _progressView;
}

#pragma mark - 设置界面
- (void)setupUI {
    // 添加控件
    [self addSubview:self.progressView];
    
    // 设置布局
    _progressView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
}

@end

@implementation RQProgressView

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    // 绘图
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGPoint center = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
    CGFloat radius = rect.size.width * 0.5;
    CGFloat start = -M_PI_2;
    CGFloat end = start + 2 * _progress * M_PI;
    
    // 绘制外圆
    [[UIColor whiteColor] setStroke];
    
    CGFloat lineWidth = 0.5;
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius - lineWidth startAngle:0 endAngle:2 * M_PI clockwise:YES];
    borderPath.lineWidth = lineWidth;
    [borderPath stroke];
    
    // 绘制内圆
    [[UIColor colorWithWhite:0.0 alpha:0.5] setFill];
    radius -= 4 * lineWidth;
    UIBezierPath *trackPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:2 * M_PI clockwise:true];
    [trackPath fill];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:start endAngle:end clockwise:YES];
    
    [path addLineToPoint:center];
    [path closePath];
    
    [[UIColor whiteColor] setFill];
    
    [path fill];
}

@end
