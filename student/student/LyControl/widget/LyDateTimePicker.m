//
//  LyDateTimePicker.m
//  LyStudyDrive
//
//  Created by Junes on 16/5/19.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyDateTimePicker.h"
#import "LyRemindView.h"
#import "LyUtil.h"





#pragma mark -LyDateCollectionViewCell

@interface LyDateCollectionViewCell : UICollectionViewCell
{
    UILabel             *lbMonthAndDay;
    UILabel             *lbWeekDay;
}

@property ( strong, nonatomic)      NSDate              *date;
//@property ( strong, nonatomic)      NSString            *weekday;
@property ( assign, nonatomic)      LyWeekday           weekday;
@property ( assign, nonatomic)      NSInteger           index;
@property ( strong, nonatomic)      UIColor             *tintColor;

@end


@implementation LyDateCollectionViewCell


#define dateCellWidth                           CGRectGetWidth(self.frame)
#define dateCellHeight                          CGRectGetHeight(self.frame)

#define dateLbMonthAndDayWidth                  (dateCellWidth*9.0/10.0f)
#define dateLbMonthAndDayHeight                 (dateCellHeight*2.0/5.0f)

#define dateLbWeekdayWidth                      dateLbMonthAndDayWidth
#define dateLbWeekdayHeight                     dateLbMonthAndDayHeight



static NSDate *tomorrow;


static NSString *yearKey = @"year";
static NSString *monthKey = @"month";
static NSString *dayKey = @"day";
static NSString *hourKey = @"hour";
static NSString *minuteKey = @"minute";
static NSString *secondKey = @"second";
static NSString *weekdayKey = @"weekday";

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame])
    {
        [self setTintColor:LyBlackColor];
        
        lbMonthAndDay = [[UILabel alloc] initWithFrame:CGRectMake( dateCellWidth/2.0f-dateLbMonthAndDayWidth/2.0f, dateCellHeight/5.0f/2.0f, dateLbMonthAndDayWidth, dateLbMonthAndDayHeight)];
        [lbMonthAndDay setFont:[UIFont systemFontOfSize:12]];
        [lbMonthAndDay setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:lbMonthAndDay];
        
        lbWeekDay = [[UILabel alloc] initWithFrame:CGRectMake( lbMonthAndDay.frame.origin.x, lbMonthAndDay.frame.origin.y+CGRectGetHeight(lbMonthAndDay.frame), dateLbWeekdayWidth, dateLbWeekdayHeight)];
        [lbWeekDay setFont:[UIFont systemFontOfSize:12]];
        [lbWeekDay setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:lbWeekDay];
    }
    
    return self;
}



- (void)setSelected:(BOOL)selected
{
    if ( selected) {
        [self setTintColor:Ly517ThemeColor];
    }
    else
    {
        [self setTintColor:LyBlackColor];
    }
}


- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    
    [lbMonthAndDay setTextColor:_tintColor];
    [lbWeekDay setTextColor:_tintColor];
}


- (void)setIndex:(NSInteger)index
{
    _index = index;
    
    if ( !tomorrow) {
        tomorrow = [NSDate dateWithTimeIntervalSinceNow:24*3600];
    }

    NSDictionary *dicDateInfo = [self getDateInfo:tomorrow andForeCount:index];
    _date = [dicDateInfo objectForKey:dateKey];
    
    
//    _weekday = [dicDateInfo objectForKey:weekdayKey];
//    [lbWeekDay setText:_weekday];
    
    NSString *strWeekday = [dicDateInfo objectForKey:weekdayKey];
    _weekday = [LyUtil weekdayFromString:strWeekday];
    [lbWeekDay setText:strWeekday];
    
    if ( index < 2) {
        if ( 0 == index) {
            [lbMonthAndDay setText:@"明天"];
        } else {
            [lbMonthAndDay setText:@"后天"];
        }
    }
    else
    {
        [lbMonthAndDay setText:[[NSString alloc] initWithFormat:@"%@/%@", [dicDateInfo objectForKey:monthKey], [dicDateInfo objectForKey:dayKey]]];
    }
    
}




