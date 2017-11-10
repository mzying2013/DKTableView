//
//  DKBaseTableViewController.m
//  DKTableView
//
//  Created by bill on 2017/11/9.
//  Copyright © 2017年 bill. All rights reserved.
//

#import "DKBaseTableViewController.h"

@interface DKBaseTableViewController ()<DKTableViewPageDelegate>
@property (nonatomic,strong) UITableView * base_tableView;
@property (nonatomic,strong) DKEmptyDataSetImplement * base_emptyDataSetImp;
@property (nonatomic,strong) DKTableViewRefreshImplement * base_refreshImp;

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
        
        _base_tableView.dk_pageDelegate = self;
        _base_tableView.dk_refreshDelegate = self.base_refreshImp;
        
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


-(DKTableViewRefreshImplement *)base_refreshImp{
    if (!_base_refreshImp) {
        _base_refreshImp = [DKTableViewRefreshImplement new];
    }
    return _base_refreshImp;
}


-(DKEmptyDataSetImplement *)emptyDataSetImp{
    return self.base_emptyDataSetImp;
}


-(DKTableViewRefreshImplement *)refreshImp{
    return self.base_refreshImp;
}


-(UITableView *)tableView{
    return self.base_tableView;
}


#pragma mark - DKTableViewPageDelegate
-(NSInteger)dk_pageIndexInitialValue{
    return 0;
}


-(NSInteger)dk_pageCountValue{
    return 10;
}


-(void)dk_tableView:(UITableView *)tableView activeStatusDidUpdate:(DKActiveStatus)status{
    NSLog(@"did update active status:%ld",status);
}


@end
