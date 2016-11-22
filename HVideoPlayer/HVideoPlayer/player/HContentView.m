//
//  HContentView.m
//  HVideoPlayer
//
//  Created by hejunsong on 16/11/22.
//  Copyright © 2016年 hjs. All rights reserved.
//

#import "HContentView.h"
#import <AVFoundation/AVFoundation.h>

@implementation HContentView

+(Class)layerClass
{
    return [AVPlayerLayer class];
}

@end
