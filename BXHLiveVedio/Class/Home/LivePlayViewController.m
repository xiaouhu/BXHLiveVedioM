//
//  LivePlayViewController.m
//  BXHLiveVedio
//
//  Created by 步晓虎 on 2017/8/30.
//  Copyright © 2017年 步晓虎. All rights reserved.
//

#import "LivePlayViewController.h"
#import "BXHLivePlayer.h"

@interface LivePlayViewController ()

@property (nonatomic, strong) BXHLivePlayer *player;

@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation LivePlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = Color_White;
    
    [self.view addSubview:self.player];
    self.player.sd_layout.leftEqualToView(self.view);
    self.player.sd_layout.rightEqualToView(self.view);
    self.player.sd_layout.topEqualToView(self.view);
    self.player.sd_layout.bottomEqualToView(self.view);
    
    [self.view addSubview:self.cancelBtn];
    self.cancelBtn.sd_layout.topEqualToView(self.view).offset(30);
    self.cancelBtn.sd_layout.leftEqualToView(self.view).offset(16);
    self.cancelBtn.sd_layout.widthIs(30);
    self.cancelBtn.sd_layout.heightIs(30);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.player play];
}

#pragma mark - lazyLoad
- (BXHLivePlayer *)player
{
    if (!_player)
    {
        _player = [[BXHLivePlayer alloc] initWithRtmpUrl:@"rtmp://10.8.1.172:1935/rtmplive/room"];
    }
    return _player;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn)
    {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.backgroundColor = [UIColor randomColor];
        @weakify(self);
        [[_cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self_weak_.player cancelPlay];
            [self_weak_ dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    return _cancelBtn;
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
