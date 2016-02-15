//
//  FirstViewController.m
//  Media All
//
//  Created by 邱少依 on 16/2/15.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "FirstViewController.h"
#import "UIImagePickerViewController.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 200, 30);
    [btn setTitle:@"录像和照相" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(wo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)wo {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"UIImagePickerViewController" bundle:nil];
    UIImagePickerViewController *v = [story instantiateViewControllerWithIdentifier:@"UIImagePickerViewController"];
    [self.navigationController pushViewController:v animated:YES];
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
