//
//  UIImageViewDecorator.h
//  HED-CoreML
//
//  Created by He on 2018/2/26.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageViewDecorator : UIControl

@property(nonatomic, strong) UIButton *removeButton;
@property(nonatomic, strong) UIButton *scaleButton;
@property(nonatomic, strong) UIImage  *image;
@property(nonatomic, strong) UIImageView *imageView;

- (instancetype)initWithImageView:(UIImageView *)imageView;

@end
