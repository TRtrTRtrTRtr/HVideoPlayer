//
//  HVideoPlayer.m
//  HVideoPlayer
//
//  Created by hejunsong on 16/11/22.
//  Copyright © 2016年 hjs. All rights reserved.
//

#import "HVideoPlayer.h"
#import "Masonry.h"

@interface HVideoPlayer()

@property(nonatomic,strong) AVPlayer *player;
@property(nonatomic,strong) AVPlayerItem *currentItem;
//@property(nonatomic,strong) AVPlayerLayer *currentPlayerLayer;

@property(nonatomic,strong) UIView   *topView;

@property(nonatomic,strong) UIView   *bottomView;
@property(nonatomic,strong) UIButton *playORpuseButton;
@property(nonatomic,strong) UIButton *fullScreenButton;
@property(nonatomic,strong) UISlider *sliderView;

@property(nonatomic,strong) UILabel  *totalTimeLable;
@property(nonatomic,strong) UILabel  *currentTimeLable;


@property(nonatomic,strong) UIView *contentView;

@end


@implementation HVideoPlayer

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self addNotifion];
    }
    return self;
}
-(void)layoutSubviews{
    
    self.currentPlayerLayer.frame = self.bounds;

}
-(void)addNotifion
{
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange{
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
            self.currentPlayerLayer.frame = self.bounds;
            
            
        }
            break;
        case UIInterfaceOrientationPortrait:{
            self.currentPlayerLayer.frame = self.bounds;
            
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            self.currentPlayerLayer.frame = self.bounds;
        }
            break;
            
        case UIInterfaceOrientationLandscapeRight:{
            self.currentPlayerLayer.frame = self.bounds;
            NSLog(@"第1个旋转方向---电池栏在右");
            
        }
            break;
        default:
            break;
    }
}


-(void)setupUI
{
    _contentView = [UIView new];
    
    _topView = [UIView new];
    
    _bottomView = [UIView new];
   
    
    _playORpuseButton  = [UIButton new];
    _fullScreenButton  = [UIButton new];
    
    _sliderView = [UISlider new];
    
    _sliderView.maximumValue = 1;
    _sliderView.minimumValue = 0;
    
    _totalTimeLable = [UILabel new];
    _currentTimeLable = [UILabel new];
    
    [self addSubview:_contentView];
    
    [self addSubview:_topView];
    [self addSubview:_bottomView];
    
    [_bottomView addSubview:_playORpuseButton];
    [_bottomView addSubview:_sliderView];
    [_bottomView addSubview:_totalTimeLable];
    [_bottomView addSubview:_currentTimeLable];
    [_bottomView addSubview:_fullScreenButton];
    
//事件绑定
    [_playORpuseButton addTarget:self action:@selector(PlayOrPuse:) forControlEvents:UIControlEventTouchUpInside];
    [_sliderView addTarget:self action:@selector(dragClcik:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
//调试背景颜色
    _topView.backgroundColor = [UIColor redColor];
    _bottomView.backgroundColor = [UIColor brownColor];
    _playORpuseButton.backgroundColor = [UIColor greenColor];
    _fullScreenButton.backgroundColor = [UIColor greenColor];
    _totalTimeLable.backgroundColor = [UIColor grayColor];
    _currentTimeLable.backgroundColor = [UIColor grayColor];
    
    
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.equalTo(@30);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.equalTo(@40);
    }];

    [_playORpuseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_bottomView.mas_centerY).offset(0);
        make.left.mas_equalTo(_bottomView.mas_left).offset(5);
        make.width.mas_equalTo(@40);
        make.height.mas_equalTo(@40);
    }];
    
    [_fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_bottomView.mas_centerY).offset(0);
        make.right.mas_equalTo(_bottomView.mas_right).offset(-5);
        make.width.mas_equalTo(@40);
        make.height.mas_equalTo(@40);
    }];

    [_totalTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_bottomView.mas_centerY).offset(0);
        make.left.mas_equalTo(_playORpuseButton.mas_right).offset(5);
        make.width.mas_equalTo(@40);
        make.height.mas_equalTo(@20);
    }];

    [_currentTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_bottomView.mas_centerY).offset(0);
        make.right.mas_equalTo(_fullScreenButton.mas_left).offset(-5);
        make.width.mas_equalTo(@40);
        make.height.mas_equalTo(@20);
    }];

    [_sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_bottomView.mas_centerY).offset(0);
        make.right.mas_equalTo(_currentTimeLable.mas_left).offset(-5);
        make.left.mas_equalTo(_totalTimeLable.mas_right).offset(5);
    }];

    
}
-(void)playerWithUrl:(NSURL *)url
{
    
    self.currentItem = [AVPlayerItem playerItemWithURL:url];
    self.player = [AVPlayer playerWithPlayerItem:_currentItem];
    self.player.usesExternalPlaybackWhileExternalScreenIsActive=YES;
    //AVPlayerLayer
    self.currentPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.currentPlayerLayer.frame = self.layer.bounds;
    self.currentPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.layer insertSublayer:_currentPlayerLayer atIndex:0];
    
    [self.player play];
    self.playORpuseButton.selected = YES;
}
//事件处理
-(void)play
{
    [self.player play];
}
-(void)pause
{
    [self.player pause];

}
-(void)PlayOrPuse:(UIButton *)sender
{
    if(sender.selected)
    {
        sender.selected = NO;
    }else
    {
        sender.selected = YES;
    }
    if(sender.selected)
    {
        [self play];
    }else
    {
        [self pause];
    }
}

-(void)dragClcik:(UISlider *)slider
{
    NSLog(@"---12--%lf",slider.value);

}

-(void)seekToTimeToPlay:(double)time
{
    [self.player seekToTime:CMTimeMakeWithSeconds(time, _currentItem.currentTime.timescale) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        
    }];


}
@end
