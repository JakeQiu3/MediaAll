//
//  RecordViewController.m
//  Media All
//
//  Created by 邱少依 on 16/2/1.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "RecordViewController.h"
#import <AVFoundation/AVFoundation.h>

#define kRecordAudioFile @"myRecord.caf"

@interface RecordViewController ()<AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//音频播放器，用于播放录音文件
@property (nonatomic,strong) NSTimer *timer;//录音声波监控（注意这里暂时不对播放进行监控）

@property (weak, nonatomic) IBOutlet UIButton *record;//开始录音
@property (weak, nonatomic) IBOutlet UIButton *pause;//暂停录音
@property (weak, nonatomic) IBOutlet UIButton *resume;//恢复录音
@property (weak, nonatomic) IBOutlet UIButton *stop;//停止录音
@property (weak, nonatomic) IBOutlet UIProgressView *audioPowerProgress;//音频波动
@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self setAudioSession];
}

//设置音频会话
- (void)setAudioSession {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
// 设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}

//取得录音文件保存路径
- (NSURL *)getPath {
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *recordStr = [filePath stringByAppendingPathComponent:kRecordAudioFile];
    return [NSURL fileURLWithPath:recordStr];
}
//取得录音文件设置
- (NSDictionary *)getAudioSetting {
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return dicM;
    
}

/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
- (AVAudioRecorder *)audioRecorder {
    if (!_audioRecorder) {
        //创建录音文件保存路径
        NSURL *url = [self getPath];
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
         //创建录音机
        NSError *error;
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate = self;
        //如果要监控声波,则必须设置为YES
        _audioRecorder.meteringEnabled = YES;
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}
/**
 *  创建播放器
 *
 *  @return 播放器
 */
- (AVAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        NSURL *url = [self getPath];
        NSError *error;
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (error) {
            NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}

/**
 *  录音声波监控定制器
 *
 *  @return 定时器
 */
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }
    return _timer;
}
// 录音声波状态设置
- (void)audioPowerChange {
      [self.audioRecorder updateMeters];//更新测量值
    float power = [self.audioRecorder averagePowerForChannel:0];
    CGFloat progress = (1.0/160.0)*(power + 160.0);
    [self.audioPowerProgress setProgress:progress animated:YES];
}
#pragma mark - UI事件
/**
 *  点击录音按钮
 *
 *  @param sender 录音按钮
 */
- (IBAction)recordClick:(UIButton *)sender {
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        self.timer.fireDate=[NSDate distantPast];
    }
}

/**
 *  点击暂定按钮
 *
 *  @param sender 暂停按钮
 */
- (IBAction)pauseClick:(UIButton *)sender {
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder pause];
        self.timer.fireDate=[NSDate distantFuture];
    }
}

/**
 *  点击恢复按钮
 *  恢复录音只需要再次调用record，AVAudioSession会帮助你记录上次录音位置并追加录音
 *
 *  @param sender 恢复按钮
 */
- (IBAction)resumeClick:(UIButton *)sender {
    [self recordClick:sender];
}

/**
 *  点击停止按钮
 *
 *  @param sender 停止按钮
 */
- (IBAction)stopClick:(UIButton *)sender {
    [self.audioRecorder stop];
    self.timer.fireDate=[NSDate distantFuture];
    self.audioPowerProgress.progress=0.0;
}
#pragma mark - 录音机代理方法
/**
 *  录音完成，录音完成后播放录音
 *
 *  @param recorder 录音机对象
 *  @param flag     是否成功
 */
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
    }
    NSLog(@"录音完成!");
}
@end
