//
//  PhotoGraphyViewController.m
//  Media All
//
//  Created by 邱少依 on 16/2/1.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "VideoCutPhotoViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface VideoCutPhotoViewController ()

@end

@implementation VideoCutPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取第13.0s的缩略图
    [self thumbnailImageRequest:13.0];
    // Do any additional setup after loading the view.
}

/**
 *  取得本地文件路径
 *
 *  @return 文件路径:path
 */
-(NSURL *)getFileUrl{
    NSString *urlStr=[[NSBundle mainBundle] pathForResource:@"The New Look of OS X Yosemite.mp4" ofType:nil];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    return url;
}

/**
 *  取得网络文件路径
 *
 *  @return 文件路径
 */
- (NSURL *)getNetworkUrl {
    NSString *urlStr=@"http://192.168.1.161/The New Look of OS X Yosemite.mp4";
    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    return url;
}
-(void)thumbnailImageRequest:(CGFloat )timeBySecond{
    //创建URL
    NSURL *url=[self getNetworkUrl];
    //根据url创建AVURLAsset
    AVURLAsset *urlAsset=[AVURLAsset assetWithURL:url];
    //根据AVURLAsset创建AVAssetImageGenerator
    AVAssetImageGenerator *imageGenerator=[AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    /*截图
     * requestTime:缩略图创建时间
     * actualTime:缩略图实际生成的时间
     */
    NSError *error=nil;
    CMTime time=CMTimeMakeWithSeconds(timeBySecond, 10);//CMTime是表示电影时间信息的结构体，第一个参数是视频第几秒，第二个参数时每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actualTime;
    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if(error){
        NSLog(@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription);
        return;
    }
    CMTimeShow(actualTime);
    UIImage *image=[UIImage imageWithCGImage:cgImage];//转化为UIImage
    //保存到相册
    UIImageWriteToSavedPhotosAlbum(image,nil, nil, nil);
    CGImageRelease(cgImage);
}

@end
