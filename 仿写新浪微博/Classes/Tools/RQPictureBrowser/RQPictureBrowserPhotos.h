//
//  RQPictureBrowserPhotos.h
//  照片浏览器
//
//  Created by Apple on 2017/10/30.
//  Copyright © 2017年 WRQ. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface RQPictureBrowserPhotos : NSObject
/** 选中索引 */
@property(nonatomic, assign) NSInteger selectedIndex;
/** url数组 */
@property(nonatomic, copy) NSArray<NSURL *> *urls;
/** 父视图的图像视图 */
@property(nonatomic, strong) NSArray<UIImageView *> *parentImageViews;

@end
