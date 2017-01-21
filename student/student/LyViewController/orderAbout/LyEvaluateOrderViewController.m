//
//  LyEvaluateOrderViewController.m
//  student
//
//  Created by Junes on 2016/11/28.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyEvaluateOrderViewController.h"
#import "TQStarRatingView.h"

#import "LyToolBar.h"
#import "LyIndicator.h"
#import "LyRemindView.h"

#import "LyCurrentUser.h"
#import "LyOrder.h"
#import "LyEvaluationForTeacher.h"

#import "NSString+Validate.h"
#import "UITextView+textCount.h"
#import "UITextView+placeholder.h"
#import "LyUtil.h"


#define eoItemFont                  LyFont(14)


float const scoreMax = 5.0f;


CGFloat const eoTvContentHeight = 150.0f;


CGFloat const eoViewScoreHeight = 50.0f;
CGFloat const eoSrScoreHeight = 25.0f;
CGFloat const eoSrScoreWidth =  eoSrScoreHeight * 5.0f;
CGFloat const eoTfScoreWidth = 30.0f;
CGFloat const eoTfScoreHeight = 40.0f;



CGFloat const eoCollectionCellCount = 3.0f;
//#define eoCollectionViewCellSize    ((SCREEN_WIDTH - horizontalSpace * 4) / eoCollectionCellCount)
CGFloat const eoCollectionViewCellSize = 100.0f;



typedef NS_ENUM(NSInteger, LyEvaluateOrderBarButtonItemTag)
{
    evaluateOrderBarButtonItemTag_evaluate = 0,
};


typedef NS_ENUM(NSInteger, LyEvaluateOrderTextViewTag)
{
    evaluateOrderTextViewTag_content = 10,
};


typedef NS_ENUM(NSInteger, LyEvaluateOrderTextFieldTag)
{
    evaluateOrderTextFieldTag_score = 10,
};






@interface LyEvaluateOrderViewController () <UITextViewDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, StarRatingViewDelegate, LyRemindViewDelegate>
{
    UIBarButtonItem     *bbiEvaluate;
    UITextView          *tvContent;
    
    UIView              *viewScore;
    TQStarRatingView    *srScore;
    UITextField         *tfScore;
    
    LyIndicator         *indicator;
}

@property (strong, nonatomic)       UICollectionView        *collectionView;



@property (assign, nonatomic)       float       score;
@property (assign, nonatomic)       LyEvaluationLevel       level;

@end

@implementation LyEvaluateOrderViewController

static NSString *const lyEvaluateOrderCollectionViewCellReuseIdenfier = @"lyEvaluateOrderCollectionViewCellReuseIdenfier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self addObserverForNotification];
    
    _order = [_delegate obtainOrderByEvaluateOrderViewController:self];

    if (!_order)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self removeObserverForNotificaton];
}


