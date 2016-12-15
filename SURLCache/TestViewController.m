//
//  TestViewController.m
//  SURLCache
//
//  Created by tongxuan on 16/12/15.
//  Copyright © 2016年 tongxuan. All rights reserved.
//

#import "TestViewController.h"
#import "FetchURL.h"

@interface TestViewController ()
@property (nonatomic, strong) FetchURL * fetch;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    self.fetch = [FetchURL new];
    [self.fetch getURLString:@"http://www.weather.com.cn/data/sk/101190408.html" parameters:nil successHandle:^(NSURLResponse *response, id responseObject) {
        NSLog(@" -- %@",responseObject);
    } failureHandle:^(NSError *error) {
        NSLog(@" -- %@",error);

    }];
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