- (NSDictionary *)getDateInfo:(NSDate *)date andForeCount:(NSInteger)count
{
    //NSCalendarIdentifierGregorian
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法 NSCalendarIdentifierGregorian,NSCalendarIdentifierGregorian
    [calendar setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    
    // NSDateComponent 可以获得日期的详细信息，即日期的组成
    
    NSDate *newDate = [date dateByAddingTimeInterval:60*60*24*count];
    
    NSDateComponents *comps = [calendar components:
                               NSCalendarUnitYear |
                               NSCalendarUnitMonth |
                               NSCalendarUnitDay |
                               NSCalendarUnitHour |
                               NSCalendarUnitMinute |
                               NSCalendarUnitSecond |
                               NSCalendarUnitWeekOfYear |
                               NSCalendarUnitWeekday
                                          fromDate:newDate];

    NSString *strWeekDay;
    
    switch ( [comps weekday]) {
        case 1: {
            strWeekDay = @"周日";
            break;
        }
        case 2: {
            strWeekDay = @"周一";
            break;
        }
        case 3: {
            strWeekDay = @"周二";
            break;
        }
        case 4: {
            strWeekDay = @"周三";
            break;
        }
        case 5: {
            strWeekDay = @"周四";
            break;
        }
        case 6: {
            strWeekDay = @"周五";
            break;
        }
        case 7: {
            strWeekDay = @"周六";
            break;
        }
        default: {
            strWeekDay = @"";
            break;
        }
    }
    
    NSDictionary *dicDate = @{
                              dateKey:newDate,
                              yearKey:[[NSString alloc] initWithFormat:@"%02ld", comps.year],
                              monthKey:[[NSString alloc] initWithFormat:@"%02ld", comps.month],
                              dayKey:[[NSString alloc] initWithFormat:@"%02ld", comps.day],
                              hourKey:[[NSString alloc] initWithFormat:@"%02ld", comps.hour],
                              minuteKey:[[NSString alloc] initWithFormat:@"%02ld", comps.minute],
                              secondKey:[[NSString alloc] initWithFormat:@"%02ld", comps.second],
                              weekdayKey:strWeekDay
                              };
    
    
    return dicDate;
}



@end


#pragma mark -LyTimeCollectionViewCell

//typedef NS_ENUM( NSInteger, LyReservateCoachCollectionViewCellState)
//{
//    reservateCoachCollectionViewCellMode_useable,
//    reservateCoachCollectionViewCellMode_used,
//    reservateCoachCollectionViewCellMode_disable
//};


@interface LyTimeCollectionViewCell : UICollectionViewCell
{
    UILabel                 *lbTime;
    UIImageView             *ivLine;
    UILabel                 *lbInfo;
}

@property ( retain, nonatomic)      LyDateTimeInfo      *dateTimeInfo;

- (void)setDateTimeInfo:(LyDateTimeInfo *)dateTimeInfo;

- (void)setCellInfo:(LyDateTimeInfoState)state mode:(int)mode masterId:(NSString *)masterId masterName:(NSString *)masterName;

@end


@implementation LyTimeCollectionViewCell


#define timeHorizontalMargin                3.0f

#define timeLbItemFont                      LyFont(10)

#define timeLbTimeWidth                     ((CGRectGetWidth(self.frame)-timeHorizontalMargin*3.0f)*2.0f/3.0f)
#define timeLbTimeHeight                    CGRectGetHeight(self.frame)


#define timeIvLineWidth                     1.0f
#define timeIvLineHeight                    (CGRectGetHeight(self.frame)*2.0f/3.0f)


#define timeLbInfoWidth                     ((CGRectGetWidth(self.frame)-timeHorizontalMargin*3.0f)/3.0f)
#define timeLbInfoHeight                    CGRectGetHeight(self.frame)


- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame])
    {
        [self initSubviews];
    }
    
    return self;
}



- (void)initSubviews
{
    [[self layer] setCornerRadius:3.0f];
    
    lbTime = [[UILabel alloc] initWithFrame:CGRectMake( timeHorizontalMargin, 0, timeLbTimeWidth, timeLbTimeHeight)];
    [lbTime setFont:timeLbItemFont];
    [lbTime setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lbTime];
    
    ivLine = [[UIImageView alloc] initWithFrame:CGRectMake( lbTime.frame.origin.x+CGRectGetWidth(lbTime.frame)+2, CGRectGetHeight(self.frame)/2.0f-timeIvLineHeight/2.0f, timeIvLineWidth, timeIvLineHeight)];
    [self addSubview:ivLine];
    
    
    lbInfo = [[UILabel alloc] initWithFrame:CGRectMake( lbTime.frame.origin.x+CGRectGetWidth(lbTime.frame)+timeHorizontalMargin, 0, timeLbInfoWidth, timeLbInfoHeight)];
    [lbInfo setFont:timeLbItemFont];
    [lbInfo setTextAlignment:NSTextAlignmentCenter];
    [lbInfo setNumberOfLines:0];
    [self addSubview:lbInfo];
    
}



