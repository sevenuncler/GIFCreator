//
//  SUImagePickerViewController.m
//  DreamOneByOne
//
//  Created by Fanghe on 2017/5/8.
//  Copyright © 2017年 Sevenuncle. All rights reserved.
//

#import "SUImagePickerViewController.h"
#import "SUImagePickerCollectionViewCell.h"
#import "SUTopBarView.h"
#import "SUAlbumsTableViewCell.h"
#import "Macros.h"
#import "UIView+Layout.h"

#import <Photos/Photos.h>

#define ITEM_WIDTH (SCREEN_WIDTH/3-5)

@interface SUImagePickerViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>
{
    UICollectionView            *_collectionView;
    NSMutableArray              *_items;
    UICollectionViewFlowLayout  *_layout;
    NSMutableIndexSet           *_indexSet;
    UIButton                    *addButton;
}
@property (strong, nonatomic) UIButton      *sortButton;
@property (strong, nonatomic) UIButton      *titleButton;
@property (strong, nonatomic) PHFetchResult *smartAlbmus;
@property (strong, nonatomic) UITableView   *tableView;
@property (copy,   nonatomic) NSMutableArray  *albums;

@end

static  NSString *reuseIdentify  =   @"imageCellIdentify";
@implementation SUImagePickerViewController

#pragma mark - 重写父类方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor   =   [UIColor whiteColor];
    /* collectionView 设置 */
    _layout =   [[UICollectionViewFlowLayout alloc] init];
    _layout.itemSize        =    CGSizeMake(ITEM_WIDTH,ITEM_WIDTH);
    _layout.scrollDirection =    UICollectionViewScrollDirectionVertical;
    _layout.minimumLineSpacing  =   15.f;
    _layout.minimumInteritemSpacing =   5.f;
    _collectionView =   [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-64-30) collectionViewLayout:_layout];
    _collectionView.delegate    =   self;
    _collectionView.dataSource  =   self;
    _collectionView.allowsMultipleSelection =   YES;
    [_collectionView registerClass:[SUImagePickerCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentify];
    [self.view addSubview:_collectionView];
    
    _indexSet   =   [NSMutableIndexSet new];
    addButton =   [UIButton buttonWithType:UIButtonTypeContactAdd];
    addButton.frame =   CGRectMake(100,0,45,30);
    
    UIButton *submit    =   [UIButton buttonWithType:UIButtonTypeCustom];
    submit.backgroundColor  =   [UIColor whiteColor];
    [submit setTitle:@"确认选择" forState:UIControlStateNormal];
    [submit setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit];
//    [submit mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.trailing.bottom.equalTo(self.view);
//        make.height.mas_equalTo(50);
//    }];
    submit.frame = self.view.bounds;
    submit.size = CGSizeMake(self.view.size.width, 50);
    
    /* 导航栏设置 */
    [self setUpTopBar];
    
    /* 相册选择设置 */
    [self setUpTableView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _items  =   [NSMutableArray new];
    dispatch_queue_t    queue = dispatch_queue_create("com.netease.sevenuncle", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusRestricted ||
                status == PHAuthorizationStatusDenied) {
                return;
            } else {
                PHFetchOptions  *fetchOption    =   [[PHFetchOptions alloc] init];
                fetchOption.sortDescriptors     =   @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
//                PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOption];
                
                PHImageManager  *imageManager   =   [PHImageManager defaultManager];
                CGFloat scale = [UIScreen mainScreen].scale;
                CGSize screenSize = [UIScreen mainScreen].bounds.size;
                
                PHImageRequestOptions   *requestOptions =   [[PHImageRequestOptions alloc] init];
                requestOptions.resizeMode   =   PHImageRequestOptionsResizeModeFast;
                requestOptions.deliveryMode =   PHImageRequestOptionsDeliveryModeHighQualityFormat;
                requestOptions.synchronous  =   NO;
                
                for(PHAsset *asset in [self assetWithCollection:[self.smartAlbmus objectAtIndex:0]]){
                    [imageManager requestImageForAsset:asset targetSize:CGSizeMake(screenSize.width*scale, screenSize.height*scale) contentMode:PHImageContentModeAspectFit options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                        [_items  addObject:result];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_collectionView reloadData];
                        });
                    }];
                }
            }
        } ];
        
    });
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)dealloc {
    NSLog(@"%s 调用了", __func__);
}

