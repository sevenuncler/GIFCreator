//
//  SUFrameCell.h
//  iOSOpenPose
//
//  Created by He on 2018/2/4.
//  Copyright © 2018年 Eugene Bokhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SUFrameCell : UICollectionViewCell
@property(nonatomic, strong) UIImageView *sourceIV;
@property(nonatomic, strong) CALayer     *skleton;
@property(nonatomic, strong) UILabel     *numbleL;
@end
