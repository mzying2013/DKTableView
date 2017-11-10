//
//  DKTableViewRefreshImplement.m
//  DKTableView
//
//  Created by bill on 2017/11/9.
//  Copyright © 2017年 bill. All rights reserved.
//

#import "DKTableViewRefreshImplement.h"
#import "DKTableViewStyle.h"
#import "UITableView+DKPage.h"

@interface DKTableViewRefreshImplement(){
    __weak UITableView * weakTableView;
}

@end


@implementation DKTableViewRefreshImplement
#pragma mark - DKTableViewRefreshDelegate
-(MJRefreshHeader *)dk_headerRefresh:(UITableView *)tableView{
    weakTableView = tableView;
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                      refreshingAction:@selector(headerRefreshAction:)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    header.stateLabel.font = [DKTableViewStyle share].font;
    header.stateLabel.textColor = [DKTableViewStyle share].textColor;
    return header;
}


-(MJRefreshFooter *)dk_footerRefresh:(UITableView *)tableView{
    weakTableView = tableView;
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                                              refreshingAction:@selector(footerRefreshAction:)];
    [footer setTitle:@"正在加载更多" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    footer.stateLabel.font = [DKTableViewStyle share].font;
    footer.stateLabel.textColor = [DKTableViewStyle share].textColor;
    return footer;
}


-(void)headerRefreshAction:(MJRefreshHeader *)sender{
    weakTableView.dk_activeStatus = DKLoadingActiveStatus;
    [weakTableView reloadEmptyDataSet];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:headerRefreshAction:)]) {
        [self.delegate tableView:weakTableView headerRefreshAction:sender];
    }
}


-(void)footerRefreshAction:(MJRefreshFooter *)sender{
    weakTableView.dk_activeStatus = DKLoadingActiveStatus;
    [weakTableView reloadEmptyDataSet];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:footerRefreshAction:)]) {
        [self.delegate tableView:weakTableView footerRefreshAction:sender];
    }
}


@end
