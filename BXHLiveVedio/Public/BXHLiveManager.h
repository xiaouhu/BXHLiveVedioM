//
//  BXHLiveManager.h
//  BXHLiveVedio
//
//  Created by 步晓虎 on 2017/8/30.
//  Copyright © 2017年 步晓虎. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFLiveKit.h"

typedef NS_ENUM(NSInteger, LiveType)
{
    LiveCameraType,
    LiveScreenRecordingType
};
@interface BXHLiveManager : NSObject <LFLiveSessionDelegate>

@property (nonatomic, assign, readonly) LiveType liveType;

@property (nonatomic, strong, readonly) RACSubject *liveStateSubject;

@property (nonatomic, strong, readonly) RACSubject *uploadSpeedSubject;

- (instancetype)initWithPreview:(UIView *)preview LiveType:(LiveType)liveType;

- (void)startLiveWithUrl:(NSString *)url;

- (void)stopLive;

- (void)turnRoundCamera;

- (void)beautyOfProgressValue:(CGFloat)progress;

- (void)brightOfProgressValue:(CGFloat)progress;

@end
