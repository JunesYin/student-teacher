//
//  LyStudent.m
//  teacher
//
//  Created by Junes on 16/8/19.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyStudent.h"

@implementation LyStudent


//@property (strong, nonatomic, nullable) NSString        *userId;
//@property (strong, nonatomic, nullable) NSString        *userName;
//@property (strong, nonatomic, nullable) NSString        *userPhoneNum;
//@property (strong, nonatomic, nullable) UIImage         *userAvatar;
//@property (strong, nonatomic, nullable) NSString        *userAvatarName;

@synthesize userId = _userId;
@synthesize userName = _userName;
@synthesize userPhoneNum = _userPhoneNum;
@synthesize userAvatar = _userAvatar;

@synthesize stuNote = _stuNote;

+ (instancetype)studentWithId:(NSString *)stuId
                      stuName:(NSString *)stuName
                  stuPhoneNum:(NSString *)stuPhoneNum
                 stuTeacherId:(NSString *)stuTeacherId
                    stuCensus:(NSString *)stuCensus
               stuPickAddress:(NSString *)stuPickAddress
            stuTrainClassName:(NSString *)stuTrainClassName
                   stuPayInfo:(LyPayInfo)stuPayInfo
             stuStudyProgress:(LySubjectMode)stuStudyProgress
                      stuNote:(NSString *)stuNote
{
    LyStudent *student = [[LyStudent alloc] initWithId:stuId
                                               stuName:stuName
                                           stuPhoneNum:stuPhoneNum
                                          stuTeacherId:stuTeacherId
                                             stuCensus:stuCensus
                                        stuPickAddress:stuPickAddress
                                     stuTrainClassName:stuTrainClassName
                                            stuPayInfo:stuPayInfo
                                      stuStudyProgress:stuStudyProgress
                                               stuNote:stuNote];
    
    return student;
}

- (instancetype)initWithId:(NSString *)stuId
                   stuName:(NSString *)stuName
               stuPhoneNum:(NSString *)stuPhoneNum
              stuTeacherId:(NSString *)stuTeacherId
                 stuCensus:(NSString *)stuCensus
            stuPickAddress:(NSString *)stuPickAddress
         stuTrainClassName:(NSString *)stuTrainClassName
                stuPayInfo:(LyPayInfo)stuPayInfo
          stuStudyProgress:(LySubjectMode)stuStudyProgress
                   stuNote:(NSString *)stuNote
{
    if (self = [super init])
    {
        _userId = stuId;
        _userName = stuName;
        _userPhoneNum = stuPhoneNum;
        
        _stuTeacherId = stuTeacherId;
        _stuCensus = stuCensus;
        _stuPickAddress = stuPickAddress;
        _stuTrainClassName = stuTrainClassName;
        _stuPayInfo = stuPayInfo;
        _stuStudyProgress = stuStudyProgress;
        self.stuNote = stuNote;
        
        [LyImageLoader loadAvatarWithUserId:_userId
                                   complete:^(UIImage * _Nullable image, NSError * _Nullable error, NSString * _Nullable userId) {
                                       if (!image) {
                                           image = [LyUtil defaultAvatarForStudent];
                                       }
                                       _userAvatar = image;
                                   }];
    }
    
    return self;
}


- (void)setStuNote:(NSString *)stuNote {
    if (![LyUtil validateString:stuNote]) {
        _stuNote = @"";
    } else {
        _stuNote = stuNote;
    }
}


- (NSString *)userTypeByString {
    return userTypeStudentKey;
}


- (NSString *)stuCensus {
    if (![LyUtil validateString:_stuCensus]) {
        return @"";
    }
    
    return _stuCensus;
}

- (NSString *)stuPickAddress {
    if (![LyUtil validateString:_stuPickAddress]) {
        return @"";
    }
    
    return _stuPickAddress;
}

- (NSString *)stuTrainClassName {
    if (![LyUtil validateString:_stuTrainClassName]) {
        return @"";
    }
    
    return _stuTrainClassName;
}

- (NSString *)stuNote {
    if (![LyUtil validateString:_stuNote]) {
        return @"";
    }
    
    return _stuNote;
}

@end
