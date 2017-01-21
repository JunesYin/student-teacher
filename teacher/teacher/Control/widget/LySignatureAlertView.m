//
//  LySignatureAlertView.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/26.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LySignatureAlertView.h"
#import "UITextView+placeholder.h"
#import "UITextView+textCount.h"
#import "LyUtil.h"





@interface LySignatureAlertView () <UITextViewDelegate>
{
    UIButton                        *btnMask;
    
    UIView                          *viewUseful;
    
    
    UIToolbar                       *toolBar;
    
    UITextView                      *tvContent;

    
    CGPoint                         centerViewUseful;
    
    
}
@end



@implementation LySignatureAlertView



- (instancetype)init
{
    if ( self = [super initWithFrame:[UIScreen mainScreen].bounds])
    {
        [self initAndLayoutSubview];
        [self seAddKeyboardEventNotification];
    }
    
    
    return self;
}


+ (instancetype)signatureAlertViewWithSignature:(NSString *)signature
{
    LySignatureAlertView *sa = [[LySignatureAlertView alloc] initWithSignature:signature];
    
    return sa;
}


- (instancetype)initWithSignature:(NSString *)signature
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds])
    {
        _signature = signature;
        [self initAndLayoutSubview];
    }
    
    return self;
}


- (void)initAndLayoutSubview
{
    btnMask = [[UIButton alloc] initWithFrame:self.bounds];
    [btnMask setBackgroundColor:LyMaskColor];
    [btnMask addTarget:self action:@selector(targetForButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnMask];
    
    
    viewUseful = [[UIView alloc] initWithFrame:CGRectMake(horizontalSpace, SCREEN_HEIGHT/2.0f-controlViewUsefulHeight/2.0f, SCREEN_WIDTH-horizontalSpace*2, controlViewUsefulHeight)];
    [viewUseful setBackgroundColor:LyWhiteLightgrayColor];
    [[viewUseful layer] setCornerRadius:5.0f];
    centerViewUseful = [viewUseful center];

    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(horizontalSpace, 0, CGRectGetWidth(viewUseful.frame)-horizontalSpace*2, controlToolBarHeight)];
    [toolBar setTintColor:Ly517ThemeColor];
    
    UIBarButtonItem *bbiCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(targetForBarButtonItem:)];
    [bbiCancel setTag:LyControlBarButtonItemMode_cancel];
    UIBarButtonItem *bbiSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
    UIBarButtonItem *bbiDone = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                style:UIBarButtonItemStyleDone
                                                               target:self action:@selector(targetForBarButtonItem:)];
    
    [bbiDone setTag:LyControlBarButtonItemMode_done];
    
    [toolBar setItems:@[bbiCancel, bbiSpace, bbiDone]];
    
    
    tvContent = [[UITextView alloc] initWithFrame:CGRectMake(verticalSpace, toolBar.ly_y+CGRectGetHeight(toolBar.frame)+verticalSpace, CGRectGetWidth(viewUseful.frame)-verticalSpace*2, CGRectGetHeight(viewUseful.frame)-CGRectGetHeight(toolBar.frame)-verticalSpace*2)];
    [tvContent setTextContainerInset:UIEdgeInsetsMake(verticalSpace, verticalSpace, verticalSpace, verticalSpace)];
    [tvContent.layer setCornerRadius:btnCornerRadius];
    [tvContent.layer setBorderWidth:1.0f];
    [tvContent.layer setBorderColor:[LyWhiteLightgrayColor CGColor]];
    [tvContent setFont:LyFont(14)];
    [tvContent setTextColor:LyBlackColor];
    [tvContent setTextAlignment:NSTextAlignmentLeft];
    [tvContent setTextCount:LySignatureLengthMax];
    [tvContent setDelegate:self];
    [tvContent setReturnKeyType:UIReturnKeyDone];
    
    
    [viewUseful addSubview:toolBar];
    [viewUseful addSubview:tvContent];

    [self addSubview:viewUseful];
    
    
    if (![LyUtil validateString:_signature]){
        [tvContent setPlaceholder:@"这个家伙很懒，什么都没留下"];
    }
    else {
        [tvContent setText:_signature];
        [tvContent update];
    }
    
}



