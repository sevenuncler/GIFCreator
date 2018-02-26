//
//  SUDrawToolView.m
//  iOSOpenPose
//
//  Created by He on 2018/2/5.
//  Copyright © 2018年 Sevenuncle. All rights reserved.
//

#import "SUDrawToolView.h"

@implementation SUDrawToolView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self addSubview:self.penButton];
        [self addSubview:self.signPenButton];
        [self addSubview:self.eraserButton];
        [self addSubview:self.saveButton];
    }
    return self;
}

- (UIButton *)penButton {
    if(!_penButton) {
        _penButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _penButton.backgroundColor = [UIColor colorWithRed:arc4random()%9/9.f green:arc4random()%9/9.f blue:arc4random()%9/9.f alpha:1];
    }
    return _penButton;
}

- (UIButton *)eraserButton {
    if(!_eraserButton) {
        _eraserButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _eraserButton.backgroundColor = [UIColor colorWithRed:arc4random()%9/9.f green:arc4random()%9/9.f blue:arc4random()%9/9.f alpha:1];
    }
    return _eraserButton;
}

@end
