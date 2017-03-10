//
//  ThirdViewController.m
//  ReactiveCocoaStudy
//
//  Created by DayHR on 2017/3/7.
//  Copyright © 2017年 haiqinghua. All rights reserved.
//

#import "ThirdViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#define urlS @"https://baike.baidu.com/api/openapi/BaikeLemmaCardApi?scope=103&format=json&appid=379020&bk_key=apple&bk_length=600"
#define imageUrlString @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1488961882434&di=c21005d46ec88f2e4d1ed8f2eedc93bc&imgtype=0&src=http%3A%2F%2Fimg.qumingxing.com%2Fupload%2Fmastermap%2F20160705%2Feyhm6j29.JPG"
@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //系统的网络请求流程
//    [self networkRequest];
    //系统图片网络请求的流程
//    [self networkIamgeRequest];
    //ReactiveCocoa网络请求的流程
    [self networkRequestUseRAC];
    //ReactiveCocoa网络图片请求的流程
//    [self networkIamgeRequestUseRAC];
}
//系统的网络请求
-(void)networkRequest{
    NSURL * url = [NSURL URLWithString:urlS];
    NSURLSession * session = [NSURLSession sharedSession];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString * dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",dataString);
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@",dic);
        [self performSelector:@selector(actionWithString:) onThread:[NSThread mainThread] withObject:dataString waitUntilDone:YES];
    }];
    [task resume];
}
//系统的网络图片请求
-(void)networkIamgeRequest{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL * url = [NSURL URLWithString:imageUrlString];
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        if (image!=nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = image;
            });
        }
    });
}
//ReactiveCocoa用在网络请求
-(void)networkRequestUseRAC{
//    [[[self.requestDataButton rac_signalForControlEvents:(UIControlEventTouchUpInside)]
//    map:^id(id value) {
//        return [self racNetworkRequest];
//    }]
//    subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    //flattenMap的用法
//    [[[self.requestDataButton rac_signalForControlEvents:(UIControlEventTouchUpInside)]
//      flattenMap:^id(id value) {
//          return [self racNetworkRequest];
//      }]
//     subscribeNext:^(id x) {
//         NSLog(@"%@",x);
//     } error:^(NSError *error) {
//         NSLog(@"%@",error);
//     }];
    //then的用法
//    [[[self racNetworkRequest]
//    then:^RACSignal *{
//        return self.textField.rac_textSignal;
//    }]
//    subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }error:^(NSError *error) {
//        NSLog(@"error");
//    }];
    //线程
    @weakify(self)
//    [[[[[self racNetworkRequest]
//        then:^RACSignal *{
//            @strongify(self);
//            return self.textField.rac_textSignal;
//        }]
//       filter:^BOOL(NSString* value) {
//           return value.length > 3?YES:NO;
//       }]
//    deliverOn:[RACScheduler mainThreadScheduler]]//回到主线程
//    subscribeNext:^(NSString * value) {
//         @strongify(self);
//         self.textView.text =value;
//         NSLog(@"%@",value);
//        NSLog(@"当前线程%@",[NSThread currentThread]);
//    } error:^(NSError *error) {
//         NSLog(@"%@",error);
//     }];
    //节流
    [[[[[self racNetworkRequest]
        then:^RACSignal *{
            @strongify(self);
            return self.textField.rac_textSignal;
        }]
       filter:^BOOL(NSString* value) {
           return value.length > 3?YES:NO;
       }]
      throttle:1]
     subscribeNext:^(NSString * value) {
         @strongify(self);
         self.textView.text =value;
         NSLog(@"%@",value);
     } error:^(NSError *error) {
         NSLog(@"%@",error);
     }];
}
-(void)networkIamgeRequestUseRAC{
    //    [[[self racRequestImage]
    //    deliverOn:[RACScheduler mainThreadScheduler]]
    //    subscribeNext:^(UIImage * image) {
    //        self.imageView.image = image;
    //    }];
    //
    @weakify(self);
    [[[[self.requestImageDataButton rac_signalForControlEvents:(UIControlEventTouchUpInside)]
       flattenMap:^RACStream *(id value) {
           NSLog(@"%@",[NSThread currentThread]);

           return [self racRequestImage];
       }]
    deliverOn:[RACScheduler mainThreadScheduler]]
    subscribeNext:^(UIImage * image) {
//        [self performSelectorOnMainThread:@selector(doSomething:) withObject:image waitUntilDone:YES];
        NSLog(@"当前线程%@",[NSThread currentThread]);
        @strongify(self);
         self.imageView.image = image;
     }];
}
#pragma mark -- 私有方法
//rac网络请求
-(RACSignal *)racNetworkRequest{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURL * url = [NSURL URLWithString:urlS];
        NSURLSession * session = [NSURLSession sharedSession];
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
        NSURLSessionTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSString * dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",dataString);
//            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//            NSLog(@"%@",dic);
            if (error ==nil) {//返回成功
                [subscriber sendNext:dataString];//发送信号
                [subscriber sendCompleted];//结束发送
            } else {
                [subscriber sendError:error];//发送错误
            }
        }];
        [task resume];
        return nil;
    }];
}
//RAC图片请求
-(RACSignal*)racRequestImage{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURL * url = [NSURL URLWithString:imageUrlString];
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        self.imageView.image = image;
        [subscriber sendNext:image];
        [subscriber sendCompleted];
        return nil;
    }];
}
//回到主线程文本框赋值
-(void)actionWithString:(id )value{
    self.textView.text = (NSString*)value;
}
-(void)doSomething:(UIImage*)image{
    self.imageView.image = image;
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
