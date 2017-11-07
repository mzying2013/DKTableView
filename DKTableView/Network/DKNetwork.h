//
//  DKNetwork.h
//  DKTableView
//
//  Created by bill on 2017/11/7.
//  Copyright © 2017年 bill. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^networkCompelted)(NSArray * subjects);

@interface DKNetwork : NSObject

+(instancetype)share;

-(NSURLSessionTask *)top250:(NSInteger)start count:(NSInteger)count completed:(networkCompelted)completed;

@end
