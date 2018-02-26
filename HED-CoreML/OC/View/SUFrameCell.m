//
//  SUFrameCell.m
//  iOSOpenPose
//
//  Created by He on 2018/2/4.
//  Copyright © 2018年 Eugene Bokhan. All rights reserved.
//

#import "SUFrameCell.h"
#import "UIView+Layout.h"

@implementation SUFrameCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self addSubview:self.sourceIV];
        [self.layer addSublayer:self.skleton];
        [self addSubview:self.numbleL];
    }
    return self;
}

- (UIImageView *)sourceIV {
    if(!_sourceIV) {
        _sourceIV = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _sourceIV;
}

- (CALayer *)skleton {
    if(!_skleton) {
        _skleton = [CALayer layer];
        _skleton.masksToBounds = YES;
        _skleton.frame = self.bounds;
    }
    return _skleton;
}

- (UILabel *)numbleL {
    if(!_numbleL) {
        _numbleL = [[UILabel alloc] initWithFrame:CGRectMake(self.size.width/2, self.size.height/2, 100, 44)];
        _numbleL.center = CGPointMake(self.size.width/2, self.size.height/2);
        _numbleL.textColor = [UIColor redColor];
        _numbleL.textAlignment = NSTextAlignmentCenter;
    }
    return _numbleL;
}

@end
