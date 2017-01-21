//
//  LyDriveSchoolViewController.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/31.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyDriveSchoolViewController.h"
#import "LyDriveSchoolTableViewCell.h"
#import "LyBottomControl.h"

#import "LyFloatView.h"
#import "LyTableViewFooterView.h"
#import "LyAddressPicker.h"
#import "LyActivity.h"
#import "LySortModePicker.h"

#import "LyRemindView.h"
#import "LyIndicator.h"

#import "LyUserManager.h"
#import "LyCurrentUser.h"


#import "UIViewController+CloseSelf.h"
#import "LyUtil.h"

#import "student-Swift.h"
#import <WebKit/WebKit.h>


#import "LySchoolDetailViewController.h"
#import "LyLoginViewController.h"


#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>



#import "LyBMKPointAnnotaion.h"
#import "LyBMKActionPaopaoView.h"



CGFloat const listOptionHeight = 50.0f;
CGFloat const lbListOptionWidth = 60.0f;
CGFloat const btnListOptionWidth = 100.0f;


//#define tvHeight                                  (SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT)


NSString *const annotationReuseIdentifierForDriveSchool = @"annotationReuseIdentifierForDriveSchool";

typedef NS_ENUM(NSInteger, LyDriveSchoolBarButtonItemTag) {
    driveSchoolBarButtonItemTag_msg = 10,
};


typedef NS_ENUM( NSInteger, LyDriveSchoolButtonMode) {
    driveSchoolButtonMode_option = 20
};



typedef NS_ENUM( NSInteger, LyDriveSchoolHttpMethod) {
    driveSchoolHttpMethod_null = 0,
    driveSchoolHttpMethod_load = 100,
    driveSchoolHttpMethod_loadMore,
    driveSchoolHttpMethod_search
    
};




@interface LyDriveSchoolViewController () < BMKMapViewDelegate, LyFloatViewDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, LySchoolDetailViewControllerDelegate, LyHttpRequestDelegate, LyTableViewFooterViewDelegate, LyActivityDelegate, LyAddressPickerDelegate, LySortModePickerDelegate>
{
    BOOL                                flagBusy;
    BOOL                                flagForDelayAddAnnonation;
    
    BOOL                                flagForShowMapOfChina;
    BOOL                                flagForMapJump;
    BOOL                                flagForMapSetCenter;
    
    
    BOOL                                flagForMapSearchJump;
    BOOL                                flagSetcurCoordinate;
    CLLocationCoordinate2D              curCoordinate;
    
    
    LyIndicator                         *indicator_search;
    
//    LyLocateMode                        locateMode;
    NSString                            *curAddressStr;
    NSArray                             *curAddress;
    
    
    BMKMapView                          *baiduMapView;
//@property (strong, nonatomic)       UITableView         *tableView;
    UIView                              *viewHeader;
    UIButton                            *btnListOption;
    
//@property (strong, nonatomic)       UIRefreshControl    *refreshControl;
//    LyTableViewFooterView               *tvFooterView;
    
    
    NSArray                             *arrSchools;
    NSIndexPath                         *curIdx_school;
    NSString                            *lastDschId;
    
    
    NSMutableArray                      *arrSchools_search;
    
    
    NSInteger                           autoLoadMoreCount;
    
    UIImage                             *iconLandMark;
    
    NSMutableArray                      *arrNeedAdd;
    LyIndicator                         *indicator_add;
    BOOL                                bHttpFlag;
    LyDriveSchoolHttpMethod             curHttpMethod;
}

@property (strong, nonatomic)       UITableView             *tableView;
@property (strong, nonatomic)       UIRefreshControl        *refreshControl;
@property (strong, nonatomic)       LyTableViewFooterView   *tvFooterView;

@property (assign, nonatomic)       LyLocateMode            curLocateMode;
@property (assign, nonatomic)       LySortMode              curSortMode;
@property (assign, nonatomic)       LyMapAddAnnonationMode  mapAddAnnonationMode;

@end

@implementation LyDriveSchoolViewController

lySingle_implementation(LyDriveSchoolViewController)

static NSString *lyDriveSchoolTableViewCellReuseIdentifier = @"lyDriveSchoolTableViewCellReuseIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self dsInitAndLayoutUI];
}



- (void)viewWillAppear:(BOOL)animated {
    
    [[self.tabBarController tabBar] setHidden:YES];

    [baiduMapView viewWillAppear];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(targetForNotificationForLocationChanged:)
                                                 name:LyNotificationForLocationChanged
                                               object:nil];
    
    [self.tableView reloadData];
}






- (void)viewDidAppear:(BOOL)animated {
    
    [LyUtil ready:YES target:self];
    
    [[LyBottomControl sharedInstance] setHidden:NO];
    [baiduMapView setDelegate:self];
    
    
    [[LyActivity sharedInstance] setDelegate:self];
    [viewHeader addSubview:[LyActivity sharedInstance]];
    
    if ( !flagForShowMapOfChina) {
        [baiduMapView setRegion:LyRegionForMapOfChina];
        [self performSelector:@selector(delayToSetFlagForShowMapOfChina) withObject:nil afterDelay:2.0f];
    }
    
    
    if ( flagForDelayAddAnnonation) {
        flagForDelayAddAnnonation = NO;
        
        [self performSelector:@selector(dschAddAnnonationToMapView:) withObject:nil afterDelay:0.5f];
    }
}



- (void)viewWillDisappear:(BOOL)animated {
    
    [[self.tabBarController tabBar] setHidden:YES];
    [[LyBottomControl sharedInstance] setHidden:YES];
    
    
    [baiduMapView setDelegate:nil];
    [baiduMapView viewWillDisappear];
    
    [[LyActivity sharedInstance] setDelegate:nil];
    [[LyActivity sharedInstance] removeFromSuperview];
    
    if (indicator_add && [indicator_add isAnimating])
    {
        [indicator_add stopAnimation];
    }
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LyNotificationForLocationChanged object:nil];
    
}


- (void)viewDidDisappear:(BOOL)animated {
    [[LyBottomControl sharedInstance] setHidden:YES];
}


- (void)dsInitAndLayoutUI {
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:LyWhiteLightgrayColor];
    
