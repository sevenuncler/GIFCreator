//
//  SUKeyFrameProperty.h
//  HED-CoreML
//
//  Created by He on 2018/2/11.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface SUKeyFrameProperty : NSObject<NSCopying>
@property(nonatomic, assign) CGRect rect;
@property(nonatomic, assign) NSInteger sourceIdx;
@property(nonatomic, assign) NSInteger effectIdx;
@property(nonatomic, strong) UIImage   *image;
@end
