//
//  ViewController.m
//  HVideoPlayer
//
//  Created by hejunsong on 16/11/22.
//  Copyright © 2016年 hjs. All rights reserved.
//

#import "ViewController.h"
#import "HVideoPlayer.h"
#import "Masonry.h"
@interface ViewController ()
@property(nonatomic,strong) HVideoPlayer *playerView;
@end

@implementation ViewController

- (void)viewDidLoad {
//  "http://wvideo.spriteapp.cn/video/2016/1121/02e48926-afe0-11e6-8931-d4ae5296039d_wpd.mp4"	
    [super viewDidLoad];
    HVideoPlayer *view = [[HVideoPlayer alloc] initWithFrame:self.view.frame];
    view.backgroundColor = [UIColor grayColor];
    view.frame = self.view.frame;
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.view.mas_top).offset(0);
         make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
         make.left.mas_equalTo(self.view.mas_left).offset(0);
         make.right.mas_equalTo(self.view.mas_right).offset(0);
    }];
    
    
    [view playerWithUrl:[NSURL URLWithString:@"http://wvideo.spriteapp.cn/video/2016/1121/02e48926-afe0-11e6-8931-d4ae5296039d_wpd.mp4"]];
    self.playerView = view;
    
    // Do any additional setup after loading the view, typically from a nib.
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
