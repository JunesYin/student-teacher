//
//  LyBottomControl.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/21.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyBottomControl.h"
#import "LyCoachViewController.h"
#import "LyGuiderViewController.h"
#import "LyTheoryStudyViewController.h"
#import "LyCommunityViewController.h"

#import "LyLocation.h"




//主视图
#define BCVIEWWIDTH                         SCREEN_WIDTH

CGFloat const BCVIEWHEIGHT = 90.0f;

#define BCVIEWFRAME                         CGRectMake( 0, SCREEN_HEIGHT-BCVIEWHEIGHT, BCVIEWWIDTH, BCVIEWHEIGHT)

//按钮个数

int const BCTIEMCOUNT = 5;
CGFloat const BCITEMSPACE = 10.0f;

//按钮视图
CGFloat const BCALLITEMVIEWHEIGHT = 40;

//按钮
CGFloat const BCITEMBTNWIDTH = BCALLITEMVIEWHEIGHT;
CGFloat const BCITEMBTNHEIGHT = BCITEMBTNWIDTH;

//按钮视图
#define BCALLITEMVIEWWIDTH                  (BCITEMBTNWIDTH*BCTIEMCOUNT+BCITEMSPACE*(BCTIEMCOUNT+1))
#define BCALLITEMVIEWFRAME                  CGRectMake( BCVIEWWIDTH/2-BCALLITEMVIEWWIDTH/2, 2, BCALLITEMVIEWWIDTH, BCALLITEMVIEWHEIGHT)

//功能视图
#define BCITEMFUNCVIEWWIDTH                 BCVIEWWIDTH
#define BCITEMFUNCVIEWHEIGHT                (BCVIEWHEIGHT-BCALLITEMVIEWHEIGHT)

//搜索框
#define bcSearchItemViewWidth               BCITEMFUNCVIEWWIDTH
#define bcSearchItemViewHeight              (BCITEMFUNCVIEWHEIGHT*3/5.0f)


CGFloat const bcSearchHorizontalSpace = 3.0f;
#define bcSearchVerticalLineHeight          (bcSearchItemViewHeight/2.0f)

CGFloat const btnAddressWidth = 100.0f;
#define btnAddressHeight                    bcSearchItemViewHeight
#define searchBarWidth                      (BCITEMFUNCVIEWWIDTH-btnAddressWidth)
#define searchBarHeight                     bcSearchItemViewHeight


#define btnTitleFont                        LyFont(14)

//理论学习

//按钮
#define BCTHEORYSTUDYBTNHEIGHT              searchBarHeight
#define BCTHEORYSTUDYBTNWIDTH               (BCTHEORYSTUDYBTNHEIGHT*3)

#define BCTHEORYSTUDYBTNSPACE               (BCITEMFUNCVIEWWIDTH-BCTHEORYSTUDYBTNWIDTH*2)/3

#define BCTHEORYSTUDYBtNTITLECOLOR          [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0]




CGFloat const viewAboutMeWidth = 15.0f;
CGFloat const viewAboutMeHeight = viewAboutMeWidth;


CGFloat const bcOffsetXMin = 5.0f;


typedef NS_ENUM( NSInteger, LyBcSearchBarTag)
{
    BcSearchBarTag_Coach = 1000,
    BcSearchBarTag_driveSchool,
    BcSearchBarTag_Guider
};



typedef NS_ENUM( NSInteger, LyBcBtnAddressItemTag)
{
    BcBtnAddressItemTag_coach,
    BcBtnAddressItemTag_driveSchool,
    BcBtnAddressItemTag_guider
};


typedef NS_ENUM( NSInteger, LyBcTheoryStudyBtnTag)
{
    BcTheoryStudyBtnTag_ExamLocale,
    BcTheoryStudyBtnTag_LicenseInfo
};


typedef NS_ENUM( NSInteger, LyBcCommunityBtnTag)
{
    BcCommunityBtnTag_SendStatus,
    BcCommunityBtnTag_NewsAboutMe
};


@interface LyBottomControl () <UISearchBarDelegate>
{
    
    UIView                              *bcAllItemView;
    UIView                              *bcItemFuncView;
    UIView                              *bcItemFuncViewForCoach;
    UIView                              *bcItemFuncViewForDriveSchool;
    UIView                              *bcItemFuncViewForGuider;
    UIView                              *bcItemFuncViewForTheoryStudy;
    UIView                              *bcItemFuncViewForCommunity;
    
    UIView                              *bcSearchItemViewForCoach;
    UIView                              *bcSearchItemViewForDriveSchool;
    UIView                              *bcSearchItemViewForGuider;
    
    
    UIView                              *viewAboutMe;
    UILabel                             *lbAboutMe;
    
    
    float                               bcItemAllViewCenterXAlways;
    float                               bcItemAllViewCenterXCurrent;
//    NSInteger                           _curIdx;
    BOOL                                bcItemBtnDragInsideFlag;
    BOOL                                bcSearchBarEditing;
    
    
    
    LyLocation                          *location;
    
}
@end


@implementation LyBottomControl


lySingle_implementation(LyBottomControl)

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}


- (instancetype)init
{
//    CGRect rectBcView = CGRectMake( 0, SCREEN_HEIGHT-BCVIEWHEIGHT, BCVIEWWIDTH, BCVIEWHEIGHT);
    
    if ( self = [super initWithFrame:BCVIEWFRAME])
    {
        [self bcLayoutUI];
        [self bcAddKeyboardEventNotification];
        [self bcSetDefaultItem];
        
        bcItemAllViewCenterXAlways = SCREEN_CENTER_X;
        
        
    }
    
    return self;
}