//    [[self.navigationController.navigationBar layer] setShadowColor:[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f] CGColor]];
//    [[self.navigationController.navigationBar layer] setShadowOffset:CGSizeMake( 0, 3.0f)];
//    [[self.navigationController.navigationBar layer] setShadowOpacity:0.5f];
//    [[self.navigationController.navigationBar layer] setShadowRadius:3.0f];
    
    UIBarButtonItem *bbiLeft_Menu = [LyUtil barButtonItem:0
                                                imageName:@"navigationBar_left"
                                                   target:self
                                                   action:@selector(presentLeftMenuViewController:)];
    UIBarButtonItem *bbiLeft_hyaline = [LyUtil barButtonItem:0
                                                   imageName:@"navigationBar_hyaline"
                                                      target:nil
                                                      action:nil];
    UIBarButtonItem *bbiRight_menu = [LyUtil barButtonItem:0
                                                 imageName:@"navigationBar_right"
                                                    target:self
                                                    action:@selector(presentRightMenuViewController:)];
    UIBarButtonItem *bbiRight_msg = [LyUtil barButtonItem:driveSchoolBarButtonItemTag_msg
                                                imageName:@"navigationBar_msg"
                                                   target:self
                                                   action:@selector(targetForBarButtonItem:)];
    
    
    
    
    UIImageView *ivNavTitle = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, 0, 44)];
    [ivNavTitle setImage:[LyUtil imageForImageName:@"navigationBar_center" needCache:NO]];
    [ivNavTitle setContentMode:UIViewContentModeScaleAspectFit];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetForNavigationItemCenter517Icon:)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [ivNavTitle setUserInteractionEnabled:YES];
    [ivNavTitle addGestureRecognizer:tapGesture];
    
    [self.navigationItem setTitleView:ivNavTitle];
    [self.navigationItem setLeftBarButtonItems:@[bbiLeft_Menu, bbiLeft_hyaline]];
    [self.navigationItem setRightBarButtonItems:@[bbiRight_menu, bbiRight_msg]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    

    //地图
    baiduMapView = [[BMKMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [baiduMapView setLogoPosition:BMKLogoPositionLeftTop];
    baiduMapView.showsUserLocation = YES;
    [baiduMapView setTrafficEnabled:NO];
    
    
    //修改定位图标
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
    param.isAccuracyCircleShow = NO;
    if ( SCREEN_WIDTH > 400) {
        param.locationViewImgName = @"baiduMap_avatar_414";
    } else if ( SCREEN_WIDTH > 350) {
        param.locationViewImgName = @"baiduMap_avatar_375";
    } else {
        param.locationViewImgName = @"baiduMap_avatar_320";
    }
    [baiduMapView updateLocationViewWithParam:param];
    [baiduMapView setShowMapScaleBar:YES];
    [baiduMapView setMapScaleBarPosition:CGPointMake( 10, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT+horizontalSpace)];
    
    
    
    //列表
    //列表头view
    viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, svActivityHeight+listOptionHeight)];
    //列表头view文字
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake( horizontalSpace, svActivityHeight, lbListOptionWidth, listOptionHeight)];
    [lbTitle setText:@"驾校"];
    [lbTitle setTextColor:LyBlackColor];
    [lbTitle setFont:LyListTitleFont];
    [lbTitle setTextAlignment:NSTextAlignmentLeft];
    //列表头view-按钮
    btnListOption = [[UIButton alloc] initWithFrame:CGRectMake( SCREEN_WIDTH-btnListOptionWidth-horizontalSpace, svActivityHeight, btnListOptionWidth, listOptionHeight)];
    btnListOption.tag = driveSchoolButtonMode_option;
    [btnListOption setTitle:@"推荐排序" forState:UIControlStateNormal];
    [btnListOption setTitleColor:LyBlackColor forState:UIControlStateNormal];
    [btnListOption setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [[btnListOption titleLabel] setFont:LyListSortModeFont];
    [btnListOption setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnListOption addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    //列表头view-底部横线
    UIView *horizontalLine_header = [[UIView alloc] initWithFrame:CGRectMake( 0, CGRectGetHeight(viewHeader.frame)-1, SCREEN_WIDTH, 1)];
    [horizontalLine_header setBackgroundColor:[UIColor lightGrayColor]];
    
    [viewHeader addSubview:lbTitle];
    [viewHeader addSubview:btnListOption];
    [viewHeader addSubview:horizontalLine_header];
    
    //驾校列表
    
    //悬浮窗
    LyFloatView *floatView = [LyFloatView floatViewWithIconMap:[LyUtil imageForImageName:@"ft_map" needCache:NO]
                                                      iconList:[LyUtil imageForImageName:@"ft_list" needCache:NO]];
    [floatView setFrame:CGRectMake(SCREEN_WIDTH - LyFloatViewDefaultSize, SCREEN_HEIGHT/2.0f - LyFloatViewDefaultSize / 2.0f, LyFloatViewDefaultSize, LyFloatViewDefaultSize)];
    [floatView setDelegate:self];
    [floatView setDefaultMode:LyFloatViewMode_map];
    
    
    [self.view addSubview:baiduMapView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:floatView];
    
    
    [baiduMapView setHidden:NO];
    [self.tableView setHidden:YES];
    
    
    _curLocateMode = LyLocateMode_auto;
    
    [[LyCurrentUser curUser].location addObserver:self forKeyPath:@"address" options:NSKeyValueObservingOptionNew context:nil];
}



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUSBAR_HEIGHT-NAVIGATIONBAR_HEIGHT)
                                                  style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setTableHeaderView:viewHeader];
        
        [_tableView addSubview:self.refreshControl];
        
        
        [_tableView setTableFooterView:self.tvFooterView];
    }
    
    return _tableView;
}


- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [LyUtil refreshControlWithTitle:nil target:self action:@selector(refreshDriveListInfo:)];
    }
    
    return _refreshControl;
}


- (LyTableViewFooterView *)tvFooterView {
    if (!_tvFooterView) {
        _tvFooterView = [[LyTableViewFooterView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, tvFooterViewHeight)];
        [_tvFooterView setDelegate:self];
    }
    
    return _tvFooterView;
}