- (void)initSubviews
{
    self.title = @"评价订单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = LyWhiteLightgrayColor;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    bbiEvaluate = [[UIBarButtonItem alloc] initWithTitle:@"发表"
                                                   style:UIBarButtonItemStyleDone
                                                  target:self
                                                  action:@selector(targetForBarButtonItem:)];
    [self.navigationItem setRightBarButtonItem:bbiEvaluate];
    
    
    tvContent = [[UITextView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + NAVIGATIONBAR_HEIGHT + horizontalSpace, SCREEN_WIDTH, eoTvContentHeight)];
    [tvContent setTag:evaluateOrderTextViewTag_content];
    [tvContent setDelegate:self];
    [tvContent setFont:eoItemFont];
    [tvContent setTextColor:[UIColor blackColor]];
    [tvContent setTextContainerInset:UIEdgeInsetsMake(verticalSpace, horizontalSpace, verticalSpace, horizontalSpace)];
    [tvContent setPlaceholder:@"快来说点什么吧"];
    [tvContent setTextCount:LyEvaluationLengthMax];
    [tvContent setReturnKeyType:UIReturnKeyDone];
    
    [self.view addSubview:tvContent];
    
    
    if (LyEvaluateOrderViewControllerMode_evaluate == _mode)
    {
        viewScore = [[UIView alloc] initWithFrame:CGRectMake(0, tvContent.frame.origin.y + eoTvContentHeight + horizontalSpace, SCREEN_WIDTH, eoViewScoreHeight)];
        [viewScore setBackgroundColor:[UIColor whiteColor]];
        
        
        tfScore = [UITextField new];
        [tfScore setTag:evaluateOrderTextFieldTag_score];
        [tfScore setDelegate:self];
        [tfScore setFont:eoItemFont];
        [tfScore setTextColor:Ly517ThemeColor];
        [tfScore setTextAlignment:NSTextAlignmentRight];
        [tfScore setKeyboardType:UIKeyboardTypeDecimalPad];
        [tfScore setInputAccessoryView:[LyToolBar toolBarWithInputControl:tfScore]];
        
        NSString *strLeft = @"我要评分", *strRigth = @"分";
        CGFloat fWidthLeftView = [strLeft sizeWithAttributes:@{NSFontAttributeName: tfScore.font}].width;
        CGFloat fWidthRightView = [strRigth sizeWithAttributes:@{NSFontAttributeName: tfScore.font}].width;
        [tfScore setFrame:CGRectMake(horizontalSpace, eoTfScoreHeight/2.0f - eoSrScoreHeight/2.0f, fWidthLeftView + eoTfScoreWidth + fWidthRightView, eoTfScoreHeight)];
        
        [tfScore setLeftView:({
            UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, fWidthLeftView, eoTfScoreHeight)];
            [lb setFont:tfScore.font];
            [lb setTextColor:[UIColor blackColor]];
            [lb setText:strLeft];
            lb;
        })];
        [tfScore setRightView:({
            UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, fWidthRightView, eoTfScoreHeight)];
            [lb setFont:tfScore.font];
            [lb setTextColor:tfScore.textColor];
            [lb setText:strRigth];
            lb;
        })];
        
        [tfScore setLeftViewMode:UITextFieldViewModeAlways];
        [tfScore setRightViewMode:UITextFieldViewModeAlways];
        
        srScore = [[TQStarRatingView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - horizontalSpace - eoSrScoreWidth, eoViewScoreHeight/2.0f - eoSrScoreHeight/2.0f, eoSrScoreWidth, eoSrScoreHeight) numberOfStar:5];
        [srScore setDelegate:self];
        
        
        
        [viewScore addSubview:tfScore];
        [viewScore addSubview:srScore];
        
        
        [self.view addSubview:viewScore];
        [self.view addSubview:self.collectionView];
        
        
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    
    
    [bbiEvaluate setEnabled:NO];
    
    [self setScore:scoreMax];
    [self updateStarRatingView];
    [self setLevel:LyEvaluationLevel_good];
}




- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setMinimumLineSpacing:0.0f];
        [flowLayout setMinimumInteritemSpacing:0.0f];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, viewScore.frame.origin.y + eoViewScoreHeight + horizontalSpace, SCREEN_WIDTH, eoCollectionViewCellSize + horizontalSpace * 2)
                                             collectionViewLayout:flowLayout];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        
        [_collectionView setScrollsToTop:NO];
        [_collectionView setScrollEnabled:NO];
        [_collectionView setShowsVerticalScrollIndicator:NO];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:lyEvaluateOrderCollectionViewCellReuseIdenfier];
    }
    
    return _collectionView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setScore:(float)score
{
    _score = score;
    [tfScore setText:[[NSString alloc] initWithFormat:@"%.1f", _score]];
}

- (void)setLevel:(LyEvaluationLevel)level
{
    _level = level;
}

- (void)updateStarRatingView
{
    [srScore setScore:_score / scoreMax withAnimation:YES];
}


- (void)allControlResignFirstResponder
{
    [tvContent resignFirstResponder];
    [tfScore resignFirstResponder];
}

- (void)targetForBarButtonItem:(UIBarButtonItem *)bbi
{
    [self allControlResignFirstResponder];
    LyEvaluateOrderBarButtonItemTag bbiTag = bbi.tag;
    switch (bbiTag) {
        case evaluateOrderBarButtonItemTag_evaluate: {
            [self evaluate];
            break;
        }
    }
    
}


