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

//监听播放起状态的监听者
@property (nonatomic ,strong) id playbackTimeObserver;

@property(nonatomic,strong) UIView *contentView;

@property(nonatomic,strong) NSDateFormatter *dateFormatter;


@property(nonatomic,assign) BOOL isDragSlidr;

@end

static void *playcontext = @"playcontext";
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
{    //旋转屏幕通知
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
    _bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
   
    
    _playORpuseButton  = [UIButton new];
    [_playORpuseButton setImage:[UIImage imageNamed:@"icon_list_btn_play_small"] forState:UIControlStateSelected];
    [_playORpuseButton setImage:[UIImage imageNamed:@"icon_list_btn_stop"] forState:UIControlStateNormal];
    
    
    _fullScreenButton  = [UIButton new];
    [_fullScreenButton setImage:[UIImage imageNamed:@"icon_list_btn_fullscreen"] forState:UIControlStateNormal];
     [_fullScreenButton setImage:[UIImage imageNamed:@"icon_list_btn_unfullscreen"] forState:UIControlStateNormal];
    
    
    _sliderView = [UISlider new];
    _sliderView.minimumTrackTintColor = [UIColor greenColor];
    _sliderView.maximumTrackTintColor = [UIColor grayColor];

    _sliderView.maximumValue = 1;
    _sliderView.minimumValue = 0;
   
    _totalTimeLable = [UILabel new];
    _currentTimeLable = [UILabel new];
    
    _totalTimeLable.textAlignment = NSTextAlignmentCenter;
    _currentTimeLable.textAlignment = NSTextAlignmentCenter;
    
    _totalTimeLable.textColor = [UIColor blackColor];
    _currentTimeLable.textColor = [UIColor blackColor];
    _totalTimeLable.font = [UIFont systemFontOfSize:12];
    _currentTimeLable.font = [UIFont systemFontOfSize:12];
    
    
    
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
    [_sliderView addTarget:self action:@selector(dragedClcik:) forControlEvents:UIControlEventTouchUpInside];
      [_sliderView addTarget:self action:@selector(dragingClcik:) forControlEvents:UIControlEventValueChanged];
    
    
    
//调试背景颜色
//    _topView.backgroundColor = [UIColor redColor];
//    _bottomView.backgroundColor = [UIColor brownColor];
//    _playORpuseButton.backgroundColor = [UIColor greenColor];
//    _fullScreenButton.backgroundColor = [UIColor greenColor];
//    _totalTimeLable.backgroundColor = [UIColor grayColor];
//    _currentTimeLable.backgroundColor = [UIColor grayColor];
    
    
    
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
    self.player.volume = .1;
    [self.player play];
    self.playORpuseButton.selected = YES;
}

-(void)setCurrentItem:(AVPlayerItem *)currentItem
{
    
    
    _currentItem = currentItem;
    [_currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:playcontext];
    [_currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:playcontext];
    [_currentItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:playcontext];
    [_currentItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:playcontext];
    [self.player replaceCurrentItemWithPlayerItem:_currentItem];
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == playcontext) {
        if([keyPath isEqualToString:@"status"])
        {
            AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];

            switch (status) {
                case AVPlayerStatusUnknown:
                    self.state = HPlayerStateBuffering;
                    break;
                case AVPlayerStatusReadyToPlay:{
                     self.state = HPlayerStateReadyToPlay;
                    [self initTimer];
                    }
                    break;
                
                case AVPlayerStatusFailed:
                     self.state = HPlayerStateFailed;
                    break;
                    
                default:
                    break;
            }
        }
       else if ([keyPath isEqualToString:@"loadedTimeRanges"])
       {
       
       
           
       }
       else if ([keyPath isEqualToString:@"playbackBufferEmpty"])
       {
           
           
       }
       else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"])
       {
           
           NSLog(@"playbackLikelyToKeepUp");
       }
        
        
    }
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

-(void)dragedClcik:(UISlider *)slider
{
    self.isDragSlidr = NO;
    double duration = CMTimeGetSeconds([self currentItemTotalTime]);
    double time  = slider.value * duration;
    [self seekToTimeToPlay:time];
    
}
-(void)dragingClcik:(UISlider *)slider
{
    self.isDragSlidr = YES;
}

-(void)seekToTimeToPlay:(double)time
{
    [self.player seekToTime:CMTimeMakeWithSeconds(time, _currentItem.currentTime.timescale) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        
    }];
}



-(void)initTimer{
    double interval = .1f;
    CMTime playerDuration = [self currentItemTotalTime];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        return;
    }
    long long nowTime = _currentItem.currentTime.value/_currentItem.currentTime.timescale;
    
//    CGFloat width = CGRectGetWidth([self.progressSlider bounds]);
//    interval = 0.5f * nowTime / width;
    self.sliderView.value = [self sliderProgress];
    __weak typeof(self) weakSelf = self;
    
    self.playbackTimeObserver =  [weakSelf.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0, NSEC_PER_SEC)  queue:dispatch_get_main_queue()                                                                          usingBlock:^(CMTime time){
        if(!self.isDragSlidr)
        {
            [weakSelf updateTimeLabel];
        }
    }];
    
}


-(void)updateTimeLabel
{
    CMTime totalCTime = [self currentItemTotalTime];
    float Totaltime = totalCTime.value/totalCTime.timescale;
    CMTime currentCTime = self.currentItem.currentTime;
    float currenttime = currentCTime.value/currentCTime.timescale;
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        self.sliderView.value = currenttime/Totaltime;
        NSLog(@"--%lf--%lf---%lf",Totaltime,currenttime,currenttime/Totaltime);
        self.currentTimeLable.text = [self convertTime:currenttime];
        self.totalTimeLable.text = [self convertTime:(Totaltime-currenttime)];
        
    });
   
}

-(CGFloat)sliderProgress
{
    CMTime totalCTime = [self currentItemTotalTime];
    long long Totaltime = totalCTime.value/totalCTime.timescale;
    CMTime currentCTime = self.currentItem.currentTime;
    long long currenttime = currentCTime.value/currentCTime.timescale;
    return currenttime/Totaltime;


}


-(CMTime)currentItemTotalTime
{
    AVPlayerItem *playerItem = _currentItem;
    if(playerItem.status == AVPlayerItemStatusReadyToPlay)
    {
        return ([playerItem duration]);
    }
    return (kCMTimeInvalid);

}
-(NSString *)convertTime:(float)seconds
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    if(seconds/3600 >= 1)
    {
        [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
        
    }else
    {
        [[self dateFormatter] setDateFormat:@"mm:ss"];
    }
    return [[self dateFormatter] stringFromDate:date];
}
-(NSDateFormatter *)dateFormatter
{
    if(_dateFormatter == nil)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    }
    return _dateFormatter;

}

@end