- (void)dschAddAnnonationToMapView:(__kindof NSArray *)aArr {
    
    if ( ![self isVisiable]) {
        flagForDelayAddAnnonation = YES;
        return;
    }
    
    flagBusy = YES;
    
    if ( !aArr) {
        [baiduMapView removeAnnotations:[baiduMapView annotations]];
    }
    
    switch (_mapAddAnnonationMode) {
        case LyMapAddAnnonationMode_all: {
            
            if ( !aArr) {
                aArr = arrSchools;
            }
            
            for ( int i = 0; i < [aArr count]; ++i) {
                LyDriveSchool *tmpItem = [aArr objectAtIndex:i];
                
                for (LyLandMark *landMark in tmpItem.arrLandMark) {
                    if ( !landMark) {// || landMark.distance > showIconInMapMaxDistance) {
                        continue;
                    }
                    
                    int flag = arc4random() % 2;
                    float randLatitude =  arc4random() % coordinateRandBase;
                    float randLongtitude = arc4random() % coordinateRandBase;
                    
                    if ( 0 == flag) {
                        randLatitude = 0.0f - randLatitude;
                        randLongtitude = 0.0f - randLongtitude;
                    }
                    CLLocationCoordinate2D coordinate = {landMark.coordinate.latitude+randLatitude/coordinateRandBase_search, landMark.coordinate.longitude+randLongtitude/coordinateRandBase_search};
                    
                    LyBMKPointAnnotaion *annotation = [[LyBMKPointAnnotaion alloc] init];
                    //                    [annotation setCoordinate:landMark.coordinate];
                    [annotation setCoordinate:coordinate];
                    [annotation setTitle:[tmpItem userName]];
                    
                    [annotation setObjectId:[tmpItem userId]];
                    [annotation setScore:[tmpItem score]];
                    //                    [annotation setPrice:[tmpItem dschPrice]];
                    
                    [baiduMapView addAnnotation:annotation];
                }
            }
            
            [indicator_add performSelector:@selector(stopAnimation) withObject:nil afterDelay:1.0f];
            
            break;
        }
        case LyMapAddAnnonationMode_search: {
            
            for ( int i = 0; i < [arrSchools_search count]; ++i) {
                
                LyDriveSchool *tmpItem = [arrSchools_search objectAtIndex:i];
                for (LyLandMark *landMark in tmpItem.arrLandMark) {
                    if ( !landMark) {
                        continue;
                    }
                    
                    int flag = arc4random() % 2;
                    float randLatitude =  arc4random() % coordinateRandBase;
                    float randLongtitude = arc4random() % coordinateRandBase;
                    
                    if ( 0 == flag) {
                        randLatitude = 0.0f - randLatitude;
                        randLongtitude = 0.0f - randLongtitude;
                    }
                    CLLocationCoordinate2D coordinate = {landMark.coordinate.latitude+randLatitude/coordinateRandBase_search, landMark.coordinate.longitude+randLongtitude/coordinateRandBase_search};
                    
                    LyBMKPointAnnotaion *annotation = [[LyBMKPointAnnotaion alloc] init];
                    [annotation setCoordinate:coordinate];
                    //                    [annotation setCoordinate:landMark.coordinate];
                    [annotation setTitle:[tmpItem userName]];
                    
                    [annotation setObjectId:[tmpItem userId]];
                    [annotation setScore:[tmpItem score]];
                    //                    [annotation setPrice:[tmpItem dschPrice]];
                    
                    [baiduMapView addAnnotation:annotation];
                }
            }
            
            [self jumpToSearchLocation];
            break;
        }
    }
    
    flagBusy = NO;
}


- (void)reloadData {
    
    [self setCurSortMode:_curSortMode];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi {
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(targetForBarButtonItem:) object:bbi];
        
        return;
    }
    
    LyDriveSchoolBarButtonItemTag bbiTag = (LyDriveSchoolBarButtonItemTag)bbi.tag;
    switch (bbiTag) {
        case driveSchoolBarButtonItemTag_msg: {
            LyMsgCenterTableViewController *msgCenter = [[LyMsgCenterTableViewController alloc] init];
            [self.navigationController pushViewController:msgCenter animated:YES];
            break;
        }
    }
}

- (void)setCurSortMode:(LySortMode)curSortMode {
    _curSortMode = curSortMode;
    
    [btnListOption setTitle:[LyUtil sortModeStringFrom:_curSortMode] forState:UIControlStateNormal];
    
    if (LyMapAddAnnonationMode_all == _mapAddAnnonationMode) {
        
        if (LySortMode_none == _curSortMode) {
            arrSchools = [[LyUserManager sharedInstance] getAllDriveSchool];
        } else {
            arrSchools = [LyUtil sortTeacherArr:arrSchools sortMode:_curSortMode];
        }
    }
    
    [self.tableView reloadData];
}

- (void)setMapAddAnnonationMode:(LyMapAddAnnonationMode)mapAddAnnonationMode {
    _mapAddAnnonationMode = mapAddAnnonationMode;
    
    [btnListOption setEnabled:(LyMapAddAnnonationMode_all == _mapAddAnnonationMode)];
    [self.tvFooterView setHidden:(LyMapAddAnnonationMode_all != _mapAddAnnonationMode)];
}


- (void)setCurLocateMode:(LyLocateMode)curLocateMode {
    _curLocateMode = curLocateMode;
    
    [self setMapAddAnnonationMode:LyMapAddAnnonationMode_all];
    [self setCurSortMode:_curSortMode];
    
}


- (void)delayToSetFlagForShowMapOfChina {
    flagForShowMapOfChina = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:LyNofiticationForRequestLocate object:nil];
}



- (void)updateBtnAddressTitle:(NSString *)strAddress {
    
    curAddressStr = strAddress;
    curAddress = [LyUtil separateString:curAddressStr separator:@" "];
    
    if ( curAddress && [curAddress count] > 2 && [[curAddress objectAtIndex:2] isKindOfClass:[NSString class]] && ![[curAddress objectAtIndex:2] isEqualToString:@""])
    {
        [[LyBottomControl sharedInstance] setBtnAddressDriveSchoolTitle:[curAddress objectAtIndex:2]];
    }
}


- (void)searchWillBegin {
    if ( [baiduMapView isHidden])
    {
        [baiduMapView setHidden:NO];
        [self.tableView setHidden:YES];
    }
}


- (void)jumpToSearchLocation {
    if ( 0 != curCoordinate.latitude || 0 != curCoordinate.longitude)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            flagForMapSearchJump = YES;
            [baiduMapView setCenterCoordinate:curCoordinate animated:YES];
        });
    }
}




- (void)openAddressPicker {
    [[LyBottomControl sharedInstance] setHidden:YES];
    
    LyAddressPicker *addressPicker = [LyAddressPicker addressPickerWithMode:LyAddressPickerMode_map];
    [addressPicker setDelegate:self];
    [addressPicker setAddress:curAddressStr];
    [addressPicker show];
}


- (void)targetForNavigationItemCenter517Icon:(UITapGestureRecognizer *)tapGesture {
    
    [arrSchools_search removeAllObjects];
    
    flagForMapJump = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:LyNofiticationForRequestLocate object:nil];
    
    [self updateBtnAddressTitle:[LyCurrentUser curUser].location.address];
    
    if (LyMapAddAnnonationMode_all != _mapAddAnnonationMode) {
        [self setMapAddAnnonationMode:LyMapAddAnnonationMode_all];
        [self dschAddAnnonationToMapView:nil];
//        [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:LyDelayTime];
        [self performSelector:@selector(reloadData) withObject:nil afterDelay:LyDelayTime];
    }
    
    
}


- (void)delayAddAnnonation:(__kindof NSArray *)arr {
    if (!indicator_add) {
        indicator_add = [[LyIndicator alloc] initWithTitle:@"正在加载地图信息..."];
    }
    [indicator_add startAnimation];
    
    [self performSelector:@selector(dschAddAnnonationToMapView:) withObject:arr afterDelay:0.05f];
    
    [indicator_add performSelector:@selector(stopAnimation) withObject:nil afterDelay:2.0f];
}


- (void)targetForButton:(UIButton *)button {
    [[LyBottomControl sharedInstance] bcResignFirstResponder];
    
    switch ( [button tag]) {
        case driveSchoolButtonMode_option: {
            LySortModePicker *sortPicker = [[LySortModePicker alloc] init];
            [sortPicker setSortMode:_curSortMode];
            [sortPicker setDelegate:self];
            [sortPicker show];
            break;
        }
    }
}




