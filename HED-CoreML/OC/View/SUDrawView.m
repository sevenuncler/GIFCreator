//
//  View.m
//  Person
//
//  Created by fanghe on 18/1/25.
//  Copyright © 2018年 Sevenuncle. All rights reserved.
//

#import "SUDrawView.h"



@implementation ShapeProperty
@end

@implementation Shape
@end



@interface SUDrawView ()
@end

@implementation SUDrawView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    for(int i=0 ;i < self.shapes.count; i++) {
        Shape *obj = self.shapes[i];
        CGContextAddPath(context, obj.path.CGPath);
        CGContextSetStrokeColorWithColor(context, obj.property.color.CGColor);
        CGContextSetLineWidth(context, obj.property.lineWidth);
        CGContextStrokePath(context);
    }
}

- (UIImage *)getSnapshot {
    UIGraphicsBeginImageContext(self.frame.size);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}




- (NSMutableArray<Shape *> *)shapes {
    if(nil == _shapes) {
        _shapes = [NSMutableArray array];
    }
    return _shapes;
}





@end

