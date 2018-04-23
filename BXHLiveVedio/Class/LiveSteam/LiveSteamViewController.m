//
//  LiveSteamViewController.m
//  BXHLiveVedio
//
//  Created by 步晓虎 on 2017/8/30.
//  Copyright © 2017年 步晓虎. All rights reserved.
//

#import "LiveSteamViewController.h"
#import "BXHLiveManager.h"
#import "LiveSteamView.h"

#import "BXHLivePlayer.h"

@interface LiveSteamViewController ()

@property (nonatomic, strong) BXHLiveManager *manager;

@property (nonatomic, strong) LiveSteamView *streamView;

@property (nonatomic, strong) UIButton *cancelBtn;
//
//@property (nonatomic, strong) BXHLivePlayer *player1;
//
//@property (nonatomic, strong) BXHLivePlayer *player2;
//
//@property (nonatomic, strong) BXHLivePlayer *player3;

@end

@implementation LiveSteamViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.steamView];
    self.streamView.sd_layout.topEqualToView(self.view);
    self.streamView.sd_layout.leftEqualToView(self.view);
    self.streamView.sd_layout.rightEqualToView(self.view);
    self.streamView.sd_layout.bottomEqualToView(self.view);
    
    [self.view addSubview:self.cancelBtn];
    self.cancelBtn.sd_layout.topEqualToView(self.view).offset(30);
    self.cancelBtn.sd_layout.leftEqualToView(self.view).offset(16);
    self.cancelBtn.sd_layout.widthIs(30);
    self.cancelBtn.sd_layout.heightIs(30);
    
//    [self.view addSubview:self.player1];
//    [self.view addSubview:self.player2];
//    [self.view addSubview:self.player3];
//    
//    self.player1.sd_layout.leftEqualToView(self.view);
//    self.player1.sd_layout.topEqualToView(self.view).offset(100);
//    self.player1.sd_layout.widthIs(80);
//    self.player1.sd_layout.heightIs(100);
//    
//    self.player2.sd_layout.leftSpaceToView(self.player1, 0);
//    self.player2.sd_layout.topEqualToView(self.view).offset(100);
//    self.player2.sd_layout.widthIs(80);
//    self.player2.sd_layout.heightIs(100);
//    
//    self.player3.sd_layout.leftSpaceToView(self.player2, 0);
//    self.player3.sd_layout.topEqualToView(self.view).offset(100);
//    self.player3.sd_layout.widthIs(80);
//    self.player3.sd_layout.heightIs(100);
    
    self.manager = [[BXHLiveManager alloc] initWithPreview:self.streamView LiveType:LiveCameraType];
    
    @weakify(self);
    [self.manager.liveStateSubject subscribeNext:^(id x) {
        switch ([x integerValue])
        {
            case LFLiveReady:
                self_weak_.streamView.stateLabel.text = @"未连接";
                break;
            case LFLivePending:
                self_weak_.streamView.stateLabel.text = @"连接中";
                break;
            case LFLiveStart:
                self_weak_.streamView.stateLabel.text = @"已连接";
                break;
            case LFLiveError:
                self_weak_.streamView.stateLabel.text = @"连接错误";
                break;
            case LFLiveStop:
                self_weak_.streamView.stateLabel.text = @"未连接";
                break;
            default:
                break;
        }
    }];
    
    [self.manager.uploadSpeedSubject subscribeNext:^(id x) {
        self_weak_.streamView.speedLabel.text = x;
    }];
    
    [self.streamView.beautySignal subscribeNext:^(UIButton *x) {
        x.selected = !x.selected;
        if (x.selected)
        {
            [self_weak_.manager beautyOfProgressValue:0];
        }
        else
        {
            [self_weak_.manager beautyOfProgressValue:0.5];
        }
    }];
    [self.streamView.cameraTurnSignal subscribeNext:^(id x) {
        [self_weak_.manager turnRoundCamera];
    }];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.manager startLiveWithUrl:@"rtmp://10.8.1.172:1935/rtmplive/room"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.manager stopLive];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - lazyLoad
- (LiveSteamView *)steamView
{
    if (!_streamView)
    {
        _streamView = [[LiveSteamView alloc] init
                      ];
    }
    return _streamView;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn)
    {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.backgroundColor = [UIColor randomColor];
        @weakify(self);
        [[_cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self_weak_ dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    return _cancelBtn;
}
//
//
//- (BXHLivePlayer *)player1
//{
//    if (!_player1)
//    {
//        _player1 = [[BXHLivePlayer alloc] initWithRtmpUrl:@"http://hdl3.douyucdn.cn/live/436781rc1epoAcpR_900.flv?wsAuth=0b1557d1f6bdcf85b238834dda64555a&token=web-douyu-0-436781-9e182f221edb5a4c8cd5c18406002e73&logo=0&expire=0&did=E636CF68B706B5ED33FD8E1D7D0342AC&ver=2017083111"];
//    }
//    return _player1;
//}
//
//- (BXHLivePlayer *)player2
//{
//    if (!_player2)
//    {
//        _player2 = [[BXHLivePlayer alloc] initWithRtmpUrl:@"http://hdl3.douyucdn.cn/live/436781rc1epoAcpR_900.flv?wsAuth=0b1557d1f6bdcf85b238834dda64555a&token=web-douyu-0-436781-9e182f221edb5a4c8cd5c18406002e73&logo=0&expire=0&did=E636CF68B706B5ED33FD8E1D7D0342AC&ver=2017083111"];
//    }
//    return _player2;
//}
//
//- (BXHLivePlayer *)player3
//{
//    if (!_player3)
//    {
//        _player3 = [[BXHLivePlayer alloc] initWithRtmpUrl:@"http://hdl3.douyucdn.cn/live/436781rc1epoAcpR_900.flv?wsAuth=0b1557d1f6bdcf85b238834dda64555a&token=web-douyu-0-436781-9e182f221edb5a4c8cd5c18406002e73&logo=0&expire=0&did=E636CF68B706B5ED33FD8E1D7D0342AC&ver=2017083111"];
//    }
//    return _player3;
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
