//
//  LyBottomControl.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/21.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "LySingleInstance.h"
#import "LyUtil.h"



typedef NS_ENUM( NSInteger, LyBcCurrentIndex)
{
    BcTheoryStudyCenter,
    BcCoachCenter,
    BcDriveSchoolCenter,
    BcGuiderCenter,
    BcCommunityCenter
};


NS_ASSUME_NONNULL_BEGIN

@protocol LyBottomControlDelegate;

@interface LyBottomControl : UIView


@property ( strong, nonatomic)              UIButton                        *bcItemBtnCoach;
@property ( strong, nonatomic)              UIButton                        *bcItemBtnDriveSchool;
@property ( strong, nonatomic)              UIButton                        *bcItemBtnGuider;
@property ( strong, nonatomic)              UIButton                        *bcItemBtnTheoryStudy;
@property ( strong, nonatomic)              UIButton                        *bcItemBtnCommunity;


@property ( strong, nonatomic)              UISearchBar                     *bcSearchBarCoach;
@property ( strong, nonatomic)              UISearchBar                     *bcSearchBarDriveSchool;
@property ( strong, nonatomic)              UISearchBar                     *bcSearchBarGuider;
@property ( strong, nonatomic)              UIButton                        *bcBtnAddressCoach;
@property ( strong, nonatomic)              UIButton                        *bcBtnAddressDriveSchool;
@property ( strong, nonatomic)              UIButton                        *bcBtnAddressGuider;

@property ( strong, nonatomic)              UIButton                        *bcBtnTheoryStudyExamLocale;
@property ( strong, nonatomic)              UIButton                        *bcBtnTheoryStudyLicenseInfo;
@property ( strong, nonatomic)              UIButton                        *bcBtnCommunitySendStatus;
@property ( strong, nonatomic)              UIButton                        *bcBtnCommunityAboutMe;


@property ( strong, nonatomic)              UITextField                     *bcTfSendStatus;
@property ( strong, nonatomic)              UITextField                     *BcBtnSendStatus;


@property (assign, nonatomic)       LyBcCurrentIndex        curIdx;


@property ( strong, nonatomic, readonly)    NSString                        *address;
@property ( assign, nonatomic, readonly)    LyLicenseType                   license;
@property ( assign, nonatomic, readonly)    LySubjectMode                   subject;



@property ( strong, nonatomic)              id<LyBottomControlDelegate>     delegate;

lySingle_interface

- (void)setLocale:(NSString *)address;

- (void)setLicenseInfo:(LyLicenseType)license object:(LySubjectMode)subject;

- (void)bcResignFirstResponder;

- (void)setBtnAddressCoachTitle:(NSString *)title;

- (void)setBtnAddressDriveSchoolTitle:(NSString *)title;

- (void)setBtnAddressGuiderTitle:(NSString *)title;

- (void)setCountAboutMe:(NSInteger)countAcountMe;

@end



@protocol LyBottomControlDelegate <NSObject>

@required
- (void)onChangViewContollerSelectedIndex:(NSInteger)selectedIndex;



- (void)onCLickedByAddressButton:(NSInteger)index;

- (void)onSearch:(NSString *)strSearch index:(NSInteger)index;

- (void)onSearchWillBegin:(NSInteger)index;

//- (void)onClickedByAddressBtnCoach;
//
//- (void)onClickedByAddressBtnDriveSchool;
//
//- (void)onClickedByAddressBtnGuider;

- (void)onBtnExamLocaleClick;

- (void)onBtnLicenseInfoClick;

- (void)onBtnSendStatusClick;

- (void)onBtnNewsAboutMeClick;







@end



NS_ASSUME_NONNULL_END
