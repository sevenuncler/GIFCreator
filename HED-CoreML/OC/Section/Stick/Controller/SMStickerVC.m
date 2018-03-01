//
//  SMStickerVC.m
//  HED-CoreML
//
//  Created by He on 2018/3/1.
//  Copyright © 2018年 s1ddok. All rights reserved.
//

#import "SMStickerVC.h"
#import "SMBone.h"
#import "SMKnee.h"

@interface SMStickerVC ()

@end

@implementation SMStickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SMBone *bone = [[SMBone alloc] initWithBegin:CGPointMake(100, 100) end:CGPointMake(200, 300)];
    [self.view addSubview:bone];
    
    SMKnee *knee = [[SMKnee alloc] initWithPoint:CGPointMake(100, 220) radium:30];
    [self.view addSubview:knee];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
