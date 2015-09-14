//
//  CoreDataHelper.h
//  CoreDataHelperPro
//
//  Created by aijun on 15/9/13.
//  Copyright (c) 2015年 aijun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataHelper : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *context;
@property (nonatomic, readonly) NSManagedObjectModel *model;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, readonly) NSPersistentStore *store;

- (void)setupCoreData;
- (void)saveContext;

@end