- (void)addObserverForNotification
{
    if ([self respondsToSelector:@selector(targetForNotification_UITextFieldTextDidChangeNotification:)])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(targetForNotification_UITextFieldTextDidChangeNotification:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:nil];
    }
}

- (void)removeObserverForNotificaton
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (BOOL)validate:(BOOL)flag
{
    [bbiEvaluate setEnabled:NO];
    
    if (tvContent.text.length < 1 || tvContent.text.length > tvContent.textCount)
    {
        if (flag)
        {
            [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:@"评价内容格式错误"] show];
        }
        return NO;
    }
    
    [bbiEvaluate setEnabled:YES];
    
    return YES;
}


- (void)handleHttpFailed:(BOOL)needRemind
{
    if (indicator.isAnimating)
    {
        [indicator stopAnimation];
        NSString *title = nil;
        
        if ([indicator.title isEqualToString:LyIndicatorTitle_evaluate])
        {
            title = @"评价失败";
        }
        
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:title] show];
    }
}

- (NSDictionary *)analysisHttpResult:(NSString *)reuslt
{
    NSDictionary *dic = [LyUtil getObjFromJson:reuslt];
    if (![LyUtil validateDictionary:dic])
    {
        return nil;
    }
    
    NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
    if (![LyUtil validateString:strCode])
    {
        return nil;
    }
    
    if (codeTimeOut == strCode.intValue)
    {
        [self handleHttpFailed:NO];
        
        [LyUtil sessionTimeOut:self];
        return nil;
    }
    
    if (codeMaintaining == strCode.intValue)
    {
        [self handleHttpFailed:NO];
        
        [LyUtil serverMaintaining];
        return nil;
    }
    
    return dic;
}

- (void)evaluate
{
    if (![LyCurrentUser curUser].isLogined) {
//        [LyUtil showLoginVc:self];
        [LyUtil showLoginVc:self action:@selector(evaluate) object:nil];
        return;
    }
    
    if (![self validate:YES])
    {
        return;
    }
    
    if ( !indicator)
    {
        indicator = [[LyIndicator alloc] initWithTitle:LyIndicatorTitle_evaluate];
    }
    else
    {
        [indicator setTitle:LyIndicatorTitle_evaluate];
    }
    [indicator startAnimation];
    
    [self performSelector:@selector(evaluate_real) withObject:nil afterDelay:validateSensitiveWordDelayTime];
}


- (void)evaluate_real
{
    if (![tvContent.text validateSensitiveWord])
    {
        [indicator stopAnimation];
        [[LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"含用非法词"] show];
        return;
    }
    
    
    NSString *userType;
    switch (_order.orderMode) {
        case LyOrderMode_driveSchool:
            userType = @"jx";
            break;
        case LyOrderMode_coach: {
            userType = @"jl";
            break;
        }
        case LyOrderMode_guider: {
            userType = @"zdy";
            break;
        }
        case LyOrderMode_reservation: {
            if ([_order.orderName rangeOfString:@"指导员"].length > 0)
            {
                userType = @"zdy";
            }
            else
            {
                userType = @"jl";
            }
            break;
        }
        case LyOrderMode_mall: {
            
            break;
        }
        case LyOrderMode_game: {
            
            break;
        }
    }
    
    LyHttpRequest *hr = [[LyHttpRequest alloc] init];
    [hr startHttpRequest:evaluateOrder_url
                    body:@{
                           contentKey:tvContent.text,
                           evaluationLevelKey:@(_level),
                           scoreKey:@(_score),
                           objectIdKey:_order.orderId,
                           objectMasterIdKey:_order.orderObjectId,
                           masterIdKey:[LyCurrentUser curUser].userId,
                           userTypeKey:userType,
                           sessionIdKey:[LyUtil httpSessionId]
                           }
                    type:LyHttpType_asynPost
                 timeOut:0
       completionHandler:^(NSString *resStr, NSData *resData, NSError *error) {
           if (error)
           {
               [self handleHttpFailed:YES];
           }
           else
           {
               NSDictionary *dic = [self analysisHttpResult:resStr];
               if (!dic)
               {
                   [self handleHttpFailed:YES];
                   return ;
               }
               
               NSString *strCode = [[NSString alloc] initWithFormat:@"%@", [dic objectForKey:codeKey]];
               switch (strCode.integerValue) {
                   case 0: {
                       [_order setOrderState:LyOrderState_completed];
                       
                       [indicator stopAnimation];
                       
                       LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_success withTitle:@"评价成功"];
                       [remind setDelegate:self];
                       [remind show];
                       break;
                   }
                   case 3: {
                       [indicator stopAnimation];
                       
                       LyRemindView *remind = [LyRemindView remindWithMode:LyRemindViewMode_fail withTitle:@"只能追评一次"];
                       remind.delegate = self;
                       [remind show];
                       break;
                   }
                   default: {
                       [self handleHttpFailed:YES];
                       break;
                   }
               }
           }
       }];
}



