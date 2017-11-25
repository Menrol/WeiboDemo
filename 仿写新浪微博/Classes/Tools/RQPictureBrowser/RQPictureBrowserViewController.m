//
//  PictureBrowserViewController.m
//  照片浏览器
//
//  Created by Apple on 2017/8/25.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "RQPictureBrowserViewController.h"
#import "RQPictureBrowserViewCell.h"
#import "RQPictureBrowserAnimator.h"
#import "RQPictureBrowserPhotos.h"

// 可重用cellId
static NSString *const PictureBrowserViewCellId = @"PictureBrowserViewCellId";

@interface RQPictureBrowserViewController () <UICollectionViewDataSource,RQPictureBrowserCellDelegate,UICollectionViewDelegate> {
    RQPictureBrowserPhotos *_photos;
    RQPictureBrowserAnimator *_animator;
}

/** 页数显示按钮 */
@property(nonatomic, strong) UIButton *pageConutButton;
/** 提示文字 */
@property(nonatomic, strong) UILabel *messageLabel;


@end

@implementation RQPictureBrowserViewController

#pragma mark - 监听方法
- (void)close {
    RQPictureBrowserViewCell *cell = [_collectionView visibleCells][0];
    _animator.fromImageView = cell.imageView.frame.size.width > 0 ? cell.imageView : cell.placeHolder;
    _photos.selectedIndex = [_collectionView indexPathForCell:cell].row;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)savePictureWithImage:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *message = (error == nil) ? @"保存成功" : @"保存失败";
    
    _messageLabel.text = message;
    
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:0 animations:^{
        _messageLabel.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                _messageLabel.transform = CGAffineTransformMakeScale(0, 0);
            }];
        });
    }];
}

#pragma mark - 构造函数
+ (instancetype)photoBroswerWithSelectedIndex:(NSInteger)selectedIndex urls:(NSArray<NSURL *> *)urls parentImageViews:(NSArray<UIImageView *> *)parentImageViews {
    return [[self alloc] initWithSelectedIndex:selectedIndex urls:urls parentImageViews:parentImageViews];
}

- (instancetype)initWithSelectedIndex:(NSInteger)selectedIndex urls:(NSArray<NSURL *> *)urls parentImageViews:(NSArray<UIImageView *> *)parentImageViews {
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _photos = [[RQPictureBrowserPhotos alloc] init];
        _photos.selectedIndex = selectedIndex;
        _photos.urls = urls;
        _photos.parentImageViews = parentImageViews;
        
        self.modalPresentationStyle = UIModalPresentationCustom;
        _animator = [[RQPictureBrowserAnimator alloc] initWithPhotos:_photos];
        self.transitioningDelegate = _animator;
    }
    
    return self;
}

#pragma mark - 视图生命周期
- (void)loadView {
    CGRect rect = [UIScreen mainScreen].bounds;
    rect.size.width += 20;
    self.view = [[UIView alloc] initWithFrame:rect];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
    [UIView animateWithDuration:0.25 animations:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 滚动到选中图片
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_photos.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark - 懒加载控件
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[RQPictureBrowserViewLayout alloc] init]];
    }
    
    return _collectionView;
}

- (UIButton *)pageConutButton {
    if(!_pageConutButton) {
        _pageConutButton = [[UIButton alloc] init];
    }
    
    return _pageConutButton;
}

- (UILabel *)messageLabel {
    if(!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
    }
    
    return _messageLabel;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photos.urls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RQPictureBrowserViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PictureBrowserViewCellId forIndexPath:indexPath];
    
    cell.imageUrl = _photos.urls[indexPath.row];
    cell.pictureDelegate = self;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / self.view.bounds.size.width;
    
    [self setPageCountWithIndex:page + 1];
}

- (void)setPageCountWithIndex:(NSInteger)index {
    _pageConutButton.hidden = _photos.urls.count == 1;
    
    [_pageConutButton setTitle:[NSString stringWithFormat:@"%ld/%lu",(long)index,(unsigned long)_photos.urls.count] forState:UIControlStateNormal];
}

#pragma mark - PictureBrowserCellDelegate
- (void)pictureBrowserCellWillDismiss {
    [self close];
}

- (void)pictureDidScrollToScaleWihScale:(CGFloat)scale {
    BOOL isHidden = scale < 1;
    _pageConutButton.hidden = isHidden;
    self.view.backgroundColor = isHidden ? [UIColor clearColor] : [UIColor blackColor];
    
    if (scale < 1) {
        self.view.alpha = scale;
        self.view.transform = CGAffineTransformMakeScale(scale, scale);
    }else {
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformIdentity;
    }
}

- (void)pictureDidLongPressWithImage:(UIImage *)image {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"保存至相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self savePictureWithImage:image];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark - 设置界面
- (void)setupUI {
    // 添加控件
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.pageConutButton];
    [self.view addSubview:self.messageLabel];
    
    // 设置位置
    _collectionView.frame = self.view.bounds;
    
    CGPoint center = self.view.center;
    _pageConutButton.frame = CGRectMake(0, 0, 80, 40);
    center.y = _pageConutButton.frame.size.height;
    _pageConutButton.center = center;
    
    _messageLabel.frame = CGRectMake(0, 0, 120, 60);
    _messageLabel.center = self.view.center;
    
    // 准备collectionview
    [self prepareCollectionView];
    // 准备页数显示按钮
    [self preparePageCountButton];
    // 准备提示文本
    [self prepareMessageLabel];
}

- (void)prepareMessageLabel {
    _messageLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.layer.cornerRadius = 6;
    _messageLabel.layer.masksToBounds = YES;
    _messageLabel.transform = CGAffineTransformMakeScale(0, 0);
}

- (void)preparePageCountButton {
    _pageConutButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [_pageConutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _pageConutButton.layer.cornerRadius = 6;
    _pageConutButton.backgroundColor = [UIColor colorWithWhite:0.01 alpha:0.5];
    
    [self setPageCountWithIndex:_photos.selectedIndex + 1];
}

- (void)prepareCollectionView {
    _collectionView.backgroundColor = [UIColor clearColor];

    [_collectionView registerClass:[RQPictureBrowserViewCell class] forCellWithReuseIdentifier:PictureBrowserViewCellId];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
}

@end

@implementation RQPictureBrowserViewLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    self.itemSize = self.collectionView.bounds.size;
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
}

@end
