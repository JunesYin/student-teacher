//
//  LySignatureView.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/26.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LySignatureView.h"
#import "UITextView+placeholder.h"
#import "UITextView+textCount.h"
#import "LyUtil.h"



#define seWidth                                 SCREEN_WIDTH
#define seHeight                                SCREEN_HEIGHT


#define viewUsefulWidth                         seWidth
CGFloat const  signViewUsefulHeight = 200.0f;

#define viewUsefulFrame                         CGRectMake( 0, seHeight/2.0f-signViewUsefulHeight/2.0f, viewUsefulWidth, signViewUsefulHeight)


CGFloat const signBtnItemWidth = 50.0f;
CGFloat const signBtnItemHeight = 40.0f;
#define btnItemTitleFont                        LyFont(16)


#define signTvContentWidth                          (viewUsefulWidth-horizontalSpace*2.0f)
CGFloat const signTvContentHeight = 150.0f;
#define tvContentFont                           LyFont(14)





@interface LySignatureView () <UITextViewDelegate>
{
    UIView                          *viewUseful;
    
    
    UIButton                        *btnCancel;
    UIButton                        *btnDone;
    
    UITextView                      *tvContent;
    
    
    
    UIView                          *viewMask;
    UIButton                        *btnBig;
    
    CGPoint                         centerViewUseful;
    
    
}
@end



@implementation LySignatureView


lySingle_implementation(LySignatureView)

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:CGRectMake( 0, 0, seWidth, seHeight)])
    {
        [self initAndLayoutSubview];
        [self seAddKeyboardEventNotification];
    }
    
    
    return self;
}



- (instancetype)init
{
    if ( self = [super initWithFrame:CGRectMake( 0, 0, seWidth, seHeight)])
    {
        [self initAndLayoutSubview];
        [self seAddKeyboardEventNotification];
    }
    
    
    return self;
}




- (void)initAndLayoutSubview
{
    viewUseful = [[UIView alloc] initWithFrame:viewUsefulFrame];
    [viewUseful setBackgroundColor:LyWhiteLightgrayColor];
    [[viewUseful layer] setCornerRadius:5.0f];
    [viewUseful setClipsToBounds:YES];
    
    centerViewUseful = [viewUseful center];
    
    
    btnCancel = [[UIButton alloc] initWithFrame:CGRectMake( horizontalSpace, verticalSpace, signBtnItemWidth, signBtnItemHeight)];
    [btnCancel setTag:signatureButtonItemMode_cancel];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [[btnCancel titleLabel] setFont:btnItemTitleFont];
    [btnCancel addTarget:self action:@selector(targetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    btnDone = [[UIButton alloc] initWithFrame:CGRectMake( viewUsefulWidth-horizontalSpace-signBtnItemWidth, verticalSpace, signBtnItemWidth, signBtnItemHeight)];
    [btnDone setTag:signatureButtonItemMode_done];
    [btnDone setTitle:@"完成" forState:UIControlStateNormal];
    [btnDone setTitleColor:Ly517ThemeColor forState:UIControlStateNormal];
    [[btnDone titleLabel] setFont:btnItemTitleFont];
    [btnDone addTarget:self action:@selector(targetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    tvContent = [[UITextView alloc] initWithFrame:CGRectMake( horizontalSpace, btnCancel.frame.origin.y+CGRectGetHeight(btnCancel.frame), signTvContentWidth, signTvContentHeight)];
    [tvContent setDelegate:self];
    [tvContent setTextColor:LyBlackColor];
    [tvContent setFont:tvContentFont];
    [tvContent setTextAlignment:NSTextAlignmentLeft];
    [tvContent setTextCount:LySignatureLengthMax];
    [tvContent setPlaceholder:@"这个家伙很懒，什么都没留下"];
    [[tvContent layer] setCornerRadius:5.0f];
    [tvContent setReturnKeyType:UIReturnKeyDone];
    
    [viewUseful addSubview:btnCancel];
    [viewUseful addSubview:btnDone];
    [viewUseful addSubview:tvContent];
    
    
    viewMask = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [viewMask setBackgroundColor:LyMaskColor];
    
    btnBig = [[UIButton alloc] initWithFrame:viewMask.frame];
    [btnBig setBackgroundColor:[UIColor clearColor]];
    [btnBig setTag:signatureButtonItemMode_done+1];
    [btnBig addTarget:self action:@selector(targetForButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [viewMask addSubview:btnBig];
    
    [self addSubview:viewMask];
    [self addSubview:viewUseful];
    
    
    [viewUseful setHidden:YES];
    [viewMask setHidden:YES];
}



- (void)setText:(NSString *)text
{
    if ( !text || [NSNull null] == (NSNull *)text || [text isEqualToString:@""])
    {
        return;
    }
    
    [tvContent setPlaceholder:nil];
    
    _text = text;
    [tvContent setText:_text];
    [tvContent update];
}


- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [LyUtil startAnimationWithView:viewUseful
                 animationDuration:0.3f
                      initialPoint:CGPointMake( centerViewUseful.x, centerViewUseful.y+seHeight-CGRectGetHeight(viewUseful.frame))
                  destinationPoint:centerViewUseful
                        completion:^(BOOL finished) {
                        }];
    
    [LyUtil startAnimationWithView:viewMask
                 animationDuration:0.3f
                         initAlpha:0.0f
                 destinationAplhas:1.0f
                         completion:^(BOOL finished) {
                         }];
}




- (void)hide
{
    
    [LyUtil startAnimationWithView:viewUseful
                 animationDuration:0.3f
                      initialPoint:centerViewUseful
                  destinationPoint:CGPointMake( centerViewUseful.x, centerViewUseful.y+seHeight-CGRectGetHeight(viewUseful.frame))
                        completion:^(BOOL finished) {
                            [viewUseful setHidden:YES];
                            [viewUseful setCenter:centerViewUseful];
                        }];
    [LyUtil startAnimationWithView:viewMask
                 animationDuration:0.3f
                         initAlpha:1.0f
                 destinationAplhas:0.0f
                         completion:^(BOOL finished) {
                             [viewMask setHidden:NO];
                             [self removeFromSuperview];
                         }];
    
}




- (void)targetForButtonItem:(UIButton *)button
{
    [tvContent resignFirstResponder];
    
    if ( signatureButtonItemMode_done+1 == [button tag])
    {
        return;
    }
    else if (signatureButtonItemMode_cancel == button.tag)
    {
        if ([_delegate respondsToSelector:@selector(onCancelBySignature:)])
        {
            [_delegate onCancelBySignature:self];
        }
        else
        {
            [self hide];
        }
    }
    else if (signatureButtonItemMode_done == button.tag)
    {
        _text = [tvContent text];
        [_delegate onDoneBySignature:self content:_text];
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



- (void)seTargetForNotificationToKeyboardWillShow:(NSNotification *)notification
{
    int keyboardHight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [viewUseful setFrame:CGRectMake( viewUsefulFrame.origin.x, SCREEN_HEIGHT-keyboardHight-signViewUsefulHeight, viewUsefulWidth, signViewUsefulHeight)];
    
}


- (void)bcTargetForNotificationToKeyboardWillHide:(NSNotification *)notification
{
    [viewUseful setFrame:CGRectMake( viewUsefulFrame.origin.x, viewUsefulFrame.origin.y, viewUsefulWidth, signViewUsefulHeight)];
}




#pragma mark -UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length > textView.textCount) {
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



