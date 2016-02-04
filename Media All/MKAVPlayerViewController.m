//
//  VideoViewController.m
//  Media All
//
//  Created by 邱少依 on 16/2/1.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "MKAVPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface MKAVPlayerViewController ()
{
    UIView *containerView;//播放器容器view
    UIButton *playOrPauseBtn;
    
}
@property (nonatomic, strong)AVPlayer *player;//播放器对象
@property (nonatomic, strong)UIProgressView *progressView;//进度条

@end

@implementation MKAVPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self.player play];
    // Do any additional setup after loading the view.
}

/*
 * 获取AVPlayer的对象
 */
- (AVPlayer *)player {
    if (!_player) {
        AVPlayerItem *playerItem = [self getPlayItem:0];
        _player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        [self addProgressObserver];
        [self addObserverToPlayerItem:playerItem];
        
    }
    return _player;
}

/**
 *  根据视频索引取得AVPlayerItem对象
 *
 *  @param videoIndex 视频顺序索引
 *
 *  @return AVPlayerItem对象
 */
- (AVPlayerItem *)getPlayItem:(int)videoIndex {
    NSString *urlStr = [NSString stringWithFormat:@"http://192.168.1.161/%i.mp4",videoIndex];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
//    根据url获得对应的AVPlayerItem。
    AVPlayerItem *playItem = [AVPlayerItem playerItemWithURL:url];
    return playItem;
}
/**
 *  给播放器添加进度更新
 */
- (void)addProgressObserver {
    
    __weak __typeof(self)weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        float current = CMTimeGetSeconds(time);
        float total=CMTimeGetSeconds([strongSelf.player.currentItem duration]);
        if (current) {
            [strongSelf.progressView setProgress:current/total animated:YES];
        }
    }];
  
}
/**
 *  给AVPlayerItem添加监控
 *
 *  @param playerItem AVPlayerItem对象
 */
- (void)addObserverToPlayerItem:(AVPlayerItem *)playItem {
    //监控状态属性
    [playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
   ////监控网络加载情况属性
    [playItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    
}
- (void)setUI {
    //播放器容器view
    containerView = [[UIView alloc]init];
    containerView.backgroundColor = [UIColor lightGrayColor];
    containerView.frame = CGRectMake(0, 64, self.view.bounds.size.width, 250);
    [self.view addSubview:containerView];
    //   创建播放器底层
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = containerView.frame;
    [containerView.layer addSublayer:playerLayer];

// 暂停或播放按钮
    playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playOrPauseBtn.frame = CGRectMake(10, 64+250, 50, 50);
    [playOrPauseBtn setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
    [playOrPauseBtn addTarget:self action:@selector(playOrPauseClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playOrPauseBtn];
    
//    进度条
   _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.frame = CGRectMake(CGRectGetMaxX(playOrPauseBtn.frame), CGRectGetMaxY(playOrPauseBtn.frame)-25,300, 0);
    _progressView.progressTintColor = [UIColor blueColor];
    _progressView.trackTintColor = [UIColor lightGrayColor];
    [self.view addSubview:_progressView];
//    播放列表
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, CGRectGetMaxY(playOrPauseBtn.frame), 100, 30);
    label.text = @"播放列表";
    label.textColor = [UIColor blueColor];
    [self.view addSubview:label];
    
//    3个切换集数的button
    NSArray *array = @[@"视频1",@"视频2",@"视频3"];
    for (int i = 0; i < 3; ++i) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10+i*(60+5), CGRectGetMaxY(label.frame)+20, 60, 50);
        btn.tag = i;
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)playOrPauseClick:(UIButton *)btn {
    if (!self.player.rate) {//执行暂停
        [btn setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
        [self.player play];
    } else if(self.player.rate) {//执行播放
        [btn setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
        [self.player pause];
    }
}
//切换视频
- (void)btnClickItem:(UIButton *)btn {
// 移除已有的监听
    [self removeNotification];
    [self removeObserverFromPlayerItem:self.player.currentItem];
//根据url获取到AVPlayerItem
    AVPlayerItem *playerItem = [self getPlayItem:(int)btn.tag];
    [self addObserverToPlayerItem:playerItem];
    //切换视频
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self addNotification];
    
}
/**
 *  添加播放器通知
 */
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
}

- (void)playbackFinished:(NSNotification *)notification {
    NSLog(@"播放完成");
}

//移除视频观察者和通知观察者
- (void)dealloc {
    [self removeObserverFromPlayerItem:self.player.currentItem];
    [self removeNotification];
  
}

- (void)removeObserverFromPlayerItem:(AVPlayerItem *)currentItem {
    [self removeObserver:self forKeyPath:@"status"];
    [self removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    AVPlayerItem *playerItem=object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status==AVPlayerStatusReadyToPlay){
            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array=playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        NSLog(@"共缓冲：%.2f",totalBuffer);
        //
    }

}

@end
