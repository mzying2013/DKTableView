//
//  UITableView+DKPage.h
//  DKTableView
//
//  Created by bill on 2017/11/9.
//  Copyright © 2017年 bill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKTableViewDelegate.h"


@interface UITableView (DKPage)
/**
 活跃状态，默认为DKDefaultActiveStatus
 */
@property (nonatomic,assign) DKActiveStatus dk_activeStatus;

/**
 当前页码
 */
@property (nonatomic,assign,readonly) NSInteger dk_pageIndex;


/**
 Delegat回调
 */
@property (nonatomic,weak) id<DKTableViewPageDelegate> dk_pageDelegate;
@property (nonatomic,weak) id<DKTableViewRefreshDelegate> dk_refreshDelegate;


/**
 是否启用下拉刷新，默认值NO
 */
@property (nonatomic,assign) BOOL dk_enableHeaderRefresh;


/**
 是否启用上拉刷新，默认值NO
 */
@property (nonatomic,assign) BOOL dk_enableFooterRefresh;


/**
 是否是初始化加载
 */
@property (nonatomic,assign,readonly) BOOL dk_isInitLoading;


@end
