//
//  ViewController.m
//  DKTableView
//
//  Created by bill on 2017/11/6.
//  Copyright © 2017年 bill. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+DKPage.h"
#import "DKNetwork.h"
#import "DKEmptyDataSetImplement.h"


@import Masonry;
@import DZNEmptyDataSet;
@import MBProgressHUD;


static NSString * const kCellID = @"kCellID";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,DKTableViewDelegate,DKEmptyDataSetDelegate>{
    NSInteger _currentStatusIndex;
    NSArray * _statusText;
}
@property (nonatomic,strong) UITableView * dkTableView;
@property (nonatomic,strong) NSArray<NSDictionary *> * dkDataSouces;
@property (nonatomic,weak) MBProgressHUD * base_loadingHUD;
@property (nonatomic,strong)DKEmptyDataSetImplement * base_emptyDataSetImp;

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
    self.dkTableView = [[UITableView alloc] init];
    self.dkTableView.delegate = self;
    self.dkTableView.dataSource = self;
    
    self.dkTableView.dk_delegate = self;
    self.dkTableView.dk_enableHeaderRefresh = YES;
    self.dkTableView.dk_enableFooterRefresh = YES;
    
    self.dkTableView.emptyDataSetSource = self.base_emptyDataSetImp;
    self.dkTableView.emptyDataSetDelegate = self.base_emptyDataSetImp;
    
    self.dkTableView.estimatedRowHeight = 0;
    self.dkTableView.estimatedSectionHeaderHeight = 0;
    self.dkTableView.estimatedSectionFooterHeight = 0;
    
    self.dkTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.dkTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellID];
    
    [self.view addSubview:self.dkTableView];
    
    __weak typeof(self) weakOfSelf = self;
    
    UIBarButtonItem * rightBtnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_switch"]
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(rightBtnItemAction)];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    [self.dkTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakOfSelf.view);
    }];
    
    self.navigationItem.title = _statusText[self.dkTableView.dk_activeStatus];
    
    self.dkTableView.dk_activeStatus = DKLoadingActiveStatus;
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



-(DKEmptyDataSetImplement *)base_emptyDataSetImp{
    if (!_base_emptyDataSetImp) {
        _base_emptyDataSetImp = [DKEmptyDataSetImplement new];
        _base_emptyDataSetImp.delegate = self;
    }
    return _base_emptyDataSetImp;
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

-(void)dk_tableView:(UITableView *)tableView activeStatusDidUpdate:(DKActiveStatus)status{
    self.navigationItem.title = _statusText[status];
}



#pragma mark - UIControl Action
-(void)rightBtnItemAction{
//    if(_currentStatusIndex + 1 == _status.count){
//        _currentStatusIndex = 0;
//    }else{
//        _currentStatusIndex += 1;
//    }
//    self.dkTableView.dk_activeStatus = [_status[_currentStatusIndex] integerValue];
//    [self.dkTableView reloadEmptyDataSet];
    
}


#pragma mark - Refresh Action
-(void)headerRefreshAction{
    self.dkTableView.dk_activeStatus = DKLoadingActiveStatus;
    [self.dkTableView reloadEmptyDataSet];
    [self performSelector:@selector(dkRequest) withObject:nil afterDelay:2];
}

-(void)footerRefreshAction{
    self.dkTableView.dk_activeStatus = DKLoadingActiveStatus;
    [self.dkTableView reloadEmptyDataSet];
    [self performSelector:@selector(dkRequest) withObject:nil afterDelay:2];
}


#pragma mark - Request Method
-(void)dkRequest{
    __weak typeof(self) weakOfSelf = self;
    
    [[DKNetwork share] top250:self.dkTableView.dk_pageIndex count:10 completed:^(NSArray *subjects) {
        if ([weakOfSelf.dkTableView.mj_footer isRefreshing] || !subjects) {
            weakOfSelf.dkTableView.dk_activeStatus = DKErrorActiveStatus;
            [weakOfSelf.dkTableView reloadData];
            return;
        }
        
        if (subjects.count == 0) {
            weakOfSelf.dkTableView.dk_activeStatus = DKSuccessActiveStatus;
            [weakOfSelf.dkTableView reloadData];
            return;
        }
        
        if ([weakOfSelf.dkTableView.mj_header isRefreshing]) {
            weakOfSelf.dkDataSouces = subjects;
        }else{
            NSMutableArray * _tempMArray = [NSMutableArray arrayWithArray:weakOfSelf.dkDataSouces];
            [_tempMArray addObjectsFromArray:subjects];
            weakOfSelf.dkDataSouces = [_tempMArray copy];
        }
        
        weakOfSelf.dkTableView.dk_activeStatus = DKSuccessActiveStatus;
        [weakOfSelf.dkTableView reloadData];
    }];
}





@end
