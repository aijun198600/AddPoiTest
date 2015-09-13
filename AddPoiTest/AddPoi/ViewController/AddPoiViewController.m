//
//  AddPoiViewController.m
//  AddPoiTest
//
//  Created by aijun on 15/9/12.
//  Copyright (c) 2015年 aijun. All rights reserved.
//

#import "AddPoiViewController.h"
#import "AddPoiViewNormalCell.h"
#import "AddPoiViewDragCell.h"
#import "iCarousel.h"
#import "AddPoiDateCardView.h"
#import "UIView+Toast.h"

@interface AddPoiViewController ()<UITableViewDelegate, UITableViewDataSource,iCarouselDelegate,iCarouselDataSource>

@end

@implementation AddPoiViewController{
    
    IBOutlet UIButton *btnClose;
    IBOutlet UIButton *btnSave;
    IBOutlet UITableView *tableVPoi;
    IBOutlet iCarousel *viewBottom;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tableVPoi.delegate = self;
    tableVPoi.dataSource = self;
    tableVPoi.separatorColor = RGBCOLOR(151, 151, 151);
    tableVPoi.backgroundColor = [UIColor clearColor];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [tableVPoi addGestureRecognizer:longPress];
    
    viewBottom.delegate = self;
    viewBottom.dataSource = self;
    viewBottom.type = iCarouselTypeLinear;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }
    return 10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 120;
    }
    return 100;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }
    
    return 40.0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        
        UILabel *labelSectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40.0)];
        labelSectionTitle.textAlignment = NSTextAlignmentCenter;
        labelSectionTitle.textColor = [UIColor colorWithRed:0.592f green:0.612f blue:0.627f alpha:1.00f];
        labelSectionTitle.text = @"My Current Journey | HK - JP | Total 5 Days";
        
        return labelSectionTitle;
    }
    
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *normalIndentifier = @"AddPoiViewNormalCell";
    AddPoiViewNormalCell *normalCell=(AddPoiViewNormalCell*)[tableView dequeueReusableCellWithIdentifier:normalIndentifier];
    if (!normalCell){
        
        normalCell = [[AddPoiViewNormalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddPoiViewNormalCell"];
        
    }
    normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    static NSString *dragIndentifier = @"AddPoiViewDragCell";
    AddPoiViewDragCell *dragCell=(AddPoiViewDragCell*)[tableView dequeueReusableCellWithIdentifier:dragIndentifier];
    if (!dragCell){
        
        dragCell = [[AddPoiViewDragCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddPoiViewDragCell"];
        
    }
    dragCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.section == 0) {
        
        dragCell.imgPoi.backgroundColor = [UIColor yellowColor];
        dragCell.labelTitle.text = [NSString stringWithFormat:@"Test %@",@(indexPath.row)];
        dragCell.labelAddress.text = [NSString stringWithFormat:@"Address : 10 , Paris %@",@(indexPath.row)];
        dragCell.viewScore.selectedColor = [UIColor blackColor];
        dragCell.viewScore.unSelectedBorderColor = [UIColor whiteColor];
        dragCell.viewScore.value = 4.5;
        
        return dragCell;
        
    }else{
        
        normalCell.imgPoi.backgroundColor = [UIColor yellowColor];
        normalCell.labelTitle.text = [NSString stringWithFormat:@"Test %@",@(indexPath.row)];
        normalCell.labelAddress.text = [NSString stringWithFormat:@"Address : 10 , Paris %@",@(indexPath.row)];
        normalCell.viewScore.selectedColor = [UIColor colorWithRed:0.259f green:0.290f blue:0.329f alpha:1.00f];
        normalCell.viewScore.value = indexPath.row%5;
        
        return normalCell;
        
    }
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        [self.view makeToast:@"长按可以进行拖动" duration:3.0 position:[NSValue valueWithCGPoint:CGPointMake(ScreenWidth/2.0, ScreenHeight-50)]];
        
        AddPoiViewDragCell *dragCell = (AddPoiViewDragCell *)[tableVPoi cellForRowAtIndexPath:indexPath];
        
//        CABasicAnimation *shakeAnimotion = [CABasicAnimation animationWithKeyPath:@"position.x"];
//        shakeAnimotion.fromValue = [NSNumber numberWithFloat:dragCell.viewContent.layer.position.x-10.0];
//        shakeAnimotion.toValue = [NSNumber numberWithFloat:dragCell.viewContent.layer.position.x+10.0];
//        shakeAnimotion.duration = 0.1;
//        shakeAnimotion.autoreverses = YES;
//        shakeAnimotion.repeatCount = 3;
//        shakeAnimotion.timingFunction =
//        [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
//        
//        [dragCell.viewContent.layer addAnimation:shakeAnimotion forKey:@"shakeAnimotion"];
        
        //弹簧动画
        dragCell.viewContent.transform = CGAffineTransformMakeTranslation(20, 0); //x轴左右移动
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
            dragCell.viewContent.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
}

#pragma mark - iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel{
    
    return 10;
    
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    AddPoiDateCardView *cardView = (AddPoiDateCardView *)view;
    
    if ( !cardView ){
        
        cardView = [[AddPoiDateCardView alloc] initWithFrame:CGRectMake(0, 10, carousel.frame.size.height-20, carousel.frame.size.height-20)];
        
    }
    
    cardView.labelDay.text = @"Day";
    cardView.labelDayNumber.text = [NSString stringWithFormat:@"%@",@(index+1)];
    cardView.labelDate.text = @"Wed - 24 June";
    
    if (index == carousel.currentItemIndex) {
        cardView.frame = CGRectMake(0, 10, carousel.frame.size.height-20, carousel.frame.size.height-20);
        [cardView becomeSelectedState];
    }else{
        cardView.frame = CGRectMake(0, 10, carousel.frame.size.height-60, carousel.frame.size.height-60);
        [cardView resignSelectedState];
    }
    
    return cardView;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case iCarouselOptionSpacing:
        {
            return value;
        }
            
        default:
            break;
    }
    
    return value;
}

