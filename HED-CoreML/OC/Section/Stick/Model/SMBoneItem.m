//
//  SMBoneItem.m
//  HED-CoreML
//
//  Created by He on 2018/3/3.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "SMBoneItem.h"

@implementation SMBoneItem

- (CGRect)myFrame {
    CGFloat x = MIN(self.beginPoint.x,self.endPoint.x);
    CGFloat y = MIN(self.beginPoint.y, self.endPoint.y);
    CGFloat width  = fabs(self.beginPoint.x - self.endPoint.x);
    CGFloat height = fabs(self.beginPoint.y - self.endPoint.y);
    return CGRectMake(x, y, width, height);
}

@end
