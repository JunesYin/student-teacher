//
//  LyRegisterViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/16.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LySingleInstance.h"


@class JVFloatLabeledTextField;
@class LyGetAuthCodeButton;

@interface LyStudentRegisterViewController : UIViewController

@property ( strong, nonatomic)              UIBarButtonItem                 *srRightBarBtnItem;
@property ( strong, nonatomic)              JVFloatLabeledTextField                     *srTfName;
@property ( strong, nonatomic)              JVFloatLabeledTextField                     *srTfPhoneNumber;
@property ( strong, nonatomic)              JVFloatLabeledTextField                     *srTfAuthCode;
@property ( strong, nonatomic)              JVFloatLabeledTextField                     *srTfPassword;
@property ( strong, nonatomic)              JVFloatLabeledTextField                     *srTfCheckPassword;

@property ( strong, nonatomic)              LyGetAuthCodeButton                        *srBtnGetAuthCode;
@property ( strong, nonatomic)              UIButton                        *srBtnRegister;



@end
