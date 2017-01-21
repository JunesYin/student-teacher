//
//  LyLandMarkManageViewController.m
//  teacher
//
//  Created by Junes on 16/8/11.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyLandMarkManageViewController.h"
#import "LyLandMarkCollectionViewCell.h"
#import "LyCollectionReusableView.h"

#import "LyAddressPicker.h"
#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"
#import "LyDistrict.h"

#import "NSMutableArray+SingleElement.h"

#import "LyUtil.h"


#import "LyAddLandMarkTableViewController.h"


CGFloat const btnAddressWidth = 150.0f;
CGFloat const btnAddressHeight = 50.0f;


CGFloat const cvLandMarksItemInterSapce = 2.0f;


CGFloat const viewToolBarHeight = 50.0f;



typedef NS_ENUM(NSInteger, LyLandMarkManageBarButtonItemMode)
{
    landMarkManageBarButtonItemMode_cancel = 0,
    landMarkManageBarButtonItemMode_edit,
    landMarkManageBarButtonItemMode_delete,
    landMarkManageBarButtonItemMode_selectAll,
    landMarkManageBarButtonItemMode_deselectAll
};


typedef NS_ENUM(NSInteger, LyLandMarkManageButtonMode)
{
    landMarkManageButtonMode_address = 10,
    landMarkManageButtonMode_add,
};


typedef NS_ENUM(NSInteger, LyLandMarkManageHttpMethod)
{
    landMarkManageHttpMethod_load = 100,
    landMarkManageHttpMethod_delete
};


@interface LyLandMarkManageViewController () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LyAddressPickerDelegate, LyHttpRequestDelegate, LyCollectionReusableViewDelegate, LyAddLandMarkDelegate>
{
    UIView                      *viewError;
    UIView                      *viewNull;
    
    UIBarButtonItem             *bbiCancel;
    UIBarButtonItem             *bbiSelectAll;
    UIBarButtonItem             *bbiEdit;
    
    BOOL                        isEditing;
    
    UIButton                    *btnAddress;
    UICollectionView            *cvLandMarks;
    
    NSArray                     *arrAddress;
    NSMutableArray              *arrDistricts;
    
    NSInteger                   curDistrictInx;
    NSArray                     *arrIdxs;
    
    UIRefreshControl            *refresher;
    LyIndicator                 *indicator_oper;
    LyIndicator                 *indicator;
    BOOL                        bHttpFlag;
    LyLandMarkManageHttpMethod  curHttpMethod;
    
}
@end

@implementation LyLandMarkManageViewController

static NSString *const landMarkManageCvCellReuseIdentifier = @"landMarkManageCvCellReuseIdentifier";
static NSString *const landMarkManageCvHeaderViewReuseIdentifier = @"landMarkManageCvHeaderViewReuseIdentifier";

static NSInteger cvLDItemCount;
static CGFloat cvLDItemWidth;
static CGFloat const cvLDItemHeight = 40.0f;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initAndLayoutSubviews];
}



- (void)viewWillAppear:(BOOL)animated {
    if (!arrDistricts || arrDistricts.count < 1) {
        arrAddress = [LyUtil separateString:[LyCurrentUser curUser].userAddress separator:@" "];
        if (arrAddress && arrAddress.count >= 2) {
            //        LyAddressPicker *ap = [LyAddressPicker addressPickerWithMode:LyAddressPickerMode_landMark];
            //        [ap setAddress:[LyCurrentUser curUser].userAddress];
            //        arrDistricts = ap.arrDistricts;
            
            [btnAddress setTitle:[[NSString alloc] initWithFormat:@"%@ %@", arrAddress[0], arrAddress[1]] forState:UIControlStateNormal];
        }
        
        [self load];
    }
}


