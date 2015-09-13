//
//  AJHeartScoreView.m
//  AddPoiTest
//
//  Created by aijun on 15/9/12.
//  Copyright (c) 2015年 aijun. All rights reserved.
//

#import "AJHeartScoreView.h"

@implementation AJHeartScoreView{
    
    CAShapeLayer *unSelectedLayer;
    CAShapeLayer *selectedLayer;
    CALayer *unSelectedMaskLayer;
    CALayer *selectedMaskLayer;
    
    CGRect pathBounds;
    CGRect totoalPathBounds;
    CGFloat scale;
    CGFloat scalePadding;
    
}


- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder])) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    
    _value = 0.0;
    _selectedColor = [UIColor redColor];
    _unSelectedBorderColor = [UIColor grayColor];
    
    unSelectedLayer = [CAShapeLayer layer];
    selectedLayer = [CAShapeLayer layer];
    selectedMaskLayer = [CALayer layer];
    selectedMaskLayer.backgroundColor = [UIColor blackColor].CGColor;
    unSelectedMaskLayer = [CALayer layer];
    unSelectedMaskLayer.backgroundColor = [UIColor blackColor].CGColor;
    
    [self.layer addSublayer:unSelectedLayer];
    [self.layer addSublayer:selectedLayer];
    
    [self setNeedsLayout];
    
}


- (void)setSelectedColor:(UIColor *)selectedColor{
    
    _selectedColor = selectedColor;
    selectedLayer.fillColor = _selectedColor.CGColor;
    selectedLayer.fillColor = _selectedColor.CGColor;
    
}

- (void)setUnSelectedBorderColor:(UIColor *)unSelectedBorderColor{
    
    _unSelectedBorderColor = unSelectedBorderColor;
    unSelectedLayer.strokeColor = _unSelectedBorderColor.CGColor;
    
}

- (void)setValue:(CGFloat)value{
    
    if (_value != value) {
        
        if (value < 0.0) {
            _value = 0.0;
        }else if(value > 5.0){
            _value = 5.0;
        }else{
            _value = value;
        }
        
        [self refreshMaskLayer];
        
    }
    
}

- (void)refreshMaskLayer{
    
    CGFloat _maximumValue = 5.0;
    CGFloat _minimumValue = 0.0;
    NSInteger _number = 5;
    CGFloat numberOfSharp = _value/((_maximumValue-_minimumValue)/_number);
    NSInteger integer = floor(numberOfSharp);
    CGFloat remainValue = numberOfSharp - integer;
    
    CGFloat selectW = (pathBounds.size.width*integer + scalePadding*integer + pathBounds.size.width*remainValue)*scale + totoalPathBounds.origin.x;
    
    CGRect selectedMaskRect = CGRectMake(0, 0, selectW, self.bounds.size.height);
    
//    CGRect selectedMaskRect = CGRectMake(totoalPathBounds.origin.x, self.bounds.origin.y+pathBounds.origin.y-0.5, selectW, self.bounds.size.height-2*pathBounds.origin.y+1.0);
    
    selectedMaskLayer.frame = selectedMaskRect;
    selectedLayer.mask = selectedMaskLayer;
    
    CGRect unSelectedMaskRect = CGRectMake(selectW, 0, self.bounds.size.width-selectW, self.bounds.size.height);
    unSelectedMaskLayer.frame = unSelectedMaskRect;
    unSelectedLayer.mask = unSelectedMaskLayer;
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    //根据bounds生成5颗最大的心形的路径
    UIBezierPath *heartPath = [self obtainHeartPath];
    pathBounds = heartPath.bounds;
    [heartPath applyTransform:CGAffineTransformMakeTranslation(-pathBounds.origin.x,-pathBounds.origin.y)];
    pathBounds = heartPath.bounds;
    
    //缩放百分比
    CGFloat padding = 3.0;
    NSInteger _number = 5;
    if ((self.bounds.size.width-(_number-1)*padding)/pathBounds.size.width/_number > (self.bounds.size.height/pathBounds.size.height)) {
        scale = self.bounds.size.height/pathBounds.size.height;
    }else{
        scale = (self.bounds.size.width-(_number-1)*padding)/pathBounds.size.width/_number;
    }
    
    //生成_number总数的心形
    scalePadding = padding/scale;
    
    UIBezierPath *totalPath = [UIBezierPath bezierPath];
    for (int i=0; i<_number; i++) {
        
        UIBezierPath *copyPath = [UIBezierPath bezierPath];
        [copyPath appendPath:heartPath];
        [copyPath applyTransform:CGAffineTransformMakeTranslation((pathBounds.size.width+scalePadding)*i,0)];
        
        [totalPath appendPath:copyPath];
    }
    [totalPath applyTransform:CGAffineTransformMakeScale(scale,scale)];
    
    
    //未选中的5颗空心
    unSelectedLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    unSelectedLayer.path = totalPath.CGPath;
    unSelectedLayer.strokeColor = _unSelectedBorderColor.CGColor;
    unSelectedLayer.fillColor = [UIColor clearColor].CGColor;
    unSelectedLayer.lineWidth = 1.0;
    
    selectedLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    selectedLayer.path = totalPath.CGPath;
    selectedLayer.fillColor = _selectedColor.CGColor;
//    selectedLayer.fillColor = _selectedColor.CGColor;
//    selectedLayer.lineWidth = 1.0;
    
    //确定遮罩层的大小
    [self refreshMaskLayer];
    
}


/**
 *  获取心形的UIBezierPath对象
 *
 *  @return 心形的UIBezierPath对象
 */
- (UIBezierPath *)obtainHeartPath{
    
    UIBezierPath *heartPath = [UIBezierPath bezierPath];
    [heartPath addArcWithCenter:CGPointMake(-1.0, 1.0) radius:1.0 startAngle:-M_PI endAngle:0 clockwise:YES];
    [heartPath addArcWithCenter:CGPointMake(1.0, 1.0) radius:1.0 startAngle:M_PI endAngle:0 clockwise:YES];
    [heartPath addQuadCurveToPoint:CGPointMake(0.0, 3.0) controlPoint:CGPointMake(1.8, 2.0)];
    [heartPath addQuadCurveToPoint:CGPointMake(-2.0, 1.0) controlPoint:CGPointMake(-1.8, 2.0)];
    [heartPath closePath];
    
    return heartPath;
    
}

@end
