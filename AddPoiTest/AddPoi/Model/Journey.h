//
//  Journey.h
//  
//
//  Created by aijun on 15/9/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface Journey : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * from;
@property (nonatomic, retain) NSString * to;
@property (nonatomic, retain) NSDate * beginDate;
@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSSet *poi;
@end

@interface Journey (CoreDataGeneratedAccessors)

- (void)addPoiObject:(NSManagedObject *)value;
- (void)removePoiObject:(NSManagedObject *)value;
- (void)addPoi:(NSSet *)values;
- (void)removePoi:(NSSet *)values;

@end
