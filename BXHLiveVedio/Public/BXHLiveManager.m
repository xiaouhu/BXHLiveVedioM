//
//  BXHLiveManager.m
//  BXHLiveVedio
//
//  Created by 步晓虎 on 2017/8/30.
//  Copyright © 2017年 步晓虎. All rights reserved.
//

#import "BXHLiveManager.h"

inline static NSString *formatedSpeed(float bytes, float elapsed_milli) {
    if (elapsed_milli <= 0) {
        return @"N/A";
    }
    
    if (bytes <= 0) {
        return @"0 KB/s";
    }
    
    float bytes_per_sec = ((float)bytes) * 1000.f /  elapsed_milli;
    if (bytes_per_sec >= 1000 * 1000) {
        return [NSString stringWithFormat:@"%.2f MB/s", ((float)bytes_per_sec) / 1000 / 1000];
    } else if (bytes_per_sec >= 1000) {
        return [NSString stringWithFormat:@"%.1f KB/s", ((float)bytes_per_sec) / 1000];
    } else {
        return [NSString stringWithFormat:@"%ld B/s", (long)bytes_per_sec];
    }
}


@interface BXHLiveManager ()

@property (nonatomic, strong) LFLiveSession *session;


@end

@implementation BXHLiveManager

- (instancetype)initWithPreview:(UIView *)preview LiveType:(LiveType)liveType
{
    if (self = [super init])
    {
        self.session.preView = preview;
        _liveType = liveType;
        
        [self requestAccessForAudio];
        [self requestAccessForVideo];
        [self creatRACSubject];
    }
    return self;
}

#pragma mark - public
- (void)startLiveWithUrl:(NSString *)url
{
    LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
    stream.url = url;
    [self.session startLive:stream];
}

- (void)stopLive
{
    [self.session stopLive];
}

- (void)turnRoundCamera
{
    AVCaptureDevicePosition devicePositon = self.session.captureDevicePosition;
    self.session.captureDevicePosition = (devicePositon == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
}

- (void)beautyOfProgressValue:(CGFloat)progress
{
    self.session.beautyLevel = progress;
}

- (void)brightOfProgressValue:(CGFloat)progress
{
    self.session.brightLevel = progress;
}

#pragma mark - private
- (void)requestAccessForVideo
{
    __weak typeof(self) _self = self;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined: {
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_self.session setRunning:YES];
                    });
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            // 已经开启授权，可继续
            dispatch_async(dispatch_get_main_queue(), ^{
                [_self.session setRunning:YES];
            });
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            ToastShowTop(@"摄像头不可用");
            
            break;
        default:
            break;
    }
}

- (void)requestAccessForAudio
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
}

- (void)creatRACSubject
{
    _liveStateSubject = [RACSubject subject];
    _uploadSpeedSubject = [RACSubject subject];
}

#pragma mark -- LFStreamingSessionDelegate
/** live status changed will callback */
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state {
    NSLog(@"liveStateDidChange: %ld", state);
    
    [_liveStateSubject sendNext:[NSNumber numberWithUnsignedInteger:state]];
}

/** live debug info callback */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug *)debugInfo

{
    [_uploadSpeedSubject sendNext:formatedSpeed(debugInfo.currentBandwidth, debugInfo.elapsedMilli)];
}

/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession *)session errorCode:(LFLiveSocketErrorCode)errorCode
{
    NSLog(@"errorCode: %ld", errorCode);
}