- (void)setDateTimeInfo:(LyDateTimeInfo *)dateTimeInfo {
    _dateTimeInfo = dateTimeInfo;
    
    if ( !_dateTimeInfo) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [[self layer] setBorderWidth:1.0f];
        [[self layer] setBorderColor:[Ly517ThemeColor CGColor]];
        [lbTime setTextColor:Ly517ThemeColor];
        [lbInfo setTextColor:Ly517ThemeColor];
        [lbInfo setText:@"预约"];
        [ivLine setImage:[LyUtil imageForImageName:@"rc_ivLine_h" needCache:NO]];
    } else {
        
        switch ( [_dateTimeInfo state]) {
            case LyDateTimeInfoState_useable: {
                [self setBackgroundColor:[UIColor whiteColor]];
                [[self layer] setBorderWidth:1.0f];
                [[self layer] setBorderColor:[Ly517ThemeColor CGColor]];
                [lbTime setTextColor:Ly517ThemeColor];
                [lbInfo setTextColor:Ly517ThemeColor];
                [lbInfo setText:@"预约"];
                [ivLine setImage:[LyUtil imageForImageName:@"rc_ivLine_h" needCache:NO]];
                break;
            }
            case LyDateTimeInfoState_used: {
                [self setBackgroundColor:LyHighLightgrayColor];
                [[self layer] setBorderWidth:1.0f];
                [[self layer] setBorderColor:[LyHighLightgrayColor CGColor]];
                [lbTime setTextColor:LyBlackColor];
                [lbInfo setTextColor:LyBlackColor];
                [lbInfo setText:[_dateTimeInfo masterName]];
                [ivLine setImage:[LyUtil imageForImageName:@"rc_ivLine_n" needCache:NO]];
                break;
            }
            case LyDateTimeInfoState_disable: {
                [self setBackgroundColor:LyHighLightgrayColor];
                [[self layer] setBorderWidth:1.0f];
                [[self layer] setBorderColor:[LyHighLightgrayColor CGColor]];
                [lbTime setTextColor:LyBlackColor];
                [lbInfo setTextColor:LyBlackColor];
                [lbInfo setText:@"不可用"];
                [ivLine setImage:[LyUtil imageForImageName:@"rc_ivLine_n" needCache:NO]];
                
                break;
            }
        }
        
        NSString *strLbTime = [[NSString alloc] initWithFormat:@"%ld:00-%ld:00", [_dateTimeInfo mode], [_dateTimeInfo mode]+1];
        [lbTime setText:strLbTime];
    }
    
}




- (void)setCellInfo:(LyDateTimeInfoState)state mode:(int)mode masterId:(NSString *)masterId masterName:(NSString *)masterName
{
    [_dateTimeInfo setState:state];
    [_dateTimeInfo setMode:mode];
    [_dateTimeInfo setMasterId:masterId];
    [_dateTimeInfo setMasterName:masterName];
    
    
    switch ( [_dateTimeInfo state]) {
        case LyDateTimeInfoState_useable: {
            [self setBackgroundColor:[UIColor whiteColor]];
            [[self layer] setBorderWidth:1.0f];
            [[self layer] setBorderColor:[Ly517ThemeColor CGColor]];
            [lbTime setTextColor:Ly517ThemeColor];
            [lbInfo setTextColor:Ly517ThemeColor];
            [lbInfo setText:@"预约"];
            [ivLine setImage:[LyUtil imageForImageName:@"rc_ivLine_h" needCache:NO]];
            break;
        }
        case LyDateTimeInfoState_used: {
            [self setBackgroundColor:LyHighLightgrayColor];
            [lbTime setTextColor:LyBlackColor];
            [lbInfo setTextColor:LyBlackColor];
            [lbInfo setText:masterName];
            [ivLine setImage:[LyUtil imageForImageName:@"rc_ivLine_n" needCache:NO]];
            break;
        }
        case LyDateTimeInfoState_disable: {
            [self setBackgroundColor:LyHighLightgrayColor];
            [lbTime setTextColor:LyBlackColor];
            [lbInfo setTextColor:LyBlackColor];
            [lbInfo setText:@"不可用"];
            [ivLine setImage:[LyUtil imageForImageName:@"rc_ivLine_n" needCache:NO]];

            break;
        }
    }

    
    NSString *strLbTime = [[NSString alloc] initWithFormat:@"%ld:00-%ld:00", [_dateTimeInfo mode], [_dateTimeInfo mode]+1];
    [lbTime setText:strLbTime];
    
}


@end







typedef NS_ENUM( NSInteger, LyDateTimePickerCollectionViewMode)
{
    dateTimePickerCollectionViewMode_date,
    dateTimePickerCollectionViewMode_time
};


