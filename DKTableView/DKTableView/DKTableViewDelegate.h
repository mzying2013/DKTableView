//
//  DKTableViewDelegate.h
//  DKTableView
//
//  Created by bill on 2017/11/10.
//  Copyright © 2017年 bill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJRefresh/MJRefresh.h>


/**
 TableView的状态

 - DKDefaultActiveStatus: 默认状态
 - DKLoadingActiveStatus: 加载中的状态（包括点击加载，header footer加载）
 - DKSuccessActiveStatus: 加载成功
 - DKErrorActiveStatus: 加载失败
 */
typedef NS_ENUM(NSInteger,DKActiveStatus){
    DKDefaultActiveStatus = 0,
    DKLoadingActiveStatus,
    DKSuccessActiveStatus,
    DKErrorActiveStatus
};



@protocol  DKTableViewRefreshDelegate<NSObject>
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



@protocol DKTableViewPageDelegate<NSObject>
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



@end
