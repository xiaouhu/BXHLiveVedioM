//
//  LiveSteamView.h
//  BXHLiveVedio
//
//  Created by 步晓虎 on 2017/8/30.
//  Copyright © 2017年 步晓虎. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveBarrageListView.h"
#import "LiveMenuView.h"

@interface LiveSteamView : UIView

@property (nonatomic, strong) RACSignal *beautySignal;

@property (nonatomic, retain) RACSignal *cameraTurnSignal;

@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) UILabel *speedLabel;

@property (nonatomic, strong) LiveMenuView *menuView;

@property (nonatomic, strong) LiveBarrageListView *listView;

@end
