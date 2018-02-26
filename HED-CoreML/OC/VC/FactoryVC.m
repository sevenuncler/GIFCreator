//
//  FactoryVC.m
//  HED-CoreML
//
//  Created by He on 2018/2/15.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "FactoryVC.h"
#import "UIView+Layout.h"
#import "Macros.h"
#import "SUFrameCell.h"
#import "SUGIFManager.h"
#import "SAMCubicSpline.h"
#import "SUKeyFrameProperty.h"
#import "UIImage+Compose.h"
#import "UIImageView+Boder.h"
#import "SUContainerView.h"

@interface FactoryVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong) id                         menuPanel;
@property(nonatomic, strong) UIImageView                *preView;
@property(nonatomic, strong) UICollectionView           *sourceImages;
@property(nonatomic, strong) UICollectionView           *effectImagesView;
@property(nonatomic, strong) UIImageView                *effectImageView;
@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong) NSArray<UIImage *>         *images;
@property(nonatomic, strong) NSArray<UIImage *>         *effectImages;
@property(nonatomic, strong) NSMutableArray<SUKeyFrameProperty *> *keyFrameProperties;
@property(nonatomic, strong) SAMCubicSpline             *cubicSpline;
@property(nonatomic, assign) CGSize                     targetSize;
@property(nonatomic, strong) SUKeyFrameProperty         *frameProperty;
@property(nonatomic, assign) NSInteger                  sourceIdx;
@property(nonatomic, assign) NSInteger                  effectIdx;
@property(nonatomic, strong) UIButton                   *submitButton;
@property(nonatomic, strong) SUContainerView            *containerView;

// GIF基本信息
@property(nonatomic, assign) CGSize                     gifSize;
@end

static NSString * const reuseID = @"reuseCell";
static NSString * const reuseID1 = @"reuseCell";
@implementation FactoryVC

#pragma mark - System Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.preView];
    [self.view addSubview:self.sourceImages];
    [self.view addSubview:self.effectImagesView];
    [self.view addSubview:self.containerView];
    [self.preView addSubview:self.effectImageView];
    self.targetSize = CGSizeMake(SCREEN_WIDTH, 270);
    [self setUpViewConfig];
    
    // Step1 加载图片
    self.images        = [self fetchImages:@"448_251"];
    self.preView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*self.gifSize.height/self.gifSize.width);
    // Step2 特效图片
    self.effectImages  = [self fetchEffectImages:@"round"];
    
    // Step3 关键帧
    NSArray *keyFrames = [self keyFrame];
    
    // Step4 光滑曲线
    self.cubicSpline   = [self smoothLine:keyFrames];
    
    // Step5 导出图片
//    [self conductGIF:self.images withEffectImages:self.effectImages];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.preView.centerY = self.view.size.height / 2;
    self.sourceImages.botton = self.view.size.height;
    
    self.effectImagesView.top = 64;
}

#pragma mark - Privte Method

- (void)setUpViewConfig {
    [self.sourceImages registerClass:[SUFrameCell class] forCellWithReuseIdentifier:reuseID];
    [self.effectImagesView registerClass:[SUFrameCell class] forCellWithReuseIdentifier:reuseID1];
    
    self.sourceImages.dataSource = self;
    self.sourceImages.delegate   = self;
    
    self.effectImagesView.delegate   = self;
    self.effectImagesView.dataSource = self;
    
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanAction:)];
    [self.effectImageView addGestureRecognizer:panGR];

    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAction:)];
    [self.effectImageView addGestureRecognizer:tapGR];
    
    self.preView.userInteractionEnabled         = YES;
    self.effectImageView.userInteractionEnabled = YES;
    
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton.backgroundColor = [UIColor redColor];
    self.submitButton.size = CGSizeMake(100, 40);
    self.submitButton.center = CGPointMake(100, 100);
    [self.submitButton addTarget:self action:@selector(onSubmitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];
}

- (void)onTapAction:(UITapGestureRecognizer *)sender {
    
}

