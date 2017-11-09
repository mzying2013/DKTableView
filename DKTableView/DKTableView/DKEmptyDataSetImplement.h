//
//  DKEmptyDataSetImplement.h
//  DKTableView
//
//  Created by bill on 2017/11/9.
//  Copyright © 2017年 bill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>


@protocol DKEmptyDataSetDelegate<NSObject>
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view;

@end



@interface DKEmptyDataSetImplement : NSObject<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,weak) id<DKEmptyDataSetDelegate> delegate;

@end
