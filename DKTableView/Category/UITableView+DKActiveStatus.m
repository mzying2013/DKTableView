//
//  UITableView+DKActiveStatus.m
//  DKTableView
//
//  Created by bill on 2017/11/7.
//  Copyright © 2017年 bill. All rights reserved.
//

#import "UITableView+DKActiveStatus.h"
#import <objc/runtime.h>
#import <MJRefresh/MJRefresh.h>

static const void * kTotalCountKey = &kTotalCountKey;

@implementation UITableView (DKActiveStatus)

-(void)dk_activeStatusHandler:(DKActiveStatus)status{
    //for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
//    totalCount += [tableView numberOfRowsInSection:section];
    
    //mj_reloadDataBlock
    
    if (status == DKInitLodingActiveStatus) {
        [self setDk_totalCount:[self dk_currentTotalCount]];
        
    }else if(status == DKHeaderRefreshActiveStatus){
        
    }
    
    if (status == DKInitLodingActiveStatus ||
        status == DKHeaderRefreshActiveStatus ||
        status == DKFooterRefreshActiveStatus) {
        [self setDk_totalCount:[self dk_currentTotalCount]];
        
    }else if(status == DKEmptyActiveStatus){
        [self endHeaderFooterRefreshing];
        
    }else if(status == DKErrorActiveStatus){
        [self endHeaderFooterRefreshing];
        
        if ([self dk_totalCount] <= 0) {
            //显示错误信息
        }
    }
}


#pragma mark - Private Property Method
-(NSInteger)dk_totalCount{
    NSNumber * totalCount = objc_getAssociatedObject(self, kTotalCountKey);
    return [totalCount integerValue];
}


-(void)setDk_totalCount:(NSInteger)dk_totalCount{
    NSNumber * totalCount = [NSNumber numberWithInteger:dk_totalCount];
    objc_setAssociatedObject(self, kTotalCountKey, totalCount, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Private Method
-(NSInteger)dk_currentTotalCount{
    NSInteger totalCount = 0;
    for (NSInteger section = 0; section<self.numberOfSections; section++) {
            totalCount += [self numberOfRowsInSection:section];
    }
    return totalCount;
}


-(void)endHeaderFooterRefreshing{
    if (self.mj_header && [self.mj_header isRefreshing]) {
        [self.mj_header endRefreshing];
    }
    
    if (self.mj_footer && [self.mj_footer isRefreshing]) {
        [self.mj_footer endRefreshing];
    }
}




@end
