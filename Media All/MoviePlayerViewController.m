//
//  MoviePlayerViewController.m
//  Media All
//
//  Created by 邱少依 on 16/2/4.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "MoviePlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
@interface MoviePlayerViewController ()
@property (nonatomic, strong) MPMoviePlayerViewController  *moviePlayerViewController;

//播放器视图控制器
//@property (nonatomic, strong) AVPlayerViewController *moviePlayerViewController;


@end

@implementation MoviePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"播放视频测试" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
    // Do any additional setup after loading the view.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        [self setUI];
        NSLog(@"------");
    }
}
- (void)setUI {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100, 100, 50, 50);
    [btn setTitle:@"播放" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
}
/**
 *  取得本地文件路径
 *
 *  @return 文件路径
 */
- (NSURL *)getFileUrl {
    NSString *fileStr = [[NSBundle mainBundle]pathForResource:@"" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:fileStr];
    return url;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(MPMoviePlayerViewController *)moviePlayerViewController{
    if (!_moviePlayerViewController) {
        NSURL *url=[self getFileUrl];
        _moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
        [self addNotification];
    }
    return _moviePlayerViewController;
}

/**
 *  添加通知监控媒体播放控制器状态
 */
- (void)addNotification {
//    状态改变就发送通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayerViewController];
//    播放结束时发布
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayerViewController];
}

/**
 * 播放状态改变时，发布
 */
- (void)mediaPlayerPlaybackStateChange:(NSNotification *)notification {
    switch (self.moviePlayerViewController.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
              NSLog(@"正在播放...");
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放.");
            break;
        case MPMoviePlaybackStateStopped:
            NSLog(@"停止播放..");
            break;

        default:
             NSLog(@"播放状态:%li",self.moviePlayerViewController.moviePlayer.playbackState);
            break;
    }
}

/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
    NSLog(@"播放完成.%li",self.moviePlayerViewController.moviePlayer.playbackState);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
