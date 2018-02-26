//
//  SUGIFManager.m
//  iOSOpenPose
//
//  Created by He on 2018/2/3.
//  Copyright © 2018年 Eugene Bokhan. All rights reserved.
//

#import "SUGIFManager.h"
#import <ImageIO/ImageIO.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation SUGIFManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SUGIFManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[SUGIFManager alloc] init];
    });
    return instance;
}

- (NSArray *)covertGifToImages:(NSString *)filePath {
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return [self covertGifToImagesWithData:data];
}

- (NSArray *)covertGifToImagesWithData:(NSData *)data {
    // 1. 转换成source
    // 2. 获取帧数目
    // 3. 遍历每一帧，生成UIImage
    if (!data) {
        return nil;
    }
    NSMutableArray *result = [NSMutableArray array];
    CGImageSourceRef sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef) data, NULL);
    size_t count = CGImageSourceGetCount(sourceRef);
    for(size_t idx=0; idx<count; idx++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(sourceRef, idx, NULL);
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        [result addObject:image];
    }
    if(sourceRef != NULL) {
        CFRelease(sourceRef);
    }
    return result.copy;
}

- (NSString *)generateGifWithArray:(NSArray *)images {
    // 随机生成一个保存路径
    NSString *documentPath = NSTemporaryDirectory();
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.gif", documentPath, [self uuidString]];
    CFURLRef URLRef = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)filePath, kCFURLPOSIXPathStyle, false);
    
    // 生成保存对象
    CGImageDestinationRef destinationRef = CGImageDestinationCreateWithURL(URLRef, kUTTypeGIF, images.count, NULL);
    
    // 帧属性设置
    NSDictionary *frameProperties = [NSDictionary
                                     dictionaryWithObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0.1], (NSString *)kCGImagePropertyGIFDelayTime, nil]
                                     forKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    //设置gif信息
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:9];
    
//    [dict setObject:[NSNumber numberWithBool:YES] forKey:(NSString*)kCGImagePropertyGIFHasGlobalColorMap];
//    [dict setObject:[NSNumber numberWithBool:YES] forKey:(NSString*)kCGImagePropertyGIFImageColorMap];

    [dict setObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount];
    [dict setObject:(NSString *)kCGImagePropertyColorModelGray forKey:(NSString *)kCGImagePropertyColorModel];
//    [dict setObject:[NSNumber numberWithInt:8] forKey:(NSString*)kCGImagePropertyDepth];
//    [dict setObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCGImagePropertyHasAlpha];
//    [dict setObject:[NSNumber numberWithInt:500] forKey:(NSString *)kCGImagePropertyPixelWidth];
//    [dict setObject:[NSNumber numberWithInt:500] forKey:(NSString *)kCGImagePropertyPixelHeight];
    NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:dict
                                                              forKey:(NSString *)kCGImagePropertyGIFDictionary];
    //合成gif
    for (UIImage* dImg in images)
    {
        CGImageDestinationAddImage(destinationRef, dImg.CGImage, (__bridge CFDictionaryRef)frameProperties);
    }
    CGImageDestinationSetProperties(destinationRef, (__bridge CFDictionaryRef)gifProperties);
    CGImageDestinationFinalize(destinationRef);
    CFRelease(destinationRef);
    return filePath;
}

- (BOOL)saveToSystemAlbumsWithGIFPath:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfFile:path];
    // 保存到本地相册
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        NSLog(@"Success at %@", [assetURL path] );
    }] ;
    return YES;
}

- (NSString *)uuidString {
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef stringRef = CFUUIDCreateString(NULL, uuidRef);
    NSString *str = [NSString stringWithString:((__bridge NSString *)stringRef)];
    CFRelease(stringRef);
    CFRelease(uuidRef);
    return str;
}

@end
