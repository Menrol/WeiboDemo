//
//  PictureBrowserViewController.m
//  仿写新浪微博OC
//
//  Created by Apple on 2017/8/25.
//  Copyright © 2017年 WRQ. All rights reserved.
//

#import "PictureBrowserViewController.h"
#import "PictureBrowserViewCell.h"
#import "PictureBrowserAnimator.h"
#import "PictureBrowserPhotos.h"
#import "SVProgressHUD.h"

// 可重用cellId
static NSString *const PictureBrowserViewCellId = @"PictureBrowserViewCellId";

@interface PictureBrowserViewController () <UICollectionViewDataSource,PictureBrowserCellDelegate> {
    PictureBrowserPhotos *_photos;
    PictureBrowserAnimator *_animator;
}
/** 保存按钮 */
@property(nonatomic, strong) UIButton *saveButton;
/** 删除按钮 */
@property(nonatomic, strong) UIButton *closeButton;

@end

@implementation PictureBrowserViewController

#pragma mark - 监听方法
- (void)close {
    PictureBrowserViewCell *cell = [_collectionView visibleCells][0];
    _animator.fromImageView = cell.imageView;
    _photos.selectedIndex = [_collectionView indexPathForCell:cell].row;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)savePicture {
    PictureBrowserViewCell *cell = [_collectionView visibleCells][0];
    
    UIImageWriteToSavedPhotosAlbum(cell.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }else {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }
}

#pragma mark - 构造函数
+ (instancetype)photoBroswerWithSelectedIndex:(NSInteger)selectedIndex urls:(NSArray<NSURL *> *)urls parentImageViews:(NSArray<UIImageView *> *)parentImageViews {
    return [[self alloc] initWithSelectedIndex:selectedIndex urls:urls parentImageViews:parentImageViews];
}

- (instancetype)initWithSelectedIndex:(NSInteger)selectedIndex urls:(NSArray<NSURL *> *)urls parentImageViews:(NSArray<UIImageView *> *)parentImageViews {
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _photos = [[PictureBrowserPhotos alloc] init];
        _photos.selectedIndex = selectedIndex;
        _photos.urls = urls;
        _photos.parentImageViews = parentImageViews;
        
        self.modalPresentationStyle = UIModalPresentationCustom;
        _animator = [[PictureBrowserAnimator alloc] initWithPhotos:_photos];
        self.transitioningDelegate = _animator;
    }
    
    return self;
}

#pragma mark - 视图生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 滚动到选中图片
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_photos.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)loadView {
    CGRect rect = [UIScreen mainScreen].bounds;
    rect.size.width += 20;
    self.view = [[UIView alloc] initWithFrame:rect];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupUI];
}

#pragma mark - 懒加载控件
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[PictureBrowserViewLayout alloc] init]];
    }
    
    return _collectionView;
}

//- (UIButton *)closeButton {
//    if (!_closeButton) {
//        _closeButton = [[UIButton alloc] initWithTitle:@"关闭" fontSize:14 color:[UIColor whiteColor] imageName:nil backColor:[UIColor darkGrayColor]];
//    }
//    return _closeButton;
//}
//
//- (UIButton *)saveButton {
//    if (!_saveButton) {
//        _saveButton = [[UIButton alloc] initWithTitle:@"保存" fontSize:14 color:[UIColor whiteColor] imageName:nil backColor:[UIColor darkGrayColor]];
//    }
//
//    return _saveButton;
//}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photos.urls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PictureBrowserViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PictureBrowserViewCellId forIndexPath:indexPath];
    
    cell.imageUrl = _photos.urls[indexPath.row];
    cell.pictureDelegate = self;
    
    return cell;
}

#pragma mark - PictureBrowserCellDelegate
- (void)pictureBrowserCellWillDismiss {
    [self close];
}

- (void)pictureDidScrollToScaleWihScale:(CGFloat)scale {
    BOOL isHidden = scale < 1;
    _saveButton.hidden = isHidden;
    _closeButton.hidden = isHidden;
    self.view.backgroundColor = isHidden ? [UIColor clearColor] : [UIColor blackColor];
    
    if (scale < 1) {
        self.view.alpha = scale;
        self.view.transform = CGAffineTransformMakeScale(scale, scale);
    }else {
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformIdentity;
    }
}

#pragma mark - 设置界面
- (void)setupUI {
    // 添加控件
    [self.view addSubview:self.collectionView];
//    [self.view addSubview:self.closeButton];
//    [self.view addSubview:self.saveButton];
    
    // 设置约束
    _collectionView.frame = self.view.bounds;
    
    CGFloat margin = [UIScreen mainScreen].scale * 4;
    
//    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).with.offset(margin);
//        make.bottom.equalTo(self.view.mas_bottom).with.offset(-margin);
//        make.size.mas_equalTo(CGSizeMake(100, 36));
//    }];
//    
//    [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.view.mas_right).with.offset(-margin - 20);
//        make.bottom.equalTo(self.view.mas_bottom).with.offset(-margin);
//        make.size.mas_equalTo(CGSizeMake(100, 36));
//    }];
    
    // 添加监听方法
    [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [_saveButton addTarget:self action:@selector(savePicture) forControlEvents:UIControlEventTouchUpInside];
    
    // 准备collectionview
    [self prepareCollectionView];
}

- (void)prepareCollectionView {
    _collectionView.backgroundColor = [UIColor clearColor];

    [_collectionView registerClass:[PictureBrowserViewCell class] forCellWithReuseIdentifier:PictureBrowserViewCellId];
    
    _collectionView.dataSource = self;
}

@end

@implementation PictureBrowserViewLayout

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