- (void)initAndLayoutSubviews
{
    self.title = @"地标管理";
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    bbiEdit = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                                style:UIBarButtonItemStyleDone
                                               target:self
                                               action:@selector(targetForBarButtonItem:)];
    [bbiEdit setTag:landMarkManageBarButtonItemMode_edit];
    
    [self.navigationItem setRightBarButtonItems:@[bbiEdit]];
    
    
    
    btnAddress = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-btnAddressWidth-horizontalSpace, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, btnAddressWidth, btnAddressHeight)];
    [btnAddress.titleLabel setFont:LyFont(14)];
    [btnAddress setTag:landMarkManageButtonMode_address];
    [btnAddress setTitleColor:LyBlackColor forState:UIControlStateNormal];
    [btnAddress setTitle:@"请选择地址" forState:UIControlStateNormal];
    [btnAddress setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnAddress addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, btnAddress.ly_y+CGRectGetHeight(btnAddress.frame)-verticalSpace, SCREEN_WIDTH, verticalSpace)];
    [horizontalLine setBackgroundColor:[UIColor whiteColor]];
    

    [self.view addSubview:btnAddress];
    [self.view addSubview:horizontalLine];
    
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (SCREEN_WIDTH > 400) {
            cvLDItemCount = 4;
        } else if (SCREEN_WIDTH > 350) {
            cvLDItemCount = 4;
        } else {
            cvLDItemCount = 3;
        }
        
        cvLDItemWidth = ((SCREEN_WIDTH*9/10.0f-cvLandMarksItemInterSapce*(cvLDItemCount-1))/cvLDItemCount);
        
    });
    
    
    UICollectionViewFlowLayout *cvLandMarksFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [cvLandMarksFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [cvLandMarksFlowLayout setMinimumLineSpacing:verticalSpace];
    [cvLandMarksFlowLayout setMinimumInteritemSpacing:cvLandMarksItemInterSapce];
    
    cvLandMarks = [[UICollectionView alloc] initWithFrame:CGRectMake(0, btnAddress.ly_y+CGRectGetHeight(btnAddress.frame), SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT-btnAddressHeight)
                                     collectionViewLayout:cvLandMarksFlowLayout];
    [cvLandMarks setDelegate:self];
    [cvLandMarks setDataSource:self];
    [cvLandMarks setBackgroundColor:[UIColor whiteColor]];
    [cvLandMarks setAllowsMultipleSelection:YES];
    
    [cvLandMarks registerClass:[LyLandMarkCollectionViewCell class] forCellWithReuseIdentifier:landMarkManageCvCellReuseIdentifier];
    [cvLandMarks registerClass:[LyCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:landMarkManageCvHeaderViewReuseIdentifier];
    [self.view addSubview:cvLandMarks];
    
    
    [cvLandMarks addSubview:refresher = [LyUtil refreshControlWithTitle:nil target:self action:@selector(refresh:)]];
    
    
    arrDistricts = [NSMutableArray array];
}


- (void)reloadData {
    [self removeViewError];;
    [self removeViewNull];
    
    [self arrDistricts_singleElementAndSort];
    
    [cvLandMarks reloadData];
}


- (void)showViewError {
    if (!viewError) {
        viewError = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*1.1f)];
        [viewError setBackgroundColor:LyWhiteLightgrayColor];
        
        UILabel *lbError = [LyUtil lbErrorWithMode:1];
        [viewError addSubview:lbError];
        
        [lbError setUserInteractionEnabled:YES];
        [viewError setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForTapGestureFromViewError)];
        [viewError addGestureRecognizer:tap];
    }
    [cvLandMarks reloadData];
    [cvLandMarks addSubview:viewError];
    [cvLandMarks setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.05f)];
}
- (void)removeViewError {
    [viewError removeFromSuperview];
    for (UIGestureRecognizer *gesture in viewError.gestureRecognizers) {
        [viewError removeGestureRecognizer:gesture];
    }
    viewError = nil;
}


- (void)showViewNull {
    if (!viewNull) {
        viewNull = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*1.1f)];
        [viewNull setBackgroundColor:LyWhiteLightgrayColor];
        
        UILabel *lbNull = [LyUtil lbNullWithText:@"还没有地标\n点击可刷新"];
        [viewNull addSubview:lbNull];
        
        [lbNull setUserInteractionEnabled:YES];
        [viewNull setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForTapGestureFromViewNull)];
        [viewNull addGestureRecognizer:tap];
    }
    
    [cvLandMarks reloadData];
    [cvLandMarks addSubview:viewNull];
    [cvLandMarks setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.05f)];
}

- (void)removeViewNull {
    [viewNull removeFromSuperview];
    for (UIGestureRecognizer *gesture in viewNull.gestureRecognizers) {
        [viewNull removeGestureRecognizer:gesture];
    }
    viewNull = nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)arrDistricts_singleElementAndSort {
    [arrDistricts singleElementByKey:@"dId"];
    
    [arrDistricts sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [[LyUtil getPinyinFromHanzi:[obj1 dName]] compare:[LyUtil getPinyinFromHanzi:[obj2 dName]]];
    }];
}


