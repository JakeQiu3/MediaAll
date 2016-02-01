//
//  AudioToolViewController.m
//  Media All
//
//  Created by 邱少依 on 16/2/1.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "AudioToolViewController.h"
#import <AudioToolbox/AudioToolbox.h>
@interface AudioToolViewController ()

@end

@implementation AudioToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    加载本地音效文件
    [self  playSoundEffect:@"msgTritone.caf"];
}
/**
 *  播放完成回调函数
 *
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID systemID,void  * clientData){
    NSLog(@"播放完成时调用");
}

- (void)playSoundEffect:(NSString *)str {
    NSString *filePath = [[NSBundle mainBundle]pathForResource:str ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge  CFURLRef)(fileUrl), &soundID);//参数：音频文件url，声音id
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    //播放音效
    AudioServicesPlaySystemSound(soundID);
//    //播放音效并震动
//    AudioServicesPlayAlertSound(soundID);
    
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
