//
//  ViewController.m
//  DKTableView
//
//  Created by bill on 2017/11/6.
//  Copyright © 2017年 bill. All rights reserved.
//

#import "ViewController.h"
#import "DKTableViewHeader.h"
#import "DKNetwork.h"
@import Masonry;


static NSString * const kCellID = @"kCellID";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,DKTableViewDelegate>
@property (nonatomic,strong) UITableView * dkTableView;
@property (nonatomic,strong) NSArray<NSDictionary *> * dataSouces;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"DKTableView";
    
    self.dkTableView = [[UITableView alloc] init];
    self.dkTableView.delegate = self;
    self.dkTableView.dataSource = self;
    self.dkTableView.dk_delegate = self;
    [self.dkTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellID];
    
    [self.view addSubview:self.dkTableView];
    
    __weak typeof(self) weakOfSelf = self;
    
    [self.dkTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakOfSelf.view);
    }];
    
    self.dkTableView.dk_activeStatus = DKInitLodingActiveStatus;
    [self request];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Property Method
-(NSArray<NSDictionary *> *)dataSouces{
    if (!_dataSouces) {
        _dataSouces = [NSArray array];
    }
    return _dataSouces;
}



#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSString * text = [NSString stringWithFormat:@"%ld",(long)indexPath.row + 1];
    cell.textLabel.text = text;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


#pragma mark - DKTableViewDelegate
-(MJRefreshHeader *)dk_headerRefresh:(UITableView *)tableView{
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                      refreshingAction:@selector(headerRefreshAction)];
    return header;
}


-(MJRefreshFooter *)dk_footerRefresh:(UITableView *)tableView{
    MJRefreshAutoFooter * footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self
                                                                  refreshingAction:@selector(footerRefreshAction)];
    return footer;
}


-(NSInteger)dk_pageIndexInitialValue{
    return 0;
}


-(NSInteger)dk_pageCountValue{
    return 10;
}


#pragma mark - Refresh Action
-(void)headerRefreshAction{
    
}

-(void)footerRefreshAction{
    
}


#pragma mark - Request Method
-(void)request{
    [[DKNetwork share] top250:self.dkTableView.dk_pageIndex count:10 completed:^(NSArray *subjects) {
        
    }];
}





@end
