//
//  ViewController.m
//  AddPoiTest
//
//  Created by aijun on 15/9/12.
//  Copyright (c) 2015年 aijun. All rights reserved.
//

#import "ViewController.h"
#import "AddPoiViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    AJHeartScoreView *heartV = [[AJHeartScoreView alloc] initWithFrame:CGRectMake(0, 64, 300, 200)];
    [self.view addSubview:heartV];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPoiBtnClick:(id)sender {
    
    AddPoiViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPoiViewController"];
    [self presentViewController:vc
                       animated:YES
                     completion:nil];
    
}


@end
