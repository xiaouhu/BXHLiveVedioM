//
//  UITableView+BXHMyTableView.m
//  ECar
//
//  Created by 步晓虎 on 14-12-22.
//  Copyright (c) 2014年 步晓虎. All rights reserved.
//

#import "UITableView+BXHMyTableView.h"
#import "MJRefresh.h"
const char separatorStyleChar;

@implementation UITableView (BXHMyTableView)

- (void)addRefreshNoWordTarget:(id)target action:(SEL)downAction
{
    MJRefreshNormalHeader * header =[MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:downAction];
    header.arrowView.image = nil;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.mj_header = header;
}
- (void)addRefreshTarget:(id)target downAction:(SEL)downAction
{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:downAction];
}

- (void)addRefreshTarget:(id)target upAction:(SEL)upAction downAction:(SEL)downAction
{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:downAction];
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:upAction];
}

- (void)endRefresh
{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

- (void)configDataIsEnd:(BOOL)isEnd
{
    if (isEnd) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }else {
        [self.mj_footer resetNoMoreData];
    }
}

@end