- (void)onSubmitAction:(id)sender {
    
    self.cubicSpline = [self smoothLineWithArray:self.images];

    SUKeyFrameProperty *currentProperty;
    NSMutableArray *result = [NSMutableArray array];
    for (UIImage *image in self.images) {
        if(image.frameProperty && image.isKeyFrame) {
            if(currentProperty == nil) {
                currentProperty = image.frameProperty;
            }else {
                NSArray *array = [self caculateKeyFrameFrom:currentProperty toFrame:image.frameProperty WithImages:self.effectImages];
                currentProperty = image.frameProperty;
                [result addObjectsFromArray:array];
            }
        }
    }
    [self conductGIF:self.images withEffectImages:self.effectImages];


}

- (void)onPanAction:(UIPanGestureRecognizer *)sender {
    UIView *view = sender.view;
    CGPoint offset = [sender translationInView:self.preView];
    CGPoint destination = CGPointMake(view.center.x + offset.x, view.center.y + offset.y);
    if(destination.x+view.size.width/2 > self.preView.size.width) {
        destination.x = self.preView.size.width - view.size.width/2;
    }else if(destination.x-view.size.width/2 < 0) {
        destination.x = view.size.width/2;
    }
    
    if(destination.y + view.size.height/2 > self.preView.size.height) {
        destination.y = self.preView.size.height - view.size.height/2;
    }else if(destination.y - view.size.height/2 < 0) {
        destination.y = view.size.height/2;
    }
    
    view.center = destination;
    [sender setTranslation:CGPointZero inView:self.preView];
}

#pragma mark - Gif Step

// 1. 获取Images
- (NSArray *)fetchImages:(NSString *)imagePath {
    NSString *gifPath = [[NSBundle mainBundle] pathForResource:imagePath ofType:@"gif"];
    SUGIFManager *manager = [SUGIFManager sharedInstance];
    NSArray *images = [manager covertGifToImages:gifPath];
    if(images && images.count>0) {
        UIImage *image = images[0];
        self.gifSize   = image.size;
    }
    return images;
}

// 2. 选择特效Images(gif)
- (NSArray *)fetchEffectImages:(NSString *)imagePath {
    NSString *gifPath1 = [[NSBundle mainBundle] pathForResource:imagePath ofType:@"gif"];
    SUGIFManager *manager = [SUGIFManager sharedInstance];
    NSArray *images1 = [manager covertGifToImages:gifPath1];
    return images1;
}

// 3. 设置关键帧
- (NSArray<SUKeyFrameProperty *> *)keyFrame {
    NSMutableArray *points = [NSMutableArray array];
    {
        SUKeyFrameProperty *property = [SUKeyFrameProperty new];
        property.sourceIdx = 0;
        property.effectIdx = 0;
        property.rect      = CGRectMake(0, 0, 30, 30);
        [points addObject:property];
    }
    {
        SUKeyFrameProperty *property = [SUKeyFrameProperty new];
        property.sourceIdx = 13;
        property.effectIdx = 5;
        property.rect      = CGRectMake(10, 30, 30, 30);
        [points addObject:property];
    }
    {
        SUKeyFrameProperty *property = [SUKeyFrameProperty new];
        property.sourceIdx = 50;
        property.effectIdx = 10;
        property.rect      = CGRectMake(20, 30, 30, 30);
        [points addObject:property];
    }
    {
        SUKeyFrameProperty *property = [SUKeyFrameProperty new];
        property.sourceIdx = 70;
        property.effectIdx = 20;
        property.rect      = CGRectMake(30, 40, 30, 30);
        [points addObject:property];
    }
    {
        SUKeyFrameProperty *property = [SUKeyFrameProperty new];
        property.sourceIdx = 80;
        property.effectIdx = 42;
        property.rect      = CGRectMake(40, 45, 30, 30);
        [points addObject:property];
    }
    return points;
}

// 4. 光滑曲线函数
- (SAMCubicSpline *)smoothLine:(NSArray<SUKeyFrameProperty *> *)points {
    NSMutableArray *interlPoints = [NSMutableArray array];
    [points enumerateObjectsUsingBlock:^(SUKeyFrameProperty * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = CGPointMake(obj.rect.origin.x/self.targetSize.width, obj.rect.origin.y/self.targetSize.height);
        [interlPoints addObject:[NSValue valueWithCGPoint:point]];
    }];
    SAMCubicSpline *splineX = [[SAMCubicSpline alloc] initWithPoints:interlPoints.copy];
    return splineX;
}

