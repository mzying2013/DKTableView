//
//  DKEmptyDataSetImplement.m
//  DKTableView
//
//  Created by bill on 2017/11/9.
//  Copyright © 2017年 bill. All rights reserved.
//

#import "DKEmptyDataSetImplement.h"
#import "UITableView+DKPage.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "DKTableViewStyle.h"

static NSString * const kDKErrorImageName = @"common_404";
static NSString * const kDKEmptyImageName = @"no_data";
static NSString * const kDKErrorTitle = @"点击重新加载";
static NSString * const kDKEmptyTitle = @"暂无数据";
static NSString * const kDKLoadingText = @"正在加载";


@interface DKEmptyDataSetImplement(){
    MBProgressHUD * dk_loadingHUD;
}

@end


@implementation DKEmptyDataSetImplement

#pragma mark - DZNEmptyDataSetSource
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        UITableView * tableView = (UITableView *)scrollView;
        if (tableView.dk_activeStatus == DKErrorActiveStatus) {
            return [UIImage imageNamed:kDKErrorImageName];
        }else{
            return [UIImage imageNamed:kDKEmptyImageName];
        }
    }
    return nil;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        UITableView * tableView = (UITableView *)scrollView;
        
        NSString *text = nil;
        if (tableView.dk_activeStatus == DKErrorActiveStatus) {
            text = kDKErrorTitle;
        }else{
            text = kDKEmptyTitle;
        }
        
        NSMutableDictionary *attributes = [NSMutableDictionary new];
        
        NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        paragraph.alignment = NSTextAlignmentCenter;
        paragraph.lineSpacing = 2.0;
        
        [attributes setObject:[DKTableViewStyle share].textColor forKey:NSForegroundColorAttributeName];
        [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
        [attributes setObject:[DKTableViewStyle share].font forKey:NSFontAttributeName];
        
        return [[NSMutableAttributedString alloc] initWithString:text attributes:[attributes copy]];
    }
    return nil;
}


- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        UITableView * tableView = (UITableView *)scrollView;
        
        if (tableView.dk_isInitLoading) {
            dk_loadingHUD = [MBProgressHUD showHUDAddedTo:scrollView animated:YES];
            dk_loadingHUD.label.text = kDKLoadingText;
            dk_loadingHUD.label.font = [DKTableViewStyle share].font;
            dk_loadingHUD.label.textColor = [DKTableViewStyle share].textColor;
            dk_loadingHUD.bezelView.color = scrollView.backgroundColor;
            return dk_loadingHUD;
        }else{
            if (dk_loadingHUD) {
                [dk_loadingHUD hideAnimated:YES];
            }
            return nil;
        }
    }
    return nil;
}



#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        if(((UITableView *)scrollView).dk_activeStatus == DKLoadingActiveStatus){
            return NO;
        }
    }
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return NO;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        UITableView * tableView = (UITableView *)scrollView;
        tableView.dk_activeStatus = DKLoadingActiveStatus;
        [tableView reloadEmptyDataSet];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(emptyDataSet:didTapView:)]) {
            [self.delegate emptyDataSet:tableView didTapView:view];
        }
    }
}

@end
