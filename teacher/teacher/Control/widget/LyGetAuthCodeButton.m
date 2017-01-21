//
//  LyGetAuthCodeButton.m
//  LyStudyDrive
//
//  Created by Junes on 16/3/26.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyGetAuthCodeButton.h"

#import "LyRemindView.h"

#import "NSString+Validate.h"

#import "LyUtil.h"




CGFloat const btnGetAuthCodeWidth = 100.0f;
CGFloat const btnGetAuthCodeHeight = 34.0f;;


#define SELFTITLEFONT               LyFont(14)


typedef NS_ENUM(NSInteger, LyGetAuthCodeButtonHttpMethod) {
    getAuthCodeButtonHttpMethod_send = 100,
};


@interface LyGetAuthCodeButton () <LyHttpRequestDelegate>
{
    BOOL                    bHttpFlag;
    LyGetAuthCodeButtonHttpMethod   curHttMethod;
}

@end


@implementation LyGetAuthCodeButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame])
    {
        [self initSomeProperty];
    }
    
    return self;
}



- (void)initSomeProperty
{
    _timeTotal = 60;
    _timeInterval = 1;
    
    [self setBackgroundImage:[LyUtil imageWithColor:Ly517ThemeColor withSize:self.frame.size] forState:UIControlStateNormal];
    [self setBackgroundImage:[LyUtil imageWithColor:[UIColor grayColor] withSize:self.frame.size] forState:UIControlStateDisabled];
    [[self layer] setMasksToBounds:YES];
    [[self layer] setCornerRadius:5.0f];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self.titleLabel setFont:SELFTITLEFONT];
    [self setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    [self addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
}


- (void)onClick {
    
    _phoneNumber = [_delegate obtainPhoneNum:self];
    
    if (![LyUtil validateString:_phoneNumber] && ![_phoneNumber validatePhoneNumber]) {
        return;
    } else {
        [self send];
        
        [self setEnabled:NO];
        [self setTitle:@"正在获取..." forState:UIControlStateDisabled];
    }
}


- (void)sendSuccess {
    
    if ( !_timer) {
        
        _curTime = _timeTotal;
        [self setEnabled:NO];
        [self setTitle:@"再次获取(60s)" forState:UIControlStateDisabled];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(targetForTimerAuth) userInfo:nil repeats:YES];
        
        [_timer fire];
    }

}


- (void)targetForTimerAuth {
    if ( _curTime > 0) {
        _curTime -= _timeInterval;
        [self setTitle:[[NSString alloc] initWithFormat:@"再次获取(%ds)", _curTime] forState:UIControlStateDisabled];
    } else {
        [self setEnabled:YES];
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)send {
    LyHttpRequest *hr = [LyHttpRequest httpRequestWithMode:getAuthCodeButtonHttpMethod_send];
    [hr setDelegate:self];
    bHttpFlag = [[hr startHttpRequest:getAuthCode_url
                                 body:@{
                                        phoneKey:_phoneNumber
                                        }
                                 type:LyHttpType_asynPost
                              timeOut:0] boolValue];
}


- (void)handleHttpFailed {
    
    [self setEnabled:YES];
    [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"发送失败"] show];
}

- (void)analysisHttpResult:(NSString *)result {
    NSDictionary *dic = [LyUtil getObjFromJson:result];
    if (![LyUtil validateDictionary:dic]) {
        [self handleHttpFailed];
        return;
    }
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if (![LyUtil validateString:strCode]) {
        [self handleHttpFailed];
        return;
    }
    
    if (codeMaintaining == [strCode integerValue]) {
        
        [LyUtil serverMaintaining];
        return;
    }
    
    
    switch (curHttMethod) {
        case getAuthCodeButtonHttpMethod_send: {
            switch ([strCode integerValue]) {
                case 0: {
                    _time = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:timeKey]];
                    _trueAuthCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:authKey]];
                    if (![LyUtil validateString:_time] || ![LyUtil validateString:_trueAuthCode]) {
                        [self handleHttpFailed];
                        return;
                    }
                    
                    [self sendSuccess];
                    
                    [[LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"发送成功"] show];
                    if (_delegate && [_delegate respondsToSelector:@selector(sendSuccessByGetAuthCodeButton:time:trueAuth:)]) {
                        [_delegate sendSuccessByGetAuthCodeButton:self time:_time trueAuth:_trueAuthCode];
                    }

                    break;
                }
                default: {
                    [self handleHttpFailed];
                    break;
                }
            }
            break;
        }
        default: {
            [self handleHttpFailed];
            break;
        }
    }
}


#pragma mark -LyHttpRequestDelegate
- (void)onLyHttpRequestAsynchronousFailed:(LyHttpRequest *)ahttpRequest {
    if (bHttpFlag) {
        bHttpFlag = NO;
        [self handleHttpFailed];
    }
    
    curHttMethod = 0;
}

- (void)onLyHttpRequestAsynchronousSuccessed:(LyHttpRequest *)ahttpRequest andResult:(NSString *)result {
    if (bHttpFlag) {
        bHttpFlag = NO;
        curHttMethod = ahttpRequest.mode;
        [self analysisHttpResult:result];
    }
    
    curHttMethod = 0;
}



@end