- (void)targetForTapGestureFromViewError {
    [self load];
}

- (void)targetForTapGestureFromViewNull {
    [self load];
}


- (void)changeBbiEdit:(LyLandMarkManageBarButtonItemMode)mode {
    if (landMarkManageBarButtonItemMode_edit == mode) {
        //当前为编辑状态，设置为展示状态
        [bbiEdit setTitle:@"编辑"];
        [bbiEdit setTag:landMarkManageBarButtonItemMode_edit];
        
        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
        [self.navigationItem setRightBarButtonItems:@[bbiEdit] animated:YES];
        
        isEditing = NO;
        bbiSelectAll = nil;
        [self reloadData];
    }
    else if (landMarkManageBarButtonItemMode_delete == mode) {
        //当前为展示状态，设置为编辑状态
        [bbiEdit setTitle:@"删除"];
        [bbiEdit setTag:landMarkManageBarButtonItemMode_delete];
        
        if (!bbiCancel)
        {
            bbiCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                         style:UIBarButtonItemStyleDone
                                                        target:self
                                                        action:@selector(targetForBarButtonItem:)];
            [bbiCancel setTag:landMarkManageBarButtonItemMode_cancel];
        }
        
        if (!bbiSelectAll) {
            bbiSelectAll = [[UIBarButtonItem alloc] initWithTitle:@"全选"
                                                            style:UIBarButtonItemStyleDone
                                                           target:self
                                                           action:@selector(targetForBarButtonItem:)];
            [bbiSelectAll setTag:landMarkManageBarButtonItemMode_selectAll];
        }
        
        [self.navigationItem setLeftBarButtonItem:bbiCancel animated:YES];
        [self.navigationItem setRightBarButtonItems:@[bbiEdit, bbiSelectAll] animated:YES];
        isEditing = YES;
        
        [self reloadData];
    }
}