- (void)bcLayoutUI
{
//    [self setBackgroundColor:[UIColor colorWithRed:0.784 green:0.784 blue:0.808 alpha:0.702]];
    [self setBackgroundColor:LyTranparentWhiteLightgrayColor];
    
    //按钮视图
    CGRect rectBcAllItemView = BCALLITEMVIEWFRAME;
    bcAllItemView = [[UIView alloc] initWithFrame:rectBcAllItemView];
    //[bcAllItemView Ly517ThemeColor];
    [self addSubview:bcAllItemView];
    
    
    //“理论学习”
    CGRect rectBcItemBtnTheoryStudy = CGRectMake( BCITEMSPACE, 0, BCITEMBTNWIDTH, BCITEMBTNHEIGHT);
    _bcItemBtnTheoryStudy = [[UIButton alloc] initWithFrame:rectBcItemBtnTheoryStudy];
    [_bcItemBtnTheoryStudy setImage:[LyUtil imageForImageName:@"bt_theoryStudy_n" needCache:NO] forState:UIControlStateNormal];
    [_bcItemBtnTheoryStudy setImage:[LyUtil imageForImageName:@"bt_theoryStudy_h" needCache:NO] forState:UIControlStateSelected];
    [_bcItemBtnTheoryStudy addTarget:self action:@selector(bcTargetForItemBtnTheoryStudy) forControlEvents:UIControlEventTouchUpInside];
    [_bcItemBtnTheoryStudy addTarget:self action:@selector(bcItemBtnOnDragInside:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    
    
    //“教练”
    CGRect rectBcItemBtnCoach = CGRectMake( rectBcItemBtnTheoryStudy.origin.x+rectBcItemBtnTheoryStudy.size.width+BCITEMSPACE, rectBcItemBtnTheoryStudy.origin.y, BCITEMBTNWIDTH, BCITEMBTNHEIGHT);
    _bcItemBtnCoach = [[UIButton alloc] initWithFrame:rectBcItemBtnCoach];
    [_bcItemBtnCoach setImage:[LyUtil imageForImageName:@"bt_coach_n" needCache:NO] forState:UIControlStateNormal];
    [_bcItemBtnCoach setImage:[LyUtil imageForImageName:@"bt_coach_h" needCache:NO] forState:UIControlStateSelected];
    [_bcItemBtnCoach addTarget:self action:@selector(bcTargetForItemBtnCoach) forControlEvents:UIControlEventTouchUpInside];
    [_bcItemBtnCoach addTarget:self action:@selector(bcItemBtnOnDragInside:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    
   
    
    //“驾校”
    CGRect rectBcItemBtnDriveSchool = CGRectMake( rectBcItemBtnCoach.origin.x+rectBcItemBtnCoach.size.width+BCITEMSPACE, rectBcItemBtnCoach.origin.y, BCITEMBTNWIDTH, BCITEMBTNHEIGHT);
    _bcItemBtnDriveSchool = [[UIButton alloc] initWithFrame:rectBcItemBtnDriveSchool];
    [_bcItemBtnDriveSchool setImage:[LyUtil imageForImageName:@"bt_driveSchool_n" needCache:NO] forState:UIControlStateNormal];
    [_bcItemBtnDriveSchool setImage:[LyUtil imageForImageName:@"bt_driveSchool_h" needCache:NO] forState:UIControlStateSelected];
    [_bcItemBtnDriveSchool addTarget:self action:@selector(bcTargetForItemBtnDriveSchool) forControlEvents:UIControlEventTouchUpInside];
    [_bcItemBtnDriveSchool addTarget:self action:@selector(bcItemBtnOnDragInside:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    
    
    //“指导员”
    CGRect rectBcItemBtnGuider = CGRectMake( rectBcItemBtnDriveSchool.origin.x+rectBcItemBtnDriveSchool.size.width+BCITEMSPACE, rectBcItemBtnDriveSchool.origin.y, BCITEMBTNWIDTH, BCITEMBTNHEIGHT);
    _bcItemBtnGuider = [[UIButton alloc] initWithFrame:rectBcItemBtnGuider];
    [_bcItemBtnGuider setImage:[LyUtil imageForImageName:@"bt_guider_n" needCache:NO] forState:UIControlStateNormal];
    [_bcItemBtnGuider setImage:[LyUtil imageForImageName:@"bt_guider_h" needCache:NO] forState:UIControlStateSelected];
    [_bcItemBtnGuider addTarget:self action:@selector(bcTargetForItemBtnGuider) forControlEvents:UIControlEventTouchUpInside];
    [_bcItemBtnGuider addTarget:self action:@selector(bcItemBtnOnDragInside:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    
    
    
    //“驾考圈”
    CGRect rectBcItemBtnCommunity = CGRectMake( rectBcItemBtnGuider.origin.x+rectBcItemBtnGuider.size.width+BCITEMSPACE, rectBcItemBtnGuider.origin.y, BCITEMBTNWIDTH, BCITEMBTNHEIGHT);
    _bcItemBtnCommunity = [[UIButton alloc] initWithFrame:rectBcItemBtnCommunity];
    [_bcItemBtnCommunity setImage:[LyUtil imageForImageName:@"bt_community_n" needCache:NO] forState:UIControlStateNormal];
    [_bcItemBtnCommunity setImage:[LyUtil imageForImageName:@"bt_community_h" needCache:NO] forState:UIControlStateSelected];
    [_bcItemBtnCommunity addTarget:self action:@selector(bcTargetForItemBtnCommunity) forControlEvents:UIControlEventTouchUpInside];
    [_bcItemBtnCommunity addTarget:self action:@selector(bcItemBtnOnDragInside:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    
    
    [bcAllItemView addSubview:_bcItemBtnGuider];
    [bcAllItemView addSubview:_bcItemBtnCoach];
    [bcAllItemView addSubview:_bcItemBtnDriveSchool];
    [bcAllItemView addSubview:_bcItemBtnTheoryStudy];
    [bcAllItemView addSubview:_bcItemBtnCommunity];
    
    
    
    //功能视图
    CGRect rectItemFuncView = CGRectMake( BCVIEWWIDTH/2-BCITEMFUNCVIEWWIDTH/2, rectBcAllItemView.origin.y+rectBcAllItemView.size.height, BCITEMFUNCVIEWWIDTH, BCITEMFUNCVIEWHEIGHT);
    bcItemFuncView = [[UIView alloc] initWithFrame:rectItemFuncView];
    [self addSubview:bcItemFuncView];
    
    CGRect rectItemFuncViewInstance = CGRectMake( 0, 0, BCITEMFUNCVIEWWIDTH, BCITEMFUNCVIEWHEIGHT);
    
    //“理论学习”功能-定位+车型
    bcItemFuncViewForTheoryStudy = [[UIView alloc] initWithFrame:rectItemFuncViewInstance];
    
    CGRect rectBcFuncExamLocale = CGRectMake( BCTHEORYSTUDYBTNSPACE, BCITEMFUNCVIEWHEIGHT/2-btnAddressHeight/2, BCTHEORYSTUDYBTNWIDTH, BCTHEORYSTUDYBTNHEIGHT);
    _bcBtnTheoryStudyExamLocale = [[UIButton alloc] initWithFrame:rectBcFuncExamLocale];
    [_bcBtnTheoryStudyExamLocale setTitle:@"考试地点" forState:UIControlStateNormal];
    [[_bcBtnTheoryStudyExamLocale titleLabel] setFont:btnTitleFont];
    [_bcBtnTheoryStudyExamLocale setTitleColor:BCTHEORYSTUDYBtNTITLECOLOR forState:UIControlStateNormal];
    [[_bcBtnTheoryStudyExamLocale layer] setBorderColor:[Ly517ThemeColor CGColor]];
    [[_bcBtnTheoryStudyExamLocale layer] setCornerRadius:5.0f];
    [[_bcBtnTheoryStudyExamLocale layer] setBorderWidth:1.0f];
    [_bcBtnTheoryStudyExamLocale setTag:BcTheoryStudyBtnTag_ExamLocale];
    [_bcBtnTheoryStudyExamLocale addTarget:self action:@selector(bcTargetForBtnTheoryStudy:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    

    //“教练”功能
    bcItemFuncViewForCoach = [[UIView alloc] initWithFrame:CGRectMake( 0, BCITEMFUNCVIEWHEIGHT/2.0f-bcSearchItemViewHeight/2.0f, bcSearchItemViewWidth, bcSearchItemViewHeight)];
    [bcItemFuncViewForCoach setBackgroundColor:[UIColor whiteColor]];
    [[bcItemFuncViewForCoach layer] setCornerRadius:5.0f];
    [bcItemFuncViewForCoach setClipsToBounds:YES];
    
    _bcBtnAddressCoach = [[UIButton alloc] initWithFrame:CGRectMake( 0, bcSearchItemViewHeight/2.0-btnAddressHeight/2.0f, btnAddressWidth, btnAddressHeight)];
    [_bcBtnAddressCoach setTag:BcBtnAddressItemTag_coach];
    [_bcBtnAddressCoach setTitle:@"获取中..." forState:UIControlStateNormal];
    [[_bcBtnAddressCoach titleLabel] setFont:btnTitleFont];
    [_bcBtnAddressCoach setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [_bcBtnAddressCoach setBackgroundImage:[LyUtil imageForImageName:@"verticalLine" needCache:NO] forState:UIControlStateNormal];
    [_bcBtnAddressCoach addTarget:self action:@selector(bcTargetForBtnAddressItem:) forControlEvents:UIControlEventTouchUpInside];
    
    _bcSearchBarCoach = [[UISearchBar alloc] initWithFrame:CGRectMake( _bcBtnAddressCoach.frame.origin.x+CGRectGetWidth(_bcBtnAddressCoach.frame), bcSearchItemViewHeight/2.0-searchBarHeight/2.0f, searchBarWidth, searchBarHeight)];
    [_bcSearchBarCoach setPlaceholder:@"例：长阳路"];
    [_bcSearchBarCoach setTag:BcSearchBarTag_Coach];
    [_bcSearchBarCoach setDelegate:self];
    [_bcSearchBarCoach setTintColor:Ly517ThemeColor];
    [_bcSearchBarCoach setBackgroundImage:[LyUtil imageWithColor:[UIColor clearColor] withSize:_bcSearchBarCoach.frame.size]];
    [[_bcSearchBarCoach layer] setBorderColor:[Ly517ThemeColor CGColor]];


    

    [bcItemFuncViewForCoach addSubview:_bcBtnAddressCoach];
    [bcItemFuncViewForCoach addSubview:_bcSearchBarCoach];
    
    

    //“驾校”功能
    bcItemFuncViewForDriveSchool = [[UIView alloc] initWithFrame:bcItemFuncViewForCoach.frame];
    [bcItemFuncViewForDriveSchool setBackgroundColor:[UIColor whiteColor]];
    [[bcItemFuncViewForDriveSchool layer] setCornerRadius:5.0f];
    [bcItemFuncViewForDriveSchool setClipsToBounds:YES];
    
    
    
    _bcBtnAddressDriveSchool = [[UIButton alloc] initWithFrame:_bcBtnAddressCoach.frame];
    [_bcBtnAddressDriveSchool setTag:BcBtnAddressItemTag_driveSchool];
    [_bcBtnAddressDriveSchool setTitle:@"获取中..." forState:UIControlStateNormal];
    [[_bcBtnAddressDriveSchool titleLabel] setFont:btnTitleFont];
    [_bcBtnAddressDriveSchool setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [_bcBtnAddressDriveSchool setBackgroundImage:[LyUtil imageForImageName:@"verticalLine" needCache:NO] forState:UIControlStateNormal];
    [_bcBtnAddressDriveSchool addTarget:self action:@selector(bcTargetForBtnAddressItem:) forControlEvents:UIControlEventTouchUpInside];
    
    _bcSearchBarDriveSchool = [[UISearchBar alloc] initWithFrame:_bcSearchBarCoach.frame];
    [_bcSearchBarDriveSchool setPlaceholder:@"例：长阳路或驾校名"];
    [_bcSearchBarDriveSchool setTag:BcSearchBarTag_driveSchool];
    [_bcSearchBarDriveSchool setDelegate:self];
    [_bcSearchBarDriveSchool setBackgroundImage:[LyUtil imageWithColor:[UIColor clearColor] withSize:_bcSearchBarDriveSchool.frame.size]];
    [[_bcSearchBarDriveSchool layer] setBorderColor:[Ly517ThemeColor CGColor]];
//    [[_bcSearchBarDriveSchool layer] setCornerRadius:BCCONTROLLAYERCORNERRADIUS];
//    [[_bcSearchBarDriveSchool layer] setBorderWidth:BCCONTROLLAYERBOARDWIDTH];
    [_bcSearchBarDriveSchool setTintColor:Ly517ThemeColor];
    
    [bcItemFuncViewForDriveSchool addSubview:_bcBtnAddressDriveSchool];
    [bcItemFuncViewForDriveSchool addSubview:_bcSearchBarDriveSchool];
    
    
    
    
    
    //"指导员"功能
    bcItemFuncViewForGuider = [[UIView alloc] initWithFrame:bcItemFuncViewForCoach.frame];
    [bcItemFuncViewForGuider setBackgroundColor:[UIColor whiteColor]];
    [[bcItemFuncViewForGuider layer] setCornerRadius:5.0f];
    [bcItemFuncViewForGuider setClipsToBounds:YES];
    
    _bcBtnAddressGuider = [[UIButton alloc] initWithFrame:_bcBtnAddressCoach.frame];
    [_bcBtnAddressGuider setTag:BcBtnAddressItemTag_guider];
    [_bcBtnAddressGuider setTitle:@"获取中..." forState:UIControlStateNormal];
    [[_bcBtnAddressGuider titleLabel] setFont:btnTitleFont];
    [_bcBtnAddressGuider setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [_bcBtnAddressGuider setBackgroundImage:[LyUtil imageForImageName:@"verticalLine" needCache:NO] forState:UIControlStateNormal];
    [_bcBtnAddressGuider addTarget:self action:@selector(bcTargetForBtnAddressItem:) forControlEvents:UIControlEventTouchUpInside];
    
    _bcSearchBarGuider = [[UISearchBar alloc] initWithFrame:_bcSearchBarCoach.frame];
    [_bcSearchBarGuider setPlaceholder:@"例：长阳路"];
    [_bcSearchBarGuider setTag:BcSearchBarTag_Guider];
    [_bcSearchBarGuider setDelegate:self];
    [_bcSearchBarGuider setTintColor:Ly517ThemeColor];
    [_bcSearchBarGuider setBackgroundImage:[LyUtil imageWithColor:[UIColor clearColor] withSize:_bcSearchBarGuider.frame.size]];
    [[_bcSearchBarGuider layer] setBorderColor:[Ly517ThemeColor CGColor]];
//    [[_bcSearchBarGuider layer] setCornerRadius:BCCONTROLLAYERCORNERRADIUS];
//    [[_bcSearchBarGuider layer] setBorderWidth:BCCONTROLLAYERBOARDWIDTH];
    
    [bcItemFuncViewForGuider addSubview:_bcBtnAddressGuider];
    [bcItemFuncViewForGuider addSubview:_bcSearchBarGuider];
    

    
    CGRect rectBcTheoryStudyBtnVehicleType = CGRectMake( rectBcFuncExamLocale.origin.x+rectBcFuncExamLocale.size.width+BCTHEORYSTUDYBTNSPACE, BCITEMFUNCVIEWHEIGHT/2-btnAddressHeight/2, BCTHEORYSTUDYBTNWIDTH, BCTHEORYSTUDYBTNHEIGHT);
    _bcBtnTheoryStudyLicenseInfo = [[UIButton alloc] initWithFrame:rectBcTheoryStudyBtnVehicleType];
    [_bcBtnTheoryStudyLicenseInfo setTitle:@"考试车型" forState:UIControlStateNormal];
    [[_bcBtnTheoryStudyLicenseInfo titleLabel] setFont:btnTitleFont];
    [_bcBtnTheoryStudyLicenseInfo setTitleColor:BCTHEORYSTUDYBtNTITLECOLOR forState:UIControlStateNormal];
    [[_bcBtnTheoryStudyLicenseInfo layer] setBorderColor:[Ly517ThemeColor CGColor]];
    [[_bcBtnTheoryStudyLicenseInfo layer] setCornerRadius:5.0f];
    [[_bcBtnTheoryStudyLicenseInfo layer] setBorderWidth:1.0f];
    [_bcBtnTheoryStudyLicenseInfo setTag:BcTheoryStudyBtnTag_LicenseInfo];
    [_bcBtnTheoryStudyLicenseInfo addTarget:self action:@selector(bcTargetForBtnTheoryStudy:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [bcItemFuncViewForTheoryStudy addSubview:_bcBtnTheoryStudyExamLocale];
    [bcItemFuncViewForTheoryStudy addSubview:_bcBtnTheoryStudyLicenseInfo];
    
    
    //“驾考圈”功能-发动态
    bcItemFuncViewForCommunity = [[UIView alloc] initWithFrame:rectItemFuncViewInstance];
//    [bcItemFuncViewForCommunity setBackgroundColor:[UIColor purpleColor]];
    
    CGRect rectBcCommunitySendStatus = CGRectMake( BCTHEORYSTUDYBTNSPACE, BCITEMFUNCVIEWHEIGHT/2-btnAddressHeight/2, BCTHEORYSTUDYBTNWIDTH, BCTHEORYSTUDYBTNHEIGHT);
    _bcBtnCommunitySendStatus = [[UIButton alloc] initWithFrame:rectBcCommunitySendStatus];
//    [bcFuncCommunityBtnSendStatus setTitle:@"发送动态" forState:UIControlStateNormal];
    [_bcBtnCommunitySendStatus setBackgroundImage:[LyUtil imageForImageName:@"bt_community_sendStatus" needCache:NO] forState:UIControlStateNormal];
    [_bcBtnCommunitySendStatus setTag:BcCommunityBtnTag_SendStatus];
    [_bcBtnCommunitySendStatus addTarget:self action:@selector(bcTargetForBtnCommunity:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect rectBcCommunityBtnNewsAboutMe = CGRectMake( rectBcFuncExamLocale.origin.x+rectBcFuncExamLocale.size.width+BCTHEORYSTUDYBTNSPACE, BCITEMFUNCVIEWHEIGHT/2-btnAddressHeight/2, BCTHEORYSTUDYBTNWIDTH, BCTHEORYSTUDYBTNHEIGHT);
    _bcBtnCommunityAboutMe = [[UIButton alloc] initWithFrame:rectBcCommunityBtnNewsAboutMe];
//    [bcFuncCommunityBtnNewsAboutMe setTitle:@"与我相关" forState:UIControlStateNormal];
    [_bcBtnCommunityAboutMe setBackgroundImage:[LyUtil imageForImageName:@"bt_community_NewsAbountMe" needCache:NO] forState:UIControlStateNormal];
    [_bcBtnCommunityAboutMe setTag:BcCommunityBtnTag_NewsAboutMe];
    [_bcBtnCommunityAboutMe addTarget:self action:@selector(bcTargetForBtnCommunity:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    viewAboutMe = [[UIView alloc] initWithFrame:CGRectMake( _bcBtnCommunityAboutMe.frame.origin.x+CGRectGetWidth(_bcBtnCommunityAboutMe.frame)-viewAboutMeWidth/2.0f, _bcBtnCommunityAboutMe.frame.origin.y-viewAboutMeHeight/2.0f, viewAboutMeWidth, viewAboutMeHeight)];
    [viewAboutMe setBackgroundColor:LyRedColor];
    [[viewAboutMe layer] setCornerRadius:viewAboutMeWidth/2.0f];
    [viewAboutMe setClipsToBounds:YES];
    
    lbAboutMe = [[UILabel alloc] initWithFrame:viewAboutMe.bounds];
    [lbAboutMe setFont:LyFont(8)];
    [lbAboutMe setTextColor:[UIColor whiteColor]];
    [lbAboutMe setTextAlignment:NSTextAlignmentCenter];
    [[viewAboutMe layer] setCornerRadius:viewAboutMeWidth/2.0f];
    [viewAboutMe setClipsToBounds:YES];
    
    [viewAboutMe addSubview:lbAboutMe];
    
//    [lbAboutMe setHidden:YES];
    
    
    [bcItemFuncViewForCommunity addSubview:_bcBtnCommunitySendStatus];
    [bcItemFuncViewForCommunity addSubview:_bcBtnCommunityAboutMe];
    [bcItemFuncViewForCommunity addSubview:viewAboutMe];
    
    
    [bcItemFuncView addSubview:bcItemFuncViewForTheoryStudy];
    [bcItemFuncView addSubview:bcItemFuncViewForCoach];
    [bcItemFuncView addSubview:bcItemFuncViewForDriveSchool];
    [bcItemFuncView addSubview:bcItemFuncViewForGuider];
    [bcItemFuncView addSubview:bcItemFuncViewForCommunity];
    
    [bcItemFuncViewForTheoryStudy setHidden:YES];
    [bcItemFuncViewForCoach setHidden:YES];
    [bcItemFuncViewForDriveSchool setHidden:YES];
    [bcItemFuncViewForGuider setHidden:YES];
    [bcItemFuncViewForCommunity setHidden:YES];
    
    [self setCountAboutMe:0];
    

//    [[LyCurrentUser curUser].location addObserver:self forKeyPath:@"address" options:NSKeyValueObservingOptionNew context:nil];
}


//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"address"])
//    {
//        NSString *newValue = [change objectForKey:NSKeyValueChangeNewKey];
//        
//        NSArray *arr = [LyUtil separateString:newValue separator:@" "];
//        if (arr && arr.count > 2)
//        {
//            [self setBtnAddressCoachTitle:arr[2]];
//            [self setBtnAddressDriveSchoolTitle:arr[2]];
//            [self setBtnAddressGuiderTitle:arr[2]];
//            
//            [[LyCurrentUser curUser].location removeObserver:self forKeyPath:@"address"];
//        }
//    }
//}



- (void)bcResignFirstResponder
{
    if ( bcSearchBarEditing)
    {
        bcSearchBarEditing = NO;
        
        if ( [_bcSearchBarCoach isFirstResponder])
        {
            [_bcSearchBarCoach resignFirstResponder];
        }
        
        if ( [_bcSearchBarGuider isFirstResponder])
        {
            [_bcSearchBarGuider resignFirstResponder];
        }
        
        if ( [_bcSearchBarDriveSchool isFirstResponder])
        {
            [_bcSearchBarDriveSchool resignFirstResponder];
        }
    }
}



- (void)setBtnAddressCoachTitle:(NSString *)title
{
    [_bcBtnAddressCoach setTitle:title forState:UIControlStateNormal];
}

- (void)setBtnAddressDriveSchoolTitle:(NSString *)title
{
    [_bcBtnAddressDriveSchool setTitle:title forState:UIControlStateNormal];
}

- (void)setBtnAddressGuiderTitle:(NSString *)title
{
    [_bcBtnAddressGuider setTitle:title forState:UIControlStateNormal];
}



- (void)setCountAboutMe:(NSInteger)countAcountMe
{
    if ( countAcountMe > 0)
    {
        [viewAboutMe setHidden:NO];
        
        
        [lbAboutMe setText:[[NSString alloc] initWithFormat:@"%d", (int)(( countAcountMe > 99) ? 99 : countAcountMe)]];
    }
    else
    {
        [viewAboutMe setHidden:YES];
        [lbAboutMe setText:@""];
    }
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self bcResignFirstResponder];
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self bcResignFirstResponder];
    
    //取得一个触摸对象（对于多点触摸可能有多个对象）
    UITouch *touch=[touches anyObject];
    
    //取得当前位置
    CGPoint current=[touch locationInView:self];
    //取得前一个位置
    CGPoint previous=[touch previousLocationInView:self];
    
    //之前中心
    CGPoint center = [bcAllItemView center];
    
    //偏移量
    CGPoint offset = CGPointMake( current.x-previous.x, current.y-previous.y);
    
    
    [bcAllItemView setCenter:CGPointMake( center.x+offset.x, center.y)];
    
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ( bcItemAllViewCenterXAlways - bcAllItemView.center.x > bcOffsetXMin) {
        //向左
        [self bcItemSlideToLeft];
    } else if ( bcItemAllViewCenterXAlways - bcAllItemView.center.x < -bcOffsetXMin) {
        //向右
        [self bcItemSlideToRight];
    }
}




- (void)bcItemBtnOnDragInside:(UIControl *)control withEvent:(UIEvent *)event {
    
    [self bcResignFirstResponder];
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint current = [touch locationInView:self];
    CGPoint previous = [touch previousLocationInView:self];
    
    CGPoint offset = CGPointMake( current.x-previous.x, current.y-previous.y);
    
    if (-bcOffsetXMin > offset.x || offset.x > bcOffsetXMin) {
        bcItemBtnDragInsideFlag = YES;
    }
    
    CGPoint center = [bcAllItemView center];
    bcItemAllViewCenterXCurrent = center.x+offset.x;
    [bcAllItemView setCenter:CGPointMake( bcItemAllViewCenterXCurrent, center.y)];
}



- (void)bcSetShowingItem:(LyBcCurrentIndex)index
{
    [self bcFirstIndexDidChanged];
    
    switch ( index) {
        case BcTheoryStudyCenter: {
            [_bcItemBtnTheoryStudy setSelected:YES];
            [_bcItemBtnCoach setSelected:NO];
            [_bcItemBtnDriveSchool setSelected:NO];
            [_bcItemBtnGuider setSelected:NO];
            [_bcItemBtnCommunity setSelected:NO];
            
            [bcItemFuncViewForTheoryStudy setHidden:NO];
            [bcItemFuncViewForCoach setHidden:YES];
            [bcItemFuncViewForDriveSchool setHidden:YES];
            [bcItemFuncViewForGuider setHidden:YES];
            [bcItemFuncViewForCommunity setHidden:YES];
            
            break;
        }
        case BcCoachCenter: {
            [_bcItemBtnTheoryStudy setSelected:NO];
            [_bcItemBtnCoach setSelected:YES];
            [_bcItemBtnDriveSchool setSelected:NO];
            [_bcItemBtnGuider setSelected:NO];
            [_bcItemBtnCommunity setSelected:NO];
            
            [bcItemFuncViewForTheoryStudy setHidden:YES];
            [bcItemFuncViewForCoach setHidden:NO];
            [bcItemFuncViewForDriveSchool setHidden:YES];
            [bcItemFuncViewForGuider setHidden:YES];
            [bcItemFuncViewForCommunity setHidden:YES];
            
            break;
        }
        case BcDriveSchoolCenter: {
            [_bcItemBtnTheoryStudy setSelected:NO];
            [_bcItemBtnCoach setSelected:NO];
            [_bcItemBtnDriveSchool setSelected:YES];
            [_bcItemBtnGuider setSelected:NO];
            [_bcItemBtnCommunity setSelected:NO];
            
            [bcItemFuncViewForTheoryStudy setHidden:YES];
            [bcItemFuncViewForCoach setHidden:YES];
            [bcItemFuncViewForDriveSchool setHidden:NO];
            [bcItemFuncViewForGuider setHidden:YES];
            [bcItemFuncViewForCommunity setHidden:YES];
            
            break;
        }
        case BcGuiderCenter: {
            [_bcItemBtnTheoryStudy setSelected:NO];
            [_bcItemBtnCoach setSelected:NO];
            [_bcItemBtnDriveSchool setSelected:NO];
            [_bcItemBtnGuider setSelected:YES];
            [_bcItemBtnCommunity setSelected:NO];
            
            [bcItemFuncViewForTheoryStudy setHidden:YES];
            [bcItemFuncViewForCoach setHidden:YES];
            [bcItemFuncViewForDriveSchool setHidden:YES];
            [bcItemFuncViewForGuider setHidden:NO];
            [bcItemFuncViewForCommunity setHidden:YES];
            
            break;
        }
        case BcCommunityCenter: {
            [_bcItemBtnTheoryStudy setSelected:NO];
            [_bcItemBtnCoach setSelected:NO];
            [_bcItemBtnDriveSchool setSelected:NO];
            [_bcItemBtnGuider setSelected:NO];
            [_bcItemBtnCommunity setSelected:YES];
            
            [bcItemFuncViewForTheoryStudy setHidden:YES];
            [bcItemFuncViewForCoach setHidden:YES];
            [bcItemFuncViewForDriveSchool setHidden:YES];
            [bcItemFuncViewForGuider setHidden:YES];
            [bcItemFuncViewForCommunity setHidden:NO];
            
            break;
        }
        default:
            break;
    }
}



- (void)bcSetDefaultItem
{
    _curIdx = BcDriveSchoolCenter;
    
    [self bcSetShowingItem:_curIdx];
}


- (void)setCurIdx:(LyBcCurrentIndex)curIdx
{   
    switch (curIdx) {
        case BcTheoryStudyCenter: {
            [self bcTargetForItemBtnTheoryStudy];
            break;
        }
        case BcCoachCenter: {
            [self bcTargetForItemBtnCoach];
            break;
        }
        case BcDriveSchoolCenter: {
            [self bcTargetForItemBtnDriveSchool];
            break;
        }
        case BcGuiderCenter: {
            [self bcTargetForItemBtnGuider];
            break;
        }
        case BcCommunityCenter: {
            [self bcTargetForItemBtnCommunity];
            break;
        }
    }
}



- (void)bcItemSlideToLeft
{
    //向左
    CGRect rectTmp = [_bcItemBtnCommunity frame];
    [_bcItemBtnCommunity setFrame:[_bcItemBtnGuider frame]];
    [_bcItemBtnGuider setFrame:[_bcItemBtnDriveSchool frame]];
    [_bcItemBtnDriveSchool setFrame:[_bcItemBtnCoach frame]];
    [_bcItemBtnCoach setFrame:[_bcItemBtnTheoryStudy frame]];
    [_bcItemBtnTheoryStudy setFrame:rectTmp];
    
    [self bcAnimationForSlide];
    
    
    _curIdx = (_curIdx + 1 + 5) % 5;
    
    [self bcSetShowingItem:_curIdx];
}



- (void)bcItemSlideToRight
{
    //向右
    CGRect rectTmp = [_bcItemBtnTheoryStudy frame];
    [_bcItemBtnTheoryStudy setFrame:[_bcItemBtnCoach frame]];
    [_bcItemBtnCoach setFrame:[_bcItemBtnDriveSchool frame]];
    [_bcItemBtnDriveSchool setFrame:[_bcItemBtnGuider frame]];
    [_bcItemBtnGuider setFrame:[_bcItemBtnCommunity frame]];
    [_bcItemBtnCommunity setFrame:rectTmp];
    

    [self bcAnimationForSlide];
    
    _curIdx = (_curIdx-1+5)%5;
    
    [self bcSetShowingItem:_curIdx];
}


- (void)bcAnimationForSlide
{
    [UIView beginAnimations:nil context:nil];
    CGPoint pointDes = CGPointMake( bcItemAllViewCenterXAlways, bcAllItemView.center.y);
    [bcAllItemView setCenter:pointDes];
    [UIView commitAnimations];
}


- (void)bcAnimationForItemBtnClick
{
    CGPoint pointForAnimation = CGPointMake( bcItemAllViewCenterXAlways+70, bcAllItemView.center.y);
    [bcAllItemView setCenter:pointForAnimation];
    
    [UIView beginAnimations:nil context:nil];
    CGPoint pointDes = CGPointMake( bcItemAllViewCenterXAlways, bcAllItemView.center.y);
    [bcAllItemView setCenter:pointDes];
    [UIView commitAnimations];
}





- (void)bcTargetForItemBtnTheoryStudy
{
    [self bcResignFirstResponder];
    
    if ( bcItemBtnDragInsideFlag) {
        if ( bcItemAllViewCenterXCurrent - bcItemAllViewCenterXAlways < -bcOffsetXMin) {
            //向左
            [self bcItemSlideToLeft];
        } else if ( bcItemAllViewCenterXCurrent - bcItemAllViewCenterXAlways > bcOffsetXMin) {
            //向右
            [self bcItemSlideToRight];
        }
    }
    else
    {
        BOOL bChangedFlag = NO;
        NSInteger iChangedIndex = _curIdx - BcTheoryStudyCenter;
        switch ( iChangedIndex) {
            case -4: {
                //不会有
                break;
            }
            case -3: {
                //不会有
                break;
            }
            case -2: {
                //不会有
                break;
            }
            case -1: {
                //不会有
                break;
            }
            case 0: {
                //就是自己
                break;
            }
            case 1: {
                bChangedFlag = YES;
                [self bcItemSlideToRight];
                break;
            }
            case 2: {
                bChangedFlag = YES;
                [self bcItemSlideToRight];
                [self bcItemSlideToRight];
                break;
            }
            case 3: {
                bChangedFlag = YES;
                [self bcItemSlideToLeft];
                [self bcItemSlideToLeft];
                break;
            }
            case 4: {
                bChangedFlag = YES;
                [self bcItemSlideToLeft];
                break;
            }
            default:
                break;
        }
        
        if ( bChangedFlag) {
//            [_bcItemBtnTheoryStudy setSelected:YES];
//            [_bcItemBtnCoach setSelected:NO];
//            [_bcItemBtnDriveSchool setSelected:NO];
//            [_bcItemBtnGuider setSelected:NO];
//            [_bcItemBtnCommunity setSelected:NO];
            
            [self bcAnimationForItemBtnClick];
        }
    }
    
    bcItemBtnDragInsideFlag = NO;
}



- (void)bcTargetForItemBtnCoach
{
    [self bcResignFirstResponder];
    
    if ( bcItemBtnDragInsideFlag)
    {
        
        if ( bcItemAllViewCenterXCurrent - bcItemAllViewCenterXAlways < -bcOffsetXMin)
        {
            //向左
            [self bcItemSlideToLeft];
        }
        else if ( bcItemAllViewCenterXCurrent - bcItemAllViewCenterXAlways > bcOffsetXMin)
        {
            //向右
            [self bcItemSlideToRight];
        }
        
    }
    else
    {
        BOOL bChangedFlag = NO;
        NSInteger iChangedIndex = _curIdx - BcCoachCenter;
        switch ( iChangedIndex) {
            case -4:
            {
                //不会有
                break;
            }
                
            case -3:
            {
                //不会有
                break;
            }
                
            case -2:
            {
                //不会有
                break;
            }
                
            case -1:
            {
                bChangedFlag = YES;
                [self bcItemSlideToLeft];
                break;
            }
                
            case 0:
            {
                //就是自己
                break;
            }
                
                
            case 1:
            {
                bChangedFlag = YES;
                [self bcItemSlideToRight];
                break;
            }
                
            case 2:
            {
                bChangedFlag = YES;
                [self bcItemSlideToRight];
                [self bcItemSlideToRight];
                break;
            }
                
            case 3:
            {
                bChangedFlag = YES;
                [self bcItemSlideToLeft];
                [self bcItemSlideToLeft];
                break;
            }
                
            case 4:
            {
                //不会有
                break;
            }
                
            default:
                break;
        }
        
        if ( bChangedFlag)
        {
//            [_bcItemBtnTheoryStudy setSelected:NO];
//            [_bcItemBtnCoach setSelected:YES];
//            [_bcItemBtnDriveSchool setSelected:NO];
//            [_bcItemBtnGuider setSelected:NO];
//            [_bcItemBtnCommunity setSelected:NO];
            
            [self bcAnimationForItemBtnClick];
        }
    
    }
    
    bcItemBtnDragInsideFlag = NO;

}



- (void)bcTargetForItemBtnDriveSchool
{
    [self bcResignFirstResponder];
    
    if ( bcItemBtnDragInsideFlag)
    {
        
        if ( bcItemAllViewCenterXCurrent - bcItemAllViewCenterXAlways < -bcOffsetXMin)
        {
            //向左
            [self bcItemSlideToLeft];
        }
        else if ( bcItemAllViewCenterXCurrent - bcItemAllViewCenterXAlways > bcOffsetXMin)
        {
            //向右
            [self bcItemSlideToRight];
        }
        
    }
    else
    {
        BOOL bChangedFlag = NO;
        NSInteger iChangedIndex = _curIdx - BcDriveSchoolCenter;
        switch ( iChangedIndex) {
            case -4:
            {
                //不会有
                break;
            }
                
            case -3:
            {
                //不会有
                break;
            }
                
            case -2:
            {
                bChangedFlag = YES;
                [self bcItemSlideToLeft];
                [self bcItemSlideToLeft];
                break;
            }
                
            case -1:
            {
                bChangedFlag = YES;
                [self bcItemSlideToLeft];
                break;
            }
                
            case 0:
            {
                //就是自己
                break;
            }
                
                
            case 1:
            {
                bChangedFlag = YES;
                [self bcItemSlideToRight];
                break;
            }
                
            case 2:
            {
                bChangedFlag = YES;
                [self bcItemSlideToRight];
                [self bcItemSlideToRight];
                break;
            }
                
            case 3:
            {
                //不会有
                break;
            }
                
            case 4:
            {
                //不会有
                break;
            }
                
            default:
                break;
        }
        
        if ( bChangedFlag)
        {
//            [_bcItemBtnTheoryStudy setSelected:NO];
//            [_bcItemBtnCoach setSelected:NO];
//            [_bcItemBtnDriveSchool setSelected:YES];
//            [_bcItemBtnGuider setSelected:NO];
//            [_bcItemBtnCommunity setSelected:NO];
            
            [self bcAnimationForItemBtnClick];
        }
        
    }
    
    bcItemBtnDragInsideFlag = NO;
}



- (void)bcTargetForItemBtnGuider
{
    
    [self bcResignFirstResponder];
    
    
    if ( bcItemBtnDragInsideFlag)
    {
        
        if ( bcItemAllViewCenterXCurrent - bcItemAllViewCenterXAlways < -bcOffsetXMin)
        {
            //向左
            [self bcItemSlideToLeft];
        }
        else if ( bcItemAllViewCenterXCurrent - bcItemAllViewCenterXAlways > bcOffsetXMin)
        {
            //向右
            [self bcItemSlideToRight];
        }
    }
    else
    {
        BOOL bChangedFlag = NO;
        NSInteger iChangedIndex = _curIdx - BcGuiderCenter;
        
        switch ( iChangedIndex) {
            case -4:
            {
                //不会有
                break;
            }
                
            case -3:
            {
                bChangedFlag = YES;
                [self bcItemSlideToRight];
                [self bcItemSlideToRight];
                break;
            }
                
            case -2:
            {
                bChangedFlag = YES;
                [self bcItemSlideToLeft];
                [self bcItemSlideToLeft];
                break;
            }
                
            case -1:
            {
                bChangedFlag = YES;
                [self bcItemSlideToLeft];
                break;
            }
                
            case 0:
            {
                //就是自己
                break;
            }
                
            case 1:
            {
                bChangedFlag = YES;
                [self bcItemSlideToRight];
                break;
            }
                
            case 2:
            {
                //不会有
                break;
            }
                
            case 3:
            {
                //不会有
                break;
            }
                 
             case 4:
             {
                 break;
             }
                
            default:
                break;
        }
        
        if ( bChangedFlag)
        {
//            [_bcItemBtnTheoryStudy setSelected:NO];
//            [_bcItemBtnCoach setSelected:NO];
//            [_bcItemBtnDriveSchool setSelected:NO];
//            [_bcItemBtnGuider setSelected:YES];
//            [_bcItemBtnCommunity setSelected:NO];
            
            [self bcAnimationForItemBtnClick];
        }
    }
    
    bcItemBtnDragInsideFlag = NO;
}



- (void)bcTargetForItemBtnCommunity {
    [self bcResignFirstResponder];
    
    if ( bcItemBtnDragInsideFlag) {
        if ( bcItemAllViewCenterXCurrent - bcItemAllViewCenterXAlways < -bcOffsetXMin) {
            //向左
            [self bcItemSlideToLeft];
        } else if ( bcItemAllViewCenterXCurrent - bcItemAllViewCenterXAlways > bcOffsetXMin) {
            //向右
            [self bcItemSlideToRight];
        }
    } else {
        BOOL bChangedFlag = NO;
        NSInteger iChangedIndex = _curIdx - BcCommunityCenter;
        
        switch ( iChangedIndex) {
            case -4:{
                bChangedFlag = YES;
                [self bcItemSlideToRight];
                break;
            }
            case -3: {
                bChangedFlag = YES;
                [self bcItemSlideToRight];
                [self bcItemSlideToRight];
                break;
            }
            case -2: {
                bChangedFlag = YES;
                [self bcItemSlideToLeft];
                [self bcItemSlideToLeft];
                break;
            }
            case -1: {
                bChangedFlag = YES;
                [self bcItemSlideToLeft];
                break;
            }
            case 0: {
                //就是自己
                break;
            }
            case 1: {
                //不会有
                break;
            }
            case 2: {
                //不会有
                break;
            }
            case 3: {
                //不会有
                break;
            }
            case 4: {
                break;
            }
            default:
                break;
        }
        
        if ( bChangedFlag) {
            [self bcAnimationForItemBtnClick];
        }
    }
    
    bcItemBtnDragInsideFlag = NO;
}


//搜索框地址按钮
- (void)bcTargetForBtnAddressItem:(UIButton *)button {
    [self bcResignFirstResponder];
    
    [_delegate onSearchWillBegin:[button tag]];
    [_delegate onCLickedByAddressButton:[button tag]];
}


//理论学习按钮
- (void)bcTargetForBtnTheoryStudy:(UIControl *)control withEvent:(UIEvent *)event {
    
    if ( BcTheoryStudyBtnTag_ExamLocale == [control tag]) {
        [_delegate onBtnExamLocaleClick];
    } else if ( BcTheoryStudyBtnTag_LicenseInfo == [control tag]) {
        [_delegate onBtnLicenseInfoClick];
    }
}

//驾考圈按钮
- (void)bcTargetForBtnCommunity:(UIControl *)control withEvent:(UIEvent *)event {
    
    if ( BcCommunityBtnTag_SendStatus == [control tag]) {
        [_delegate onBtnSendStatusClick];
    } else if ( BcCommunityBtnTag_NewsAboutMe == [control tag]) {
        [self setCountAboutMe:0];
        [_delegate onBtnNewsAboutMeClick];
    }
}



- (void)bcAddKeyboardEventNotification {
    //增加监听，当键盘出现或改变时收出消息
    if ( [self respondsToSelector:@selector(bcTargetForNotificationToKeyboardWillShow:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bcTargetForNotificationToKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    
    //增加监听，当键退出时收出消息
    if ( [self respondsToSelector:@selector(bcTargetForNotificationToKeyboardWillHide:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bcTargetForNotificationToKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}



//当键盘出现或改变时调用
- (void)bcTargetForNotificationToKeyboardWillShow:(NSNotification *)notification {
    bcSearchBarEditing = YES;
    
    int keyboardHight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    CGRect rectBcViewKeyboardShowing = CGRectMake( 0, SCREEN_HEIGHT-keyboardHight-BCVIEWHEIGHT, BCVIEWWIDTH, BCVIEWHEIGHT);
    [self setFrame:rectBcViewKeyboardShowing];
    
    if ( [_bcSearchBarCoach isFirstResponder]) {
        [_delegate onSearchWillBegin:0];
        [_bcSearchBarCoach setShowsCancelButton:YES animated:YES];
    }
    
    
    if ( [_bcSearchBarDriveSchool isFirstResponder]) {
        [_delegate onSearchWillBegin:1];
        [_bcSearchBarDriveSchool setShowsCancelButton:YES animated:YES];
    }
    
    if ( [_bcSearchBarGuider isFirstResponder]) {
        [_delegate onSearchWillBegin:2];
        [_bcSearchBarGuider setShowsCancelButton:YES animated:YES];
    }
}



//当键退出时调用
- (void)bcTargetForNotificationToKeyboardWillHide:(NSNotification *)notification {
    [self bcTargetForKeyboardHide];
}


- (void)bcTargetForKeyboardHide {
    
    [self setFrame:BCVIEWFRAME];
    [bcAllItemView setFrame:BCALLITEMVIEWFRAME];
    
    switch (_curIdx) {
        case BcCoachCenter: {
           [_bcSearchBarCoach setShowsCancelButton:NO animated:YES];
            break;
        }
        case BcDriveSchoolCenter: {
            [_bcSearchBarDriveSchool setShowsCancelButton:NO animated:YES];
            break;
        }
        case BcGuiderCenter: {
            [_bcSearchBarGuider setShowsCancelButton:NO animated:YES];
            break;
        }
        default:
            break;
    }
}


- (void)bcFirstIndexDidChanged {
    [_delegate onChangViewContollerSelectedIndex:_curIdx];
}



- (void)setLocale:(NSString *)address {
    
    if (![LyUtil validateString:address] || address.length < 4) {
        return;
    }
    
    NSArray *arr = [LyUtil separateString:address separator:@" "];
    
    if ( !arr || ![arr isKindOfClass:[NSArray class]] || [arr count] < 2) {
        return;
    }
    
    _address = address;
    
    NSString *strProvince = [arr objectAtIndex:0];
    NSString *strCity = [arr objectAtIndex:1];
    
    NSString *province;
    NSString *city;
    
    NSRange rangeProvince = [strProvince rangeOfString:@"省"];
    if ( rangeProvince.length < 1) {
        rangeProvince = [strProvince rangeOfString:@"市"];
        if ( rangeProvince.length < 1) {
            rangeProvince = [strProvince rangeOfString:@"自治区"];
            if ( rangeProvince.length < 1) {
                rangeProvince = [strProvince rangeOfString:@"特别行政区"];
                if ( rangeProvince.length < 1) {
                    province = strProvince;
                } else {
                    province = [strProvince substringToIndex:rangeProvince.location];
                }
                
            } else {
                province = [strProvince substringToIndex:rangeProvince.location];
                
                NSRange rangeNation = [province rangeOfString:@"壮族"];
                if ( rangeNation.length < 1) {
                    rangeNation = [province rangeOfString:@"回族"];
                    if ( rangeNation.length < 1) {
                        rangeNation = [province rangeOfString:@"维吾尔"];
                        if ( rangeNation.length < 1) {
//                            province = province;
                        } else {
                            province = [province substringToIndex:rangeNation.location];
                        }
                    } else {
                        province = [province substringToIndex:rangeNation.location];
                    }
                    
                } else {
                    province = [province substringToIndex:rangeNation.location];
                }
                
            }
        } else {
            province = [strProvince substringToIndex:rangeProvince.location];
        }
        
    } else {
        province = [strProvince substringToIndex:rangeProvince.location];
    }
    
    
    
    NSRange rangeCity = [strCity rangeOfString:@"市"];
    if ( rangeCity.length < 1) {
        rangeCity = [strCity rangeOfString:@"特别行政区"];
        if ( rangeCity.length < 1) {
            city = strCity;
        } else {
            city = [strCity substringToIndex:rangeCity.location];
        }
    } else {
        city = [strCity substringToIndex:rangeCity.location];
    }
    
    
    [_bcBtnTheoryStudyExamLocale setTitle:[[NSString alloc] initWithFormat:@"%@ %@", province, city] forState:UIControlStateNormal];
    
}

- (void)setLicenseInfo:(LyLicenseType)license object:(LySubjectMode)subject {
    _license = license;
    _subject = subject;
    
    [_bcBtnTheoryStudyLicenseInfo setTitle:[[NSString alloc] initWithFormat:@"%@ %@", [LyUtil driveLicenseStringFrom:_license], [LyUtil subjectStringForm:subject]]
                                  forState:UIControlStateNormal];
}





#pragma mark -UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    if (searchBar.text.length > 0) {
        [_delegate onSearch:[searchBar text] index:[searchBar tag]-BcSearchBarTag_Coach];
    }

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}





@end



