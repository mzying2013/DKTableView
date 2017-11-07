//
//  DKTableViewDelegate.h
//  DKTableView
//
//  Created by bill on 2017/11/6.
//  Copyright © 2017年 bill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJRefresh/MJRefresh.h>

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
 header刷新回调方法
 */
-(void)dk_headerRefreshAction:(UITableView *)tableView;


/**
 footer刷新回调方法
 */
-(void)dk_footerRefreshAction:(UITableView *)tableView;



/**
 dk_activeStatus的更新

 @param tableView 当前的tableView
 */
-(void)dk_activeStatusDidUpdate:(UITableView *)tableView;


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
