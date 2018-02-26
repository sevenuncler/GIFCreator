//
//  View.h
//  Person
//
//  Created by fanghe on 18/1/25.
//  Copyright © 2018年 Sevenuncle. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Shape;
@class ShapeProperty;

@interface SUDrawView : UIView
@property(nonatomic, strong) NSMutableArray<Shape *> *shapes;
- (UIImage *)getSnapshot;
@end

@interface ShapeProperty : NSObject
@property(nonatomic, strong) UIColor *color;
@property(nonatomic, assign) CGFloat lineWidth;
@end

@interface Shape : NSObject
@property(nonatomic, strong) UIBezierPath  *path;
@property(nonatomic, strong) ShapeProperty *property;
@end

