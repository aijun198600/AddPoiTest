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
#import "Journey.h"
#import "Poi.h"
#import "AppDelegate.h"

@interface AddPoiViewController ()<UITableViewDelegate, UITableViewDataSource,iCarouselDelegate,iCarouselDataSource,UIAlertViewDelegate>

@end

@implementation AddPoiViewController{
    
    IBOutlet UIButton *btnClose;
    IBOutlet UIButton *btnSave;
    IBOutlet UITableView *tableVPoi;
    IBOutlet iCarousel *viewBottom;
    
    AppDelegate *appDelegate;   /**< 通过appdelegate获取core data context */
    
    BOOL isAdd;                 /**< 判断是否已经新增景点 */
    BOOL isChange;              /**< 判断景点列表是否更新 */
    
    NSMutableArray *listPoi;    /**< 景点列表数据源 */
    NSMutableArray *listDate;   /**< 日期时间数据源 */
    Journey *myJourney;         /**< 当前的行程对象 */
    Poi *addPoi;                /**< 当前要添加的景点对象 */
    
    NSInteger changeIndex;      /**< 拖动到的index */
    
    UILabel *labelToast;        /**< 加载成功后的提示 */
    Poi *delPoi;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    labelToast = [[UILabel alloc] init];
    labelToast.backgroundColor = [UIColor blackColor];
    labelToast.textColor = [UIColor whiteColor];
    labelToast.numberOfLines = 0;
    labelToast.hidden = YES;
    [self.view addSubview:labelToast];
    
    [self initData];
    
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


#pragma mark - 初始化数据
- (void)initData{
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    isAdd = NO;
    isChange = NO;
    changeIndex = -1;
    
    listPoi = [[NSMutableArray alloc] init];
    listDate = [[NSMutableArray alloc] init];
    
    if (self.addPoiData) {
        
        myJourney = [self.addPoiData objectForKey:@"journey"];
        
        if (myJourney) {
            NSDate *beginDate = myJourney.beginDate;
            NSInteger journeyDay = [myJourney.day integerValue];
            
            //添加下方日期数据
            for (int i=1; i<journeyDay+1; i++) {
                
                NSDate *dayDate = [NSDate dateWithTimeInterval:(i-1)*24*60*60 sinceDate:beginDate];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
                [formatter setTimeZone:timeZone];
                [formatter setDateFormat:@"EEE - dd MMM"];
                
                NSString * dateStr = [formatter stringFromDate:dayDate];
                NSDictionary *dateDict = @{
                                           @"day":@"Day",
                                           @"dayNumber":[NSString stringWithFormat:@"%i",i],
                                           @"dateStr":dateStr
                                           };
                [listDate addObject:dateDict];
                
            }
            NSLog(@"日期卡片添加结果:%@", listDate);
            
            //通过数据库查询添加当前行程的所有景点
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Poi"];
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"journey = %@",myJourney];
            request.predicate = pre;
            NSSortDescriptor *tagSort = [NSSortDescriptor sortDescriptorWithKey:@"ordertag" ascending:YES];
            request.sortDescriptors = @[tagSort];
            
            NSError *error = nil;
            NSArray *pois = [[appDelegate.coreDataHelper context]
                             executeFetchRequest:request error:&error];
            NSLog(@"查询结果:%@", pois);
            if (!error && pois.count > 0) {
                [listPoi addObjectsFromArray:pois];
            }
            
        }
        
    }
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }
    return listPoi.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (isAdd) {
            return 80;
        }
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
        labelSectionTitle.text = [NSString stringWithFormat:@"%@ | %@ - %@ | Total %@ Days",myJourney.title,myJourney.from,myJourney.to,myJourney.day];
        
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
    
    static NSString *blackIndentifier = @"AddPoiViewBlackCell";
    UITableViewCell *blackCell = [tableView dequeueReusableCellWithIdentifier:blackIndentifier];
    if (!blackCell) {
        
        blackCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:blackIndentifier];
        blackCell.backgroundColor = [UIColor blackColor];
        
    }
    
    if (indexPath.section == 0) {
        
        dragCell.imgPoi.backgroundColor = [UIColor yellowColor];
        dragCell.labelTitle.text = self.addPoiData[@"name"];
        dragCell.labelAddress.text = self.addPoiData[@"address"];
        dragCell.viewScore.selectedColor = [UIColor blackColor];
        dragCell.viewScore.unSelectedBorderColor = [UIColor whiteColor];
        dragCell.viewScore.value = [self.addPoiData[@"score"] floatValue];
        
        if (isAdd == YES) {
            dragCell.hidden = YES;
        }else{
            dragCell.hidden = NO;
        }
        
        return dragCell;
        
    }else{
        
        if (indexPath.row != changeIndex) {
            
            normalCell.imgPoi.backgroundColor = [UIColor yellowColor];
            normalCell.poi = [listPoi objectAtIndex:indexPath.row];
            
            return normalCell;
            
        }else{
            
            return blackCell;
            
        }
        
    }
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        [self.view makeToast:@"长按可以进行拖动" duration:3.0 position:[NSValue valueWithCGPoint:CGPointMake(ScreenWidth/2.0, ScreenHeight-50)]];
        
        AddPoiViewDragCell *dragCell = (AddPoiViewDragCell *)[tableVPoi cellForRowAtIndexPath:indexPath];
        
        //弹簧动画
        dragCell.viewContent.transform = CGAffineTransformMakeTranslation(20, 0); //x轴左右移动
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
            dragCell.viewContent.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView*)tableView  editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath{
    
    if (indexPath.section == 1) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
    
}

