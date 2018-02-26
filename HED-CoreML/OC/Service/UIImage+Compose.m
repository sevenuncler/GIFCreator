//
//  UIImage+Compose.m
//  HED-CoreML
//
//  Created by He on 2018/2/11.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "UIImage+Compose.h"
#import <objc/runtime.h>

@implementation UIImage (Compose)
static char *tagID = "tag";
static char *frameID = "frame";
static char *keyID   = "isKeyFrame";

- (UIImage *)composeWithImage:(UIImage *)image inRect:(CGRect)frame {
    UIGraphicsBeginImageContextWithOptions(self.size, YES, self.scale);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [image drawInRect:frame];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

- (NSInteger)tag {
    return [objc_getAssociatedObject(self, tagID) integerValue];
}

- (void)setTag:(NSInteger)tag {
    objc_setAssociatedObject(self, tagID, @(tag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setFrameProperty:(SUKeyFrameProperty *)frameProperty {
    objc_setAssociatedObject(self, frameID, frameProperty, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SUKeyFrameProperty *)frameProperty {
    return objc_getAssociatedObject(self, frameID);
}

- (void)setIsKeyFrame:(BOOL)isKeyFrame {
    objc_setAssociatedObject(self, keyID, [NSNumber numberWithBool:isKeyFrame], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isKeyFrame {
    return  [((NSNumber*)objc_getAssociatedObject(self, keyID)) boolValue];
}

@end
