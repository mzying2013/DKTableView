//
//  UITableView+DKCategory.m
//  DKTableView
//
//  Created by bill on 2017/11/6.
//  Copyright © 2017年 bill. All rights reserved.
//

#import "UITableView+DKCategory.h"
#import "DKWeakObjectContainer.h"
#import "DKTableViewDelegate.h"
#import <objc/runtime.h>



static const void * kWeakObjectContainerKey = &kWeakObjectContainerKey;
static const void * kActiveStatusKey = &kActiveStatusKey;
static const void * kPageIndexKey = &kPageIndexKey;
static const void * kTotalCountKey = &kTotalCountKey;



@implementation UITableView (DKCategory)

#pragma mark - Private Property Method
-(NSInteger)private_dk_pageIndex{
    NSNumber * index = objc_getAssociatedObject(self, kPageIndexKey);
    return [index integerValue];
}


-(void)setPrivate_dk_pageIndex:(NSInteger)private_dk_pageIndex{
    NSNumber * index = [NSNumber numberWithInteger:private_dk_pageIndex];
    objc_setAssociatedObject(self, kPageIndexKey, index, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



/**
 私有方法，返回存储的cell数量

 @return cell数量
 */
-(NSInteger)private_dk_totalCount{
    NSNumber * totalCount = objc_getAssociatedObject(self, kTotalCountKey);
    return [totalCount integerValue];
}


/**
 私有方法，存储cell的数量

 @param private_dk_totalCount cell的数量
 */
-(void)setPrivate_dk_totalCount:(NSInteger)private_dk_totalCount{
    NSNumber * totalCount = [NSNumber numberWithInteger:private_dk_totalCount];
    objc_setAssociatedObject(self, kTotalCountKey, totalCount, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Public Property Method
- (id<DKTableViewDelegate>)dk_delegate{
    DKWeakObjectContainer *container = objc_getAssociatedObject(self,kWeakObjectContainerKey);
    return container.weakObject;
}


-(void)setDk_delegate:(id<DKTableViewDelegate>)dk_delegate{
    id weakObjectContainer = [[DKWeakObjectContainer alloc] initWithWeakObject:dk_delegate];
    objc_setAssociatedObject(self,
                             kWeakObjectContainerKey,
                             weakObjectContainer,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(DKActiveStatus)dk_activeStatus{
    NSNumber * status = objc_getAssociatedObject(self, kActiveStatusKey);
    return [status integerValue];
}

-(void)setDk_activeStatus:(DKActiveStatus)dk_activeStatus{
    if (self.dk_delegate && [self.dk_delegate respondsToSelector:@selector(dk_activeStatusDidUpdate:)]) {
        [self.dk_delegate dk_activeStatusDidUpdate:self];
    }
    
    NSNumber * status = [NSNumber numberWithInteger:dk_activeStatus];
    objc_setAssociatedObject(self, kActiveStatusKey, status, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(NSInteger)dk_pageIndex{
    return [self private_dk_pageIndex];
}

-(BOOL)dk_enableHeaderRefresh{
    if (self.mj_header) {
        return YES;
    }else{
        return NO;
    }
}


-(void)setDk_enableHeaderRefresh:(BOOL)dk_enableHeaderRefresh{
    if (dk_enableHeaderRefresh) {
        if (!self.mj_header) {
            if (self.dk_delegate && [self.dk_delegate respondsToSelector:@selector(dk_headerRefresh:)]) {
                [self.dk_delegate dk_headerRefresh:self];
            }
        }
    }else{
        if (self.mj_header) {
            self.mj_header = nil;
        }
    }
}


-(BOOL)dk_enableFooterRefresh{
    if (self.mj_footer) {
        return YES;
    }else{
        return NO;
    }
}


-(void)setDk_enableFooterRefresh:(BOOL)dk_enableFooterRefresh{
    if (dk_enableFooterRefresh) {
        if (!self.mj_footer) {
            if (self.dk_delegate && [self.dk_delegate respondsToSelector:@selector(dk_footerRefresh:)]) {
                self.mj_footer = [self.dk_delegate dk_footerRefresh:self];
            }
        }
    }else{
        if (self.mj_footer) {
            self.mj_footer = nil;
        }
    }
}



#pragma mark - Private Method
-(void)private_dk_activeStatusHandler:(DKActiveStatus)status{
    if (status == DKInitLodingActiveStatus) {
        [self setPrivate_dk_totalCount:[self private_dk_currentTotalCount]];
        
    }else if(status == DKHeaderRefreshActiveStatus){
        //重置分页索引
        [self setPrivate_dk_pageIndex:[self private_dk_pageIndexInitialValue]];
        [self setPrivate_dk_totalCount:[self private_dk_currentTotalCount]];
        
    }else if(status == DKFooterRefreshActiveStatus){
        
        
    }else if(status == DKEmptyActiveStatus){
        if ([self headerIsRefreshing]) {
            [self.mj_header endRefreshing];
            self.mj_header.hidden = YES;
            self.mj_footer.hidden = YES;
            
        }else if([self footerIsRefreshing]){
            [self.mj_footer endRefreshingWithNoMoreData];
        }
        
    }else if(status == DKErrorActiveStatus){
        if (self.mj_header && [self.mj_header isRefreshing]) {
            [self.mj_header endRefreshing];
            self.mj_header.hidden = YES;
            self.mj_footer.hidden = YES;
            
        }else if(self.mj_footer && [self.mj_footer isRefreshing]){
            [self.mj_footer endRefreshingWithNoMoreData];
        }
        
    }else if(status == DKSuccessActiveStatus){
        if ([self private_dk_currentTotalCount] < [self private_dk_pageCountValue]) {
            //No More
            [self.mj_footer endRefreshingWithNoMoreData];
        }else{
            //Have More
            [self.mj_footer endRefreshing];
        }
    }
}


/**
 私有方法，当前tableView cell的数量

 @return cell的数量
 */
-(NSInteger)private_dk_currentTotalCount{
    NSInteger totalCount = 0;
    for (NSInteger section = 0; section<self.numberOfSections; section++) {
        totalCount += [self numberOfRowsInSection:section];
    }
    return totalCount;
}


/**
 私有方法，分页索引初始值

 @return 索引初始值
 */
-(NSInteger)private_dk_pageIndexInitialValue{
    if (self.dk_delegate && [self.dk_delegate respondsToSelector:@selector(dk_pageIndexInitialValue)]) {
        return [self.dk_delegate dk_pageIndexInitialValue];
    }
    return 0;
}


-(NSInteger)private_dk_pageCountValue{
    if (self.dk_delegate && [self.dk_delegate respondsToSelector:@selector(dk_pageCountValue)]) {
        [self.dk_delegate dk_pageCountValue];
    }
}


-(void)endHeaderFooterRefreshing{
    if (self.mj_header && [self.mj_header isRefreshing]) {
        [self.mj_header endRefreshing];
    }
    
    if (self.mj_footer && [self.mj_footer isRefreshing]) {
        [self.mj_footer endRefreshing];
    }
}


-(BOOL)headerIsRefreshing{
    if (self.mj_header && [self.mj_header isRefreshing]) {
        return YES;
    }
    return NO;
}


-(BOOL)footerIsRefreshing{
    if (self.mj_footer && [self.mj_footer isRefreshing]) {
        return YES;
    }
    return NO;
}
    




@end
