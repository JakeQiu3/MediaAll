//
//  AudioQueueServicesViewController.m
//  Media All
//
//  Created by 邱少依 on 16/2/2.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "AudioQueueServicesViewController.h"
#import "FSAudioStream.h"
@interface AudioQueueServicesViewController ()
@property (nonatomic,strong) FSAudioStream *audioStream;
@end

@implementation AudioQueueServicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.audioStream play];
}
/**
 *  取得本地文件路径
 *
 *  @return 文件路径
 */

- (NSURL *)getFileUrl {
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"刘若英 - 原来你也在这里" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    return url;
}

-(NSURL *)getNetworkUrl{
    NSString *urlStr=@"http://192.168.1.102/liu.mp3";
    NSURL *url=[NSURL URLWithString:urlStr];
    return url;
}
/**
 *  创建FSAudioStream对象
 *
 *  @return FSAudioStream对象
 */
-(FSAudioStream *)audioStream{
    if (!_audioStream) {
        NSURL *url=[self getNetworkUrl];
        //创建FSAudioStream对象
        _audioStream=[[FSAudioStream alloc]initWithUrl:url];
        _audioStream.onFailure=^(FSAudioStreamError error,NSString *description){
            NSLog(@"播放过程中发生错误，错误信息：%@",description);
        };
        _audioStream.onCompletion=^(){
            NSLog(@"播放完成!");
        };
        [_audioStream setVolume:0.5];//设置声音
    }
    return _audioStream;
}

@end
