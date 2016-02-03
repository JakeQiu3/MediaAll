//
//  VideoViewController.m
//  Media All
//
//  Created by 邱少依 on 16/2/1.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "VideoViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface VideoViewController ()
{
    UIView *containerView;//播放器容器view
    UIButton *playOrPauseBtn;
    UIProgressView *progressView;//进度条
    
}
@property (nonatomic, strong)AVPlayer *player;//播放器对象

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self.player play];
    // Do any additional setup after loading the view.
}
- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc] initWithPlayerItem:<#(nonnull AVPlayerItem *)#>];
        
    }
    return _player;
}
- (void)setUI {
    //播放器容器view
    containerView = [[UIView alloc]init];
    containerView.frame = CGRectMake(0, 64, self.view.bounds.size.width, 250);
    [self.view addSubview:containerView];
    //   创建播放器底层
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = containerView.frame;
    [containerView.layer addSublayer:playerLayer];

// 暂停或播放按钮
    playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playOrPauseBtn.frame = CGRectMake(0, 64+250, 50, 50);
    
    [self.view addSubview:playOrPauseBtn];
    
//    进度条
   progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.frame = CGRectMake(CGRectGetMaxX(playOrPauseBtn.frame), CGRectGetMaxY(playOrPauseBtn.frame), 100, 0);
    progressView.progressTintColor = [UIColor blueColor];
    progressView.trackTintColor = [UIColor lightGrayColor];
    [self.view addSubview:progressView];
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
