//
//  AddPoiViewController.h
//  AddPoiTest
//
//  Created by aijun on 15/9/12.
//  Copyright (c) 2015年 aijun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPoiViewController : UIViewController

@property(nonatomic, strong)NSDictionary *addPoiData;

- (IBAction)btnCloseAction:(id)sender;
- (IBAction)btnSaveAction:(id)sender;

@end
