//
//  ViewController.m
//  SURLCache
//
//  Created by tongxuan on 16/12/15.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"


@interface ViewController ()
@property (nonatomic, strong) UIButton * btn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
}

- (void)loadData {
    [self.view addSubview:self.btn];
    self.btn.frame = CGRectMake(100, 200, 100, 50);
}

- (void)click {
    TestViewController * vc = [TestViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Getter
- (UIButton *)btn {
    if (!_btn) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"123123" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        _btn = btn;
    }
    return _btn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
