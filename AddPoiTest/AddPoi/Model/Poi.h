//
//  Poi.h
//  
//
//  Created by aijun on 15/9/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Journey;

@interface Poi : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * img;
@property (nonatomic, retain) NSString * adress;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * isdelete;
@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSNumber * ordertag;
@property (nonatomic, retain) Journey *journey;

@end
