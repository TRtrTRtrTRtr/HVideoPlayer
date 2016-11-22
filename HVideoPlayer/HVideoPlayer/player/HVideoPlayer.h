//
//  HVideoPlayer.h
//  HVideoPlayer
//
//  Created by hejunsong on 16/11/22.
//  Copyright © 2016年 hjs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HVideoPlayer : UIView
-(void)playerWithUrl:(NSURL *)url;
@property(nonatomic,strong) AVPlayerLayer *currentPlayerLayer;


@end
