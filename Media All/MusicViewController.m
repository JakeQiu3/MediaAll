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
@property (nonatomic, weak) UILabel *singerLabel;//歌手名字
@property (nonatomic, weak) UIButton *playOrPauseBtn;//播放/暂停按钮(如果tag为0认为是暂停状态，1是播放状态)
@property (nonatomic, weak) UIProgressView *playProgress;//进度条
@property (nonatomic, weak) NSTimer *timer;//进度更新定时器

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
//    背景图
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageV.image = [UIImage imageNamed:@"Ren'eLiu"];
    [self.view addSubview:imageV];
//    底部版面控制器
    UIView *controlPanelView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 200, self.view.bounds.size.width, 200)];
    controlPanelView.backgroundColor = [UIColor blackColor];
    controlPanelView.alpha = 0.5;
    [self.view addSubview:controlPanelView];
    _controlPanelView = controlPanelView;
//  歌手名字label
    UILabel *singerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
    singerLabel.text = kMusicSinger;
    singerLabel.textColor = [UIColor whiteColor];
    singerLabel.textAlignment = NSTextAlignmentLeft;
    [_controlPanelView addSubview:singerLabel];
    _singerLabel = singerLabel;
//  进度条
    UIProgressView *playProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    playProgress.frame = CGRectMake(0, 70, controlPanelView.frame.size.width, 1);
    playProgress.progressTintColor = [UIColor blueColor];
    playProgress.trackTintColor =[UIColor grayColor];
    [_controlPanelView addSubview:playProgress];
    _playProgress = playProgress;
// button
    UIButton *playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playOrPauseBtn.frame = CGRectMake((self.view.bounds.size.width- 50)*0.5, CGRectGetMaxY(_playProgress.frame)+5, 50, 50);
    [playOrPauseBtn setImage:[UIImage imageNamed:@"playing_btn_play_n"] forState:UIControlStateNormal];
    [playOrPauseBtn setImage:[UIImage imageNamed:@"playing_btn_play_h"] forState:UIControlStateHighlighted];
    [playOrPauseBtn addTarget:self action:@selector(playOrPauseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_controlPanelView addSubview:playOrPauseBtn];
    _playOrPauseBtn = playOrPauseBtn;
}

-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:true];
    }
    return _timer;
}

//点击button方法
- (void)playOrPauseBtn:(UIButton *)btn {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #import "ViewController.h"
 #import <AVFoundation/AVFoundation.h>
 #define kMusicFile @"刘若英 - 原来你也在这里.mp3"
 #define kMusicSinger @"刘若英"
 #define kMusicTitle @"原来你也在这里"
 
 @interface ViewController ()<AVAudioPlayerDelegate>
 
 @property (nonatomic,strong) AVAudioPlayer *audioPlayer;//播放器
 @property (weak, nonatomic) IBOutlet UILabel *controlPanel; //控制面板
 @property (weak, nonatomic) IBOutlet UIProgressView *playProgress;//播放进度
 @property (weak, nonatomic) IBOutlet UILabel *musicSinger; //演唱者
 @property (weak, nonatomic) IBOutlet UIButton *playOrPause; //播放/暂停按钮(如果tag为0认为是暂停状态，1是播放状态)
 
 @property (weak ,nonatomic) NSTimer *timer;//进度更新定时器
 
 @end
 
 @implementation ViewController
 
 - (void)viewDidLoad {
 [super viewDidLoad];
 
 [self setupUI];
 
 }
 
 /**
 *  显示当面视图控制器时注册远程事件
 *
 *  @param animated 是否以动画的形式显示
 */
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //开启远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    //作为第一响应者
    //[self becomeFirstResponder];
}
/**
 *  当前控制器视图不显示时取消远程控制
 *
 *  @param animated 是否以动画的形式消失
 */
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    //[self resignFirstResponder];
}

/**
 *  初始化UI
 */
-(void)setupUI{
    self.title=kMusicTitle;
    self.musicSinger.text=kMusicSinger;
}

-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:true];
    }
    return _timer;
}

/**
 *  创建播放器
 *
 *  @return 音频播放器
 */
-(AVAudioPlayer *)audioPlayer{
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
        [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
        [audioSession setActive:YES error:nil];
        //添加通知，拔出耳机后暂停播放
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    }
    return _audioPlayer;
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

/**
 *  点击播放/暂停按钮
 *
 *  @param sender 播放/暂停按钮
 */
- (IBAction)playClick:(UIButton *)sender {
    if(sender.tag){
        sender.tag=0;
        [sender setImage:[UIImage imageNamed:@"playing_btn_play_n"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"playing_btn_play_h"] forState:UIControlStateHighlighted];
        [self pause];
    }else{
        sender.tag=1;
        [sender setImage:[UIImage imageNamed:@"playing_btn_pause_n"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"playing_btn_pause_h"] forState:UIControlStateHighlighted];
        [self play];
    }
}

/**
 *  更新播放进度
 */
-(void)updateProgress{
    float progress= self.audioPlayer.currentTime /self.audioPlayer.duration;
    [self.playProgress setProgress:progress animated:true];
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

 */

@end
