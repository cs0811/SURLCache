//
//  FetchURL.h
//  SURLCache
//
//  Created by tongxuan on 16/12/15.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessHandle)(NSURLResponse *response, id responseObject);
typedef void(^FailureHandle)(NSError * error);

@interface FetchURL : NSObject

+ (instancetype)shareFetch;

- (void)getURLString:(NSString *)URLString parameters:(NSDictionary *)parameters successHandle:(SuccessHandle)success failureHandle:(FailureHandle)failure;

- (void)postURLString:(NSString *)URLString parameters:(NSDictionary *)parameters successHandle:(SuccessHandle)success failureHandle:(FailureHandle)failure;

@end
