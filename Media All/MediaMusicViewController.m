//
//  MediaMusicViewController.m
//  Media All
//
//  Created by 邱少依 on 16/2/2.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "MediaMusicViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface MediaMusicViewController ()<MPMediaPickerControllerDelegate>

@property (nonatomic, strong) MPMediaPickerController *mediaPicker;//媒体选择控制器
@property (nonatomic,strong) MPMusicPlayerController *musicPlayer; //音乐播放器
@end

@implementation MediaMusicViewController

-(void)dealloc{
    [self.musicPlayer endGeneratingPlaybackNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
}

- (void)setUI {
    NSArray *titleArray = @[@"选择音乐",@"播放",@"暂停",@"停止",@"上一曲",@"下一曲"];
    for (int i=0; i<6; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100+i;
        btn.frame = CGRectMake(100, 100+i*60, 200, 30);
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }

}

/**
 * 获得媒体选择器
 */
- (MPMediaPickerController *)mediaPicker {
    if (!_mediaPicker) {
        _mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAny];
        _mediaPicker.delegate = self;
        _mediaPicker.allowsPickingMultipleItems = YES;
        _mediaPicker.showsCloudItems=YES;//显示icloud选项
        _mediaPicker.prompt = @"请选择要播放的音乐";
        
        
    }
    return _mediaPicker;
}

/**
 *  获得音乐播放器
 *
 *  @return 音乐播放器
 */
-(MPMusicPlayerController *)musicPlayer{
    if (!_musicPlayer) {
        
        _musicPlayer=[MPMusicPlayerController systemMusicPlayer];
        [_musicPlayer beginGeneratingPlaybackNotifications];//开启通知，否则监控不到MPMusicPlayerController的通知
        [self addNotification];//添加通知
        
        //如果不使用MPMediaPickerController可以使用如下方法获得音乐库媒体队列
        //[_musicPlayer setQueueWithItemCollection:[self getLocalMediaItemCollection]];
    }
    return _musicPlayer;
}
/**
 *  添加通知
 */
-(void)addNotification{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStateChange:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.musicPlayer];
}
/**
 *  播放状态改变通知
 *
 *  @param notification 通知对象
 */
-(void)playbackStateChange:(NSNotification *)notification{
    switch (self.musicPlayer.playbackState) {
        case MPMusicPlaybackStatePlaying:
            NSLog(@"正在播放...");
            break;
        case MPMusicPlaybackStatePaused:
            NSLog(@"播放暂停..");
            break;
        case MPMusicPlaybackStateStopped:
            NSLog(@"播放停止.");
            break;
        default:
            break;
    }
}

- (void)clickBtn:(UIButton *)btn {
    switch (btn.tag-100) {
        case 0:
            [self chooseMusic];
            break;
        case 1:
            [self playMusic];
            break;
        case 2:
            [self pauseMusic];
            break;
        case 3:
            [self stopMusic];
            break;
        case 4:
            [self previousMusic];
            break;
        case 5:
            [self nextMusic];
            break;
        default:
            break;
    }
}

/**
 * 选择音乐
 */
- (void)chooseMusic {
    [self presentViewController:self.mediaPicker animated:YES completion:^{
        
    }];
}

/**
 * 播放音乐
 */
- (void)playMusic {
    [self.musicPlayer play];
}

/**
 * 暂停音乐
 */
- (void)pauseMusic {
    [self.musicPlayer pause];
}

/**
 * 停止音乐
 */
- (void)stopMusic {
    [self.musicPlayer stop];
}

/**
 * 上一首音乐
 */
- (void)previousMusic {
//    [self.musicPlayer skipToBeginning];//跳转到开始
    [self.musicPlayer skipToPreviousItem];
}

/**
 * 下一首音乐
 */
- (void)nextMusic {
    [self.musicPlayer skipToNextItem];
}

#pragma mark - MPMediaPickerController代理方法
//选择完成后执行
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    MPMediaItem *mediaItem=[mediaItemCollection.items firstObject];//第一个播放音乐
    /*
     * 获取音乐的信息
     */
    NSString *title= [mediaItem valueForKey:MPMediaItemPropertyAlbumTitle];
    NSString *artist= [mediaItem valueForKey:MPMediaItemPropertyAlbumArtist];
    MPMediaItemArtwork *artwork= [mediaItem valueForKey:MPMediaItemPropertyArtwork];
    UIImage *image=[artwork imageWithSize:CGSizeMake(100, 100)];//专辑图片
    NSLog(@"标题：%@,表演者：%@,专辑：%@,专辑图片:%@",title ,artist,artwork,image);
    [self.musicPlayer setQueueWithItemCollection:mediaItemCollection];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [self dismissModalViewControllerAnimated:YES];
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
