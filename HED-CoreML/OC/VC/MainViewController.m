//
//  MainViewController.m
//  iOSOpenPose
//
//  Created by He on 2018/2/2.
//  Copyright © 2018年 Eugene Bokhan. All rights reserved.
//

#import "MainViewController.h"
#import "HED_CoreML-Swift.h"
#import "SUGIFManager.h"
#import "SUFrameCell.h"
#import "SUDrawView.h"
#import "SUPenView.h"

#define IMAGE_SIZE 50
static NSString *reuseID = @"reuseCell";
@interface MainViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong) UIImageView       *imageView;
@property(nonatomic, strong) CALayer           *skeletionLayer;
@property(nonatomic, strong) SUDrawView        *drawView;
@property(nonatomic, strong) dispatch_source_t timer;
@property(nonatomic, strong) UICollectionView  *collectionView;
@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong) NSArray           *sourceImages;
@property(nonatomic, strong) NSMutableArray<UIImage *>           *skeletonImages;
@property(nonatomic, strong) NSIndexPath       *currentIdx;

// 绘图工具菜单
@property(nonatomic, strong) UIButton        *saveFrameButton;
@property(nonatomic, strong) NSMutableArray  *frames;
@property(nonatomic, strong) UIButton        *gifSubmitButton;
@property(nonatomic, strong) SUPenView       *penView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.imageView addSubview:self.drawView];
//    [self.imageView addSubview:self.penView];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.saveFrameButton];
    [self.view addSubview:self.gifSubmitButton];
    
    [self.saveFrameButton addTarget:self action:@selector(onSaveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.gifSubmitButton addTarget:self action:@selector(onGifSaveAction:) forControlEvents:UIControlEventTouchUpInside];
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanAction:)];
    [self.drawView addGestureRecognizer:panGR];
    UIPanGestureRecognizer *penPanGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPenPanAction:)];
    [self.penView addGestureRecognizer:penPanGR];
    [self doWork];
}

- (void)onSaveAction:(id)sender {
    [self.frames replaceObjectAtIndex:self.currentIdx.item withObject:[self.drawView.shapes mutableCopy]];
}

- (void)onPenPanAction:(UIPanGestureRecognizer *)sender {
    CGPoint offset = [sender translationInView:self.drawView];
    CGPoint origin = self.penView.center;
    self.penView.center = CGPointMake(origin.x+offset.x, origin.y+offset.y);
    [sender setTranslation:CGPointZero inView:self.drawView];
}

- (void)onGifSaveAction:(id)sender {
    SUGIFManager *manager = [SUGIFManager sharedInstance];
    NSMutableArray *result = [NSMutableArray array];
    SUDrawView *drawView = [SUDrawView new];
    drawView.frame = self.drawView.frame;
    [self.frames enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UIImage class]]) {
            [result addObject:obj];
        }else {
            drawView.shapes = obj;
            UIImage *image = [drawView getSnapshot];
            [result addObject:image];
        }
    }];
    NSString *path = [manager generateGifWithArray:result];
    [manager saveToSystemAlbumsWithGIFPath:path];
}

- (void)onPanAction:(UIPanGestureRecognizer *)sender {
    CGPoint offset = [sender translationInView:self.drawView];
    CGPoint origin = self.penView.center;
    self.penView.center = CGPointMake(origin.x+offset.x, origin.y+offset.y);
    [sender setTranslation:CGPointZero inView:self.drawView];
    
    CGPoint point = self.penView.frame.origin;
    UIGestureRecognizerState state = sender.state;
    switch (state) {
        case UIGestureRecognizerStateBegan:
        {
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:point];
            Shape *shape = [Shape new];
            shape.path = [path copy];
            shape.property = [ShapeProperty new];
            shape.property.color = [UIColor redColor];
            shape.property.lineWidth = 3;
            [self.drawView.shapes addObject:shape];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            Shape *shape = self.drawView.shapes.lastObject;
            [shape.path addLineToPoint:point];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            Shape *shape = self.drawView.shapes.lastObject;
            [shape.path addLineToPoint:point];
            break;
        }
        default:
            break;
    }
    [self.drawView setNeedsDisplay];
}

- (void)doWork {
//    __weak typeof(self) weakSelf = self;
    // 步骤：
    // 1. 获取GIF/视频等
    NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"448_251" ofType:@"gif"];
    SUGIFManager *manager = [SUGIFManager sharedInstance];
    NSArray *images = [manager covertGifToImages:gifPath];
