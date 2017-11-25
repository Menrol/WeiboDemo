//
//  RQPictureBrowserViewController.h
//  照片浏览器
//
//  Created by Apple on 2017/8/25.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RQPictureBrowserViewController : UIViewController
/** collectionView */
@property(nonatomic, strong) UICollectionView *collectionView;


+ (instancetype)photoBroswerWithSelectedIndex:(NSInteger)selectedIndex
                             urls:(NSArray <NSURL *> *)urls
                 parentImageViews:(NSArray <UIImageView *> *)parentImageViews;

@end

@interface RQPictureBrowserViewLayout : UICollectionViewFlowLayout
@end
