//
//  LiveSteamView.m
//  BXHLiveVedio
//
//  Created by 步晓虎 on 2017/8/30.
//  Copyright © 2017年 步晓虎. All rights reserved.
//

#import "LiveSteamView.h"

@implementation LiveSteamView

- (instancetype)init
{
    if (self = [super init])
    {
        [self addSubview:self.stateLabel];
        [self addSubview:self.speedLabel];
        [self addSubview:self.menuView];
//        [self addSubview:self.listView];
        
        self.stateLabel.sd_layout.centerXEqualToView(self);
        self.stateLabel.sd_layout.topEqualToView(self).offset(20);
        self.stateLabel.sd_layout.widthIs(60);
        self.stateLabel.sd_layout.heightIs(20);
        
        self.speedLabel.sd_layout.rightEqualToView(self).offset(-10);
        self.speedLabel.sd_layout.topEqualToView(self.stateLabel);
        self.speedLabel.sd_layout.widthIs(60);
        self.speedLabel.sd_layout.heightIs(20);
        
        self.menuView.sd_layout.leftEqualToView(self).offset(10);
        self.menuView.sd_layout.bottomEqualToView(self).offset(-20);
        self.menuView.sd_layout.heightIs(30);
        self.menuView.sd_layout.widthIs(90);
    }
    return self;
}

#pragma mark - lazyLoad
- (UILabel *)stateLabel
{
    if (!_stateLabel)
    {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.backgroundColor = [UIColor colorWithRed:0.10 green:0.1 blue:0.1 alpha:0.5];
        _stateLabel.font = Font_sys_10;
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.textColor = [UIColor lightGrayColor];
        _stateLabel.layer.cornerRadius = 3;
        _stateLabel.clipsToBounds = YES;
    }
    return _stateLabel;
}

- (UILabel *)speedLabel
{
    if (!_speedLabel)
    {
        _speedLabel = [[UILabel alloc] init];
        _speedLabel.backgroundColor = [UIColor colorWithRed:0.10 green:0.1 blue:0.1 alpha:0.5];
        _speedLabel.font = Font_sys_10;
        _speedLabel.textAlignment = NSTextAlignmentCenter;
        _speedLabel.textColor = [UIColor lightGrayColor];
        _speedLabel.layer.cornerRadius = 3;
        _speedLabel.clipsToBounds = YES;
    }
    return _speedLabel;
}


- (LiveMenuView *)menuView
{
    if (!_menuView)
    {
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.backgroundColor = [UIColor randomColor];
        [btn1 setTitle:@"翻转" forState:UIControlStateNormal];
        btn1.titleLabel.font = Font_sys_9;
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.backgroundColor = [UIColor randomColor];
        [btn2 setTitle:@"美颜" forState:UIControlStateNormal];
        btn2.titleLabel.font = Font_sys_9;
        
        self.cameraTurnSignal = [btn1 rac_signalForControlEvents:UIControlEventTouchUpInside];
        self.beautySignal = [btn2 rac_signalForControlEvents:UIControlEventTouchUpInside];
        _menuView = [[LiveMenuView alloc] initWithBtns:@[btn1,btn2]];
    }
    return _menuView;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
