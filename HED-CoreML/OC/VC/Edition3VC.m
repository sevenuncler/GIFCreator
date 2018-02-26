//
//  Edition3VC.m
//  HED-CoreML
//
//  Created by He on 2018/2/11.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "Edition3VC.h"
#import "SUGIFManager.h"
#import "UIImage+Compose.h"
#import "SAMCubicSpline.h"

@interface Edition3VC ()

@property(nonatomic, strong) SAMCubicSpline *splineX;
@property(nonatomic, strong) SAMCubicSpline *splineY;

@property(nonatomic, strong) UIImageView      *preView;
@property(nonatomic, strong) UICollectionView *sourceImages;

@end

@implementation Edition3VC

- (void)viewDidLoad {
    [super viewDidLoad];    
    // 1. 获取Images
    NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"448_251" ofType:@"gif"];
    SUGIFManager *manager = [SUGIFManager sharedInstance];
    NSArray *images = [manager covertGifToImages:gifPath];
    
    // 2. 选择特效Images(gif)
    NSString *gifPath1 = [[NSBundle mainBundle] pathForResource:@"round" ofType:@"gif"];
    NSArray *images1 = [manager covertGifToImages:gifPath1];
    
    // 3. 设置关键帧
    CGPoint point0 = CGPointMake(0, 0);
    CGPoint point1 = CGPointMake(10/100.f, 15/100.f);
    CGPoint point2 = CGPointMake(20/100.f, 16/100.f);
    CGPoint point3 = CGPointMake(30/100.f, 18/100.f);
    CGPoint point4 = CGPointMake(40/100.f, 19/100.f);
    CGPoint point5 = CGPointMake(50/100.f, 30/100.f);
    CGPoint point6 = CGPointMake(60/100.f, 55/100.f);
    CGPoint point7 = CGPointMake(70/100.f, 77/100.f);
    CGPoint point8 = CGPointMake(80/100.f, 88/100.f);
    CGPoint point9 = CGPointMake(100/100.f, 100/100.f);
    
    NSMutableArray *points = [NSMutableArray array];
    [points addObject:[NSValue valueWithCGPoint:point0]];
    [points addObject:[NSValue valueWithCGPoint:point1]];
    [points addObject:[NSValue valueWithCGPoint:point2]];
    [points addObject:[NSValue valueWithCGPoint:point3]];
    [points addObject:[NSValue valueWithCGPoint:point4]];
    [points addObject:[NSValue valueWithCGPoint:point5]];
    [points addObject:[NSValue valueWithCGPoint:point6]];
    [points addObject:[NSValue valueWithCGPoint:point7]];
    [points addObject:[NSValue valueWithCGPoint:point8]];
    [points addObject:[NSValue valueWithCGPoint:point9]];

    // 4. 光滑曲线函数
    self.splineX = [[SAMCubicSpline alloc] initWithPoints:points.copy];
    NSLog(@"%lf", [self.splineX interpolate:0/100.f]);
    NSLog(@"%lf", [self.splineX interpolate:10/100.f]);
    NSLog(@"%lf", [self.splineX interpolate:11/100.f]);
    NSLog(@"%lf", [self.splineX interpolate:20/100.f]);
    NSLog(@"%lf", [self.splineX interpolate:23/100.f]);
    NSLog(@"%lf", [self.splineX interpolate:50/100.f]);

    // 5. 合成特效
    NSArray *composeImages = [self compose:images with:images1];
    // 6. 生成GIF
    NSString *gifSavePath = [manager generateGifWithArray:composeImages];
    [manager saveToSystemAlbumsWithGIFPath:gifSavePath];
}


#pragma mark - 步骤
- (void)keyPoint {
    
}

- (NSArray *)compose:(NSArray<UIImage *> *)source with:(NSArray *)effects {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:source.count];
    __weak NSArray *weakSource = source;
    __block CGFloat x = 0;
    __weak typeof(self) weakSelf = self;
    [effects enumerateObjectsUsingBlock:^(UIImage *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *image = [weakSource[idx] composeWithImage:obj inRect:CGRectMake(x*100, [weakSelf.splineX interpolate:x]*100, 40, 40)];
        x += 10/100.f;
        [result addObject:image];
    }];
    
    return result;
}

@end
