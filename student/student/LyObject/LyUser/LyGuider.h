//
//  LyGuider.h
//  LyStudyDrive
//
//  Created by Junes on 16/3/29.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyUser.h"


@interface LyGuider : LyUser

@property ( strong, nonatomic)                      NSString                *userId;
@property ( strong, nonatomic)                      NSString                *userName;
@property ( strong, nonatomic)                      NSString                *userBirthday;
@property ( strong, nonatomic)                      NSString                *userPhoneNum;
@property ( strong, nonatomic)                      UIImage                 *userAvatar;
@property ( strong, nonatomic)                      NSString                *userAddress;
@property ( strong, nonatomic)                      NSString                *userSignature;
@property ( assign, nonatomic)                      LySex                   userSex;
@property ( assign, nonatomic)                      int                     userAge;
@property ( assign, nonatomic)                      LyUserType              userType;
@property ( strong, nonatomic, readonly)            NSMutableArray          *arrLandMark;
@property (assign, nonatomic, getter=isSearching)   BOOL                    searching;
@property ( assign, nonatomic)                      double                  distance;

@property (assign, nonatomic)   int     precedence;

@property ( assign, nonatomic          ) LyLicenseType userLicenseType;


@property (assign, nonatomic)       float   price;
@property (assign, nonatomic)       float   score;
@property (assign, nonatomic)       int     stuAllCount;


@property ( strong, nonatomic)                      NSString                *guiCost;
@property ( strong, nonatomic)                      NSString          *guiPickRange;
@property ( strong, nonatomic)                      NSString                *guiDescription;
//@property ( assign, nonatomic)                      float                   guiScore;               //星级
@property ( strong, nonatomic)                      NSString                *guiTeachBirthday;
@property ( assign, nonatomic, readonly)            int                     guiTeachedAge;          //教车年龄
@property ( strong, nonatomic)                      NSString                *guiDriveBirthday;
@property ( assign, nonatomic, readonly)            int                     guiDrivedAge;           //驾车年龄
//@property ( assign, nonatomic)                      int                     guiTeachAllCount;       //所有学生数
@property ( assign, nonatomic)                      int                     guiTeachedPassedCount;  //已通过学生数
@property ( assign, nonatomic)                      int                     guiTeachableCount;      //可教学生数
@property ( assign, nonatomic)                      int                     guiTeachingCount;       //正在教学生数
//@property ( assign, nonatomic)                      float                   guiPrice;               //价格
@property ( assign, nonatomic)                      int                     guiPraiseCount;         //好评数
@property ( assign, nonatomic)                      int                     guiEvaluationCount;      //总评论数
@property ( assign, nonatomic)                      int                     guiConsultCount;

@property ( strong, nonatomic, readonly)                      NSMutableArray          *guiArrPicUrl;

@property ( assign, nonatomic)                      BOOL                    guiTimeFlag;
@property ( assign, nonatomic)                      LyTeacherVerifyState    guiVerifyState;

@property ( assign, nonatomic)           double          deposit;


+ (instancetype)guiderWithIdNoAvatar:(NSString *)userId
                            userName:(NSString *)userName;

- (instancetype)initWithIdNoAvatar:(NSString *)userId
                          userName:(NSString *)userName;


+ (instancetype)guiderWithGuiderId:(NSString *)guiId
                           guiName:(NSString *)guiName;

- (instancetype)initWithGuiderId:(NSString *)guiId
                         guiName:(NSString *)guiName;


+ (instancetype)guiderWithId:(NSString *)guiId
                     guiName:(NSString *)guiName
                       score:(float)score
                      guiSex:(LySex)guiSex
                 guiBirthday:(NSString *)guiBirthday
            guiTeachBirthday:(NSString *)guiTeachBirthday
            guiDriveBirthday:(NSString *)guiDriveBirthday
                 stuAllCount:(int)stuAllCount
       coaTeachedPassedCount:(int)guiTeachedPassedCount
           guiEvaluationCount:(int)guiEvaluationCount
              guiPraiseCount:(int)guiPraiseCount
                       price:(float)price;

- (instancetype)initWithId:(NSString *)guiId
                   guiName:(NSString *)guiName
                  score:(float)score
                    guiSex:(LySex)guiSex
               guiBirthday:(NSString *)guiBirthday
          guiTeachBirthday:(NSString *)guiTeachBirthday
          guiDriveBirthday:(NSString *)guiDriveBirthday
               stuAllCount:(int)stuAllCount
     coaTeachedPassedCount:(int)guiTeachedPassedCount
         guiEvaluationCount:(int)guiEvaluationCount
            guiPraiseCount:(int)guiPraiseCount
                     price:(float)price;

- (NSString *)userTypeByString;

- (NSString *)perPass;

- (NSString *)perPraise;


- (NSString *)userLicenseTypeByString;

- (void)addPicUrl:(NSString *)picUrl;

@end
