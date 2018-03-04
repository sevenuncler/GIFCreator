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
#import "SMBoneHand.h"

#import "SMStickManItem.h"
#import "SMHeadItem.h"
#import "SMStickMan.h"
#import "SMBoneItem.h"
#import "SMHandItem.h"
#import "SMFeetItem.h"


@interface SMStickerVC ()

@property(nonatomic, strong) SMBone *bone;
@property(nonatomic, strong) SMStickManItem *stickManItem;

@end

@implementation SMStickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SMStickMan *man = [[SMStickMan alloc] initWithItem:self.stickManItem];
    [self.view addSubview:man];
    
    
    
//    SMBone *bone = [[SMBone alloc] initWithBegin:CGPointMake(100, 100) end:CGPointMake(200, 300)];
//    [self.view addSubview:bone];
//    
//    {
//        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanAction:)];
//        [bone.beginKneeView addGestureRecognizer:panGR];
//    }
//    {
//        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanAction2:)];
//        [bone.endKneeView addGestureRecognizer:panGR];
//    }
//    bone.beginKneeView.userInteractionEnabled = YES;
//    self.bone = bone;
    
}

- (void)xMan {
    {
        SMBone *neck = [[SMBone alloc] initWithBegin:CGPointMake(200, 100) end:CGPointMake(200, 120)];
        [self.view addSubview:neck];
    }
    
    {
        SMBone *shoulder = [[SMBone alloc] initWithBegin:CGPointMake(150, 120) end:CGPointMake(250, 120)];
        [self.view addSubview:shoulder];
    }
    
    {
        SMBone *leftThigh = [[SMBone alloc] initWithBegin:CGPointMake(120, 150) end:CGPointMake(150, 120)];
        [self.view addSubview:leftThigh];
    }
    {
        SMBone *rightThigh = [[SMBone alloc] initWithBegin:CGPointMake(250, 120) end:CGPointMake(280, 150)];
        [self.view addSubview:rightThigh];
    }
    
    {
        SMBone *backbone = [[SMBone alloc] initWithBegin:CGPointMake(200, 120) end:CGPointMake(200, 170)];
        [self.view addSubview:backbone];
    }
    
    {
        SMBone *leftThigh = [[SMBone alloc] initWithBegin:CGPointMake(200, 170) end:CGPointMake(150, 220)];
        [self.view addSubview:leftThigh];
    }
    {
        SMBone *leftShins = [[SMBone alloc] initWithBegin:CGPointMake(150, 220) end:CGPointMake(150, 260)];
        [self.view addSubview:leftShins];
    }
    {
        SMBone *leftFeet = [[SMBoneHand alloc] initWithBegin:CGPointMake(150, 260) end:CGPointMake(140, 260)];
        [self.view addSubview:leftFeet];
    }
    {
        SMBone *rightThigh = [[SMBone alloc] initWithBegin:CGPointMake(200, 170) end:CGPointMake(250, 220)];
        [self.view addSubview:rightThigh];
    }
    {
        SMBone *rightShins = [[SMBone alloc] initWithBegin:CGPointMake(250, 220) end:CGPointMake(250, 260)];
        [self.view addSubview:rightShins];
    }
    {
        SMBoneHand *rightFeet = [[SMBoneHand alloc] initWithBegin:CGPointMake(250, 260) end:CGPointMake(270, 260)];
        [self.view addSubview:rightFeet];
    }
}

- (void)onPanAction:(UIPanGestureRecognizer *)sender {
    CGPoint offset = [sender translationInView:self.view];
    self.bone.beginPoint = CGPointMake(self.bone.beginPoint.x + offset.x, self.bone.beginPoint.y +offset.y );
    [self.bone setNeedsLayout];
    [sender setTranslation:CGPointZero inView:self.view];
}

- (void)onPanAction2:(UIPanGestureRecognizer *)sender {
    CGPoint offset = [sender translationInView:self.view];
    self.bone.endPoint = CGPointMake(self.bone.endPoint.x + offset.x, self.bone.endPoint.y +offset.y );
    [self.bone setNeedsLayout];
    [sender setTranslation:CGPointZero inView:self.view];
}