//    images = [images subarrayWithRange:NSMakeRange(0, 20)];
    NSLog(@">>>> 总共%zi <<<<", images.count);
    self.sourceImages = images;
    // 2. 使用CoreML获取
    NSMutableArray<UIImage *> *result = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [images enumerateObjectsUsingBlock:^(UIImage   *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@">>>> idx%zi <<<<", idx);

            UIImage *img = [ModelManager predication:obj];
            img = [self scaleToSize:img size:CGSizeMake(448, 251)];
//            NSString *tempFile = [NSString stringWithFormat:@"%@/xxx.png", NSTemporaryDirectory()];
//            if(![UIImagePNGRepresentation(img) writeToFile:tempFile atomically:YES]) {
//                NSLog(@"保存失败");
//            }
//            UIImage *image = [UIImage imageWithContentsOfFile:tempFile];
            [result addObject:img];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.imageView.image = img;
//            });
        }];
        NSLog(@">>>> CoreML完成 <<<<");
        NSString *path = [manager generateGifWithArray:result];
        [manager saveToSystemAlbumsWithGIFPath:path];
    });
    
//    self.skeletonImages = result;
    // 3. 编辑，展开每一帧图片,展示出获取的人体骨架，如果有需要完善骨架，提供绘图添加功能
    self.frames = [NSMutableArray arrayWithArray:images];
//    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
//    self.timer = timer;
//    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
//    static int idx = 0;
//    CALayer *layer = [CALayer layer];
//    layer.frame = self.imageView.bounds;
////    layer.position = self.imageView.center;
//    layer.opacity = 0.5;
//    [self.imageView.layer addSublayer:layer];
//    self.skeletionLayer = layer;
//    dispatch_source_set_event_handler(timer, ^{
//        weakSelf.imageView.image = images[idx];
//        layer.contents = (__bridge id _Nullable)(result[idx].CGImage);
//        idx ++;
//        idx = (idx) % images.count;
//    });
    [self.collectionView reloadData];
    // 4. 编辑，背景图片/颜色、背景音乐设置（视频）
    // 5. 完成，生成GIF或者视频文件
//    NSString *path = [manager generateGifWithArray:result];
//    [manager saveToSystemAlbumsWithGIFPath:path];
    
    
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (void)doPreview:(id)sender {
    dispatch_resume(self.timer);
}




#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIdx = indexPath;
    if(![self.frames[indexPath.item] isKindOfClass:[UIImage class]]) {
        self.drawView.shapes = self.frames[indexPath.item];
    }else {
//        self.drawView.shapes = nil;
    }
    [self.drawView setNeedsDisplay];

    self.imageView.image = self.sourceImages[indexPath.item];
//    self.skeletionLayer.contents = (__bridge id)(self.skeletonImages[indexPath.section].CGImage);
    NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:indexPath.section];
    [self.collectionView reloadSections:set];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sourceImages.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SUFrameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    cell.sourceIV.image = self.sourceImages[indexPath.item];
    return cell;
}

- (UIImageView *)imageView {
    if(!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 368, 368)];
        _imageView.backgroundColor = [UIColor blackColor];
//        _imageView.alpha = 0.5;
        _imageView.center = CGPointMake(self.view.frame.size.width/2.f, self.view.frame.size.height/2.f);
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UICollectionView *)collectionView {
    if(!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-IMAGE_SIZE, self.view.frame.size.width, IMAGE_SIZE) collectionViewLayout:self.flowLayout];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[SUFrameCell class] forCellWithReuseIdentifier:reuseID];
        
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if(!_flowLayout) {
        _flowLayout = [UICollectionViewFlowLayout new];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.itemSize = CGSizeMake(IMAGE_SIZE, IMAGE_SIZE);
    }
    return _flowLayout;
}

- (SUDrawView *)drawView {
    if(!_drawView) {
        _drawView = [[SUDrawView alloc] initWithFrame:self.imageView.bounds];
        _drawView.backgroundColor = [UIColor whiteColor];
//        _drawView.alpha = 0.5;
    }
    return _drawView;
}

- (UIButton *)saveFrameButton {
    if(!_saveFrameButton) {
        _saveFrameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveFrameButton.frame = CGRectMake(200, 64, 50, 30);
        _saveFrameButton.backgroundColor = [UIColor redColor];
    }
    return _saveFrameButton;
}

- (UIButton *)gifSubmitButton {
    if(!_gifSubmitButton) {
        _gifSubmitButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _gifSubmitButton.frame = CGRectMake(270, 64, 50, 30);
        _gifSubmitButton.backgroundColor = [UIColor blueColor];
    }
    return _gifSubmitButton;
}

- (SUPenView *)penView {
    if(!_penView) {
        _penView = [[SUPenView alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
        _penView.backgroundColor = [UIColor clearColor];
    }
    return _penView;
}

@end
