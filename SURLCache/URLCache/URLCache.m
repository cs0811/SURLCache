//
//  URLCache.m
//  SURLCache
//
//  Created by tongxuan on 16/12/15.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "URLCache.h"

@interface URLCache ()
@end

@implementation URLCache

- (void)setMemoryCapacity:(NSUInteger)memoryCapacity {
    if (memoryCapacity == 0) {
        return;
    }
    [super setMemoryCapacity:memoryCapacity];
}



@end
