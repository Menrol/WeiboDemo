//
//  RQPictureBrowserAnimator.h
//  照片浏览器
//
//  Created by Apple on 2017/8/29.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RQPictureBrowserPhotos.h"

@interface RQPictureBrowserAnimator : NSObject <UIViewControllerTransitioningDelegate>
/** 解除转场动画时的view */
@property(nonatomic, strong) UIImageView *fromImageView;


- (instancetype)initWithPhotos:(RQPictureBrowserPhotos *)photos;

@end
