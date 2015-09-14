//
//  AppDelegate.h
//  AddPoiTest
//
//  Created by aijun on 15/9/12.
//  Copyright (c) 2015年 aijun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly)CoreDataHelper *coreDataHelper;

@end

