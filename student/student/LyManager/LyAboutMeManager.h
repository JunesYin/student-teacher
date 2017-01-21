//
//  LyAboutMeManager.h
//  LyStudyDrive
//
//  Created by Junes on 16/6/23.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LyAboutMe.h"
#import "LySingleInstance.h"


@interface LyAboutMeManager : NSObject

lySingle_interface

- (void)addAboutMe:(LyAboutMe *)aboutMe;

- (LyAboutMe *)getAboutMeWithId:(NSString *)amId;

- (NSArray *)aboutMeWithUserId:(NSString *)userId;

- (NSArray *)additionalAboutMeWithAboutMe:(LyAboutMe *)aboutMe;

@end
