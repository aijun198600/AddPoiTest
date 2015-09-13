//
//  AJHeartScoreView.h
//  AddPoiTest
//
//  Created by aijun on 15/9/12.
//  Copyright (c) 2015年 aijun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJHeartScoreView : UIView


/**
 *  评分组件的当前值
 */
@property (nonatomic, assign) CGFloat value;

/**
 *  取值的颜色
 */
@property (nonatomic, strong) UIColor *selectedColor;

/**
 *  取值的颜色
 */
@property (nonatomic, strong) UIColor *unSelectedBorderColor;

@end
