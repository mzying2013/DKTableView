//
//  DKTableViewRefreshImplement.h
//  DKTableView
//
//  Created by bill on 2017/11/9.
//  Copyright © 2017年 bill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UITableView+DKPage.h"


@protocol DKTableViewRefreshActionDelegate<NSObject>
-(void)tableView:(UITableView *)tableView headerRefreshAction:(MJRefreshHeader *)header;
-(void)tableView:(UITableView *)tableView footerRefreshAction:(MJRefreshFooter *)footer;

@end

@interface DKTableViewRefreshImplement : NSObject<DKTableViewRefreshDelegate>
@property (nonatomic,weak)id<DKTableViewRefreshActionDelegate> delegate;

@end
