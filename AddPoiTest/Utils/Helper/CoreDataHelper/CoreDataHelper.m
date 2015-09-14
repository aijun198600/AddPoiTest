//
//  CoreDataHelper.m
//  CoreDataHelperPro
//
//  Created by aijun on 15/9/13.
//  Copyright (c) 2015年 aijun. All rights reserved.
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper


#pragma mark - Files
NSString *storeFileName = @"addpoi.sqlite";

#pragma mark - Paths
- (NSString *)documentsDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSURL *)storesDirectory{
    NSURL *storesDirectory = [[NSURL fileURLWithPath:[self documentsDirectory]] URLByAppendingPathComponent:@"Stores"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storesDirectory path]]) {
        NSError *error = nil;
        if ([fileManager createDirectoryAtURL:storesDirectory withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"Successfully Create DB Path:%@",[storesDirectory path]);
        }
    }
    
    return storesDirectory;
}

- (NSURL *)storeURL{
    return [[self storesDirectory] URLByAppendingPathComponent:storeFileName];
}

#pragma mark - Setup
- (id)init{
    
    self = [super init];
    
    if (self) {
        
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_context setPersistentStoreCoordinator:_coordinator];
    }
    
    return self;
}

- (void)loadStore{
    
    if (_store) {
        return;
    }
    
    NSError *error = nil;
    _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURL] options:nil error:&error];
    
    if (error) {
        NSLog(@"error:%@",error.localizedDescription);
    }
    
}

- (void)setupCoreData{
    
    [self loadStore];
    
}

#pragma mark - Saving
- (void)saveContext{
    
    if ([_context hasChanges]) {
        
        NSError *error = nil;
        
        if ([_context save:&error]) {
            NSLog(@"_context save change successfully");
        }else{
            NSLog(@"_context save change failed :%@",error.localizedDescription);
        }
        
    }
    
}


@end