#pragma mark - 自定义设置
- (void)setUpTableView {
    self.tableView  =   [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundColor  =   [UIColor colorWithWhite:1.f alpha:0.85];
    self.tableView.delegate     = self;
    self.tableView.dataSource   = self;
//    [self.tableView registerClass:[SUAlbumsTableViewCell class] forCellReuseIdentifier:@"reuseAlbumsCell"];
    self.tableView.tableFooterView  =   [UIView new];
    [self.view addSubview:self.tableView];
    self.tableView.hidden   =   YES;
}

- (void)setUpTopBar {
    if(self.navigationController) {
        
    }else {
        SUTopBarView *topBar = [SUTopBarView topBar];
        topBar.frame  = CGRectMake(0,0,SCREEN_WIDTH,44);
        topBar.backgroundColor  =   [UIColor whiteColor];
        /* 取消按钮 */
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setTitle:@"<" forState:UIControlStateNormal];
        [backButton setTitleColor:self.view.tintColor forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(onBackClicked:) forControlEvents:UIControlEventTouchUpInside];
        backButton.frame    =   CGRectMake(0, 0, 40, 40);
        topBar.leftBarButtonItem.customView =   backButton;
        
        /* 标题按钮 */
        UIView *container = [[UIView alloc] init];
        container.frame    = CGRectMake(0, 0, 120, 44);
        
        self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.titleButton setTitle:@"相机胶卷" forState:UIControlStateNormal];
        [self.titleButton setTitleColor:self.view.tintColor forState:UIControlStateNormal];
        [self.titleButton addTarget:self action:@selector(onSortClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.sortButton    =   [UIButton buttonWithType:UIButtonTypeCustom];
        [self.sortButton setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
        [self.sortButton setImage:[UIImage imageNamed:@"up"] forState:UIControlStateSelected];
        [self.sortButton addTarget:self action:@selector(onSortClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [container addSubview:self.titleButton];
        [container addSubview:self.sortButton];
//        [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.bottom.top.equalTo(container);
//            make.width.equalTo(container.mas_width).multipliedBy(0.7);
//        }];
        self.titleButton.frame = container.bounds;
        self.titleButton.size  = CGSizeMake(container.size.width*0.7f, container.size.height);
//        [self.sortButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(container);
//            make.size.mas_equalTo(CGSizeMake(8, 8));
//            make.leading.equalTo(self.titleButton.mas_trailing).offset(5);
//        }];
        self.sortButton.centerY = container.centerY;
        self.sortButton.size    = CGSizeMake(8, 8);
        self.sortButton.left    = self.titleButton.right + 5;
        topBar.centerBarButtonItem.customView = container;
        
        [self.view addSubview:topBar];
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SUAlbumsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseAlbumsCell"];
    if(nil == cell) {
        cell = [SUAlbumsTableViewCell loadCell];
    }
    
    PHAssetCollection *album = [self.albums objectAtIndex:indexPath.row];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:album options:nil];
    PHAsset *asset = [result lastObject];
    [self fillImageView:cell.cover byAsset:asset];
    cell.name.text  =   [NSString stringWithFormat:@"%@", album.localizedTitle];
    cell.count.text =   [NSString stringWithFormat:@"(%zi)", [result count]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PHAssetCollection *collection = self.albums[indexPath.row];
    _items = [self imagesWithAssetCollection:collection];
    self.tableView.hidden = YES;
    [self.titleButton setTitle:collection.localizedTitle forState:UIControlStateNormal];
    [self onSortClicked:self.sortButton];
    [_collectionView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}

#pragma mark - UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return (_items.count<(section+1)*3)?_items.count%3:3;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return (_items.count%3==0)?_items.count/3:(_items.count/3+1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SUImagePickerCollectionViewCell    *cell   =   nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentify forIndexPath:indexPath];
    NSInteger   ind = (indexPath.section*3+indexPath.item);
    if(ind<_items.count){
        cell.image  =   [_items objectAtIndex:ind];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [_indexSet addIndex:indexPath.section*3+indexPath.item ];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    [_indexSet removeIndex:indexPath.section*3+indexPath.item ];
}

#pragma mark - 事件处理
- (void)submit:(UIButton *)sender {
    NSMutableArray *medias = [NSMutableArray new];

    [_indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        [medias addObject:[_items objectAtIndex:idx]];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
    if(_completionHandler) {
        _completionHandler([medias copy]);
    }
}

- (void)onBackClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onSortClicked:(UIButton *)sender {
    //1. 显示UITableView
    //2. 按相册名称获取照片
    //3.

    self.tableView.hidden = self.sortButton.isSelected;
    [self.tableView reloadData];
    self.sortButton.selected = !self.sortButton.isSelected;
}


#pragma mark - setter & getter
- (NSArray *)albums {
    if(_albums == nil) {
        NSMutableArray *mutableArray = [NSMutableArray new];
    //相机胶卷
    PHFetchResult *cameras = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    //最近添加
    PHFetchResult *recents = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumRecentlyAdded options:nil];
    //视频
    PHFetchResult *videos = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumVideos options:nil];
    
    //个人收藏
    PHFetchResult *favorites = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumFavorites options:nil];
    
    //连拍快照
    PHFetchResult *bursts = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumBursts options:nil];
    
    //自定义
    PHFetchResult *regular = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        [cameras enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mutableArray addObject:obj];
        }];
        [recents enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mutableArray addObject:obj];
        }];
        [bursts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mutableArray addObject:obj];
        }];
        [videos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mutableArray addObject:obj];
        }];
        [favorites enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mutableArray addObject:obj];
        }];
        [regular enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mutableArray addObject:obj];
        }];
        _albums = mutableArray;
    }
    return _albums;
}

