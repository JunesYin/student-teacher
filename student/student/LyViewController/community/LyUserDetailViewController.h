//
//  LyUserDetailViewController.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/15.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LyUser;

@protocol LyUserDetailDelegate <NSObject>

@required
- (NSString *)obtainUserId;

@optional
- (LyUser *)obtainUserInfo;

@end


@interface LyUserDetailViewController : UIViewController

@property ( retain, nonatomic, readonly)    NSString                        *userId;

@property ( strong, nonatomic)              UIButton                        *btnAttente;
@property ( strong, nonatomic)              UIButton                        *btnMessage;

@property ( weak, nonatomic)                id<LyUserDetailDelegate>        delegate;





@end
