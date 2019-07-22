//
//  nonConcurrentOperation.m
//  NSOperationDemo
//
//  Created by lee on 2019/7/22.
//  Copyright © 2019 Onlyou. All rights reserved.
//

#import "NonConcurrentOperation.h"

@implementation NonConcurrentOperation

- (void)main
{
    for (NSInteger i = 0; i < 2; ++i) {
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"任务，---%@", [NSThread currentThread]);
    }
}

@end