- (SAMCubicSpline *)smoothLineWithArray:(NSArray<UIImage *> *)images {
    NSMutableArray *interlPoints = [NSMutableArray array];
    [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.frameProperty) {
            SUKeyFrameProperty *frameProperty = obj.frameProperty;
            CGPoint point = CGPointMake(frameProperty.rect.origin.x/self.targetSize.width, frameProperty.rect.origin.y/self.targetSize.height);
            [interlPoints addObject:[NSValue valueWithCGPoint:point]];
        }
    }];
    SAMCubicSpline *splineX = [[SAMCubicSpline alloc] initWithPoints:interlPoints.copy];
    return splineX;
}

// 5. 合成特效
// 6. 生成GIF
- (NSString *)conductGIF:(NSArray *)images withEffectImages:(NSArray *)images1{
    SUGIFManager *manager = [SUGIFManager sharedInstance];
    NSArray *composeImages = [self compose2:images with:images1];
    NSString *gifSavePath = [manager generateGifWithArray:composeImages];
    [manager saveToSystemAlbumsWithGIFPath:gifSavePath];
    return gifSavePath;
}

#pragma mark - 功能函数

// Compose 1
- (NSArray *)compose:(NSArray<UIImage *> *)source with:(NSArray *)effects {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:source.count];
    __weak NSArray *weakSource = source;
    __block CGFloat x = 0;
    __weak typeof(self) weakSelf = self;
    [effects enumerateObjectsUsingBlock:^(UIImage *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *image = [weakSource[idx] composeWithImage:obj inRect:CGRectMake(x*100, [weakSelf.cubicSpline interpolate:x]*100, 40, 40)];
        x += 10/100.f;
        [result addObject:image];
    }];
    return result;
}

// Compose 2
- (NSArray *)compose2:(NSArray<UIImage *> *)source with:(NSArray *)effects {
    NSMutableArray *result = [NSMutableArray arrayWithArray:source];
    __weak NSMutableArray<UIImage *> *weakSource = result;
    
    [result enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.frameProperty) {
            SUKeyFrameProperty *property = obj.frameProperty;
            CGFloat targetWidth   = obj.size.width;
            CGFloat targetHeight  = obj.size.height;
            CGRect  releativeRect = property.rect;
            UIImage *image = [obj composeWithImage:effects[property.effectIdx] inRect:CGRectMake(releativeRect.origin.x * targetWidth,
                                  releativeRect.origin.y * targetHeight,
                                  releativeRect.size.width  * targetWidth,
                                  releativeRect.size.height * targetHeight)];
            [weakSource replaceObjectAtIndex:idx withObject:image];
        }
    }];
    return result;
}

