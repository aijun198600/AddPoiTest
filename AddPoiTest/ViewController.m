//
//  ViewController.m
//  AddPoiTest
//
//  Created by aijun on 15/9/12.
//  Copyright (c) 2015年 aijun. All rights reserved.
//

#import "ViewController.h"
#import "AddPoiViewController.h"
#import "AppDelegate.h"
#import "Journey.h"

@interface ViewController ()

@end

@implementation ViewController{
    
    IBOutlet UITextField *tfPoiName;
    IBOutlet UITextField *tfPoiAddress;
    IBOutlet UITextField *tfPoiScore;
    IBOutlet UITextField *tfJourneyName;
    
    Journey *myJourney;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    tfJourneyName.userInteractionEnabled = NO;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Journey"];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSError *error = nil;
    NSArray *journeys = [[appDelegate.coreDataHelper context] executeFetchRequest:request error:&error];
    
    if (!error && journeys.count>0) {
        
        myJourney = [journeys objectAtIndex:0];
        tfJourneyName.text = myJourney.title;
        
    }
    
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)endEdit{
    
    [self.view endEditing:YES];
    
}


- (IBAction)addPoiBtnClick:(id)sender {
    
    [self endEdit];
#pragma TODO - 暂时未做输入验证
    
    
    NSString *poiName = tfPoiName.text;
    NSString *poiAddress = tfPoiAddress.text;
    NSString *poiScore = tfPoiScore.text;
    
    
    AddPoiViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPoiViewController"];
    vc.addPoiData = @{
                      @"name":poiName,
                      @"address":poiAddress,
                      @"score":poiScore,
                      @"journey":myJourney
                      };
    [self presentViewController:vc
                       animated:YES
                     completion:nil];
    
}


@end
