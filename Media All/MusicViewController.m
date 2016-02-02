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
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;//播放器
@property (nonatomic, strong) UIView *controlPanelView;//控制面板
@property (nonatomic, strong) UILabel *singerLabel;//歌手名字
@property (nonatomic, strong) UIButton *playOrPauseBtn;//播放/暂停按钮(如果tag为0认为是暂停状态，1是播放状态)
@property (nonatomic, strong) UIProgressView *playProgress;//进度条
@property (nonatomic, strong) NSTimer *timer;//进度更新定时器

@end

@implementation MusicViewController
 //开启远程控制
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
}
//当前控制器视图不显示时取消远程控制
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    //[self resignFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kMusicTitle;
    [self setupUI];
}

- (void)setupUI {
//    背景图
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageV.image = [UIImage imageNamed:@"Ren'eLiu"];
    [self.view addSubview:imageV];
//    底部版面控制器
   _controlPanelView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 150, self.view.bounds.size.width, 150)];
    _controlPanelView.backgroundColor = [UIColor blackColor];
    _controlPanelView.alpha = 0.5;
    [self.view addSubview:_controlPanelView];
    
//  歌手名字label
   _singerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 80, 20)];
    _singerLabel.text = kMusicSinger;
    _singerLabel.textColor = [UIColor whiteColor];
    _singerLabel.textAlignment = NSTextAlignmentLeft;
    [_controlPanelView addSubview:_singerLabel];
//    进度条
    _playProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _playProgress.frame = CGRectMake(0, 70, _controlPanelView.frame.size.width, 1);
    _playProgress.progressTintColor = [UIColor blueColor];
    _playProgress.trackTintColor =[UIColor grayColor];
    [_controlPanelView addSubview:_playProgress];
//    播放按钮
    _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _playOrPauseBtn.frame = CGRectMake((self.view.bounds.size.width- 50)*0.5, CGRectGetMaxY(_playProgress.frame)+15, 50, 50);
    _playOrPauseBtn.tag = 0;
    [_playOrPauseBtn setImage:[UIImage imageNamed:@"playing_btn_play_n"] forState:UIControlStateNormal];
    [_playOrPauseBtn setImage:[UIImage imageNamed:@"playing_btn_play_h"] forState:UIControlStateHighlighted];
    [_playOrPauseBtn addTarget:self action:@selector(playOrPauseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_controlPanelView addSubview:_playOrPauseBtn];

}

//点击button方法
- (void)playOrPauseBtn:(UIButton *)btn {
        if(btn.tag){
            btn.tag=0;
            [btn setImage:[UIImage imageNamed:@"playing_btn_play_n"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"playing_btn_play_h"] forState:UIControlStateHighlighted];
            [self pause];
        }else{
            btn.tag=1;
            [btn setImage:[UIImage imageNamed:@"playing_btn_pause_n"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"playing_btn_pause_h"] forState:UIControlStateHighlighted];
            [self play];
        }
}

/**
 *  播放音频
 */
-(void)play{
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
        self.timer.fireDate=[NSDate distantPast];//恢复定时器
    }
}
/**
 *  暂停播放
 */
-(void)pause{
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer pause];
        self.timer.fireDate=[NSDate distantFuture];//暂停定时器，注意不能调用invalidate方法，此方法会取消，之后无法恢复

    }
}

//创建播放器
- (AVAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        NSString *urlStr=[[NSBundle mainBundle]pathForResource:kMusicFile ofType:nil];
        NSURL *url=[NSURL fileURLWithPath:urlStr];
        NSError *error=nil;
        //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        //设置播放器属性
        _audioPlayer.numberOfLoops=0;//设置为0不循环
        _audioPlayer.delegate=self;
        [_audioPlayer prepareToPlay];//加载音频文件到缓存
        if(error){
            NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
            return nil;
        }
        //设置后台播放模式
        AVAudioSession *audioSession=[AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        //        [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
        [audioSession setActive:YES error:nil];
        //添加通知，拔出耳机后暂停播放
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    }
    return _audioPlayer;
}

-(NSTimer *)timer{
    if (!_timer) {
         _timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:true];
        
    }
    return _timer;
}
/**
 *  更新播放进度
 */
-(void)updateProgress{
    
    float progress= self.audioPlayer.currentTime /self.audioPlayer.duration;
//    保存
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithFloat:progress]forKey:@"progress"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.playProgress setProgress:progress animated:YES];
}

/**
 *  一旦输出改变则执行此方法
 *
 *  @param notification 输出改变通知对象
 */
-(void)routeChange:(NSNotification *)notification{
    NSDictionary *dic=notification.userInfo;
    int changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
    if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription=dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
        //原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            [self pause];
        }
    }
    
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSLog(@"%@:%@",key,obj);
    }];
}
//通知注销

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}

#pragma mark - 播放器代理方法
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"音乐播放完成...");
    //根据实际情况播放完成可以将会话关闭，其他音频应用继续播放
    [[AVAudioSession sharedInstance]setActive:NO error:nil];
}

@end
