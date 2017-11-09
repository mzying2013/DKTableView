//
//  UITableView+DKCategory.h
//  DKTableView
//
//  Created by bill on 2017/11/6.
//  Copyright © 2017年 bill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>
@protocol DKTableViewDelegate;


typedef NS_ENUM(NSInteger,DKActiveStatus){
    DKDefaultActiveStatus = 0,
    DKLoadingActiveStatus,
    DKSuccessActiveStatus,
    DKErrorActiveStatus    
};






@protocol DKTableViewDelegate <NSObject>


@optional
/**
 分页初始值，默认0
 */
-(NSInteger)dk_pageIndexInitialValue;


/**
 每页的数量，默认10
 */
-(NSInteger)dk_pageCountValue;


/**
 dk_activeStatus的更新
 
 @param tableView 当前的tableView
 */
-(void)dk_tableView:(UITableView *)tableView activeStatusDidUpdate:(DKActiveStatus)status;


/**
 header刷新组件
 
 @param tableView 当前的tableView
 @return header刷新组件
 */
-(MJRefreshHeader *)dk_headerRefresh:(UITableView *)tableView;


/**
 footer刷新组件
 
 @param tableView 当前的tableView
 @return footer刷新组件
 */
-(MJRefreshFooter *)dk_footerRefresh:(UITableView *)tableView;




@end















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


/**
 是否是初始化加载
 */
@property (nonatomic,assign,readonly) BOOL dk_isInitLoading;




@end