- (void)setPlaceholder:(NSString *)placeholder
{
    [tvContent setPlaceholder:placeholder];
    [tvContent updatePlaceholder];
}




- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [self seAddKeyboardEventNotification];
    
    [LyUtil startAnimationWithView:viewUseful
                                  animationDuration:0.3f
                                       initialPoint:CGPointMake( centerViewUseful.x, centerViewUseful.y+SCREEN_HEIGHT-CGRectGetHeight(viewUseful.frame))
                                   destinationPoint:centerViewUseful
                                         completion:^(BOOL finished) {
                                         }];
    
    [LyUtil startAnimationWithView:btnMask
                                  animationDuration:0.3f
                                          initAlpha:0.0f
                                  destinationAplhas:1.0f
                                          comletion:^(BOOL finished) {
                                          }];
}




- (void)hide
{
    [tvContent resignFirstResponder];
    [self seRemoveKeyboardEventNotification];
    
    [LyUtil startAnimationWithView:viewUseful
                                  animationDuration:0.3f
                                       initialPoint:centerViewUseful
                                   destinationPoint:CGPointMake( centerViewUseful.x, centerViewUseful.y+SCREEN_HEIGHT-CGRectGetHeight(viewUseful.frame))
                                         completion:^(BOOL finished) {
                                             [viewUseful setHidden:YES];
                                             [viewUseful setCenter:centerViewUseful];
                                         }];
    [LyUtil startAnimationWithView:btnMask
                                  animationDuration:0.3f
                                          initAlpha:1.0f
                                  destinationAplhas:0.0f
                                          comletion:^(BOOL finished) {
                                              [btnMask setHidden:NO];
                                              [self removeFromSuperview];
                                          }];
    
}




- (void)targetForButton:(UIButton *)button
{
    [tvContent resignFirstResponder];
    
    if (_delegate && [_delegate respondsToSelector:@selector(signatureAlertView:isClickButtonDone:)])
    {
        [_delegate signatureAlertView:self isClickButtonDone:NO];
    }
    else
    {
        [self hide];
    }
}



- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi
{
    [tvContent resignFirstResponder];
    
    if (LyControlBarButtonItemMode_cancel == bbi.tag)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(signatureAlertView:isClickButtonDone:)])
        {
            [_delegate signatureAlertView:self isClickButtonDone:NO];
        }
        else
        {
            [self hide];
        }
    }
    else if (LyControlBarButtonItemMode_done == bbi.tag)
    {
        _signature = tvContent.text;
        [_delegate signatureAlertView:self isClickButtonDone:YES];
    }
}





- (void)seAddKeyboardEventNotification
{
    //增加监听，当键盘出现或改变时收出消息
    if ( [self respondsToSelector:@selector(seTargetForNotificationToKeyboardWillShow:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(seTargetForNotificationToKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    
    //增加监听，当键退出时收出消息
    if ( [self respondsToSelector:@selector(seTargetForNotificationToKeyboardWillShow:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bcTargetForNotificationToKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}


- (void)seRemoveKeyboardEventNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)seTargetForNotificationToKeyboardWillShow:(NSNotification *)notification
{
    CGFloat keyboardHight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [viewUseful setFrame:CGRectMake( horizontalSpace, SCREEN_HEIGHT-keyboardHight-controlViewUsefulHeight, SCREEN_WIDTH-horizontalSpace*2, controlViewUsefulHeight)];
    
}


- (void)bcTargetForNotificationToKeyboardWillHide:(NSNotification *)notification
{
    [viewUseful setFrame:CGRectMake( horizontalSpace, SCREEN_HEIGHT/2.0f-controlViewUsefulHeight/2.0f, SCREEN_WIDTH-horizontalSpace*2, controlViewUsefulHeight)];
}




#pragma mark -UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length > textView.textCount)
    {
        textView.text = [textView.text substringToIndex:textView.textCount];
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [tvContent resignFirstResponder];
}




@end