#pragma mark -LyDateTimePicker

@interface LyDateTimePicker () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    UICollectionView            *cvDate;
    UICollectionView            *cvTime;
}
@end


@implementation LyDateTimePicker


CGFloat const dtHorizontalMargin = 1.0f;
CGFloat const dtVerticalMargin = 7.0f;

CGFloat const dtpCvDateHeight = 50.0f;

CGFloat const dtpCvTimeItemHeight = 40.0f;


#define dateTimePickerDefaultWidth                  SCREEN_WIDTH
//#define dateTimePickerDefaultHeight                 (dtpCvDateHeight+dtpCvTimeItemHeight*8+dtVerticalMargin*10)


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
static NSString *lyDateCollectionViewCellReuseIdentifier = @"lyDateCollectionViewCellReuseIdentifier";
static NSString *lyTimeCollectionViewCellReuseIdentifier = @"lyTimeCollectionViewCellReuseIdentifier";

- (instancetype)init
{
    if ( self = [super initWithFrame:CGRectMake( 0, 0, [[UIScreen mainScreen] bounds].size.width, 50.0f)])
    {
        [self initSubviews];
    }
    
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame])
    {
        [self initSubviews];
    }
    
    return self;
}



- (void)initSubviews
{
    
    UICollectionViewFlowLayout *dateCollectionVIewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [dateCollectionVIewFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [dateCollectionVIewFlowLayout setMinimumLineSpacing:0.0f];
    [dateCollectionVIewFlowLayout setMinimumInteritemSpacing:0.0f];
    
    cvDate = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, dtpCvDateHeight)
                                collectionViewLayout:dateCollectionVIewFlowLayout];
    [cvDate setTag:dateTimePickerCollectionViewMode_date];
    [cvDate setDelegate:self];
    [cvDate setDataSource:self];
    [cvDate setBackgroundColor:LyHighLightgrayColor];
    [cvDate setScrollsToTop:NO];
    [cvDate setShowsVerticalScrollIndicator:NO];
    [cvDate setShowsHorizontalScrollIndicator:NO];
    [cvDate registerClass:[LyDateCollectionViewCell class] forCellWithReuseIdentifier:lyDateCollectionViewCellReuseIdentifier];
    
    
    
    UICollectionViewFlowLayout *timeCollectionVIewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [timeCollectionVIewFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [timeCollectionVIewFlowLayout setMinimumLineSpacing:dtVerticalMargin];
    [timeCollectionVIewFlowLayout setMinimumInteritemSpacing:dtHorizontalMargin];
    
    cvTime = [[UICollectionView alloc] initWithFrame:CGRectMake( 0, cvDate.frame.origin.y+CGRectGetHeight(cvDate.frame), SCREEN_WIDTH, dtpCvTimeHeight)
                                collectionViewLayout:timeCollectionVIewFlowLayout];
    [cvTime setTag:dateTimePickerCollectionViewMode_time];
    [cvTime setDelegate:self];
    [cvTime setDataSource:self];
    [cvTime setBackgroundColor:[UIColor clearColor]];
    [cvTime setScrollEnabled:NO];
    [cvTime setScrollsToTop:NO];
    [cvTime setShowsVerticalScrollIndicator:NO];
    [cvTime setShowsHorizontalScrollIndicator:NO];
    [cvTime registerClass:[LyTimeCollectionViewCell class] forCellWithReuseIdentifier:lyTimeCollectionViewCellReuseIdentifier];
    
    
    [self addSubview:cvDate];
    [self addSubview:cvTime];
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
    [cvDate selectItemAtIndexPath:ip
                         animated:NO
                   scrollPosition:UICollectionViewScrollPositionNone];

    
}


- (void)reloadData {
    [cvTime reloadData];
}