- (void)refreshDriveListInfo:(UIRefreshControl *)rc {
    [self load];
}


- (void)load {
    [self.tvFooterView startAnimation];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(0) forKey:startKey];
    [dic setObject:userTypeSchoolKey forKey:userTypeKey];
//    [dic setObject:[[NSString alloc] initWithFormat:@"%.10f", [LyCurrentUser curUser].location.location.coordinate.latitude] forKey:latitudeKey];
//    [dic setObject:[[NSString alloc] initWithFormat:@"%.10f", [LyCurrentUser curUser].location.location.coordinate.longitude] forKey:longitudeKey];
    [dic setObject:@([LyCurrentUser curUser].location.location.coordinate.latitude) forKey:latitudeKey];
    [dic setObject:@([LyCurrentUser curUser].location.location.coordinate.longitude) forKey:longitudeKey];
    
    if ([[LyCurrentUser curUser] isLogined]) {
        [dic setObject:[LyCurrentUser curUser].userId forKey:userIdKey];
        [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    }
    
    NSString *address = [[[LyCurrentUser curUser] location] address];
    NSArray *arrAddress = [LyUtil separateString:address separator:@" "];
    NSString *strCity;
    if (arrAddress && arrAddress.count >= 2) {
        strCity = [arrAddress objectAtIndex:1];
        strCity = [strCity substringToIndex:strCity.length - 1];
    } else {
        strCity = @"上海";
    }
    
//    strCity = @"吉安";
    
    [dic setObject:strCity forKey:addressKey];
  
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:driveSchoolHttpMethod_load];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:getTeacherList_url
                                   body:dic
                                   type:LyHttpType_asynPost
                                       timeOut:30.0f] boolValue];
}



- (void)loadMore:(NSInteger)start {
    
    if ( [[LyUserManager sharedInstance] countOfDriveSchool] >= driveSchoolListMaxCount) {
        [self.tvFooterView stopAnimation];
        [self.tvFooterView setStatus:LyTableViewFooterViewStatus_disable];
        return;
    }
    
    [self.tvFooterView startAnimation];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(start) forKey:startKey];
    [dic setObject:userTypeSchoolKey forKey:userTypeKey];
//    [dic setObject:[[NSString alloc] initWithFormat:@"%.10f", [LyCurrentUser curUser].location.location.coordinate.latitude] forKey:latitudeKey];
//    [dic setObject:[[NSString alloc] initWithFormat:@"%.10f", [LyCurrentUser curUser].location.location.coordinate.longitude] forKey:longitudeKey];
    [dic setObject:@([LyCurrentUser curUser].location.location.coordinate.latitude) forKey:latitudeKey];
    [dic setObject:@([LyCurrentUser curUser].location.location.coordinate.longitude) forKey:longitudeKey];
    
    if ([[LyCurrentUser curUser] isLogined]) {
        [dic setObject:[LyCurrentUser curUser].userId forKey:userIdKey];
        [dic setObject:[LyUtil httpSessionId] forKey:sessionIdKey];
    }
    
    NSString *address = [[[LyCurrentUser curUser] location] address];
    NSArray *arrAddress = [LyUtil separateString:address separator:@" "];
    NSString *strCity;
    if (arrAddress && arrAddress.count >= 2) {
        strCity = [arrAddress objectAtIndex:1];
        strCity = [strCity substringToIndex:strCity.length - 1];
    } else {
        strCity = @"上海";
    }
//    strCity = @"吉安";
    
    [dic setObject:strCity forKey:addressKey];
    

    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:driveSchoolHttpMethod_loadMore];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:getTeacherList_url
                                  body:dic
                                  type:LyHttpType_asynPost
                                       timeOut:30.0f] boolValue];
}


- (void)search:(NSString *)strSearch {
    if (!curAddress || curAddress.count < 3) {
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"还没有位置信息"] show];
        return;
    }
    
    
    CLGeocoder *gecoder = [[CLGeocoder alloc] init];
    [gecoder geocodeAddressString:[[NSString alloc] initWithFormat:@"%@%@%@", curAddress[0], curAddress[1], strSearch]
                completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                    if (!error) {
                        CLPlacemark *placeMark = [placemarks objectAtIndex:0];
                        
                        if ( placeMark && placeMark.location) {
                            curCoordinate = placeMark.location.coordinate;
                        } else {
                            if ([LyCurrentUser curUser].location.isValid) {
                                curCoordinate = [LyCurrentUser curUser].location.location.coordinate;
                            } else {
                                curCoordinate = {+31.27545736, +121.54045277};
                            }
                        }
                        
                    } else {
                        if ([LyCurrentUser curUser].location.isValid) {
                            curCoordinate = [LyCurrentUser curUser].location.location.coordinate;
                        } else {
                            curCoordinate = {+31.27545736, +121.54045277};
                        }
                    }
                    
                    [self search_real:strSearch];
                }];
    
    
    if ( !indicator_search)
    {
        indicator_search = [[LyIndicator alloc] initWithTitle:@"正在搜索..."];
    }
    [indicator_search startAnimation];
    
    
}


- (void)search_real:(NSString *)strSearch
{
    flagSetcurCoordinate = NO;
    
    [baiduMapView removeAnnotations:[baiduMapView annotations]];
    [self setMapAddAnnonationMode:LyMapAddAnnonationMode_search];
    
    NSString *strProvince = [curAddress objectAtIndex:0];
    strProvince = [strProvince substringToIndex:[strProvince length]-1];
    
    NSString *strCity = [curAddress objectAtIndex:1];
    strCity = [strCity substringToIndex:[strCity length]-1];
    
    NSString *strDistrict = [curAddress objectAtIndex:2];
    strDistrict = [strDistrict substringToIndex:[strDistrict length]-1];
    
    LyHttpRequest *httpRequest = [LyHttpRequest httpRequestWithMode:driveSchoolHttpMethod_search];
    [httpRequest setDelegate:self];
    bHttpFlag = [[httpRequest startHttpRequest:searchSchool_url
                                          body:@{
                                                 searchProvinceKey:strProvince,
                                                 searchCityKey:strCity,
                                                 searchDistrictKey:strDistrict,
                                                 searchAddressKey:strSearch,
                                                 latitudeKey:@(curCoordinate.latitude),
                                                 longitudeKey:@(curCoordinate.longitude)
                                                 }
                                          type:LyHttpType_asynPost
                                       timeOut:15] boolValue];
}


- (void)handleHttpFailed {
    if ([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefreshing];
    }
    
    if ([self.tvFooterView isAnimating]) {
        [self.tvFooterView stopAnimation];
    }
    
    if ( [indicator_search isAnimating]) {
        [indicator_search stopAnimation];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"无结果"] show];
        [self performSelector:@selector(jumpToSearchLocation) withObject:nil afterDelay:LyDelayTime];
    }
    
    [self.tvFooterView setStatus:LyTableViewFooterViewStatus_error];
}


