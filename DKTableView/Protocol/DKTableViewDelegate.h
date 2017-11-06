//
//  DKTableViewDelegate.h
//  DKTableView
//
//  Created by bill on 2017/11/6.
//  Copyright © 2017年 bill. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DKTableViewDelegate <NSObject>


@optional
/**
 分页初始值，默认0
 */
-(void)dk_pageIndexInitialValue;


/**
 每页的数量，默认10
 */
-(void)dk_pageCountValue;


/**
 header刷新回调方法
 */
-(void)dk_headerRefreshAction:(UITableView *)tableView;


/**
 footer刷新回调方法
 */
-(void)dk_footerRefreshAction:(UITableView *)tableView;


@end
