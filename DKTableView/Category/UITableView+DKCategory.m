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


@implementation UITableView (DKCategory)




#pragma mark - Property Method
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
    return 0;
}

@end
