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

- (void)setPoi:(Poi *)poi{
    
    _poi = poi;
    
    if ([_poi.isdelete boolValue] == YES) {
        
        NSMutableAttributedString *attriName = [[NSMutableAttributedString alloc] initWithString:_poi.name];
        [attriName addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, attriName.length)];
        [attriName addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithRed:0.733f green:0.722f blue:0.737f alpha:1.00f] range:NSMakeRange(0, attriName.length)];
        [attriName addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.733f green:0.722f blue:0.737f alpha:1.00f] range:NSMakeRange(0, attriName.length)];
        self.labelTitle.attributedText = attriName;
        
        NSMutableAttributedString *attriAddress = [[NSMutableAttributedString alloc] initWithString:_poi.adress];
        [attriAddress addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, attriAddress.length)];
        [attriAddress addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithRed:0.733f green:0.722f blue:0.737f alpha:1.00f] range:NSMakeRange(0, attriAddress.length)];
        [attriAddress addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.733f green:0.722f blue:0.737f alpha:1.00f] range:NSMakeRange(0, attriAddress.length)];
        self.labelAddress.attributedText = attriAddress;
        
        self.viewScore.selectedColor = [UIColor colorWithRed:0.733f green:0.722f blue:0.737f alpha:1.00f];
        self.viewScore.unSelectedBorderColor = [UIColor colorWithRed:0.733f green:0.722f blue:0.737f alpha:1.00f];
        self.viewScore.value = [_poi.score floatValue];
        
    }else{
        
        NSMutableAttributedString *attriName = [[NSMutableAttributedString alloc] initWithString:_poi.name];
        [attriName addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, attriName.length)];
        self.labelTitle.attributedText = attriName;
        
        NSMutableAttributedString *attriAddress = [[NSMutableAttributedString alloc] initWithString:_poi.adress];
        [attriAddress addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, attriAddress.length)];
        self.labelAddress.attributedText = attriAddress;

        self.viewScore.selectedColor = [UIColor colorWithRed:0.259f green:0.290f blue:0.329f alpha:1.00f];
        self.viewScore.unSelectedBorderColor = [UIColor colorWithRed:0.737f green:0.741f blue:0.749f alpha:1.00f];
        self.viewScore.value = [_poi.score floatValue];
        
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
