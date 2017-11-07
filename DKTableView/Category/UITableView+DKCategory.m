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



@implementation UITableView (DKCategory)

#pragma mark - Private Property Method
-(NSInteger)privateDKPageIndex{
    NSNumber * index = objc_getAssociatedObject(self, kPageIndexKey);
    return [index integerValue];
}


-(void)setPrivateDKPageIndex:(NSInteger)privateDKPageIndex{
    NSNumber * index = [NSNumber numberWithInteger:privateDKPageIndex];
    objc_setAssociatedObject(self, kPageIndexKey, index, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
}


-(NSInteger)dk_pageIndex{
    return [self privateDKPageIndex];
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
    




@end
