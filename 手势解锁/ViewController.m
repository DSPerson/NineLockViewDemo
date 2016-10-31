//
//  ViewController.m
//  手势解锁
//
//  Created by dsperson on 2016/10/30.
//  Copyright © 2016年 杜帅. All rights reserved.
//

#import "ViewController.h"
#import <SDCycleScrollView.h>
#import "DSLockView.h"
@interface ViewController ()
@property (strong, nonatomic) DSLockView *dsLockView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dsLockView = ({
        DSLockView *ds = [[DSLockView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 400)];
        ds.passwordStr = @"123";
        ds.openAnimate = true;
        ds.backgroundColor = [UIColor clearColor];
        [self.view addSubview:ds];
        ds;
      
    });
    
    //可以在此界面任何地方使用 这里可以做一些动画上的问题
    self.dsLockView.kDSResultBlock = ^(BOOL result,BOOL resu) {
        NSLog(@"%d", result);
    };
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
