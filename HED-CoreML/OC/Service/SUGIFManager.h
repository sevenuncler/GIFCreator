//
//  SUGIFManager.h
//  iOSOpenPose
//
//  Created by He on 2018/2/3.
//  Copyright © 2018年 Eugene Bokhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUGIFManager : NSObject

+ (instancetype)sharedInstance;
- (NSArray *)covertGifToImages:(NSString *)filePath;
- (NSArray *)covertGifToImagesWithData:(NSData *)data;
- (NSString *)generateGifWithArray:(NSArray *)images;
- (BOOL)saveToSystemAlbumsWithGIFPath:(NSString *)path;

@end
