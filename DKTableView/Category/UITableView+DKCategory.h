//
//  UITableView+DKCategory.h
//  DKTableView
//
//  Created by bill on 2017/11/6.
//  Copyright © 2017年 bill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+DKActiveStatus.h"
@protocol DKTableViewDelegate;

@interface UITableView (DKCategory)
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
@property (nonatomic,weak) id<DKTableViewDelegate> dk_delegate;


/**
 是否启用下拉刷新，默认值NO
 */
@property (nonatomic,assign) BOOL dk_enableHeaderRefresh;


/**
 是否启用上拉刷新，默认值NO
 */
@property (nonatomic,assign) BOOL dk_enableFooterRefresh;




@end
