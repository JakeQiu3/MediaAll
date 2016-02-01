//
//  MusicViewController.m
//  Media All
//
//  Created by 邱少依 on 16/2/1.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "MusicViewController.h"
#import <AVFoundation/AVFoundation.h>

#define kMusicFile @"刘若英 - 原来你也在这里.mp3"
#define kMusicSinger @"刘若英"
#define kMusicTitle @"原来你也在这里"
@interface MusicViewController ()<AVAudioPlayerDelegate>
@property (nonatomic, weak) AVAudioPlayer *audioPlayer;//播放器
@property (nonatomic, weak) UIView *controlPanelView;//控制面板
@property (nonatomic, weak) UIProgressView *playProgress;//进度条
@property (nonatomic, weak) NSTimer *timer;//进度更新定时器
@property (nonatomic, weak) UIButton *playOrPauseBtn;//播放/暂停按钮(如果tag为0认为是暂停状态，1是播放状态)
@property (nonatomic, weak) UILabel *singerLabel;
@end

@implementation MusicViewController
 //开启远程控制
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kMusicSinger;
    
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Ren'eLiu"]];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
