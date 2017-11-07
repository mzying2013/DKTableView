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
@import DZNEmptyDataSet;
@import MBProgressHUD;


static NSString * const kCellID = @"kCellID";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,DKTableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>{
    NSArray * _status;
    NSInteger _currentStatusIndex;
    NSArray * _statusText;
}
@property (nonatomic,strong) UITableView * dkTableView;
@property (nonatomic,strong) NSArray<NSDictionary *> * dataSouces;

@end

@implementation ViewController


-(instancetype)init{
    self = [super init];
    
    if (self) {
        _status = @[@(DKDefaultActiveStatus),@(DKInitLodingActiveStatus)
                    ,@(DKEmptyActiveStatus),@(DKErrorActiveStatus)];
        _statusText = @[@"DKDefaultActiveStatus",@"DKInitLodingActiveStatus",
                        @"DKEmptyActiveStatus",@"DKErrorActiveStatus"];
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
    self.dkTableView.emptyDataSetSource = self;
    self.dkTableView.emptyDataSetDelegate = self;
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
    
    
//    self.dkTableView.dk_activeStatus = DKInitLodingActiveStatus;
//    [self request];
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
    return 0;
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


#pragma mark - DZNEmptyDataSetSource
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    if (self.dkTableView.dk_activeStatus == DKErrorActiveStatus) {
        return [UIImage imageNamed:@"common_404"];
    }else{
        return [UIImage imageNamed:@"no_data"];
    }
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = nil;
    if (self.dkTableView.dk_activeStatus == DKErrorActiveStatus) {
        text = @"点击重新加载";
    }else{
        text = @"暂无数据";
    }
    UIColor *textColor = [UIColor colorWithRed:125/255.0 green:127/255.0 blue:127/255.0 alpha:1.0];
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    paragraph.lineSpacing = 2.0;
    
    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    [attributes setObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
    
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}


- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    if (self.dkTableView.dk_activeStatus == DKInitLodingActiveStatus) {
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:scrollView animated:YES];
        hud.label.text = @"Loading...";
        hud.bezelView.color = [UIColor whiteColor];
        return hud;
    }else{
        [MBProgressHUD hideHUDForView:scrollView animated:YES];
        return nil;
    }
}


#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    if (self.dkTableView.dk_activeStatus == DKDefaultActiveStatus) {
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    NSLog(@"did tap view..............");
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


-(void)dk_activeStatusDidUpdate:(UITableView *)tableView{
    self.navigationItem.title = _statusText[_currentStatusIndex];
}



#pragma mark - UIControl Action
-(void)rightBtnItemAction{
    if(_currentStatusIndex + 1 == _status.count){
        _currentStatusIndex = 0;
    }else{
        _currentStatusIndex += 1;
    }
    self.dkTableView.dk_activeStatus = [_status[_currentStatusIndex] integerValue];
    [self.dkTableView reloadEmptyDataSet];
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