- (void)dschAnalysisDriveSchoolInfo:(NSString *)strResult {
    NSDictionary *dic = [LyUtil getObjFromJson:strResult];
    if (![LyUtil validateDictionary:dic]) {
        [self handleHttpFailed];
        return;
    }
    
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if (![LyUtil validateString:strCode]) {
        [self handleHttpFailed];
        return;
    }
    
    
    if (codeMaintaining == [strCode integerValue]) {
        [indicator_search stopAnimation];
        [indicator_add stopAnimation];
        [self.tvFooterView stopAnimation];
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    switch ( curHttpMethod) {
        case driveSchoolHttpMethod_load: {
            switch ( [strCode integerValue]) {
                case 0: {
                    
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    
                    if (![LyUtil validateArray:arrResult]) {
                        [self.refreshControl endRefreshing];
                        [self.tvFooterView setStatus:LyTableViewFooterViewStatus_disable];
                        return;
                    }
                    
                    
                    for (NSDictionary *dicItem in arrResult) {
                        if (![LyUtil validateDictionary:dicItem]) {
                            continue;
                        }
                        
                        NSString *strDschId = [dicItem objectForKey:userIdKey];
                        NSString *strScore = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:scoreKey]];
                        NSString *strAllCount = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:teachAllCountKey]];
                        NSString *strPrice = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:minPriceKey]];
                        NSString *strPrecedence = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:precedenceKey]];
                        
                        NSString *strDschName = [dicItem objectForKey:trueNameKey];
                        if (![LyUtil validateString:strDschName]) {
                            strDschName = [dicItem objectForKey:nameKey];
                            
                            if (![LyUtil validateString:strDschName]) {
                                strDschName = [dicItem objectForKey:nickNameKey];
                            }
                        }
                        if (!strDschName) {
                            strDschName = [LyUtil getUserNameWithUserId:strDschId];
                        }
                        
                        
                        LyDriveSchool *tmpDriveSchool = [[LyUserManager sharedInstance] getDriveSchoolWithDriveSchoolId:strDschId];
                        if (!tmpDriveSchool || LyUserType_school != tmpDriveSchool.userType) {
                            tmpDriveSchool = [LyDriveSchool driveShcoolWithDschId:strDschId
                                                                         dschName:strDschName
                                                                            score:[strScore floatValue]
                                                                      stuAllCount:[strAllCount intValue]
                                                                            price:[strPrice floatValue]];
                            
                            [[LyUserManager sharedInstance] addUser:tmpDriveSchool];
                        }
                        [tmpDriveSchool setPrecedence:strPrecedence.intValue];
                        
                        
                        NSArray *arrLandMark = [dicItem objectForKey:landMarkKey];
                        if ([LyUtil validateArray:arrLandMark]) {

                            for (NSDictionary *dicLandMark in arrLandMark) {
                                if (![LyUtil validateDictionary:dicLandMark]) {
                                    continue;
                                }
                                
                                NSString *lmId = [dicLandMark objectForKey:idKey];
                                CLLocationDegrees latitude = [[dicLandMark objectForKey:latitudeKey] doubleValue];
                                CLLocationDegrees longitue = [[dicLandMark objectForKey:longitudeKey] doubleValue];
                                
                                if ([LyUtil validateString:lmId]) {
                                    LyLandMark *landMark = [LyLandMark landMarkWithId:lmId
                                                                             masterId:strDschId
                                                                             latitude:latitude
                                                                            longitude:longitue];
                                    if (landMark) {
                                        [tmpDriveSchool addLandMark:landMark];
                                    }
                                }
                            }
                        }

                        NSString *strLastStudent = [dicItem objectForKey:lastStudentKey];
                        NSString *strSignTime = [dicItem objectForKey:signTimeKey];
                        if ([LyUtil validateString:strLastStudent] && [LyUtil validateString:strSignTime]) {
                            [tmpDriveSchool setLastSignInfo:strLastStudent andTime:strSignTime];
                        }
                        
                        
                    }
                    
                    arrSchools = [[LyUserManager sharedInstance] getAllDriveSchool];
                    arrSchools = [LyUtil sortTeacherArr:arrSchools sortMode:_curSortMode];
                
                    
                    if ( [self.refreshControl isRefreshing]) {
                        [self.refreshControl endRefreshing];
                    }
                    if ( [self.tvFooterView isAnimating]) {
                        [self.tvFooterView stopAnimation];
                    }
                    
                    if ( ![self.tableView isHidden]) {
//                        [self.tableView reloadData];
                        [self reloadData];
                        if (!arrNeedAdd) {
                            arrNeedAdd = [[NSMutableArray alloc] initWithCapacity:1];
                        }
                        [arrNeedAdd addObjectsFromArray:arrSchools];
                    } else {
                        [self delayAddAnnonation:nil];
                    }

                    
                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
            
        case driveSchoolHttpMethod_loadMore: {
            
            switch ( [strCode integerValue]) {
                case 0: {
                    NSArray *arrResult = [dic objectForKey:resultKey];
                    
                    if ( !arrResult || [NSNull null] == (NSNull *)arrResult || ![arrResult isKindOfClass:[NSArray class]] || ![arrResult count])
                    {
                        if ( [self.refreshControl isRefreshing])
                        {
                            [self.refreshControl endRefreshing];
                        }
                        if ( [self.tvFooterView isAnimating])
                        {
                            [self.tvFooterView stopAnimation];
                        }
                        [self.tvFooterView setStatus:LyTableViewFooterViewStatus_disable];
                        
                        return;
                    }
                    
                    NSMutableArray *arrCurrent = [[NSMutableArray alloc] initWithCapacity:1];
                    
                    for ( int i = 0; i < [arrResult count]; ++i)
                    {
                        NSDictionary *dicItem = [arrResult objectAtIndex:i];
                        if ( !dicItem || [dicItem isKindOfClass:[NSNull class]] || ![dicItem isKindOfClass:[NSDictionary class]] || ![dicItem count])
                        {
                            continue;
                        }
                        
                        NSString *strDschId = [dicItem objectForKey:userIdKey];
                        NSString *strScore = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:scoreKey]];
                        NSString *strAllCount = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:teachAllCountKey]];
                        NSString *strPrice = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:minPriceKey]];
                        NSString *strPrecedence = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:precedenceKey]];
                        
                        NSString *strDschName = [dicItem objectForKey:trueNameKey];
                        if ( !strDschName || [NSNull null] == (NSNull *)strDschName || [strDschName isEqualToString:@""])
                        {
                            strDschName = [dicItem objectForKey:nameKey];
                            if ( !strDschName || [NSNull null] == (NSNull *)strDschName || [strDschName isEqualToString:@""])
                            {
                                strDschName = [dicItem objectForKey:nickNameKey];
                            }
                        }
                        if (!strDschName)
                        {
                            strDschName = [LyUtil getUserNameWithUserId:strDschId];
                        }
                        
                        
                        LyDriveSchool *tmpDriveSchool = [[LyUserManager sharedInstance] getDriveSchoolWithDriveSchoolId:strDschId];
                        if (!tmpDriveSchool || LyUserType_school != tmpDriveSchool.userType) {
                            tmpDriveSchool = [LyDriveSchool driveShcoolWithDschId:strDschId
                                                                         dschName:strDschName
                                                                        score:[strScore floatValue]
                                                                     stuAllCount:[strAllCount intValue]
                                                                        price:[strPrice floatValue]];
                            
                            [[LyUserManager sharedInstance] addUser:tmpDriveSchool];
                        }
                        
                        [tmpDriveSchool setPrecedence:strPrecedence.intValue];
                        
                        NSArray *arrLandMark = [dicItem objectForKey:landMarkKey];
                        if ([LyUtil validateArray:arrLandMark]) {
                            for (NSDictionary *dicLandMark in arrLandMark) {
                                if ( !dicLandMark || [dicLandMark isKindOfClass:[NSNull class]] || ![dicLandMark isKindOfClass:[NSDictionary class]] || ![dicLandMark count])
                                {
                                    continue;
                                }
                                
                                NSString *lmId = [dicLandMark objectForKey:idKey];
                                CLLocationDegrees latitude = [[dicLandMark objectForKey:latitudeKey] doubleValue];
                                CLLocationDegrees longitue = [[dicLandMark objectForKey:longitudeKey] doubleValue];
                                
                                if ( !lmId || [lmId isKindOfClass:[NSNull class]] || [lmId rangeOfString:@"null"].length > 0 || [lmId length] < 1)
                                {
                                    continue;
                                }
                                else
                                {
                                    LyLandMark *landMark = [LyLandMark landMarkWithId:lmId
                                                                             masterId:strDschId
                                                                             latitude:latitude
                                                                            longitude:longitue];
                                    if (landMark)
                                    {
                                        [tmpDriveSchool addLandMark:landMark];
                                    }
                                }
                            }
                        }
                        
                        
                        NSString *strLastStudent = [dicItem objectForKey:lastStudentKey];
                        NSString *strSignTime = [dicItem objectForKey:signTimeKey];
                        if ( !strLastStudent || [strLastStudent isKindOfClass:[NSNull class]] || [strLastStudent isEqualToString:@""])
                        {
  
                        }
                        else
                        {
                            if ( !strSignTime || [strSignTime isKindOfClass:[NSNull class]] || [strSignTime isEqualToString:@""])
                            {
                                
                            }
                            else
                            {
                                [tmpDriveSchool setLastSignInfo:strLastStudent andTime:strSignTime];
                            }
                        }
                        [arrCurrent addObject:tmpDriveSchool];
                    }
                    
                    
                    arrSchools = [[LyUserManager sharedInstance] getAllDriveSchool];
                    arrSchools = [LyUtil sortTeacherArr:arrSchools sortMode:_curSortMode];
            
                    
                    [self.refreshControl endRefreshing];
                    [self.tvFooterView stopAnimation];
                    
                    
                    
                    if ( ![self.tableView isHidden])
                    {
                        [self reloadData];
                        if (!arrNeedAdd)
                        {
                            arrNeedAdd = [[NSMutableArray alloc] initWithCapacity:1];
                        }
                        [arrNeedAdd addObjectsFromArray:arrCurrent];
                    }
                    else
                    {
                        [self delayAddAnnonation:[arrCurrent copy]];
                    }

                    break;
                }
                    
                case 1: {
                    [self handleHttpFailed];
                    break;
                }
                    
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        case driveSchoolHttpMethod_search: {
            switch ( [strCode integerValue]) {
                case 0: {
                    NSDictionary *dicResult = [dic objectForKey:resultKey];
                    if (![LyUtil validateDictionary:dicResult]) {
                        [indicator_search stopAnimation];
                        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"无结果"] show];
                        
                        [self jumpToSearchLocation];
                        return;
                    }
                    
                    [arrSchools_search removeAllObjects];
                    
                    NSString *flag = [[NSString alloc] initWithFormat:@"%@", [dicResult objectForKey:flagKey]];
                    if ( flag && 1 == [flag integerValue]) {
                        NSArray *arrSchool = [dicResult objectForKey:schoolKey];
                        if (![LyUtil validateArray:arrSchool]) {
                            [indicator_search stopAnimation];
                            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"无结果"] show];
                            
                            [self jumpToSearchLocation];
                            return;
                        }
                        
                        for (NSDictionary *dicItem in arrSchool) {
                            if (![LyUtil validateDictionary:dicItem]) {
                                continue;
                            }
                            NSString *strUserId = [dicItem objectForKey:userIdKey];
                            NSString *strScore = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:scoreKey]];
                            NSString *strAllCount = [[NSString alloc] initWithFormat:@"%@", [dicItem objectForKey:teachAllCountKey]];
                            
                            NSString *strUserName = [dicItem objectForKey:nickNameKey];
                            if (![LyUtil validateString:strUserName]) {
                                strUserName = [LyUtil getUserNameWithUserId:strUserId];
                            }
                            
                            LyDriveSchool *tmpDriveSchool = [LyDriveSchool driveShcoolWithDschId:strUserId
                                                                                        dschName:strUserName
                                                                                       score:[strScore floatValue]
                                                                                    stuAllCount:[strAllCount intValue]
                                                                                       price:0];
                            
                            [tmpDriveSchool setSearching:YES];
                            
                            NSArray *arrLandMark = [dicItem objectForKey:landMarkKey];
                            if ([LyUtil validateArray:arrLandMark]) {
                                
                                for (NSDictionary *dicLandMark in arrLandMark) {
                                    if (![LyUtil validateDictionary:dicLandMark]) {
                                        continue;
                                    }
                                    
                                    NSString *lmId = [dicLandMark objectForKey:idKey];
                                    CLLocationDegrees latitude = [[dicLandMark objectForKey:latitudeKey] doubleValue];
                                    CLLocationDegrees longitue = [[dicLandMark objectForKey:longitudeKey] doubleValue];
                                    
                                    
                                    if (![LyUtil validateString:lmId]) {
                                        continue;
                                    }
                                    
                                    LyLandMark *landMark = [LyLandMark landMarkWithId:lmId
                                                                             masterId:strUserId
                                                                             latitude:latitude
                                                                            longitude:longitue];
                                    if (landMark)
                                    {
                                        if (landMark.distance > 0 && tmpDriveSchool.distance > 0 && landMark.distance < tmpDriveSchool.distance ) {
                                            curCoordinate = {latitude, longitue};
                                        }
                                        
                                        
                                        [tmpDriveSchool addLandMark:landMark];

                                    }
                                    
                                }
                            }
                            if (!arrSchools_search) {
                                arrSchools_search = [[NSMutableArray alloc] initWithCapacity:1];
                            }
                            [arrSchools_search addObject:tmpDriveSchool];
                        }
                    }
                    else
                    {
                        NSArray *arrLand = [dicResult objectForKey:landKey];
                        if (![LyUtil validateArray:arrLand]) {
                            [indicator_search stopAnimation];
                            [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"无结果"] show];
                            
                            [self jumpToSearchLocation];
                            return;
                        }
                        
                        NSMutableDictionary *dicMapSchool = [[NSMutableDictionary alloc] initWithCapacity:1];
                        for (NSDictionary *dicItem in arrLand) {
                            if (![LyUtil validateDictionary:dicItem]) {
                                continue;
                            }
                            
                            NSArray *arrSchool = [dicItem objectForKey:schoolKey];
                            if (![LyUtil validateArray:arrSchool]) {
                                continue;
                            }
                            
                            NSString *lmId = [dicItem objectForKey:idKey];
                            CLLocationDegrees latitude = [[dicItem objectForKey:latitudeKey] doubleValue];
                            CLLocationDegrees longitue = [[dicItem objectForKey:longitudeKey] doubleValue];
                            
                            for (NSDictionary *dicSchool in arrSchool) {
                                if (![LyUtil validateDictionary:dicSchool]) {
                                    continue;
                                }
                                NSString *strUserId = [dicSchool objectForKey:userIdKey];
                                NSString *strScore = [[NSString alloc] initWithFormat:@"%@", [dicSchool objectForKey:scoreKey]];
                                NSString *strAllCount = [[NSString alloc] initWithFormat:@"%@", [dicSchool objectForKey:teachAllCountKey]];
//                                NSString *strPrice = [[NSString alloc] initWithFormat:@"%@", [dicSchool objectForKey:minPriceKey]];
                                
                                NSString *strUserName = [dicSchool objectForKey:nickNameKey];
                                if (![LyUtil validateString:strUserName]) {
                                    strUserName = [LyUtil getUserNameWithUserId:strUserId];
                                }
                                
                                LyDriveSchool *tmpDriveSchool = [dicMapSchool objectForKey:strUserId];
                                if ( tmpDriveSchool)
                                {
                                    [tmpDriveSchool setUserName:strUserName];
                                    [tmpDriveSchool setScore:[strScore floatValue]];
                                    [tmpDriveSchool setStuAllCount:[strAllCount intValue]];
                                }
                                else
                                {
                                    tmpDriveSchool = [LyDriveSchool driveShcoolWithDschId:strUserId
                                                                                 dschName:strUserName
                                                                                score:[strScore floatValue]
                                                                             stuAllCount:[strAllCount intValue]
                                                                                price:0];
                                    [dicMapSchool setObject:tmpDriveSchool forKey:strUserId];
                                }
                                LyLandMark *landMark = [LyLandMark landMarkWithId:lmId
                                                                         masterId:strUserId
                                                                       coordinate:{latitude, longitue}];
                                [tmpDriveSchool addLandMark:landMark];
                            }
                        }
                        
                        arrSchools_search = [NSMutableArray arrayWithArray:[dicMapSchool allValues]];
                    }
                    
                    
                    
                    if ( [arrSchools_search count] > 0) {
                        [self dschAddAnnonationToMapView:nil];
                    } else {
                        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"无结果"] show];
                        [self jumpToSearchLocation];
                    }
                    
