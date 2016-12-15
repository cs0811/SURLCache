//
//  FetchURL.m
//  SURLCache
//
//  Created by tongxuan on 16/12/15.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "FetchURL.h"
#import "AFNetworking.h"
#import "URLCache.h"

static FetchURL * fetch = nil;

@interface FetchURL ()

@property (nonatomic, strong) AFURLSessionManager * manager;

@property (nonatomic, strong) NSMutableArray * dataTasksArr;

@end

@implementation FetchURL

+ (instancetype)shareFetch {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        fetch = [[FetchURL alloc] init];
    });
    return fetch;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataTasksArr = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    
    for (NSInteger i=0; i<self.dataTasksArr.count; i++) {
        NSURLSessionDataTask * dataTask = self.dataTasksArr[i];
        [dataTask cancel];
#ifdef DEBUG
        NSLog(@"URL: %@ removed",dataTask.currentRequest.URL.absoluteString);
#endif
        [self.dataTasksArr removeObject:dataTask];
    }

}

- (void)getURLString:(NSString *)URLString parameters:(NSDictionary *)parameters successHandle:(SuccessHandle)success failureHandle:(FailureHandle)failure {
    [self networkWithURLString:URLString parameters:parameters method:@"GET" successHandle:success failureHandle:failure];
}

- (void)postURLString:(NSString *)URLString parameters:(NSDictionary *)parameters successHandle:(SuccessHandle)success failureHandle:(FailureHandle)failure {
    [self networkWithURLString:URLString parameters:parameters method:@"POST" successHandle:success failureHandle:failure];
}

#pragma mark Private
- (void)networkWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters method:(NSString *)method successHandle:(SuccessHandle)success failureHandle:(FailureHandle)failure {
    NSMutableURLRequest * request = [[AFHTTPRequestSerializer serializer] requestWithMethod:method URLString:URLString parameters:parameters error:nil];
    request.timeoutInterval = 15.0;
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    // cache
    NSCachedURLResponse *cacheURLResponse = nil;
    if ([method isEqual:@"GET"]) {
        cacheURLResponse = [[URLCache sharedURLCache] cachedResponseForRequest:request];
        if (cacheURLResponse) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)cacheURLResponse.response;
            NSString *cachedResponseEtag = [httpResponse.allHeaderFields objectForKey:@"Etag"];
            if (cachedResponseEtag) {
                [request setValue:cachedResponseEtag forHTTPHeaderField:@"If-None-Match"];
            }
        }
    }
    
    [AFHTTPResponseSerializer serializer].acceptableContentTypes = [NSSet setWithArray:@[@"application/json",@"text/html",@"application/xml"]];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response,id responseObject, NSError *error) {
        if (error) {
#ifdef DEBUG
            NSLog(@"Error: %@", error);
#endif
            failure(error);
        } else {
            NSData * data = responseObject;
            NSHTTPURLResponse *newHttpResponse = (NSHTTPURLResponse *)response;
            if (newHttpResponse.statusCode == 304) {
                // cached in local
                data = cacheURLResponse.data;
            } else {
                // refreshed from server
            }
            
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
#ifdef DEBUG
            NSLog(@"Response: %@\n\nData: %@",response, dic);
#endif
            success(response, dic);
        }
    }];
    [dataTask resume];
    if (dataTask) {
        [self.dataTasksArr addObject:dataTask];
    }
}

#pragma mark Getter 
- (AFURLSessionManager *)manager {
    if (_manager == nil) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    return _manager;
}

@end
