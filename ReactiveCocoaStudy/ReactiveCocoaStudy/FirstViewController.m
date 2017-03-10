//
//  FirstViewController.m
//  ReactiveCocoaStudy
//
//  Created by DayHR on 2017/3/7.
//  Copyright © 2017年 haiqinghua. All rights reserved.
//

#import "FirstViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    //创建信号
//    RACSignal * single = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        NSLog(@"想");
//        [subscriber sendNext:@"发送了信号"];//发送信号
//        NSLog(@"你");
//        [subscriber sendCompleted];//发送完成，订阅自动移除
//        //RACDisposable 手动移除订阅者
//        return [RACDisposable disposableWithBlock:^{
//            NSLog(@"豆腐");
//        }];
//    }];
//    //订阅信号
//    NSLog(@"我");
//    [single subscribeNext:^(id x) {
//        NSLog(@"吃");
//        NSLog(@"信号的值：%@",x);
//    }];
//    //创建信号
//    RACSignal * single = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        NSLog(@"想");
//        [subscriber sendNext:@"发送了一个信号"];//发送信号
//        NSLog(@"你");
//        //RACDisposable 手动移除订阅者
//        return [RACDisposable disposableWithBlock:^{
//            NSLog(@"豆腐");
//        }];
//    }];
//    //订阅信号
//    NSLog(@"我");
//    RACDisposable * disposable = [single subscribeNext:^(id x) {
//        NSLog(@"吃");
//        NSLog(@"信号的值：%@",x);
//    }];
//    //手动移除订阅
//    [disposable dispose];
    //创建信号
    RACSignal * single = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"想");
        [subscriber sendNext:@"发送了信号"];//发送信号
        NSLog(@"你");
        [subscriber sendCompleted];//发送完成，订阅自动移除
        //RACDisposable 手动移除订阅者
        return nil;
    }];
    //订阅信号
    NSLog(@"我");
    [single subscribeNext:^(id x) {
        NSLog(@"吃");
        NSLog(@"信号的值：%@",x);
    }];
    
}
- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
