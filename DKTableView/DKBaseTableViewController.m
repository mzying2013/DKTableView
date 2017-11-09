//
//  DKBaseTableViewController.m
//  DKTableView
//
//  Created by bill on 2017/11/9.
//  Copyright © 2017年 bill. All rights reserved.
//

#import "DKBaseTableViewController.h"

@interface DKBaseTableViewController ()<DKTableViewDelegate>
@property (nonatomic,strong) UITableView * base_tableView;
@property (nonatomic,strong) DKEmptyDataSetImplement * base_emptyDataSetImp;

@end

@implementation DKBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Property Method
-(UITableView *)base_tableView{
    if (!_base_tableView) {
        _base_tableView = [[UITableView alloc] init];
        
        _base_tableView.dk_delegate = self;
        _base_tableView.dk_enableHeaderRefresh = YES;
        _base_tableView.dk_enableFooterRefresh = YES;
        
        _base_tableView.emptyDataSetSource = self.base_emptyDataSetImp;
        _base_tableView.emptyDataSetDelegate = self.base_emptyDataSetImp;
        
        _base_tableView.estimatedRowHeight = 0;
        _base_tableView.estimatedSectionHeaderHeight = 0;
        _base_tableView.estimatedSectionFooterHeight = 0;
        _base_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIColor * color = [UIColor colorWithRed:246/255.0 green:247/255.0 blue:248/255.0 alpha:1];
        _base_tableView.backgroundColor = color;
    }
    return _base_tableView;
}


-(DKEmptyDataSetImplement *)base_emptyDataSetImp{
    if (!_base_emptyDataSetImp) {
        _base_emptyDataSetImp = [DKEmptyDataSetImplement new];
    }
    return _base_emptyDataSetImp;
}


-(DKEmptyDataSetImplement *)emptyDataSetImp{
    return self.base_emptyDataSetImp;
}


-(UITableView *)tableView{
    return self.base_tableView;
}


#pragma mark - DKTableViewDelegate
-(MJRefreshHeader *)dk_headerRefresh:(UITableView *)tableView{
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                      refreshingAction:@selector(headerRefreshAction)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    return header;
}


-(MJRefreshFooter *)dk_footerRefresh:(UITableView *)tableView{
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                                              refreshingAction:@selector(footerRefreshAction)];
    [footer setTitle:@"正在加载更多" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    return footer;
}


-(NSInteger)dk_pageIndexInitialValue{
    return 0;
}


-(NSInteger)dk_pageCountValue{
    return 10;
}


#pragma mark - Public Method
-(void)headerRefreshAction{
    
}


-(void)footerRefreshAction{
    
}




@end
