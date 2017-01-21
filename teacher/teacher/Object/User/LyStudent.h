//
//  LyStudent.h
//  teacher
//
//  Created by Junes on 16/8/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyUser.h"
#import "LyUtil.h"

@interface LyStudent : LyUser

@property (strong, nonatomic, nonnull) NSString        *userId;
@property (strong, nonatomic, nonnull) NSString        *userName;
@property (strong, nonatomic, nonnull) NSString        *userPhoneNum;
@property (strong, nonatomic, nullable) UIImage        *userAvatar;

@property (strong, nonatomic, nonnull)  NSString        *stuTeacherId;
@property (strong, nonatomic, nullable) NSString        *stuCensus;
@property (strong, nonatomic, nullable) NSString        *stuPickAddress;
@property (strong, nonatomic, nullable) NSString        *stuTrainClassName;
@property (assign, nonatomic)           LyPayInfo       stuPayInfo;
@property (assign, nonatomic)           LySubjectMode   stuStudyProgress;
//@property (strong, nonatomic, nullable) NSString        *stuNote;
@property (strong, nonatomic, nullable) NSString        *stuNote;



+ (instancetype)studentWithId:(NSString *)stuId
                      stuName:(NSString *)stuName
                  stuPhoneNum:(NSString *)stuPhoneNum
                 stuTeacherId:(NSString *)stuTeacherId
                    stuCensus:(NSString *)stuCensus
               stuPickAddress:(NSString *)stuPickAddress
            stuTrainClassName:(NSString *)stuTrainClassName
                   stuPayInfo:(LyPayInfo)stuPayInfo
             stuStudyProgress:(LySubjectMode)stuStudyProgress
                      stuNote:(NSString *)stuNote;

- (instancetype)initWithId:(NSString *)stuId
                   stuName:(NSString *)stuName
               stuPhoneNum:(NSString *)stuPhoneNum
              stuTeacherId:(NSString *)stuTeacherId
                 stuCensus:(NSString *)stuCensus
            stuPickAddress:(NSString *)stuPickAddress
         stuTrainClassName:(NSString *)stuTrainClassName
                stuPayInfo:(LyPayInfo)stuPayInfo
          stuStudyProgress:(LySubjectMode)stuStudyProgress
                   stuNote:(NSString *)stuNote;

- (NSString *)userTypeByString;

@end
