//
//  SecondViewController.m
//  ReactiveCocoaStudy
//
//  Created by DayHR on 2017/3/7.
//  Copyright © 2017年 haiqinghua. All rights reserved.
//

#import "SecondViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self simpleOne];
    [self mediumOne];
     
}
-(void)simpleOne{
    //订阅textField的输入文字改变的信号
//    [self.textfield.rac_textSignal subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    //textField的值肯定是字符串类型，所以可以这么写
//    [self.textfield.rac_textSignal subscribeNext:^(NSString* x) {
//        NSLog(@"%@",x);
//    }];
    //使用filter用于过滤信号，选择符合条件的信号
//    [[self.textfield.rac_textSignal filter:^BOOL(NSString* value) {
//        return value.length>3?YES:NO;
//    }]subscribeNext:^(NSString* x) {
//        NSLog(@"过滤后的到的信号：%@",x);
//    }];
    //使用map将textField的字符串信号转换为其他类型的信号，这里将它转换为布尔类型
//    [[[self.textfield.rac_textSignal filter:^BOOL(NSString* value) {
//        return value.length>3?YES:NO;
//    }]map:^id(NSString* value) {
//        return value.length > 4?[UIColor redColor]:[UIColor whiteColor];
//    }]subscribeNext:^(UIColor* value) {
//        self.textfield.backgroundColor = value;
//    }];
    //通过宏来简写上面的内容(这里省去了filter)
    RAC(self.textfield ,backgroundColor) = [self.textfield.rac_textSignal map:^id(NSString* value) {
        return value.length > 4?[UIColor redColor]:[UIColor whiteColor];
    }];
    //用同样的方法给textView改变背景色
    RAC(self.textView ,backgroundColor) = [self.textView.rac_textSignal map:^id(NSString* value) {
        return value.length > 4?[UIColor redColor]:[UIColor whiteColor];
    }];
    //将两个信号合并
    RACSignal * mergeTwoSignal = [RACSignal combineLatest:@[self.textfield.rac_textSignal,self.textView.rac_textSignal] reduce:^id(NSString * value1,NSString * value2){
        return [NSNumber numberWithBool:([value1 isEqualToString:@"11111"]&&[value2 isEqualToString:@"22222"])];
    }];
    RAC(self.addButton,enabled) = [mergeTwoSignal map:^id(NSNumber* value) {
        return value;
    }];
    //将按钮的点击事件，转换成一个信号，进行订阅
//    [[self.addButton rac_signalForControlEvents:(UIControlEventTouchUpInside)]
//     subscribeNext:^(NSNumber * value) {
//         self.displayLabel.text = @"1314";
//     }];
    
    //也可以在订阅信号之前做其他的附加操作，不改变信号流
//    [[[self.addButton rac_signalForControlEvents:(UIControlEventTouchUpInside)]
//     doNext:^(id x) {
//         //改变label的背景色
//         self.displayLabel.backgroundColor = [UIColor redColor];
//     }]
//     subscribeNext:^(NSNumber * value) {
//         self.displayLabel.text = @"1314";
//     }];
    //添加防止循环引用
    //@weakify宏让你创建一个弱引用的影子对象（如果你需要多个弱引用，你可以传入多个变量），@strongify让你创建一个对之前传入@weakify对象的强引用。
    @weakify(self);
    [[[self.addButton rac_signalForControlEvents:(UIControlEventTouchUpInside)]
      doNext:^(id x) {
          self.displayLabel.textColor = [UIColor redColor];
      }]
     subscribeNext:^(NSNumber * value) {
         @strongify(self);
         self.displayLabel.text = @"1314";
     }];
}
-(void)mediumOne{
//    [self.textfield.rac_textSignal map:^id(id value) {
//        NSString * text = value;
////       return []
//    }]
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
