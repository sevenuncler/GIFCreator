//
//  SUKeyFrameProperty.m
//  HED-CoreML
//
//  Created by He on 2018/2/11.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "SUKeyFrameProperty.h"

@implementation SUKeyFrameProperty

- (id)copyWithZone:(NSZone *)zone {
    SUKeyFrameProperty *frameProperty = [SUKeyFrameProperty new];
    frameProperty.rect      = self.rect;
    frameProperty.sourceIdx = self.sourceIdx;
    frameProperty.effectIdx = self.effectIdx;
    frameProperty.image     = [self.image copy];
    return frameProperty;
}

@end
