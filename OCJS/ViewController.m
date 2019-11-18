//
//  ViewController.m
//  OCJS
//
//  Created by JackMa on 2019/11/18.
//  Copyright © 2019 fire. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "FourViewController.h"
#import "SixViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// OC - JS 传统交互方式演练
- (IBAction)bt1Click:(UIButton *)sender {
    FirstViewController *vc = [[FirstViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)bt2Click:(UIButton *)sender {
    SecondViewController *vc = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)bt3Click:(UIButton *)sender {
    FourViewController *vc = [[FourViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)bt4Click:(UIButton *)sender {
    SixViewController *vc = [[SixViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