- (void)changeBbiSelectAll:(LyLandMarkManageBarButtonItemMode)mode {
    if (landMarkManageBarButtonItemMode_selectAll == mode) {
        //当前为全选状态，设置为不全选状态
        [bbiSelectAll setTag:landMarkManageBarButtonItemMode_selectAll];
        [bbiSelectAll setTitle:@"全选"];
        for (NSInteger i = 0; i < [cvLandMarks numberOfSections]; ++i) {
            for (NSInteger j = 0; j < [cvLandMarks numberOfItemsInSection:i]; ++j) {
                [cvLandMarks deselectItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i] animated:NO];
            }
        }
    }
    else if (landMarkManageBarButtonItemMode_deselectAll == mode) {
        //当前为不全选状态，设置为全选状态
        [bbiSelectAll setTag:landMarkManageBarButtonItemMode_deselectAll];
        [bbiSelectAll setTitle:@"取消全选"];
        for (NSInteger i = 0; i < [cvLandMarks numberOfSections]; ++i) {
            for (NSInteger j = 0; j < [cvLandMarks numberOfItemsInSection:i]; ++j) {
                [cvLandMarks selectItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            }
        }
    }
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi
{
    if (landMarkManageBarButtonItemMode_cancel == bbi.tag){
        [self changeBbiEdit:landMarkManageBarButtonItemMode_edit];      //更改为展示状态
    }
    else if (landMarkManageBarButtonItemMode_edit == bbi.tag) {
        [self changeBbiEdit:landMarkManageBarButtonItemMode_delete];    //更改为编辑状态
    }
    else if (landMarkManageBarButtonItemMode_delete == bbi.tag) {
        arrIdxs = [cvLandMarks indexPathsForSelectedItems];
        if (!arrIdxs || arrIdxs.count < 1) {
            [self changeBbiEdit:landMarkManageBarButtonItemMode_edit];  //更改为展示状态
            return;
        }
        
        NSString *message;
        NSIndexPath *idx = [arrIdxs objectAtIndex:0];
        if (arrIdxs.count > 1) {
            message = [[NSString alloc] initWithFormat:@"确定删除「%@」等%ld个地标吗？", [[[[arrDistricts objectAtIndex:idx.section] dArrLandMark] objectAtIndex:idx.row] lmName], arrIdxs.count];
        } else {
            message = [[NSString alloc] initWithFormat:@"确定删除「%@」吗？", [[[[arrDistricts objectAtIndex:idx.section] dArrLandMark] objectAtIndex:idx.row] lmName]];
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除地标"
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleCancel
                                                handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"删除"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    [self delete];
                                                }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else if (landMarkManageBarButtonItemMode_selectAll == bbi.tag) {
        [self changeBbiSelectAll:landMarkManageBarButtonItemMode_deselectAll];  //更改为全选状态
    }
    else if (landMarkManageBarButtonItemMode_deselectAll == bbi.tag) {
        [self changeBbiSelectAll:landMarkManageBarButtonItemMode_selectAll];    //更改为不全选状态
        
    }
}


- (void)targetForButton:(UIButton *)button {
    if (landMarkManageButtonMode_address == button.tag) {
        LyAddressPicker *addressPicker = [LyAddressPicker addressPickerWithMode:LyAddressPickerMode_landMark];
        [addressPicker setDelegate:self];
        [addressPicker setAddress:btnAddress.titleLabel.text];
        [addressPicker show];
    } else if (landMarkManageButtonMode_add == button.tag) {
        LyAddLandMarkTableViewController *addLandMark = [[LyAddLandMarkTableViewController alloc] init];
        [self.navigationController pushViewController:addLandMark animated:YES];
    }
}


- (void)refresh:(UIRefreshControl *)rc {
    [self load];
}


- (void)load {
    
    if (!arrAddress || arrAddress.count < 2) {
        [refresher endRefreshing];
        return;
    }
    
    if (!indicator) {
        indicator = [LyIndicator indicatorWithTitle:nil];
    }
    [indicator startAnimation];
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:landMarkManageHttpMethod_load];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:landMarkManage_url
                                 body:@{
                                       cityKey:[arrAddress[1] substringToIndex:[arrAddress[1] length]-1],
                                       userTypeKey:[[LyCurrentUser curUser] userTypeByString],
                                       userIdKey:[LyCurrentUser curUser].userId,
                                       sessionIdKey:[LyUtil httpSessionId]
                                       }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


- (void)delete {
    if (!indicator_oper) {
        indicator_oper = [LyIndicator indicatorWithTitle:LyIndicatorTitle_delete];
    } else {
        [indicator_oper setTitle:LyIndicatorTitle_delete];
    }
    [indicator_oper startAnimation];
    
    NSString *strCity;
    if (arrAddress && arrAddress.count > 1) {
        strCity = [arrAddress objectAtIndex:1];
        strCity = [strCity substringToIndex:strCity.length - 1];
    } else {
        strCity = @"";
    }
    
    
    NSMutableString *strLandMark = [[NSMutableString alloc] initWithString:@""];
    for (int i = 0; i < arrDistricts.count; ++i) {
        LyDistrict *district = arrDistricts[i];
        if (!district) {
            continue;
        }
        
        for (int j = 0; j < district.dArrLandMark.count; ++j) {
            LyLandMark *landMark = district.dArrLandMark[j];
            if (!landMark) {
                continue;
            }
            
            NSInteger idx = [arrIdxs indexOfObject:[NSIndexPath indexPathForRow:j inSection:i]];
            if (0 <= idx && idx <= arrIdxs.count) {
                continue;
            }
            
            [strLandMark appendFormat:@"%@,", landMark.lmId];
        }
        
    }
    
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:landMarkManageHttpMethod_delete];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:operateLandMark_url
                                 body:@{
                                        cityKey:strCity,
                                        landMarkIdKey:strLandMark,
                                        userIdKey:[LyCurrentUser curUser].userId,
                                        userTypeKey:[[LyCurrentUser curUser] userTypeByString],
                                        sessionIdKey:[LyUtil httpSessionId]
                                        }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


- (void)handleHttpFailed {
    
    if ([indicator isAnimating]) {
        [indicator stopAnimation];
        [refresher endRefreshing];
        [self showViewError];
    }
    
    if ([indicator_oper isAnimating]) {
        [indicator_oper stopAnimation];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"删除失败"] show];
    }
}


