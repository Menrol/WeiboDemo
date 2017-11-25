//
//  RQPictureBrowserViewCell.m
//  照片浏览器
//
//  Created by Apple on 2017/8/26.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "RQPictureBrowserViewCell.h"
#import "RQPictureBrowserAnimator.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "FLAnimatedImageView+WebCache.h"

@interface RQPictureBrowserViewCell () <UIScrollViewDelegate>

@end

@implementation RQPictureBrowserViewCell

- (void)setImageUrl:(NSURL *)imageUrl {
    _imageUrl = imageUrl;
    
    [self resetScrollView];
    
    UIImage *placeHolderImage = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:imageUrl.absoluteString];
    [self preparePlaceHolderWithImage:placeHolderImage];
    
    [_imageView sd_setImageWithURL:[self bmiddleUrlWithUrl:imageUrl] placeholderImage:placeHolderImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _placeHolder.progress = (CGFloat)receivedSize / (CGFloat)expectedSize;
        });
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image != nil) {
            _placeHolder.hidden = YES;
            [self setPositionWithImage:image];
        }
    }];
}

- (void)tapPicture {
    [_pictureDelegate pictureBrowserCellWillDismiss];
}

- (void)longPressWithGesture:(UILongPressGestureRecognizer *)longGesture {
    if (longGesture.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    UIImage *image = self.imageView.image;
    
    if (image == nil) {
        return;
    }
    
    [_pictureDelegate pictureDidLongPressWithImage:image];
}

/* bmiddleUrl */
- (NSURL *)bmiddleUrlWithUrl:(NSURL *)url {
    NSString *urlString = [url absoluteString];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"/thumbnail/" withString:@"/bmiddle/"];
    
    return [NSURL URLWithString:urlString];
}

/* 初始化scrollView */
- (void)resetScrollView {
    // 重置imageView
    _imageView.transform = CGAffineTransformIdentity;
    
    _scrollView.contentInset = UIEdgeInsetsZero;
    _scrollView.contentSize = CGSizeZero;
    _scrollView.contentOffset = CGPointZero;
}

/* 设置位置 */
- (void)setPositionWithImage:(UIImage *)image {
    CGSize size = [self sizeWithImage:image];
    
    if (size.height > _scrollView.bounds.size.height) {
        _imageView.frame = CGRectMake(0, 0, size.width, size.height);
        _scrollView.contentSize = size;
        
        return;
    }
    
    _imageView.frame = CGRectMake(0, 0, size.width, size.height);
    
    // 设置顶部间距
    CGFloat y = (_scrollView.bounds.size.height - size.height) * 0.5;
    _scrollView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0);
}

/* 计算size */
- (CGSize)sizeWithImage:(UIImage *)image {
    CGFloat width = _scrollView.bounds.size.width;
    CGFloat height = image.size.height * width / image.size.width;
    
    return CGSizeMake(width, height);
}

/* 准备占位视图 */
- (void)preparePlaceHolderWithImage: (UIImage *)image {
    if (image == nil) {
        _placeHolder.frame = _scrollView.frame;
        return;
    }
    
    CGFloat width = _scrollView.bounds.size.width;
    CGFloat height = _scrollView.bounds.size.height;
    CGFloat h = image.size.height * width / image.size.width;
    
    _placeHolder.image = image;
    _placeHolder.frame = CGRectMake(0, 0, width, h);
    
    CGFloat y = 0;
    if (h > height) {
        _placeHolder.frame = CGRectMake(0, 0, width, height);
        return;
    }
    
    y = (height - h) / 2;
    _scrollView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0);
}


#pragma mark - 构造函数
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    
    return self;
}

#pragma mark - 懒加载控件
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[FLAnimatedImageView alloc] init];
    }
    
    return _imageView;
}

- (RQPlaceHolderImageView *)placeHolder {
    if (!_placeHolder) {
        _placeHolder = [[RQPlaceHolderImageView alloc] init];
    }
    
    return _placeHolder;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (scale < 1) {
        [_pictureDelegate pictureBrowserCellWillDismiss];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat y = (scrollView.bounds.size.height - _imageView.frame.size.height) * 0.5;
    y = y < 0 ? 0 : y;
    CGFloat x = (scrollView.bounds.size.width - _imageView.frame.size.width) * 0.5;
    x = x < 0 ? 0 : x;
    
    scrollView.contentInset = UIEdgeInsetsMake(y, x, 0, 0);
    
    [_pictureDelegate pictureDidScrollToScaleWihScale:_imageView.transform.a];
}

#pragma mark - 设置界面
- (void)setupUI {
    // 添加子控件
    [self.contentView addSubview:self.scrollView];
    [_scrollView addSubview:self.imageView];
    [_scrollView addSubview:self.placeHolder];
    
    // 设置大小
    CGRect rect = self.bounds;
    rect.size.width -= 20;
    _scrollView.frame = rect;
    
    // 设置缩放
    _scrollView.delegate = self;
    _scrollView.minimumZoomScale = 0.5;
    _scrollView.maximumZoomScale = 2.0;
    
    // 设置手势
    _imageView.userInteractionEnabled = YES;
    [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPicture)]];
    [_imageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressWithGesture:)]];
    
    _placeHolder.userInteractionEnabled = YES;
    [_placeHolder addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPicture)]];
}

@end