//                    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:LyDelayTime];
                    [self performSelector:@selector(reloadData) withObject:nil afterDelay:LyDelayTime];
                    
                    [indicator_search stopAnimation];
                    
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




#pragma mark -LyHttpRequestDelegate
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest {
    if ( bHttpFlag) {
        bHttpFlag = NO;
        [self handleHttpFailed];
    }
    
    curHttpMethod = driveSchoolHttpMethod_null;
}

- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result {
    if ( bHttpFlag) {
        bHttpFlag = NO;
        
        curHttpMethod = (LyDriveSchoolHttpMethod)ahttpRequest.mode;
        [self dschAnalysisDriveSchoolInfo:result];
    }
    
    curHttpMethod = driveSchoolHttpMethod_null;
}



#pragma mark -LySortModePickerDelegate
- (void)onDoneBySortModePicker:(LySortModePicker *)aPicker sortMode:(LySortMode)aSortMode {
    [aPicker hide];
    
    if (aSortMode != _curSortMode) {
        [self setCurSortMode:aSortMode];
    }
}



#pragma mark -LyAddressPickerDelegate
- (void)onAddressPickerCancel:(LyAddressPicker *)addressPicker {
    [[LyBottomControl sharedInstance] setHidden:NO];
    [addressPicker hide];
}


