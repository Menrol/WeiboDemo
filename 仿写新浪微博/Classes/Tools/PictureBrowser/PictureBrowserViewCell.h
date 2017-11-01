//
//  PictureBrowserViewCell.h
//  仿写新浪微博OC
//
//  Created by Apple on 2017/8/26.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PictureBrowserCellDelegate <NSObject>

- (void)pictureBrowserCellWillDismiss;
- (void)pictureDidScrollToScaleWihScale:(CGFloat)scale;
- (void)pictureDidLongPressWithImage:(UIImage *)image;

@end

@interface PictureBrowserViewCell : UICollectionViewCell
/** 图片Url */
@property(nonatomic, copy) NSURL *imageUrl;
/** 滚动视图 */
@property(nonatomic, strong) UIScrollView *scrollView;
/** 图片 */
@property(nonatomic, strong) UIImageView *imageView;
/** 代理 */
@property(nonatomic, weak) id<PictureBrowserCellDelegate> pictureDelegate;

@end
