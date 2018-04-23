//
//  LiveMenuView.m
//  BXHLiveVedio
//
//  Created by 步晓虎 on 2017/8/30.
//  Copyright © 2017年 步晓虎. All rights reserved.
//

#import "LiveMenuView.h"

#define MenuWidth 30.0

@interface LiveMenuView()

@property (nonatomic, strong) UIButton *arrowBtn;

@property (nonatomic, strong) NSArray *btns;

@end

@implementation LiveMenuView

- (instancetype)initWithBtns:(NSArray *)btns
{
    if (self = [super init])
    {
        self.clipsToBounds = YES;
        self.btns = [NSArray arrayWithArray:btns];
        [self addSubview:self.arrowBtn];
        
        [self layoutBtnWithBtns:btns];
    }
    return self;
}

- (void)layoutBtnWithBtns:(NSArray *)btns
{
    UIButton *topBtn = nil;
    NSInteger index = 0;
    for (UIButton *btn in btns)
    {
        [self addSubview:btn];
        if (topBtn)
        {
            btn.sd_layout.leftSpaceToView(topBtn, 0);
        }
        else
        {
            btn.sd_layout.leftEqualToView(self);
        }
        btn.sd_layout.widthIs(MenuWidth);
        btn.sd_layout.topEqualToView(self);
        btn.sd_layout.bottomEqualToView(self);
        if (index == btns.count - 1)
        {
            self.arrowBtn.sd_layout.leftSpaceToView(btn, 0);
            self.arrowBtn.sd_layout.topEqualToView(self);
            self.arrowBtn.sd_layout.bottomEqualToView(self);
            self.arrowBtn.sd_layout.widthIs(MenuWidth);
        }
        topBtn = btn;
        index++;
    }
}

#pragma mark - action
- (void)arrowAction
{
    self.arrowBtn.selected = !self.arrowBtn.selected;
    if(self.arrowBtn.selected)
    {
        UIButton *topBtn = [self.btns firstObject];
        [UIView animateWithDuration:0.3 animations:^{
            CGFloat offset = -(self.btns.count * MenuWidth);
            topBtn.sd_layout.leftEqualToView(self).offset(offset);
            [topBtn updateLayout];
        }];
    }
    else
    {
        UIButton *topBtn = [self.btns firstObject];
        [UIView animateWithDuration:0.3 animations:^{
            topBtn.sd_layout.leftEqualToView(self);
            [topBtn updateLayout];
        }];
    }
}

#pragma mark - lazyLoade
- (UIButton *)arrowBtn
{
    if (!_arrowBtn)
    {
        _arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _arrowBtn.backgroundColor = [UIColor randomColor];
        [_arrowBtn addTarget:self action:@selector(arrowAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _arrowBtn;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
