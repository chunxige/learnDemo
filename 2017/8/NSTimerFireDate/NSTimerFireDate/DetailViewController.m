//
//  DetailViewController.m
//  NSTimerFireDate
//
//  Created by chunxi on 2017/8/15.
//  Copyright © 2017年 chunxi. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) int count;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    typeof(self) __weak weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        weakSelf.count ++ ;
        NSLog(@"执行：%d",weakSelf.count);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"fireDate:%@,valid:%d",self.timer.fireDate,self.timer.valid);
        });
    }];
    
    /*
     If true, the timer will repeatedly reschedule itself until invalidated. If false, the timer will be invalidated after it fires.
     
     当repeats为NO时候，在给定时间执行完毕后，定时器会重置为无效状态
     
     */
    //[self monitorTimer];
    
}

- (IBAction)backAction:(id)sender {
    // 递归会导致内存泄露 所以在返回的时候销毁递归
    [NSObject cancelPreviousPerformRequestsWithTarget:self  selector:@selector(monitorTimer) object:nil];
    [self.navigationController popViewControllerAnimated:YES];

}


- (IBAction)fireAction:(id)sender {
    NSLog(@"fire action");
    
    /*
     调用fire 会立即触发定时器的action
     并且并不影响定时器的按时回调规则
     */
    [self.timer fire];
}

- (IBAction)distancePastAction:(id)sender {
    // 设置的触发日期在过去，会立即触发，如果是repeat = YES
    // 会继续按照时间间隔触发action
    // 继续
    NSLog(@"past:%@",[NSDate distantPast]);
    self.timer.fireDate = [NSDate distantPast];
}


- (IBAction)distanceFutureAction:(id)sender {
    /*
     设置的是触发日期，在触发日期后才开始重复的时间间隔触发action
     如果是遥远的未来 ，那一直不会触发
     */
    // 暂停
    NSLog(@"future:%@",[NSDate distantFuture]);
    self.timer.fireDate = [[NSDate date] dateByAddingTimeInterval:10];
}


- (void)dealloc{
    NSLog(@"dealloc");
}


@end
