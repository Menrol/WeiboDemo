//
//  PictureBrowserAnimator.h
//  仿写新浪微博OC
//
//  Created by Apple on 2017/8/29.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureBrowserPhotos.h"

@interface PictureBrowserAnimator : NSObject <UIViewControllerTransitioningDelegate>
/** 解除转场动画时的view */
@property(nonatomic, strong) UIImageView *fromImageView;


- (instancetype)initWithPhotos:(PictureBrowserPhotos *)photos;

@end
