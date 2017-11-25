//
//  PlaceHolderImageView.h
//  照片浏览器
//
//  Created by Apple on 2017/8/29.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RQPlaceHolderImageView : UIImageView
/** 进度 */
@property(nonatomic, assign) CGFloat progress;

@end

@interface RQProgressView : UIView
/** 进度 */
@property(nonatomic, assign) CGFloat progress;

@end
