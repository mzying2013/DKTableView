//
//  DKBaseTableViewController.h
//  DKTableView
//
//  Created by bill on 2017/11/9.
//  Copyright © 2017年 bill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKTableViewHeader.h"

@interface DKBaseTableViewController : UIViewController
@property (nonatomic,strong,readonly) DKEmptyDataSetImplement * emptyDataSetImp;
@property (nonatomic,strong,readonly) UITableView * tableView;

/**
 触发header刷新，子类覆盖
 */
-(void)headerRefreshAction;

/**
 触发footer刷新，子类覆盖
 */
-(void)footerRefreshAction;

@end
