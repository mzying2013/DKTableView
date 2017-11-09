//
//  DKWeakObjectContainer.m
//  DKTableView
//
//  Created by bill on 2017/11/6.
//  Copyright © 2017年 bill. All rights reserved.
//

#import "DKWeakObjectContainer.h"

@implementation DKWeakObjectContainer

-(instancetype)initWithWeakObject:(id)object{
    self = [super init];
    
    if (self) {
        _weakObject = object;
    }
    
    return self;
}

@end
