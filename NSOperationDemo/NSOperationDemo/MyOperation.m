//
//  MyOperation.m
//  NSOperationDemo
//
//  Created by lee on 2019/7/19.
//  Copyright © 2019 Onlyou. All rights reserved.
//

#import "MyOperation.h"

@interface MyOperation()

@property (nonatomic, assign) BOOL executing;
@property (nonatomic, assign) BOOL finished;

@end

@implementation MyOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

#pragma mark - start
- (void)start
{
    NSLog(@"任务开始");
    //开始执行
    self.executing = YES;
    
    //执行循环操作
    for (NSInteger i = 0; i < 10; ++i) {
        
        if ( self.cancelled ) {
            //如果任务已经被取消了，更改状态后，返回
            self.executing = NO;
            self.finished = YES;
            NSLog(@"任务取消，退出");
            return;
        }
        
        NSLog(@"Task %ld, thread:%@,executing=%d,cancelled=%d,finished=%d,operationCount=%lu", (long)i, [NSThread currentThread], self.executing, self.cancelled, self.finished, (unsigned long)[[NSOperationQueue currentQueue] operationCount]);
        [NSThread sleepForTimeInterval:0.2];
    }
    
    NSLog(@"任务结束");
    self.executing = NO;
    self.finished = YES;
    
    NSLog(@"end...thread:%@,executing=%d,cancelled=%d,finished=%d,operationCount=%lu", [NSThread currentThread], self.executing, self.cancelled, self.finished, (unsigned long)[[NSOperationQueue currentQueue] operationCount]);
    
}

//任务是否是并发
- (BOOL)isAsynchronous
{
    return YES;
}

#pragma mark - getter & setter

- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"executing"];
    _executing = executing;
    [self didChangeValueForKey:@"executing"];
}

- (BOOL)executing
{
    return _executing;
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"finished"];
    _finished = finished;
    [self didChangeValueForKey:@"finished"];
}

@end
