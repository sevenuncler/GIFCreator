//
//  SUImagePickerCollectionViewCell.m
//  DreamOneByOne
//
//  Created by Fanghe on 2017/5/8.
//  Copyright © 2017年 Sevenuncle. All rights reserved.
//

#import "SUImagePickerCollectionViewCell.h"
#import "UIView+Layout.h"

@interface SUImagePickerCollectionViewCell()
{
    UIImageView *_imageViewOfPhoto;
    UIButton    *_selectedButton;
}
@end

@implementation SUImagePickerCollectionViewCell
- (instancetype) initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        if(!_imageViewOfPhoto){
            _imageViewOfPhoto   =   [UIImageView new];
            _imageViewOfPhoto.contentMode = UIViewContentModeScaleAspectFill;
            [self.contentView addSubview:_imageViewOfPhoto];
//            [_imageViewOfPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.equalTo(self);
//            }];
            _imageViewOfPhoto.frame = self.bounds;
            _imageViewOfPhoto.clipsToBounds = YES;
            self.backgroundColor    =   [UIColor redColor];
            _imageViewOfPhoto.userInteractionEnabled    =   YES;
        }
        _selectedButton   =   [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedButton addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [_selectedButton setImage:[UIImage imageNamed:@"image"] forState:UIControlStateNormal];
        [_selectedButton setImage:[UIImage imageNamed:@"placeholder"] forState:UIControlStateSelected];
        [self.contentView addSubview:_selectedButton];
//        [_selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.trailing.equalTo(self.mas_trailing).offset(-5);
//            make.top.equalTo(self.mas_top).offset(5);
//            make.height.mas_equalTo(30);
//            make.width.mas_equalTo(30);
//        }];
        
        _selectedButton.top = 5;
        _selectedButton.size = CGSizeMake(30, 30);
        _selectedButton.right = self.size.width - 5;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self=[super initWithCoder:aDecoder]){
        
    }
    return self;
}

- (instancetype) init{
    if(self=[super init]){
        
    }
    return self;
}

- (void)setImage:(UIImage *)image{
    
    _image  =   image;
    _imageViewOfPhoto.image = _image;
}

- (void)selectPhoto:(UIButton *)sender{
    sender.selected =   !sender.selected;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    _selectedButton.selected    =   selected;
}
@end
