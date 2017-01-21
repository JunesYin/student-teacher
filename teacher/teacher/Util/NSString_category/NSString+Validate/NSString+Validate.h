//
//  NSString+Validate.h
//  LyStudyDrive
//
//  Created by Junes on 16/4/28.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validate)

- (BOOL)validatePhoneNumber;

- (BOOL)validatePassword;

- (BOOL)validateAuthCode;

- (BOOL)validateName;

- (BOOL)validateInt;

- (BOOL)validateEmail;

- (BOOL)validateSensitiveWord;

- (BOOL)validateIdCar;

@end
