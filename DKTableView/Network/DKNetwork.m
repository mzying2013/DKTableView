//
//  DKNetwork.m
//  DKTableView
//
//  Created by bill on 2017/11/7.
//  Copyright © 2017年 bill. All rights reserved.
//

#import "DKNetwork.h"
@import AFNetworking;

@interface DKNetwork()
@property (nonatomic,strong) AFHTTPSessionManager * httpSession;

@end


@implementation DKNetwork

+(instancetype)share{
    static dispatch_once_t onceToken;
    static DKNetwork * network;
    dispatch_once(&onceToken, ^{
        network = [DKNetwork new];
        
        
    });
    return network;
}


#pragma mark - Property Method
-(AFHTTPSessionManager *)httpSession{
    if (!_httpSession) {
        NSURL * url = [NSURL URLWithString:@"https://api.douban.com"];
        _httpSession = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
        _httpSession.requestSerializer.timeoutInterval = 15;
        _httpSession.responseSerializer = [AFJSONResponseSerializer serializer];
        ((AFJSONResponseSerializer *)_httpSession.responseSerializer).removesKeysWithNullValues = YES;
    }
    return _httpSession;
}



-(NSURLSessionTask *)top250:(NSInteger)start count:(NSInteger)count completed:(networkCompelted)completed{
    NSDictionary * parameters = @{@"start":@(start),@"count":@(count)};
    
    return [self.httpSession GET:@"/v2/movie/top250"
                      parameters:parameters
                        progress:nil
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 if (completed) {
                                     completed(responseObject[@"subjects"]);
                                 }
                             });
                             
                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             NSLog(@"top 250 network get error:%@",error);
                             
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 if (completed) {
                                     
                                     NSMutableArray * _tempMArray = [NSMutableArray array];
                                     for (NSInteger index = 0; index < count; index++) {
                                         NSString * name = [NSString stringWithFormat:@"%ld 电影",(long)index + 1];
                                         [_tempMArray addObject:@{@"title":name}];
                                     }
                                     completed([_tempMArray copy]);
                                 }
                             });                             
                         }];
}




@end