- (void)onAddressPickerDone:(NSString *)address addressPicker:(LyAddressPicker *)addressPicker {
    [self setCurLocateMode:LyLocateMode_pick];
    
    [self updateBtnAddressTitle:address];
    
    [[LyBottomControl sharedInstance] setHidden:NO];
    [addressPicker hide];
}


- (void)onAddressPickerAutoLocate:(LyAddressPicker *)aAddressPicker {
    if ( LyLocateMode_auto != _curLocateMode) {
        [self setCurLocateMode:LyLocateMode_auto];
        [self targetForNavigationItemCenter517Icon:nil];
        [self performSelector:@selector(dschAddAnnonationToMapView:) withObject:nil afterDelay:0.3];
    }
    
    [[LyBottomControl sharedInstance] setHidden:NO];
    [aAddressPicker hide];
}


#pragma mark -LyFloatViewDelegate
- (void)onClicked {
    [[LyBottomControl sharedInstance] bcResignFirstResponder];
    
    if ( [baiduMapView isHidden]) {
        [[LyBottomControl sharedInstance] setHidden:NO];
        
        [baiduMapView setHidden:NO];
        [self.tableView setHidden:YES];
        
        if (arrNeedAdd && arrNeedAdd.count > 0) {
            [self delayAddAnnonation:arrNeedAdd];
            [arrNeedAdd removeAllObjects];
        }
    } else {
        [baiduMapView setHidden:YES];
        [self.tableView setHidden:NO];
        
        if ( [self.tableView numberOfRowsInSection:0] < [arrSchools count]) {
//            [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.001f];
            [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.001f];
        }
        
        if ( [self.tableView contentOffset].y > bottomControlHideCerticality) {
            [[LyBottomControl sharedInstance] setHidden:YES];
        } else {
            [[LyBottomControl sharedInstance] setHidden:NO];
        }
    }
}




#pragma mark -BMKMapViewDelegate
//*当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {

    UIViewController *nextVc = nil;
    
    LyBMKPointAnnotaion *lyPointAnnotation = (LyBMKPointAnnotaion *)view.annotation;
    
    if ( [[lyPointAnnotation title] rangeOfString:@"我的位置"].length > 0 && ![lyPointAnnotation respondsToSelector:@selector(objectId)])
    {
        LyUserInfoTableViewController *userInfo = [[LyUserInfoTableViewController alloc] init];
        nextVc = userInfo;
    }
    else
    {   
        lastDschId = [lyPointAnnotation objectId];
        
        
        LySchoolDetailViewController *sd = [[LySchoolDetailViewController alloc] init];
        [sd setDelegate:self];
        nextVc = sd;
    }
    
    if ([LyCurrentUser curUser].isLogined) {
        [self.navigationController pushViewController:nextVc animated:YES];
    } else {
        [LyUtil showLoginVc:self nextVC:nextVc showMode:LyShowVcMode_push];
    }
    
}


