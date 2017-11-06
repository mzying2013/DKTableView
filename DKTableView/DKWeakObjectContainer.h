//
//  DKWeakObjectContainer.h
//  DKTableView
//
//  Created by bill on 2017/11/6.
//  Copyright © 2017年 bill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKWeakObjectContainer : NSObject

@property (nonatomic, readonly, weak) id weakObject;

-(instancetype)initWithWeakObject:(id)object;

@end
