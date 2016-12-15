//
//  FetchURL.m
//  SURLCache
//
//  Created by tongxuan on 16/12/15.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "FetchURL.h"
#import "AFNetworking.h"

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

- (void)getWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters successHandle:(SuccessHandle)success failureHandle:(FailureHandle)failure {
    
    NSMutableURLRequest * request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
    request.timeoutInterval = 15.0;
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [AFHTTPResponseSerializer serializer].acceptableContentTypes = [NSSet setWithArray:@[@"application/json",@"text/html",@"application/xml"]];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response,id responseObject, NSError *error) {
        if (error) {
#ifdef DEBUG
            NSLog(@"Error: %@", error);
#endif
            failure(error);
        } else {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
#ifdef DEBUG
            NSLog(@"Response: %@", dic);
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