- (NSArray *)caculateKeyFrameFrom:(SUKeyFrameProperty *)from toFrame:(SUKeyFrameProperty *)to WithImages:(NSArray<UIImage *> *)images{
    NSInteger sourceStart = from.sourceIdx;
    NSInteger sourceEnd   = to.sourceIdx;
    NSInteger effectStart = from.effectIdx;
    NSInteger effectEnd   = to.effectIdx;
    CGRect    fromRect    = from.rect;
    CGRect    toRect      = to.rect;
    
    // 错误，返回Nil
    int sStep = 1;
    int eStep = 1;
    // TODO 需要完善
    if(sourceEnd < sourceStart) {
        sStep = -1;
    }
    if(effectEnd < effectStart) {
        eStep = -1;
    }
    
    NSInteger sourceCount = sourceEnd - sourceStart + 1;
    NSInteger effectCount = effectEnd - effectStart + 1;
    CGFloat gap = sourceCount/ (CGFloat)effectCount;
    CGFloat   rectGap     = (toRect.origin.x - fromRect.origin.x)/sourceCount;
    CGFloat   rectVetGap  = (toRect.origin.y - fromRect.origin.y)/sourceCount;
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:sourceEnd - sourceStart];
    NSLog(@">>>>> 原始起始:%zi 结束:%zi 水平:%lf 垂直:%lf", sourceStart, sourceEnd, rectGap, rectVetGap);
    NSLog(@">>>>> 特效起始:%zi 结束:%zi 水平:%lf 垂直:%lf", effectStart, effectEnd, rectGap, rectVetGap);
    if(gap>1) { // 增加frame
        // 5-9 中插入0-3

        for(int i=1; i<sourceCount-1; i++) {
            NSInteger idx = ((NSInteger)((i)/gap)) % effectCount;
//            [array addObject:images[idx]];
            if(eStep > 0) {
                idx = idx + effectStart;
            }else {
                idx = effectEnd - idx;
            }
            // 添加特效对应属性
            NSInteger sourceIdx = sourceStart + i;
            if(self.images[sourceStart+i].frameProperty == nil) {
                SUKeyFrameProperty *keyProperty = [SUKeyFrameProperty new];
                keyProperty.sourceIdx = sourceIdx;
                keyProperty.rect      = from.rect;
                self.images[sourceIdx].frameProperty = keyProperty;
            }
            SUKeyFrameProperty *effectProperty   = images[effectEnd].frameProperty;
            CGRect             effectRect        = effectProperty.rect;
            SUKeyFrameProperty *keyFrameProperty = self.images[sourceIdx].frameProperty;
            keyFrameProperty.effectIdx = idx;
            keyFrameProperty.image     = images[idx];
            keyFrameProperty.rect      = CGRectMake(fromRect.origin.x+i*rectGap, fromRect.origin.y+i*rectVetGap, effectRect.size.width, effectRect.size.height);
            NSLog(@">>>>> 插入特效:%zi 特效:%zi rect:%@", sourceIdx, idx, NSStringFromCGRect(keyFrameProperty.rect));
        }
    }else {     // 减少frame
        // 3-9 中插入 5-14
        gap = effectCount / (CGFloat)sourceCount;
        for(int i=1; i<sourceCount-1; i++) {
            NSInteger idx = (NSInteger)((i)*gap) % effectCount;

            if(eStep > 0) {
                idx = idx + effectStart;
            }else {
                idx = effectEnd - idx;
            }
            // 添加特效对应属性
            NSInteger sourceIdx = sourceStart + i;
            if(self.images[sourceStart+i].frameProperty == nil) {
                SUKeyFrameProperty *keyProperty = [SUKeyFrameProperty new];
                keyProperty.sourceIdx = sourceIdx;
                keyProperty.rect      = from.rect;
                self.images[sourceIdx].frameProperty = keyProperty;
            }
            SUKeyFrameProperty *effectProperty   = images[effectEnd].frameProperty;
            CGRect             effectRect        = effectProperty.rect;
            SUKeyFrameProperty *keyFrameProperty = self.images[sourceIdx].frameProperty;
            keyFrameProperty.effectIdx = idx;
            keyFrameProperty.image     = images[idx];
            keyFrameProperty.rect      = CGRectMake(fromRect.origin.x+i*rectGap, fromRect.origin.y+i*rectVetGap, effectRect.size.width, effectRect.size.height);
            NSLog(@">>>>> 插入特效2:%zi 特效:%zi rect:%@", sourceIdx, idx, NSStringFromCGRect(keyFrameProperty.rect));
        }
    }
//    [array addObject:images[effectEnd]];
//    NSLog(@">>>>> %zi", effectEnd);
    
    NSLog(@">>>>> 插入特效3:%zi 特效:%zi rect:%@", sourceEnd, effectEnd, NSStringFromCGRect(self.images[sourceEnd].frameProperty.rect));


    return [array copy];
}

- (void)showSourceImageWithIndex:(NSInteger)index {
    
}

