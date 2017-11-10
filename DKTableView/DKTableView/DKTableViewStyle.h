//
//  DKTableViewStyle.h
//  DKTableView
//
//  Created by bill on 2017/11/9.
//  Copyright © 2017年 bill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DKTableViewStyle : NSObject

+(instancetype)share;
@property (nonatomic,strong) UIFont * font;
@property (nonatomic,strong) UIColor * textColor;

@end
