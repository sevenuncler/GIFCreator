//
//  SUImagePickerCollectionViewCell.h
//  DreamOneByOne
//
//  Created by Fanghe on 2017/5/8.
//  Copyright © 2017年 Sevenuncle. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SUImagePickerCollectionViewCellDelegate;
@interface SUImagePickerCollectionViewCell : UICollectionViewCell
@property   (nonatomic, strong) UIImage *image;
@property   (nonatomic, weak)   id<SUImagePickerCollectionViewCellDelegate> delegate;
- (void) setSelected:(BOOL)selected;
@end

@protocol SUImagePickerCollectionViewCellDelegate <NSObject>


@end
