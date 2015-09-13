//
//  AddPoiDateCardView.m
//  AddPoiTest
//
//  Created by aijun on 15/9/13.
//  Copyright (c) 2015年 aijun. All rights reserved.
//

#import "AddPoiDateCardView.h"

@implementation AddPoiDateCardView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0.847f green:0.847f blue:0.847f alpha:1.00f];
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor colorWithRed:0.592f green:0.592f blue:0.592f alpha:1.00f].CGColor;
        
        self.labelDay = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 25.0)];
        self.labelDay.textAlignment = NSTextAlignmentCenter;
        self.labelDay.textColor = [UIColor blackColor];
        self.labelDay.font = [UIFont systemFontOfSize:17.0];
        [self addSubview:self.labelDay];
        
        self.labelDayNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.labelDayNumber.textAlignment = NSTextAlignmentCenter;
        self.labelDayNumber.textColor = [UIColor blackColor];
        self.labelDayNumber.font = [UIFont boldSystemFontOfSize:25.0];
        [self addSubview:self.labelDayNumber];
        
        self.labelDate = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-25.0, frame.size.width, 25.0)];
        self.labelDate.textAlignment = NSTextAlignmentCenter;
        self.labelDate.textColor = [UIColor colorWithRed:0.620f green:0.624f blue:0.604f alpha:1.00f];
        self.labelDate.font = [UIFont systemFontOfSize:17.0];
        [self addSubview:self.labelDate];
        
        
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    
    self.labelDay.frame = CGRectMake(0, 0, frame.size.width, 25.0);
    self.labelDayNumber.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.labelDate.frame = CGRectMake(0, frame.size.height-25.0, frame.size.width, 25.0);
    
}

- (void)becomeSelectedState{
    
    self.labelDay.hidden = NO;
    self.labelDate.hidden = NO;
    self.labelDayNumber.font = [UIFont boldSystemFontOfSize:40.0];
    self.layer.borderColor = [UIColor colorWithRed:0.290f green:0.290f blue:0.290f alpha:1.00f].CGColor;
    
}

- (void)resignSelectedState{
    
    self.labelDay.hidden = YES;
    self.labelDate.hidden = YES;
    self.labelDayNumber.font = [UIFont boldSystemFontOfSize:25.0];
    self.layer.borderColor = [UIColor colorWithRed:0.592f green:0.592f blue:0.592f alpha:1.00f].CGColor;
    
}

@end
