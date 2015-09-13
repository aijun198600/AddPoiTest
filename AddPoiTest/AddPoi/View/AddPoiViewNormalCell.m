//
//  AddPoiViewNormalCell.m
//  AddPoiTest
//
//  Created by aijun on 15/9/13.
//  Copyright (c) 2015年 aijun. All rights reserved.
//

#import "AddPoiViewNormalCell.h"

@implementation AddPoiViewNormalCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.imgPoi.backgroundColor = [UIColor yellowColor];
    self.imgPoi.layer.borderColor = RGBCOLOR(156, 156, 156).CGColor;
    self.imgPoi.layer.borderWidth = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