#pragma mark - lazyLoad
- (LFLiveSession *)session
{
    if (!_session)
    {
        /**      发现大家有不会用横屏的请注意啦，横屏需要在ViewController  supportedInterfaceOrientations修改方向  默认竖屏  ****/
        /**      发现大家有不会用横屏的请注意啦，横屏需要在ViewController  supportedInterfaceOrientations修改方向  默认竖屏  ****/
        /**      发现大家有不会用横屏的请注意啦，横屏需要在ViewController  supportedInterfaceOrientations修改方向  默认竖屏  ****/
        
        
//        /***   默认分辨率368 ＊ 640  音频：44.1 iphone6以上48  双声道  方向竖屏 ***/
//        LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
//        videoConfiguration.videoSize = CGSizeMake(360, 640);
//        videoConfiguration.videoBitRate = 800*1024;
//        videoConfiguration.videoMaxBitRate = 1000*1024;
//        videoConfiguration.videoMinBitRate = 500*1024;
//        videoConfiguration.videoFrameRate = 24;
//        videoConfiguration.videoMaxKeyframeInterval = 48;
//        videoConfiguration.outputImageOrientation = UIDeviceOrientationPortrait;
//        videoConfiguration.autorotate = YES;
//        videoConfiguration.sessionPreset = LFCaptureSessionPreset720x1280;
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfigurationForQuality:LFLiveAudioQuality_Medium] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_Low1] captureType:LFLiveCaptureDefaultMask];
        
        /**    自己定制单声道  */
        /*
         LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
         audioConfiguration.numberOfChannels = 1;
         audioConfiguration.audioBitrate = LFLiveAudioBitRate_64Kbps;
         audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
         */
        
        /**    自己定制高质量音频96K */
        /*
         LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
         audioConfiguration.numberOfChannels = 2;
         audioConfiguration.audioBitrate = LFLiveAudioBitRate_96Kbps;
         audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:[LFLiveVideoConfiguration defaultConfiguration]];
         */
        
        /**    自己定制高质量音频96K 分辨率设置为540*960 方向竖屏 */
        
        /*
         LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
         audioConfiguration.numberOfChannels = 2;
         audioConfiguration.audioBitrate = LFLiveAudioBitRate_96Kbps;
         audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         
         LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
         videoConfiguration.videoSize = CGSizeMake(540, 960);
         videoConfiguration.videoBitRate = 800*1024;
         videoConfiguration.videoMaxBitRate = 1000*1024;
         videoConfiguration.videoMinBitRate = 500*1024;
         videoConfiguration.videoFrameRate = 24;
         videoConfiguration.videoMaxKeyframeInterval = 48;
         videoConfiguration.orientation = UIInterfaceOrientationPortrait;
         videoConfiguration.sessionPreset = LFCaptureSessionPreset540x960;
         
         _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration];
         */
        
        
        /**    自己定制高质量音频128K 分辨率设置为720*1280 方向竖屏 */
        
        /*
         LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
         audioConfiguration.numberOfChannels = 2;
         audioConfiguration.audioBitrate = LFLiveAudioBitRate_128Kbps;
         audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         
         LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
         videoConfiguration.videoSize = CGSizeMake(720, 1280);
         videoConfiguration.videoBitRate = 800*1024;
         videoConfiguration.videoMaxBitRate = 1000*1024;
         videoConfiguration.videoMinBitRate = 500*1024;
         videoConfiguration.videoFrameRate = 15;
         videoConfiguration.videoMaxKeyframeInterval = 30;
         videoConfiguration.landscape = NO;
         videoConfiguration.sessionPreset = LFCaptureSessionPreset360x640;
         
         _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration];
         */
        
        
        /**    自己定制高质量音频128K 分辨率设置为720*1280 方向横屏  */
        
        /*
         LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
         audioConfiguration.numberOfChannels = 2;
         audioConfiguration.audioBitrate = LFLiveAudioBitRate_128Kbps;
         audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         
         LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
         videoConfiguration.videoSize = CGSizeMake(1280, 720);
         videoConfiguration.videoBitRate = 800*1024;
         videoConfiguration.videoMaxBitRate = 1000*1024;
         videoConfiguration.videoMinBitRate = 500*1024;
         videoConfiguration.videoFrameRate = 15;
         videoConfiguration.videoMaxKeyframeInterval = 30;
         videoConfiguration.landscape = YES;
         videoConfiguration.sessionPreset = LFCaptureSessionPreset720x1280;
         
         _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration];
         */
        
        _session.delegate = self;
        _session.showDebugInfo = YES;
        /*本地存储*/
        //        _session.saveLocalVideo = YES;
        //        NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.mp4"];
        //        unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
        //        NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
        //        _session.saveLocalVideoPath = movieURL;
        
        /*
         UIImageView *imageView = [[UIImageView alloc] init];
         imageView.alpha = 0.8;
         imageView.frame = CGRectMake(100, 100, 29, 29);
         imageView.image = [UIImage imageNamed:@"ios-29x29"];
         _session.warterMarkView = imageView;*/
        
    }
    return _session;
}


//- (RACSubject *)liveStateSubject
//{
//    if (!_liveStateSubject)
//    {
//        
//    }
//}

@end
