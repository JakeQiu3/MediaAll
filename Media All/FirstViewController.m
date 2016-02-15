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
    UISegmentedControl *segentControl = [[UISegmentedControl alloc] initWithItems:@[@"录像",@"照相"]];
//    segentControl.selectedSegmentIndex = 0;
    segentControl.apportionsSegmentWidthsByContent = YES;
    segentControl.tintColor = [UIColor blueColor];
    segentControl.frame = CGRectMake(100, 100, 120, 30);
    [segentControl addTarget:self action:@selector(chooseCamera:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segentControl];
}

- (void)chooseCamera:(UISegmentedControl *)segementControl {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"UIImagePickerViewController" bundle:nil];
    UIImagePickerViewController *imagePickerVC = [story instantiateViewControllerWithIdentifier:@"UIImagePickerViewController"];
    [self.navigationController pushViewController:imagePickerVC animated:YES];
    switch (segementControl.selectedSegmentIndex) {
        case 0:
            imagePickerVC.isVideo = 1;
            break;
            
        default:
            break;
    }
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