- (void)setSelectIndex:(NSInteger)index
{
    [cvDate selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    LyDateCollectionViewCell *tmpCell = (LyDateCollectionViewCell *)[cvDate cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    _date = [tmpCell date];
    [self collectionView:cvDate didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:index  inSection:0]];
}


#pragma mark --UICollectionViewDelegate
//UICollectionViewCell被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch ( [collectionView tag]) {
        case dateTimePickerCollectionViewMode_date:
        {
            LyDateCollectionViewCell *tmpCell = (LyDateCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            _date = [tmpCell date];
            _weekday = [tmpCell weekday];
            
            if ( [_delegate respondsToSelector:@selector(dateTimePicker:didSelectDateItemAtIndex:andDate:)])
            {
                [_delegate dateTimePicker:self didSelectDateItemAtIndex:[indexPath row] andDate:_date];
            }
            break;
        }
            
        case dateTimePickerCollectionViewMode_time: {
            
            if (!_date) {
                LyDateCollectionViewCell *tmpCell = (LyDateCollectionViewCell *)[cvDate cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                _date = [tmpCell date];
                _weekday = tmpCell.weekday;
            }
            
            NSDate *now = [NSDate date];
            NSString *last = [[NSString alloc] initWithFormat:@"%@ %02d:00:00 +0800", [[[LyUtil dateFormatterForAll] stringFromDate:now] substringToIndex:dateStringLength], lastestClickForReservate];
            NSDate *lastestDate = [[LyUtil dateFormatterForAll] dateFromString:last];
            
            NSString *strDate = [[[LyUtil dateFormatterForAll] stringFromDate:_date] substringToIndex:dateStringLength];
            strDate = [strDate stringByAppendingString:[[NSString alloc] initWithFormat:@" %02ld:00:00 +0800", (long)indexPath.row]];
            NSDate *dateDes = [[LyUtil dateFormatterForAll] dateFromString:strDate];
            
            int dayTimes = [LyUtil getDaysFrom:now To:dateDes];
            
            if (dayTimes < 2 && NSOrderedDescending == [now compare:lastestDate]) {
                [[LyRemindView remindWithMode:LyRemindViewMode_warn withTitle:[[NSString alloc] initWithFormat:@"预约须在前一天「%d:00」前", lastestClickForReservate]] show];
                break;
            }
            
            if ( [_delegate respondsToSelector:@selector(dateTimePicker:didSelectTimeItemAtIndex:andDate:andWeekday:)]) {
                [_delegate dateTimePicker:self didSelectTimeItemAtIndex:indexPath.row andDate:_date andWeekday:_weekday];
            }
            break;
        }
            
        default:
            break;
    }
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

//返回这个UICollectionViewCell是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( dateTimePickerCollectionViewMode_date == [collectionView tag])
    {
        return YES;
    }
    else if ( dateTimePickerCollectionViewMode_time == [collectionView tag])
    {
        
        LyTimeCollectionViewCell *timeCell = (LyTimeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        switch ( [[timeCell dateTimeInfo] state]) {
            
            case LyDateTimeInfoState_useable: {
                return YES;
                break;
            }
            case LyDateTimeInfoState_used: {
                return NO;
                break;
            }
            case LyDateTimeInfoState_disable: {
                return NO;
                break;
            }
            default: {
                return NO;
                break;
            }
        }
    }

    
    
    return NO;
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ( dateTimePickerCollectionViewMode_date == [collectionView tag])
    {
        return 7;
    }
    else if ( dateTimePickerCollectionViewMode_time == [collectionView tag])
    {
        return 24;
    }
    
    return 0;
    
}

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( dateTimePickerCollectionViewMode_date == [collectionView tag])
    {
        LyDateCollectionViewCell *tmpCell = (LyDateCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:lyDateCollectionViewCellReuseIdentifier forIndexPath:indexPath];
        
        if ( tmpCell)
        {
            [tmpCell setIndex:[indexPath row]];
        }
        
        return tmpCell;
    }
    else if ( dateTimePickerCollectionViewMode_time == [collectionView tag])
    {
        LyTimeCollectionViewCell *tmpCell = (LyTimeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:lyTimeCollectionViewCellReuseIdentifier forIndexPath:indexPath];
        
        if ( tmpCell)
        {
            LyDateTimeInfo *dti = [_dataSource dateTimePicker:self forItemIndex:[indexPath row]];
        
            [tmpCell setDateTimeInfo:dti];
        }
        
        return tmpCell;
    }
    
    
    return nil;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ( dateTimePickerCollectionViewMode_date == [collectionView tag])
    {
        return CGSizeMake( CGRectGetWidth(self.frame)/5.0f, dtpCvDateHeight);
    }
    else if ( dateTimePickerCollectionViewMode_time == [collectionView tag])
    {
        return CGSizeMake( (CGRectGetWidth(self.frame)-9)/3.0f, dtpCvTimeItemHeight);
    }
    
    return CGSizeZero;
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if ( dateTimePickerCollectionViewMode_date == [collectionView tag])
    {
        return UIEdgeInsetsMake( 0, 0, 0, 0);
    }
    else if ( dateTimePickerCollectionViewMode_time == [collectionView tag])
    {
        return UIEdgeInsetsMake( dtVerticalMargin, 1, dtVerticalMargin, 1);
    }

    return UIEdgeInsetsMake( 0, 0, 0, 0);
}


@end












