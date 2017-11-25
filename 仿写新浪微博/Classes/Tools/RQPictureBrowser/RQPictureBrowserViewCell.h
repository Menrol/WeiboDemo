//
//  PictureBrowserViewCell.h
//  照片浏览器
//
//  Created by Apple on 2017/8/26.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RQPlaceHolderImageView.h"

@protocol RQPictureBrowserCellDelegate <NSObject>

- (void)pictureBrowserCellWillDismiss;
- (void)pictureDidScrollToScaleWihScale:(CGFloat)scale;
- (void)pictureDidLongPressWithImage:(UIImage *)image;

@end

@interface RQPictureBrowserViewCell : UICollectionViewCell
/** 图片Url */
@property(nonatomic, copy) NSURL *imageUrl;
/** 滚动视图 */
@property(nonatomic, strong) UIScrollView *scrollView;
/** 图片 */
@property(nonatomic, strong) UIImageView *imageView;
/** 占位图 */
@property(nonatomic, strong) RQPlaceHolderImageView *placeHolder;
/** 代理 */
@property(nonatomic, weak) id<RQPictureBrowserCellDelegate> pictureDelegate;

@end
