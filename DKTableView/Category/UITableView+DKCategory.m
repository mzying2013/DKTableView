//
//  UITableView+DKCategory.m
//  DKTableView
//
//  Created by bill on 2017/11/6.
//  Copyright © 2017年 bill. All rights reserved.
//

#import "UITableView+DKCategory.h"
#import "DKWeakObjectContainer.h"
#import <objc/runtime.h>



static const void * kWeakObjectContainerKey = &kWeakObjectContainerKey;
static const void * kActiveStatusKey = &kActiveStatusKey;
static const void * kPageIndexKey = &kPageIndexKey;
static const void * kTotalCountKey = &kTotalCountKey;



@implementation UITableView (DKCategory)

#pragma mark - Private Property Method
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
    NSNumber * status = [NSNumber numberWithInteger:dk_activeStatus];
    objc_setAssociatedObject(self, kActiveStatusKey, status, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self private_dk_activeStatusHandler:dk_activeStatus];
    
    if (self.dk_delegate && [self.dk_delegate respondsToSelector:@selector(dk_tableView:activeStatusDidUpdate:)]) {
        [self.dk_delegate dk_tableView:self activeStatusDidUpdate:self.dk_activeStatus];
    }
}


-(NSInteger)dk_pageIndex{
    if (self.dk_activeStatus == DKLoadingActiveStatus) {
        if (![self footerIsRefreshing]) {
            return [self private_dk_pageIndexInitialValue];
        }
    }
    
    NSInteger index = [self private_dk_currentTotalCount] / [self private_dk_pageCountValue];
    return index + [self private_dk_pageIndexInitialValue];
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
                self.mj_header = [self.dk_delegate dk_headerRefresh:self];
                self.mj_header.hidden = YES;
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
                self.mj_footer.hidden = YES;
            }
        }
    }else{
        if (self.mj_footer) {
            self.mj_footer = nil;
        }
    }
}



-(BOOL)dk_isInitLoading{
    if(self.dk_activeStatus == DKLoadingActiveStatus){
        if (![self headerIsRefreshing] && ![self footerIsRefreshing]) {
            return YES;
        }
    }
    return NO;
}



#pragma mark - Private Method
-(void)private_dk_activeStatusHandler:(DKActiveStatus)status{
    if ([self headerIsRefreshing]) {
        //Header
        if (status == DKLoadingActiveStatus) {
            [self setPrivate_dk_totalCount:[self private_dk_currentTotalCount]];
            
        }else if(status == DKSuccessActiveStatus){
            [self.mj_header endRefreshing];
            
            BOOL isEmpty = [self private_dk_currentTotalCount] == 0;
            if (isEmpty) {
                self.mj_header.hidden = YES;
                self.mj_footer.hidden = YES;
            }else{
                self.mj_header.hidden = NO;
            }
            
        }else if(status == DKErrorActiveStatus){
            self.mj_header.hidden = YES;
            self.mj_footer.hidden = YES;
        }
        
        
    }else if([self footerIsRefreshing]){
        //Footer
        if (status == DKLoadingActiveStatus) {
            [self setPrivate_dk_totalCount:[self private_dk_currentTotalCount]];
            
        }else if(status == DKSuccessActiveStatus){
            [self.mj_footer endRefreshing];
            
            BOOL isEmpty = ([self private_dk_currentTotalCount] - [self private_dk_totalCount]) <= 0;
            
            if (isEmpty) {
                [self.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.mj_footer endRefreshing];
            }
            
        }else if(status == DKErrorActiveStatus){
            [self.mj_footer endRefreshing];
        }
        
    }else{
        //Init
        if (status == DKLoadingActiveStatus) {
            self.mj_header.hidden = YES;
            self.mj_footer.hidden = YES;
            [self setPrivate_dk_totalCount:[self private_dk_currentTotalCount]];
            
        }else if(status == DKSuccessActiveStatus){
            BOOL isEmpty = [self private_dk_currentTotalCount] == 0;
            
            if (isEmpty) {
                //空数据
                self.mj_header.hidden = YES;
                self.mj_footer.hidden = YES;
                
            }else{
                self.mj_header.hidden = NO;
                self.mj_footer.hidden = NO;
            }
            
        }else if(status == DKErrorActiveStatus){
            [self.mj_footer endRefreshing];
        }
    }
}


/**
 私有方法，当前tableView cell的数量

 @return cell的数量
 */
-(NSInteger)private_dk_currentTotalCount{
    id<UITableViewDataSource> dataSource = self.dataSource;
    
    NSInteger sections = 1;
    if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sections = [dataSource numberOfSectionsInTableView:self];
    }
    
    NSInteger items = 0;
    if (dataSource && [dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        for (NSInteger section = 0; section < sections; section++) {
            items += [dataSource tableView:self numberOfRowsInSection:section];
        }
    }
    
    return items;
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
        return [self.dk_delegate dk_pageCountValue];
    }
    return 10;
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
