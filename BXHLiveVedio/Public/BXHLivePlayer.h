//
//  BXHLivePlayer.h
//  BXHLiveVedio
//
//  Created by 步晓虎 on 2017/8/30.
//  Copyright © 2017年 步晓虎. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXHLivePlayer : UIView

@property (nonatomic, copy, readonly) NSString *playUrl;

- (instancetype)initWithRtmpUrl:(NSString *)url;

- (void)play;

- (void)pause;

- (void)cancelPlay;

@end