//*地图区域改变完成后会调用此接口
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if ( flagForMapSetCenter) {
        flagForMapSetCenter = NO;
        [baiduMapView setZoomLevel:15.0f];
    } else if ( flagForMapSearchJump) {
        flagForMapSearchJump = NO;
        [baiduMapView setZoomLevel:13.0f];
    }
}


//*根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    LyBMKPointAnnotaion *lyAnnotation = (LyBMKPointAnnotaion *)annotation;
    
    BMKAnnotationView *annotationView = [baiduMapView dequeueReusableAnnotationViewWithIdentifier:annotationReuseIdentifierForDriveSchool];
    if (!annotationView) {
        annotationView = [[BMKAnnotationView alloc] initWithAnnotation:lyAnnotation reuseIdentifier:annotationReuseIdentifierForDriveSchool];
        [annotationView setCanShowCallout:YES];
        
        if (!iconLandMark) {
            if ( SCREEN_WIDTH > 400) {
                iconLandMark = [LyUtil imageForImageName:@"annotation_dsch_414" needCache:YES];
            } else if ( SCREEN_WIDTH > 350) {
                iconLandMark = [LyUtil imageForImageName:@"annotation_dsch_375" needCache:YES];
            } else {
                iconLandMark = [LyUtil imageForImageName:@"annotation_dsch_320" needCache:YES];
            }
        }
        [annotationView setImage:iconLandMark];
    }
    
    
    LyBMKActionPaopaoView *pao = [[LyBMKActionPaopaoView alloc] init];
    [pao setTitle:[lyAnnotation title]];
    [pao setScore:[lyAnnotation score]];
    
    [annotationView setPaopaoView:[[BMKActionPaopaoView alloc] initWithCustomView:pao]];
    
    
    return annotationView;
}



#pragma mark -LyTableViewFooterViewDelegate
- (void)loadMoreData:(LyTableViewFooterView *)tableViewFooterView {
    if (LyMapAddAnnonationMode_all == _mapAddAnnonationMode) {
        [self loadMore:arrSchools.count];
    }
}



#pragma  mark -LySchoolDetailViewControllerDelegate
- (NSString *)schoolIdBySchoolDetailViewController:(LySchoolDetailViewController *)aSchoolDetailVC
{
    return lastDschId;
}




#pragma mark -LyActivityDelegate
- (void)activitiViewHasReady:(LyActivity *)aActivity {
    dispatch_async(dispatch_get_main_queue(), ^{
        [aActivity removeFromSuperview];
        [viewHeader addSubview:aActivity];
    });
}

- (void)onClickedByActivity:(LyActivity *)activity withIndex:(NSInteger)index andUrl:(NSURL *)url {
    [LyUtil openUrl:url];
}



#pragma mark -LyNotificationForLocationChanged
- (void)targetForNotificationForLocationChanged:(NSNotification *)notification {
    
    if ( !flagForShowMapOfChina) {
        return;
    }
    
    BMKUserLocation *userLocation = (BMKUserLocation *)[notification object];
    
    [baiduMapView updateLocationData:userLocation];
    
    if ( !flagForMapJump) {
        flagForMapJump = YES;
        flagForMapSetCenter = YES;
        [baiduMapView setCenterCoordinate:[[userLocation location] coordinate] animated:YES];
    }
    
    if ( autoLoadMoreCount < autoLoadMoreMaxCount && driveSchoolHttpMethod_null == curHttpMethod && !flagBusy) {
        [self loadMore:5 * autoLoadMoreCount];
        autoLoadMoreCount++;
    }
}



#pragma mark -KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([self isVisiable])
    {
        if ([keyPath isEqualToString:@"address"])
        {
            NSString *newValue = [change objectForKey:NSKeyValueChangeNewKey];
            
            if (newValue && newValue.length > 0 && LyLocateMode_auto == _curLocateMode)
            {
                [self updateBtnAddressTitle:newValue];
            }
        }
    }
}



#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return dschtcellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    curIdx_school = indexPath;
    lastDschId = [[[self.tableView cellForRowAtIndexPath:curIdx_school] driveSchool] userId];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    

    LySchoolDetailViewController *sd = [[LySchoolDetailViewController alloc] init];
    [sd setDelegate:self];
    
    if ([LyCurrentUser curUser].isLogined) {
        [self.navigationController pushViewController:sd animated:YES];
    } else {
        [LyUtil showLoginVc:self nextVC:sd showMode:LyShowVcMode_push];
    }
    
    
}




#pragma mark UITableViewDataSource相关
////返回分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


////返回每个分组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (_mapAddAnnonationMode) {
        case LyMapAddAnnonationMode_all: {
            return arrSchools.count;
            break;
        }
        case LyMapAddAnnonationMode_search: {
            return arrSchools_search.count;
            break;
        }
    }
    
    return 0;
}


////生成每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyDriveSchoolTableViewCell *tmpCell = [tableView dequeueReusableCellWithIdentifier:lyDriveSchoolTableViewCellReuseIdentifier];
    
    if ( !tmpCell) {
        tmpCell = [[LyDriveSchoolTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lyDriveSchoolTableViewCellReuseIdentifier];
    }
    
    switch (_mapAddAnnonationMode) {
        case LyMapAddAnnonationMode_all: {
            [tmpCell setDriveSchool:[arrSchools objectAtIndex:indexPath.row]];
            tmpCell.isSearching = NO;
            break;
        }
        case LyMapAddAnnonationMode_search: {
            [tmpCell setDriveSchool:[arrSchools_search objectAtIndex:indexPath.row]];
            tmpCell.isSearching = YES;
            break;
        }
    }
    
    return tmpCell;
}


#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ( scrollView == self.tableView) {
        if ( [baiduMapView isHidden]) {
            if ( [self.tableView contentOffset].y > bottomControlHideCerticality) {
                [[LyBottomControl sharedInstance] setHidden:YES];
            } else {
                [[LyBottomControl sharedInstance] setHidden:NO];
            }
        }
    }
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (scrollView == self.tableView) {// && !decelerate) {
        if (LyMapAddAnnonationMode_all == _mapAddAnnonationMode && scrollView == self.tableView && [scrollView contentOffset].y + CGRectGetHeight([scrollView frame]) > [scrollView contentSize].height + tvFooterViewDefaultHeight && scrollView.contentSize.height > scrollView.frame.size.height)
        {
            [self loadMore:arrSchools.count];
        }
    }
    
}



- (void)dealloc {
    [[LyCurrentUser curUser].location removeObserver:self forKeyPath:@"address"];
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