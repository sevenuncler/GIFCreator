//
//  UIImage+Compose.h
//  HED-CoreML
//
//  Created by He on 2018/2/11.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUKeyFrameProperty.h"

@interface UIImage (Compose)
@property(nonatomic, assign) NSInteger tag;
@property(nonatomic, strong) SUKeyFrameProperty *frameProperty;
@property(nonatomic, assign) BOOL isKeyFrame;
- (UIImage *)composeWithImage:(UIImage *)image inRect:(CGRect)frame;
@end