//修改默认文字
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        Poi *poi = [listPoi objectAtIndex:indexPath.row];
        if ([poi.isdelete boolValue]) {
            return @"Add\nBack";
        }else{
            return @"Not\nGoing";
        }
        
    }
    
    return @"";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete && indexPath.section == 1){
        
        Poi *poi = [listPoi objectAtIndex:indexPath.row];
        poi.isdelete = @(![poi.isdelete boolValue]);
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        isChange = YES;
        
    }
    
}


#pragma mark - iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel{
    
    return listDate.count;
    
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    AddPoiDateCardView *cardView = (AddPoiDateCardView *)view;
    
    if ( !cardView ){
        
        cardView = [[AddPoiDateCardView alloc] initWithFrame:CGRectMake(0, 10, carousel.frame.size.height-20, carousel.frame.size.height-20)];
        
    }
    
    NSDictionary *dateDict = [listDate objectAtIndex:index];
    cardView.labelDay.text = dateDict[@"day"];
    cardView.labelDayNumber.text = dateDict[@"dayNumber"];
    cardView.labelDate.text = dateDict[@"dateStr"];
    
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
    
    if (isAdd == YES) {
        return;
    }
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:tableVPoi];
    NSIndexPath *indexPath = [tableVPoi indexPathForRowAtPoint:location];
    
    
    static UIView       *snapshot = nil;
    static NSIndexPath  *sourceIndexPath = nil;
    static BOOL isInsert = nil;
    static BOOL isMove = nil;
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath && indexPath.section == 0 && indexPath.row == 0) {
                sourceIndexPath = indexPath;
                
                AddPoiViewDragCell *cell = (AddPoiViewDragCell *)[tableVPoi cellForRowAtIndexPath:indexPath];
                
                snapshot = [self customSnapshoFromView:cell.viewContent];
                
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [tableVPoi addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    
                    cell.alpha = 0.0f;
                } completion:^(BOOL finished) {
                    cell.hidden = YES;
                }];
                isMove = YES;
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            
            if (!isMove) {
                break;
            }
            
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            NSLog(@"y:%@",@(center.y));
            
            if (center.y < 120+40) {
                
                NSLog(@"删除第一行:%@",@(changeIndex));
                if (isInsert && changeIndex ==0) {
                    [listPoi removeObjectAtIndex:changeIndex];
                    [tableVPoi deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
                    isInsert = nil;
                    changeIndex = -1;
                    sourceIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                }
                
            }else{
                
                if (!isInsert) {
                    [listPoi insertObject:@{} atIndex:0];
                    changeIndex = 0;
                    [tableVPoi insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
                    sourceIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                    isInsert = YES;
                }else{
                    
                    NSLog(@"交换行数:%@",@(changeIndex));
                    if (indexPath && ![indexPath isEqual:sourceIndexPath] && indexPath.section == 1) {
                        
                        changeIndex = indexPath.row;
                        [listPoi exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                        [tableVPoi moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                        sourceIndexPath = indexPath;
                        
                    }
                    
                }
                
            }
            
            break;
        }
            
        default: {
            
            if (!isMove) {
                break;
            }
            
            NSLog(@"最后松手");
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            if (center.y >= 120+40) {
                NSLog(@"添加到数据库:%@",@(changeIndex));
                if (!addPoi) {
                    addPoi = [NSEntityDescription insertNewObjectForEntityForName:@"Poi" inManagedObjectContext:[appDelegate.coreDataHelper context]];
                    addPoi.name = self.addPoiData[@"name"];
                    addPoi.adress = self.addPoiData[@"address"];
                    addPoi.journey = myJourney;
                    addPoi.score = @([self.addPoiData[@"score"] floatValue]);
                    addPoi.isdelete = @(YES);
                    addPoi.day = @(viewBottom.currentItemIndex + 1);
                    addPoi.ordertag = @(changeIndex);
                }
                
                [listPoi replaceObjectAtIndex:changeIndex withObject:addPoi];
                changeIndex = -1;
//                [tableVPoi reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sourceIndexPath.row inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
                
                isAdd = YES;
                isChange = YES;
                
                [tableVPoi reloadData];
                [self showToastAfterAddWithString:@"1 spot added.Updates are avaliable on your schedule"];
            }
            
            
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
            changeIndex = -1;
            sourceIndexPath = nil;
            isMove = nil;
            isInsert = nil;
            
            break;
        }
    }
    
}

- (IBAction)btnCloseAction:(id)sender {
    
    if (isChange) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"景点已经改变，是否放弃修改" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (IBAction)btnSaveAction:(id)sender {
    
    for (int i=0 ; i<listPoi.count; i++) {
        Poi *poi = [listPoi objectAtIndex:i];
        poi.ordertag = @(i+1);
    }
    
    [appDelegate.coreDataHelper saveContext];
    isChange = NO;
    
}

- (void)showToastAfterAddWithString:(NSString *)str{
    
    labelToast.hidden = NO;
    labelToast.frame = CGRectMake(0, 64, ScreenWidth, 0);
    labelToast.text = str;
    [self.view bringSubviewToFront:labelToast];
    
    __block id copySelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        labelToast.frame = CGRectMake(0, 64, ScreenWidth, 80);
    } completion:^(BOOL finished) {
        [copySelf performSelector:@selector(dismissToast) withObject:nil afterDelay:2.0];
    }];
    
}

- (void)dismissToast{
    
    [UIView animateWithDuration:0.5 animations:^{
        labelToast.frame = CGRectMake(0, 64, ScreenWidth, 0);
    } completion:^(BOOL finished) {
        labelToast.hidden = YES;
    }];
    
}

# pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        //取消所有数据库的修改
        [appDelegate.coreDataHelper.context rollback];
        [self dismissViewControllerAnimated:YES completion:nil];
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
