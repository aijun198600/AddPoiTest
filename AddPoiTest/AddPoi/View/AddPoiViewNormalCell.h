//
//  AddPoiViewNormalCell.h
//  AddPoiTest
//
//  Created by aijun on 15/9/13.
//  Copyright (c) 2015年 aijun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJHeartScoreView.h"

@interface AddPoiViewNormalCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgPoi;
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelAddress;
@property (strong, nonatomic) IBOutlet AJHeartScoreView *viewScore;

@end
