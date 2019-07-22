//
//  ViewController.m
//  NSOperationDemo
//
//  Created by lee on 2019/7/19.
//  Copyright © 2019 Onlyou. All rights reserved.
//

#import "ViewController.h"
#import "NonConcurrentOperation.h"
#import "MyOperation.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    [self invocationOperationAsync];
//    [self invocationOperationSync];
//    [self blockOperationSync];
//    [self blockOperationAddExecutionBlock];
//    [self nonConcurrentOperationAction];
//    [self customOperationAction];
//    [self testMacConcurrentOperationCount];
//    [self testDependency];
//    [self testCircleDependency];
    [self threadCommunication];
}

#pragma mark - NSInvocationOperation

//NSInvocationOperation  同步执行
- (void)invocationOperationSync
{
    
    //创建 operation
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task:) object:@"任务1"];
    
    [operation start];
    
}

//NSInvocationOperation  异步执行
- (void)invocationOperationAsync
{
    //创建 operation
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task:) object:@"任务1"];
    //创建一个操作队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    //将任务添加到队列中
    [queue addOperation:operation];
}

#pragma mark - NSBlockOperation

//NSBlockOperation 同步执行
- (void)blockOperationSync
{
    //创建 operation
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1.0];
            NSLog(@"block operation---%@", [NSThread currentThread]);
        }
    }];
    
    [operation start];
}

//NSBlockOperation 异步执行
- (void)blockOperationAsync
{
    //创建 operation
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1.0];
            NSLog(@"block operation---%@", [NSThread currentThread]);
        }
    }];
    
    //创建一个操作队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    //将任务添加到队列中
    [queue addOperation:operation];
}

//NSBlockOperation addExecutionBlock
- (void)blockOperationAddExecutionBlock
{
    //创建 operation
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1.0];
            NSLog(@"任务1：---%@", [NSThread currentThread]);
        }
    }];
    
    for (NSInteger i = 2; i < 7; ++i) {
        [operation addExecutionBlock:^{
            for (NSInteger j = 0; j < 2; ++j) {
                [NSThread sleepForTimeInterval:1.0];
                NSLog(@"任务%ld：---%@", i, [NSThread currentThread]);
            }
        }];
    }
    
    [operation start];
}

#pragma mark - 自定义NSOperation
- (void)nonConcurrentOperationAction
{
    //不加入队列
    NonConcurrentOperation *operation = [[NonConcurrentOperation alloc] init];
    [operation start];
    
    NSLog(@"---------");
    
    //加入队列
    NonConcurrentOperation *operation1 = [[NonConcurrentOperation alloc] init];
    NSOperationQueue *queue = [NSOperationQueue new];
    [queue addOperation:operation1];
}

- (void)customOperationAction
{
    MyOperation *operation = [[MyOperation alloc] init];
    NSOperationQueue *queue = [NSOperationQueue new];
    [queue addOperation:operation];
}

#pragma mark - 队列最大并发数
- (void)testMacConcurrentOperationCount
{
    //创建 operation1
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1.0];
            NSLog(@"任务1：---%@", [NSThread currentThread]);
        }
    }];
    
    //创建 operation2
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1.0];
            NSLog(@"任务2：---%@", [NSThread currentThread]);
        }
    }];
    
    //创建 operation3
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1.0];
            NSLog(@"任务3：---%@", [NSThread currentThread]);
        }
    }];
    
    //创建 operation4
    NSBlockOperation *operation4 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1.0];
            NSLog(@"任务4：---%@", [NSThread currentThread]);
        }
    }];
    
    NSOperationQueue *queue = [NSOperationQueue new];
//    queue.maxConcurrentOperationCount = 0;
//    queue.maxConcurrentOperationCount = 1;
    queue.maxConcurrentOperationCount = 2;
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    [queue addOperation:operation3];
    [queue addOperation:operation4];
}

#pragma mark - 依赖
- (void)testDependency
{
    //创建 operation1
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1.0];
            NSLog(@"任务1：---%@", [NSThread currentThread]);
        }
    }];
    
    //创建 operation2
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1.0];
            NSLog(@"任务2：---%@", [NSThread currentThread]);
        }
    }];
    
    [operation1 addDependency:operation2];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    [queue addOperation:operation1];
    [queue addOperation:operation2];
}

- (void)testCircleDependency
{
    //创建 operation1
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1.0];
            NSLog(@"任务1：---%@", [NSThread currentThread]);
        }
    }];
    
    //创建 operation2
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1.0];
            NSLog(@"任务2：---%@", [NSThread currentThread]);
        }
    }];
    
    //创建 operation3
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:1.0];
            NSLog(@"任务3：---%@", [NSThread currentThread]);
        }
    }];
    
    [operation1 addDependency:operation2];
//    [operation2 addDependency:operation3];
//    [operation3 addDependency:operation1];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    [queue addOperation:operation1];
    [queue addOperation:operation2];
//    [queue addOperation:operation3];

}

#pragma mark - 线程间通讯
- (void)threadCommunication
{
    //1 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    //2 创建操作
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        
        //2.1 执行耗时操作
        NSURL *url = [NSURL URLWithString:@"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1902385933,516700697&fm=26&gp=0.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        NSLog(@"图片下载完毕-----%@",[NSThread currentThread]);
        
        //2.2 获取主队列，回到主线程执行block里面的任务
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            //在主线程中，刷新UI
            self.imageView.image = image;
        }];
    }];
    
    //3 加入队列
    [queue addOperation:operation];
}

#pragma mark - 打印任务
- (void)task:(NSString *)taskName {
    for (NSInteger i = 0; i < 2; ++i) {
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"%@---%@", taskName, [NSThread currentThread]);
    }
}

@end
