//
//  ViewController.m
//  DKTableView
//
//  Created by bill on 2017/11/6.
//  Copyright © 2017年 bill. All rights reserved.
//

#import "ViewController.h"
#import "DKNetwork.h"

@import Masonry;
@import DZNEmptyDataSet;
@import MBProgressHUD;


static NSString * const kCellID = @"kCellID";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,DKEmptyDataSetDelegate>{
    NSInteger _currentStatusIndex;
    NSArray * _statusText;
}
@property (nonatomic,strong) NSArray<NSDictionary *> * dkDataSouces;

@end

@implementation ViewController


-(instancetype)init{
    self = [super init];
    
    if (self) {
        _statusText = @[@"DKDefaultActiveStatus",@"DKLoadingActiveStatus",
                        @"DKSuccessActiveStatus",@"DKErrorActiveStatus"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.dk_enableHeaderRefresh = YES;
    self.tableView.dk_enableFooterRefresh = YES;
    self.emptyDataSetImp.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellID];
    
    [self.view addSubview:self.tableView];
    __weak typeof(self) weakOfSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakOfSelf.view);
    }];
    
    self.navigationItem.title = _statusText[self.tableView.dk_activeStatus];
    
    self.tableView.dk_activeStatus = DKLoadingActiveStatus;
    [self performSelector:@selector(dkRequest) withObject:nil afterDelay:2];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Property Method
-(NSArray<NSDictionary *> *)dkDataSouces{
    if (!_dkDataSouces) {
        _dkDataSouces = [NSArray array];
    }
    return _dkDataSouces;
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dkDataSouces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSString * name = self.dkDataSouces[indexPath.row][@"title"];
    NSString * text = [NSString stringWithFormat:@"%ld.%@",(long)indexPath.row + 1,name];
    cell.textLabel.text = text;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


#pragma mark - DKEmptyDataSetDelegate
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        UITableView * tableView = (UITableView *)scrollView;
        tableView.dk_activeStatus = DKLoadingActiveStatus;
        [tableView reloadEmptyDataSet];
        [self performSelector:@selector(dkRequest) withObject:nil afterDelay:2];
    }
}


#pragma mark - DKTableViewDelegate
//-(void)dk_tableView:(UITableView *)tableView activeStatusDidUpdate:(DKActiveStatus)status{
//    self.navigationItem.title = _statusText[status];
//}



#pragma mark - Refresh Action
-(void)headerRefreshAction{
    [super headerRefreshAction];
    self.tableView.dk_activeStatus = DKLoadingActiveStatus;
    [self.tableView reloadEmptyDataSet];
    [self performSelector:@selector(dkRequest) withObject:nil afterDelay:2];
}

-(void)footerRefreshAction{
    [super footerRefreshAction];
    self.tableView.dk_activeStatus = DKLoadingActiveStatus;
    [self.tableView reloadEmptyDataSet];
    [self performSelector:@selector(dkRequest) withObject:nil afterDelay:2];
}


#pragma mark - Request Method
-(void)dkRequest{
    __weak typeof(self) weakOfSelf = self;
    
    [[DKNetwork share] top250:self.tableView.dk_pageIndex count:10 completed:^(NSArray *subjects) {
        if (!subjects) {
            weakOfSelf.tableView.dk_activeStatus = DKErrorActiveStatus;
            [weakOfSelf.tableView reloadData];
            return;
        }
        
        if (subjects.count == 0) {
            weakOfSelf.tableView.dk_activeStatus = DKSuccessActiveStatus;
            [weakOfSelf.tableView reloadData];
            return;
        }
        
        if ([weakOfSelf.tableView.mj_header isRefreshing]) {
            weakOfSelf.dkDataSouces = subjects;
        }else{
            NSMutableArray * _tempMArray = [NSMutableArray arrayWithArray:weakOfSelf.dkDataSouces];
            [_tempMArray addObjectsFromArray:subjects];
            weakOfSelf.dkDataSouces = [_tempMArray copy];
        }
        
        weakOfSelf.tableView.dk_activeStatus = DKSuccessActiveStatus;
        [weakOfSelf.tableView reloadData];
    }];
}





@end
