//
//  NSString+Validate.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/28.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "NSString+Validate.h"

@implementation NSString (Validate)

- (BOOL)validatePhoneNumber
{
    if ( self.length < 11)
    {
        return NO;
    }
    
    
    NSString *verFlagPhoneNumber = @"^1[34578]\\d{9}$";
    
    
    NSPredicate *regexPhoneNumber = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", verFlagPhoneNumber];
    
    return [regexPhoneNumber evaluateWithObject:self];
    
}



- (BOOL)validatePassword
{
    if ( self.length < 6 || self.length > 18)
    {
        return NO;
    }
    
    NSString *verFlagPassword = @"(\\d+[a-zA-Z]+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*)|([a-zA-Z]+\\d+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*)|(\\d+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*[a-zA-Z]+)|([a-zA-Z]+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*\\d+)|([-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*\\d+[a-zA-Z]+)|([-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*[a-zA-Z]+\\d+)";
    // 必须包含数字和字母，可以包含上述特殊字符。
    // 依次为（如果包含特殊字符）
    // 数字 字母 特殊
    // 字母 数字 特殊
    // 数字 特殊 字母
    // 字母 特殊 数字
    // 特殊 数字 字母
    // 特殊 字母 数字
    
    NSPredicate *regexPassword = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", verFlagPassword];
    
    
    return [regexPassword evaluateWithObject:self];
}



- (BOOL)validateAuthCode
{
    if ( 6 != self.length)
    {
        return NO;
    }
    
    
    NSString *verFlagAuthCode = @"^[0-9]*$";
    
    NSPredicate *regexAuthCode = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", verFlagAuthCode];
    
    
    return [regexAuthCode evaluateWithObject:self];
}



- (BOOL)validateName
{
//    NSString *verFlagName = @"^[\u4e00-\u9fa5]{2,15}$|^[a-zA-z]";
    NSString *verFlagName = @"^[\u4e00-\u9fa5_a-zA-Z0-9]+$";
    
    NSPredicate *regexName = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", verFlagName];
    
    return [regexName evaluateWithObject:self];
}



- (BOOL)validateInt
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}


- (BOOL)validateEmail
{
    NSString *verFlagEmail = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    
    NSPredicate *regexEmail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", verFlagEmail];
    
    return [regexEmail evaluateWithObject:self];
    
}



- (BOOL)validateSensitiveWord
{
    NSError *error;
    NSString *txtPath = [[NSBundle mainBundle] pathForResource:@"sensitiveWord" ofType:@"txt"];
    NSString *strContent = [NSString stringWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:&error];
    
    if (!error)
    {
        NSArray *arr = [self separateString:strContent separator:@"\r\n"];
        
        for (NSString *item in arr)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", item];
            if ([predicate evaluateWithObject:self])
            {
                NSLog(@"含有非法内容--%@", item);
                return NO;
            }
        }
    }
    
    return YES;
}



- (BOOL)validateIdCar
{
    NSString *verFlagIdCar = @"/^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$/";
    
    NSPredicate *regexIdCar = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", verFlagIdCar];
    
    return [regexIdCar evaluateWithObject:self];
}



- (NSArray *)separateString:(NSString *)strSour separator:(NSString *)separator
{
    if ( !strSour || [NSNull null] == (NSNull *)strSour || [strSour isEqualToString:@""])
    {
        return nil;
    }
    
    NSString *strTmp = [strSour copy];
    
    NSRange rangeOfSeparator = [strTmp rangeOfString:separator];
    
    if ( rangeOfSeparator.length < 1)
    {
        return @[strSour];
    }
    
    NSString *strItem = [strTmp substringToIndex:rangeOfSeparator.location];
    
    NSString *strRemain = [strTmp substringFromIndex:rangeOfSeparator.location+rangeOfSeparator.length];
    
    
    return [@[strItem] arrayByAddingObjectsFromArray:[self separateString:strRemain separator:separator]];
}



@end