- (void)analysisHttpResult:(NSString *)result {
    NSDictionary *dic = [LyUtil getObjFromJson:result];
    if (!dic || ![LyUtil validateDictionary:dic]) {
        [self handleHttpFailed];
        return;
    }
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if (!strCode || ![LyUtil validateString:strCode]) {
        [self handleHttpFailed];
        return;
    }
    
    if (codeTimeOut == [strCode integerValue]) {
        [indicator stopAnimation];
        [indicator_oper stopAnimation];
        [refresher endRefreshing];
        
        [LyUtil sessionTimeOut];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator stopAnimation];
        [indicator_oper stopAnimation];
        [refresher endRefreshing];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    switch (curHttpMethod) {
        case landMarkManageHttpMethod_load: {
            
            [arrDistricts removeAllObjects];
            
            switch ([strCode integerValue]) {
                case 0: {
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    if (!arrResult || ![LyUtil validateArray:arrResult]) {
                        [indicator stopAnimation];
                        [refresher endRefreshing];
                        [self showViewNull];
                        return;
                    }
                    
                    for (NSDictionary *itemDistrict in arrResult) {
                        if (!itemDistrict || ![LyUtil validateDictionary:itemDistrict]) {
                            continue;
                        }
                        
                        NSString *strDistriceId = [itemDistrict objectForKey:idKey];
                        NSString *strDistrictName = [itemDistrict objectForKey:districtNameKey];
                        LyDistrict *district = [LyDistrict distirctWithId:strDistriceId
                                                                     name:strDistrictName];
                        
                        district.cityName = [arrAddress[1] substringToIndex:[arrAddress[1] length]-1];
                        
                        [arrDistricts addObject:district];
                        
                        NSArray *arrLandMark = [itemDistrict objectForKey:landKey];
                        if (!arrLandMark || ![LyUtil validateArray:arrLandMark]) {
                            continue;
                        }
                        for (NSDictionary *itemLandMark in arrLandMark) {
                            if (!itemDistrict || ![LyUtil validateDictionary:itemDistrict]) {
                                continue;
                            }
                            
                            NSString *strLandMarkId = [itemLandMark objectForKey:idKey];
                            NSString *strLandMarkName = [itemLandMark objectForKey:landNameKey];
                            
                            LyLandMark *landmark = [LyLandMark landMarkWithId:strLandMarkId
                                                                         name:strLandMarkName];
                            [district addLandMark:landmark];
                        }
                    }
                    
                    [self reloadData];
                    
                    [indicator stopAnimation];
                    [refresher endRefreshing];
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case landMarkManageHttpMethod_delete: {
            switch ([strCode integerValue]) {
                case 0: {
//                    [arrDistricts removeAllObjects];
//                    
//                    NSArray *arrResult = [dic objectForKey:resultKey];
//                    if (!arrResult || ![LyUtil validateArray:arrResult]) {
//                        [indicator_oper stopAnimation];
//                        [refresher endRefreshing];
//                        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"删除失败"] show];
//                        
//                        return;
//                    }
//                    
//                    for (NSDictionary *itemDistrict in arrResult) {
//                        if (!itemDistrict || ![LyUtil validateDictionary:itemDistrict]) {
//                            continue;
//                        }
//                        
//                        NSString *strDistriceId = [itemDistrict objectForKey:idKey];
//                        NSString *strDistrictName = [itemDistrict objectForKey:districtNameKey];
//                        LyDistrict *district = [LyDistrict distirctWithId:strDistriceId
//                                                                     name:strDistrictName];
//                        
//                        [arrDistricts addObject:district];
//                        
//                        NSArray *arrLandMark = [itemDistrict objectForKey:landKey];
//                        if (!arrLandMark || ![LyUtil validateArray:arrLandMark]) {
//                            continue;
//                        }
//                        for (NSDictionary *itemLandMark in arrLandMark) {
//                            if (!itemDistrict || ![LyUtil validateDictionary:itemDistrict]) {
//                                continue;
//                            }
//                            
//                            NSString *strLandMarkId = [itemLandMark objectForKey:idKey];
//                            NSString *strLandMarkName = [itemLandMark objectForKey:landNameKey];
//                            
//                            LyLandMark *landmark = [LyLandMark landMarkWithId:strLandMarkId
//                                                                         name:strLandMarkName];
//                            [district addLandMark:landmark];
//                        }
//                    }
                    
                    for (NSIndexPath *indexPath in arrIdxs) {
                        if (!indexPath) {
                            continue;
                        }
                        
                        LyDistrict *district = arrDistricts[indexPath.section];
                        if (!district || ![LyUtil validateArray:district.dArrLandMark]) {
                            continue;
                        }
                        
                        [district.dArrLandMark removeObjectAtIndex:indexPath.row];
                    }
                    
                    [self reloadData];
                    [self targetForBarButtonItem:bbiCancel];
                    
                    [indicator_oper stopAnimation];
                    [refresher endRefreshing];
                    [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"删除成功"] show];
                    
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        default: {
            [self handleHttpFailed];
            break;
        }
    }
    
}


#pragma mark -LyHttpReqeustDelegate
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest {
    if (bHttpFlag) {
        bHttpFlag = NO;
        [self handleHttpFailed];
    }
    curHttpMethod = 0;
}

- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result {
    if (bHttpFlag) {
        bHttpFlag = NO;
        curHttpMethod = ahttpRequest.mode;
        
        [self analysisHttpResult:result];
    }
    
    curHttpMethod = 0;
}


#pragma mark -LyAddressPicker
- (void)onAddressPickerCancel:(LyAddressPicker *)addressPicker {
    [addressPicker hide];
}


- (void)onAddressPickerDone:(NSString *)address addressPicker:(LyAddressPicker *)addressPicker {
    [addressPicker hide];
    
    if (![address isEqualToString:btnAddress.titleLabel.text]) {
        [btnAddress setTitle:address forState:UIControlStateNormal];
        arrAddress = [LyUtil separateString:address separator:@" "];

        [self load];
    }
}


#pragma mark -LyAddLandMarkDelegate
- (NSDictionary *)landMarkInfoByAddLandMarkTVC:(LyAddLandMarkTableViewController *)aAddLandMarkTVC {
//    return [arrDistricts objectAtIndex:curDistrictInx];
    return @{
             landMarkKey : arrDistricts,
             districtKey : [arrDistricts objectAtIndex:curDistrictInx]
             };
}

- (void)onDoneAddLandMark:(LyAddLandMarkTableViewController *)aAddLandMarkVC landMarks:(NSArray *)landMarks {
    [aAddLandMarkVC.navigationController popViewControllerAnimated:YES];
    
    [self reloadData];
}


#pragma mark -LyCollectionReusableViewDelegate
- (void)onClickButtonFuncByCollectionReusableView:(LyCollectionReusableView *)aCrv {
    curDistrictInx = aCrv.tag;
    
    LyAddLandMarkTableViewController *addLandMark = [[LyAddLandMarkTableViewController alloc] init];
    [addLandMark setDelegate:self];
    [self.navigationController pushViewController:addLandMark animated:YES];
}




#pragma mark -UICollectionViewDelegate
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//}


#pragma mark -UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return arrDistricts.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[arrDistricts objectAtIndex:section] dArrLandMark] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LyLandMarkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:landMarkManageCvCellReuseIdentifier forIndexPath:indexPath];
    
    if (cell) {
        [cell setLandMark:[[[arrDistricts objectAtIndex:indexPath.section] dArrLandMark] objectAtIndex:indexPath.row] editing:isEditing];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        LyCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                  withReuseIdentifier:landMarkManageCvHeaderViewReuseIdentifier
                                                                                         forIndexPath:indexPath];
//        if (arrDistricts.count < indexPath.section) {
//            return nil;
//        }
        
        LyDistrict *district = [arrDistricts objectAtIndex:indexPath.section];
        NSMutableString *strText = [[NSMutableString alloc] initWithString:district.dName];
        if (district.dArrLandMark && district.dArrLandMark.count > 0) {
            [strText appendFormat:@"（%ld）", district.dArrLandMark.count];
        }
        
        [headerView setTitle:strText];
        [headerView setFunc:@"添加"];
        [headerView setTag:indexPath.section];
        [headerView setBackgroundColor:LyWhiteLightgrayColor];
        [headerView setDelegate:self];
        [headerView setFuncHide:isEditing];
        reusableview = headerView;
    }
    
    return reusableview;
}


#pragma mark -UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(cvLDItemWidth, cvLDItemHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(verticalSpace, SCREEN_WIDTH/10.0f, verticalSpace*2, 0);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, LyCollectionReusableViewHeight);
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
