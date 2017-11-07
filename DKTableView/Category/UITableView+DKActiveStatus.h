//
//  UITableView+DKActiveStatus.h
//  DKTableView
//
//  Created by bill on 2017/11/7.
//  Copyright © 2017年 bill. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,DKActiveStatus){
    DKDefaultActiveStatus = 0,
    DKInitLodingActiveStatus,
    DKHeaderRefreshActiveStatus,
    DKFooterRefreshActiveStatus,
    DKEmptyActiveStatus,
    DKErrorActiveStatus,
    DKLoadNoMoreActiveStatus,
    DKLoadHaveMoreActiveStatus
};

@interface UITableView (DKActiveStatus)

-(void)activeStatus:(DKActiveStatus)status;

@end
