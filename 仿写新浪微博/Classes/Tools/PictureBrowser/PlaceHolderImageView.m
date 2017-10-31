//
//  PlaceHolderImageView.m
//  仿写新浪微博OC
//
//  Created by Apple on 2017/8/29.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "PlaceHolderImageView.h"

@interface PlaceHolderImageView ()
/** 进度视图 */
@property(nonatomic, strong) ProgressView *progressView;

@end

@implementation PlaceHolderImageView

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
- (ProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[ProgressView alloc] init];
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
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:32]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:32]];
}

@end

@implementation ProgressView

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
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:start endAngle:end clockwise:YES];
    
    [path addLineToPoint:center];
    [path closePath];
    
    [[UIColor whiteColor] setFill];
    
    [path fill];
}

@end