#pragma mark -LyRemindViewDelegate
- (void)remindViewDidHide:(LyRemindView *)aRemind
{
    if (_delegate && [_delegate respondsToSelector:@selector(onDoneByEvaluateOrderViewController:)])
    {
        [_delegate onDoneByEvaluateOrderViewController:self];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark -StarRatingViewDelegate
- (void)starRatingView:(TQStarRatingView *)view score:(float)score
{
    if (tfScore.isFirstResponder) {
        return;
    }
    
    [self setScore:score * scoreMax];
}



#pragma mark -UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [tvContent resignFirstResponder];
        return NO;
    }
    
    BOOL result = YES;
    LyEvaluateOrderTextViewTag tvTag = textView.tag;
    switch (tvTag) {
        case evaluateOrderTextViewTag_content: {
            if (textView.text.length + text.length > textView.textCount)
            {
                result = NO;
            }
            break;
        }
    }
    
    return result;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self validate:NO];
}


#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL result = YES;
    LyEvaluateOrderTextFieldTag tfTag = textField.tag;
    switch (tfTag) {
        case evaluateOrderTextFieldTag_score: {
            NSString *strNew = [[NSString alloc] initWithFormat:@"%@%@", textField.text, string];
            if (![strNew validateFloat])
            {
                result = NO;
            }
            break;
        }
    }
    
    return result;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    LyEvaluateOrderTextFieldTag tfTag = textField.tag;
    switch (tfTag) {
        case evaluateOrderTextFieldTag_score: {
            if (textField.text.length < 1) {
                [self setScore:0];
            }
            break;
        }
    }
}


#pragma mark -UITextFieldTextDidChangeNotification
- (void)targetForNotification_UITextFieldTextDidChangeNotification:(NSNotification *)notifi
{
    float newScore = tfScore.text.floatValue;
    if (newScore > scoreMax)
    {
        [self setScore:scoreMax];
    }
    else
    {
        _score = newScore;
    }
    [self updateStarRatingView];
}


#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self setLevel:LyEvaluationLevel_good + indexPath.row];
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return eoCollectionCellCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lyEvaluateOrderCollectionViewCellReuseIdenfier forIndexPath:indexPath];
    if (cell)
    {
        NSString *imageName = [[NSString alloc] initWithFormat:@"reputionMode_%ld_n", indexPath.row];
        NSString *imageName_h = [[NSString alloc] initWithFormat:@"reputionMode_%ld_h", indexPath.row];
        
        
        [cell setBackgroundView:({
            UIImageView *iv = [[UIImageView alloc] initWithFrame:cell.bounds];
            [iv setImage:[LyUtil imageForImageName:imageName needCache:NO]];
            iv;
        })];
        
        [cell setSelectedBackgroundView:({
            UIImageView *iv = [[UIImageView alloc] initWithFrame:cell.bounds];
            [iv setImage:[LyUtil imageForImageName:imageName_h needCache:NO]];
            iv;
        })];
    }
    
    return cell;
}

#pragma mark -UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(eoCollectionViewCellSize, eoCollectionViewCellSize);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(horizontalSpace, (SCREEN_WIDTH - eoCollectionViewCellSize * eoCollectionCellCount) / 2.0f, horizontalSpace, (SCREEN_WIDTH - eoCollectionViewCellSize * eoCollectionCellCount) / 2.0f);
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
