//
//  RQPictureBrowserAnimator.m
//  照片浏览器
//
//  Created by Apple on 2017/8/29.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "RQPictureBrowserAnimator.h"
#import "RQPictureBrowserViewController.h"
#import "SDWebImageManager.h"

@interface RQPictureBrowserAnimator () <UIViewControllerAnimatedTransitioning> {
    BOOL _isPresent;
    RQPictureBrowserPhotos *_photos;
}

@end

@implementation RQPictureBrowserAnimator

#pragma mark - 构造函数
- (instancetype)initWithPhotos:(RQPictureBrowserPhotos *)photos {
    self = [super init];
    if (self) {
        _photos = photos;
    }
    
    return self;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _isPresent = NO;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _isPresent = YES;
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    _isPresent ? [self presentAnimationWithContext:transitionContext] : [self dismissAnimationWithContext:transitionContext];
}

#pragma mark - 自定义转场动画
- (void)presentAnimationWithContext: (id<UIViewControllerContextTransitioning>)context {
    UIView *toView = [context viewForKey:UITransitionContextToViewKey];
    [context.containerView addSubview:toView];
    RQPictureBrowserViewController *vc = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    vc.collectionView.hidden = YES;
    
    UIImageView *imageView = [self dummyImageView];
    UIImageView *parentIV = [self parentImageView];
    imageView.frame = [context.containerView convertRect:parentIV.frame fromView:parentIV.superview];
    [context.containerView addSubview:imageView];
    
    [UIView animateWithDuration:[self transitionDuration:context] animations:^{
        imageView.frame = [self endRectWithImageView:imageView];
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        vc.collectionView.hidden = NO;
        [context completeTransition:YES];
    }];
}

- (void)dismissAnimationWithContext: (id<UIViewControllerContextTransitioning>)context {
    UIView *fromView = [context viewForKey:UITransitionContextFromViewKey];
    
    UIImageView *imageView = [self dummyImageView];
    imageView.frame = [context.containerView convertRect:_fromImageView.frame fromView:_fromImageView.superview];
    
    [fromView removeFromSuperview];
    [context.containerView addSubview:imageView];
    
    [UIView animateWithDuration:[self transitionDuration:context] animations:^{
        UIImageView *parentIV = [self parentImageView];
        imageView.frame = [context.containerView convertRect:parentIV.frame fromView:parentIV.superview];
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        [context completeTransition:YES];
    }];
}

- (CGRect)endRectWithImageView:(UIImageView *)imageView {
    UIImage *image = imageView.image;
    
    if (image == nil ) {
        return imageView.frame;
    }
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGSize imageSize = screenSize;
    
    imageSize.height = image.size.height * imageSize.width / image.size.width;
    
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    
    if (imageSize.height < screenSize.height) {
        rect.origin.y = (screenSize.height - imageSize.height) / 2;
    }
    
    return rect;
}

- (UIImageView *)dummyImageView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self dummyImage]];
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    return imageView;
}

- (UIImageView *)parentImageView {
    return _photos.parentImageViews[_photos.selectedIndex];
}

- (UIImage *)dummyImage {
    NSString *key = [_photos.urls[_photos.selectedIndex] absoluteString];
    UIImage *image = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:key];
    
    if (image == nil) {
        image = _photos.parentImageViews[_photos.selectedIndex].image;
    }
    
    return image;
}
@end