#pragma mark - iCarouselDataSource
- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel{
    
    [carousel reloadData];
    
}

#pragma mark - 长按手势处理
- (void)longPressGestureRecognized:(id)sender{
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:tableVPoi];
    NSIndexPath *indexPath = [tableVPoi indexPathForRowAtPoint:location];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        static UIView       *snapshot = nil;
        static NSIndexPath  *sourceIndexPath = nil;
        switch (state) {
            case UIGestureRecognizerStateBegan: {
                if (indexPath) {
                    sourceIndexPath = indexPath;
                    
                    AddPoiViewDragCell *cell = (AddPoiViewDragCell *)[tableVPoi cellForRowAtIndexPath:indexPath];
                    
                    snapshot = [self customSnapshoFromView:cell.viewContent];
                    
                    __block CGPoint center = cell.center;
                    snapshot.center = center;
                    snapshot.alpha = 0.0;
                    [tableVPoi addSubview:snapshot];
                    [UIView animateWithDuration:0.25 animations:^{
                        
                        // Offset for gesture location.
                        center.y = location.y;
                        snapshot.center = center;
                        snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                        snapshot.alpha = 0.98;
                        
                        cell.alpha = 0.0f;
                    } completion:^(BOOL finished) {
                        cell.hidden = YES;
                    }];
                }
                break;
            }
                
            case UIGestureRecognizerStateChanged: {
                CGPoint center = snapshot.center;
                center.y = location.y;
                snapshot.center = center;
                
                // Is destination valid and is it different from source?
                if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                    
                    // ... update data source.
//                    [_items exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                    
                    // ... move the rows.
                    [tableVPoi moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                    
                    // ... and update source so it is in sync with UI changes.
                    sourceIndexPath = indexPath;
                }
                break;
            }
                
            default: {
                // Clean up.
                UITableViewCell *cell = [tableVPoi cellForRowAtIndexPath:sourceIndexPath];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    snapshot.center = cell.center;
                    snapshot.transform = CGAffineTransformIdentity;
                    snapshot.alpha = 0.0;
                    
                    cell.alpha = 1.0f;
                } completion:^(BOOL finished) {
                    cell.hidden = NO;
                    [snapshot removeFromSuperview];
                    snapshot = nil;
                    
                }];
                sourceIndexPath = nil;
                break;
            }
        }
        
    }
    
}

#pragma mark - 截图
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    UIView* snapshot = nil;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 7.0) {
        //ios7.0 以下通过截图形式保存快照
        snapshot = [self customSnapShortFromViewEx:inputView];
    }else{
        //ios7.0 系统的快照方法
        snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    }
    
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

- (UIView *)customSnapShortFromViewEx:(UIView *)inputView
{
    CGSize inSize = inputView.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(inSize, NO, [UIScreen mainScreen].scale);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView* snapshot = [[UIImageView alloc] initWithImage:image];
    
    return snapshot;
}

@end
