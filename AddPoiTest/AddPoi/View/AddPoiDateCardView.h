//
//  AddPoiDateCardView.h
//  AddPoiTest
//
//  Created by aijun on 15/9/13.
//  Copyright (c) 2015年 aijun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPoiDateCardView : UIView

@property(nonatomic, strong)UILabel *labelDay;
@property(nonatomic, strong)UILabel *labelDayNumber;
@property(nonatomic, strong)UILabel *labelDate;

/**
 *  获取选择状态
 */
- (void)becomeSelectedState;

/**
 *  取消选择状态
 */
- (void)resignSelectedState;

@end
