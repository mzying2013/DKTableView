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
@property (nonatomic,strong,readonly) DKTableViewRefreshImplement * refreshImp;
@property (nonatomic,strong,readonly) UITableView * tableView;


@end
