//
//  HomeListViewController.m
//  BXHLiveVedio
//
//  Created by 步晓虎 on 2017/8/30.
//  Copyright © 2017年 步晓虎. All rights reserved.
//

#import "HomeListViewController.h"
#import "LivePlayViewController.h"
#import "LiveSteamViewController.h"

@interface HomeListViewController ()

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) UIButton *streamBtn;

@end

@implementation HomeListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = Color_White;
    
    [self.view addSubview:self.playBtn];
    [self.view addSubview:self.streamBtn];
    
    self.playBtn.sd_layout.topEqualToView(self.view).offset(100);
    self.playBtn.sd_layout.leftEqualToView(self.view).offset(30);
    self.playBtn.sd_layout.rightEqualToView(self.view).offset(-30);
    self.playBtn.sd_layout.heightIs(60);
    
    self.streamBtn.sd_layout.topSpaceToView(self.playBtn, 30);
    self.streamBtn.sd_layout.leftEqualToView(self.view).offset(30);
    self.streamBtn.sd_layout.rightEqualToView(self.view).offset(-30);
    self.streamBtn.sd_layout.heightIs(60);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - laztLoad
- (UIButton *)playBtn
{
    if (!_playBtn)
    {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.backgroundColor = [UIColor randomColor];
        [_playBtn setTitle:@"观看直播" forState:UIControlStateNormal];
        @weakify(self);
        [[_playBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            LivePlayViewController *playVc = [[LivePlayViewController alloc] init];
            [self_weak_ presentViewController:playVc animated:YES completion:nil];
        }];
    }
    return _playBtn;
}

- (UIButton *)streamBtn
{
    if (!_streamBtn)
    {
        _streamBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _streamBtn.backgroundColor = [UIColor randomColor];
        [_streamBtn setTitle:@"我要直播" forState:UIControlStateNormal];
        @weakify(self);
        [[_streamBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            LiveSteamViewController *streamVc = [[LiveSteamViewController alloc] init];
            [self_weak_ presentViewController:streamVc animated:YES completion:nil];
        }];
    }
    return _streamBtn;
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
