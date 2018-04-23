//
//  UITableView+BXHMyTableView.h
//  ECar
//
//  Created by 步晓虎 on 14-12-22.
//  Copyright (c) 2014年 步晓虎. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (BXHMyTableView)

- (void)addRefreshNoWordTarget:(id)target action:(SEL)downAction;

- (void)addRefreshTarget:(id)target downAction:(SEL)downAction;

// 添加 上拉加载 下拉刷新
- (void)addRefreshTarget:(id)target upAction:(SEL)upAction downAction:(SEL)downAction;

// 结束刷新
- (void)endRefresh;
//
- (void)configDataIsEnd:(BOOL)isEnd;

@end
