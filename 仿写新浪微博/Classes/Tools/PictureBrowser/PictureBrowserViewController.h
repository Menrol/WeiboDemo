//
//  PictureBrowserViewController.h
//  仿写新浪微博OC
//
//  Created by Apple on 2017/8/25.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureBrowserViewController : UIViewController
/** collectionView */
@property(nonatomic, strong) UICollectionView *collectionView;

+ (instancetype)photoBroswerWithSelectedIndex:(NSInteger)selectedIndex
                             urls:(NSArray <NSURL *> *)urls
                 parentImageViews:(NSArray <UIImageView *> *)parentImageViews;

@end

@interface PictureBrowserViewLayout : UICollectionViewFlowLayout
@end