- (void)saveKeyFrame {
    if(self.effectImageView.hidden == YES) {
        return;
    }
    CGRect  rectEffect = self.effectImageView.frame;
    CGRect  rectPreView = self.preView.frame;
//    CGFloat scale = rectPreView.size.width/rectEffect.size.width;
//    CGFloat scale1= rectPreView.size.height/rectEffect.size.height;
//
//    CGFloat ratio = self.gifSize.width / rectPreView.size.width;
    
    
    self.frameProperty.rect = CGRectMake(rectEffect.origin.x / rectPreView.size.width,
                                         rectEffect.origin.y / rectPreView.size.height,
                                         rectEffect.size.width/rectPreView.size.width,
                                         rectEffect.size.height/rectPreView.size.height );
    
    self.frameProperty.sourceIdx = self.sourceIdx;
    self.frameProperty.effectIdx = self.effectIdx;
    self.frameProperty.image     = self.effectImages[self.effectIdx];
    
    self.images[self.sourceIdx].tag = self.effectIdx;
    self.images[self.sourceIdx].isKeyFrame    = YES;
    self.images[self.sourceIdx].frameProperty = [self.frameProperty copy];
    
    self.effectImages[self.effectIdx].tag = self.effectIdx;
    self.effectImages[self.effectIdx].frameProperty = [self.frameProperty copy];
    SUKeyFrameProperty *p = self.effectImages[self.effectIdx].frameProperty;
    NSLog(@">>>>>> 原:%zi 特:%zi rect:%@", p.sourceIdx,p.effectIdx, NSStringFromCGRect(p.rect));

}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if([collectionView isEqual:self.sourceImages]) {
        // 1. 保存当前效果
        [self saveKeyFrame];
        // 2.
        self.preView.image = self.images[indexPath.item];
        self.sourceIdx     = indexPath.item;
        self.effectImageView.hidden = YES;

        // 3. 如果已经设置了，则获取设置的效果图片
        if(self.images[indexPath.item].frameProperty) {
            SUKeyFrameProperty *frameProperty = self.images[indexPath.item].frameProperty;
            self.effectImageView.image  = self.effectImages[frameProperty.effectIdx];
            CGRect releativeRect = frameProperty.rect;
            CGRect preViewRect   = self.preView.bounds;
            CGFloat preWidth = preViewRect.size.width;
            CGFloat preHeight= preViewRect.size.height;
            self.effectImageView.frame  = CGRectMake(releativeRect.origin.x * preWidth,
                                                     releativeRect.origin.y * preHeight, releativeRect.size.width * preWidth, releativeRect.size.height * preHeight);
            self.effectImageView.hidden = NO;
        }
    }else {
        // 1. 手动添加效果图片
        self.effectIdx              = indexPath.item;
        self.effectImageView.image  = self.effectImages[indexPath.item];
        self.effectImageView.hidden = NO;
        self.effectImageView.center = CGPointMake(self.preView.size.width/2, self.preView.size.height/2);
    }
    //    self.skeletionLayer.contents = (__bridge id)(self.skeletonImages[indexPath.section].CGImage);
//    NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:indexPath.section];
//    [self.sourceImages reloadSections:set];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if([collectionView isEqual:self.effectImagesView]) {
        return self.effectImages.count;
    }
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SUFrameCell *cell = nil;
    if([collectionView isEqual:self.effectImagesView]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID1 forIndexPath:indexPath];
        cell.sourceIV.image = self.effectImages[indexPath.item];
    }else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
        cell.sourceIV.image = self.images[indexPath.item];
    }
    cell.numbleL.text = [NSString stringWithFormat:@"%zi", indexPath.item ];
    cell.numbleL.textColor = [UIColor redColor];
    return cell;
}


#pragma makr - Getter & Setter

- (UIImageView *)preView {
    if(!_preView) {
        _preView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,270)];
    }
    return _preView;
}

- (UICollectionView *)sourceImages {
    if(!_sourceImages) {
        _sourceImages = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55) collectionViewLayout:self.flowLayout];
    }
    return _sourceImages;
}

- (UICollectionView *)effectImagesView {
    if(!_effectImagesView) {
        UICollectionViewFlowLayout *_flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(45, 45);
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 5;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _effectImagesView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55) collectionViewLayout:_flowLayout];
        
    }
    return _effectImagesView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if(!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(45, 45);
        _flowLayout.minimumLineSpacing = 5;
        _flowLayout.minimumInteritemSpacing = 5;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (UIImageView *)effectImageView {
    if(!_effectImageView) {
        _effectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _effectImageView.hidden = YES;
    }
    return _effectImageView;
}

- (SUKeyFrameProperty *)frameProperty {
    if(!_frameProperty) {
        _frameProperty = [SUKeyFrameProperty new];
    }
    return _frameProperty;
}

- (SUContainerView *) containerView{
    if(!_containerView) {
        _containerView = [[SUContainerView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    }
    return _containerView;
}

@end
