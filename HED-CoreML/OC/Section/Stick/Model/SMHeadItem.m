//
//  SMHeadItem.m
//  HED-CoreML
//
//  Created by He on 2018/3/4.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "SMHeadItem.h"

@implementation SMHeadItem

- (CGRect)myFrame {
    CGRect frame = CGRectMake(self.center.x - self.radium, self.center.y - self.radium, self.radium*2, self.radium*2);
    return frame;
}

@end