- (SMStickManItem *)stickManItem {
    if(!_stickManItem) {
        _stickManItem = [SMStickManItem new];
        {
            SMHeadItem *headItem = [SMHeadItem new];
            headItem.center = CGPointMake(100, 100);
            headItem.radium = 20;
            _stickManItem.head = headItem;
        }
        {
            SMBoneItem *item = [SMBoneItem new];
            item.beginPoint = CGPointMake(100, 120);
            item.endPoint   = CGPointMake(101, 150); // TO FIX
            item.lineWidth  = 5;
            item.kneeRadium = 5;
            _stickManItem.neck = item;
        }
        {
            SMBoneItem *item = [SMBoneItem new];
            item.beginPoint = CGPointMake(61, 150);
            item.endPoint   = CGPointMake(141, 150); // TO FIX
            item.lineWidth  = 5;
            item.kneeRadium = 5;
            _stickManItem.shoulder = item;
        }
        {
            SMBoneItem *item = [SMBoneItem new];
            item.beginPoint = CGPointMake(61, 150);
            item.endPoint   = CGPointMake(50, 200); // TO FIX
            item.lineWidth  = 5;
            item.kneeRadium = 5;
            _stickManItem.leftArm = item;
        }
        {
            SMBoneItem *item = [SMBoneItem new];
            item.beginPoint = CGPointMake(50, 200);
            item.endPoint   = CGPointMake(30, 140); // TO FIX
            item.lineWidth  = 5;
            item.kneeRadium = 5;
            _stickManItem.leftForearm = item;
        }
        {
            SMHandItem *item = [SMHandItem new];
            item.beginPoint = CGPointMake(30, 140);
            item.endPoint   = CGPointMake(35, 120); // TO FIX
            item.lineWidth  = 5;
            item.kneeRadium = 5;
            _stickManItem.leftHand = item;
        }

        {
            SMBoneItem *item = [SMBoneItem new];
            item.beginPoint = CGPointMake(141, 150);
            item.endPoint   = CGPointMake(151, 200); // TO FIX
            item.lineWidth  = 5;
            item.kneeRadium = 5;
            _stickManItem.rightArm = item;
        }
        {
            SMBoneItem *item = [SMBoneItem new];
            item.beginPoint = CGPointMake(151, 200);
            item.endPoint   = CGPointMake(180, 140); // TO FIX
            item.lineWidth  = 5;
            item.kneeRadium = 5;
            _stickManItem.rightForearm = item;
        }
        {
            SMHandItem *item = [SMHandItem new];
            item.beginPoint = CGPointMake(180, 140);
            item.endPoint   = CGPointMake(190, 150); // TO FIX
            item.lineWidth  = 5;
            item.kneeRadium = 5;
            _stickManItem.rightHand = item;
        }

        {
            SMBoneItem *item = [SMBoneItem new];
            item.beginPoint = CGPointMake(101, 150);
            item.endPoint   = CGPointMake(100, 250); // TO FIX
            item.lineWidth  = 5;
            item.kneeRadium = 5;
            _stickManItem.backbone = item;
        }

        {
            SMBoneItem *item = [SMBoneItem new];
            item.beginPoint = CGPointMake(100, 250);
            item.endPoint   = CGPointMake(70, 300); // TO FIX
            item.lineWidth  = 5;
            item.kneeRadium = 5;
            _stickManItem.leftThigh = item;
        }
        {
            SMBoneItem *item = [SMBoneItem new];
            item.beginPoint = CGPointMake(70, 300);
            item.endPoint   = CGPointMake(80, 350); // TO FIX
            item.lineWidth  = 5;
            item.kneeRadium = 5;
            _stickManItem.leftShins = item;
        }
        {
            SMFeetItem *item = [SMFeetItem new];
            item.beginPoint = CGPointMake(80, 350);
            item.endPoint   = CGPointMake(70, 360); // TO FIX
            item.lineWidth  = 5;
            item.kneeRadium = 5;
            _stickManItem.leftfeet = item;
        }

        {
            SMBoneItem *item = [SMBoneItem new];
            item.beginPoint = CGPointMake(100, 250);
            item.endPoint   = CGPointMake(140, 320); // TO FIX
            item.lineWidth  = 5;
            item.kneeRadium = 5;
            _stickManItem.rightThigh = item;
        }
        {
            SMBoneItem *item = [SMBoneItem new];
            item.beginPoint = CGPointMake(140, 320);
            item.endPoint   = CGPointMake(150, 370); // TO FIX
            item.lineWidth  = 5;
            item.kneeRadium = 5;
            _stickManItem.rightShins = item;
        }
        {
            SMFeetItem *item = [SMFeetItem new];
            item.beginPoint = CGPointMake(150, 370);
            item.endPoint   = CGPointMake(180, 375); // TO FIX
            item.lineWidth  = 5;
            item.kneeRadium = 5;
            _stickManItem.rightFeet = item;
        }
    }
    return _stickManItem;
}

@end