- (PHFetchResult *)smartAlbmus {
    if(!_smartAlbmus) {
        _smartAlbmus = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    }
    return _smartAlbmus;
}

#pragma mark - 获取相册或照片等

- (PHFetchResult *)assetWithCollection:(PHAssetCollection *)collection {
    //创建读取相册信息的options
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    //读取相册里面的所有信息 PHFetchResult <PHAsset *>
    PHFetchResult *assetsResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    return assetsResult;
}

- (void)fillImageView:(UIImageView *)imageView byAsset:(PHAsset *)asset {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous =   YES;
    options.resizeMode  =   PHImageRequestOptionsResizeModeFast;
    PHImageManager *manager = [PHImageManager defaultManager];
    __weak typeof(imageView) weakImageView = imageView;
    [manager requestImageForAsset:asset targetSize:CGSizeMake(45, 45) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        weakImageView.image = result;
    }];
}

- (NSMutableArray *)imagesWithAssetCollection:(PHAssetCollection *)collection {
    NSMutableArray *images = [NSMutableArray array];
    PHFetchResult *result = [self assetWithCollection:collection];
    PHImageManager *manager = [PHImageManager defaultManager];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.deliveryMode    =   PHImageRequestOptionsDeliveryModeFastFormat;
    
    for(PHAsset *asset in result) {
        [manager requestImageForAsset:asset targetSize:CGSizeMake(ITEM_WIDTH, ITEM_WIDTH) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [images addObject:result];
        }];
    }
    return images;
}
@end
