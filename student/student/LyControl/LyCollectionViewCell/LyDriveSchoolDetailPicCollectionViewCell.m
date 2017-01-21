//
//  LyDriveSchoolDetailPicCollectionViewCell.m
//  LyStudyDrive
//
//  Created by Junes on 16/4/6.
//  Copyright © 2016年 Junes. All rights reserved.
//

#import "LyDriveSchoolDetailPicCollectionViewCell.h"
#import "LyUtil.h"

#import "UIImageView+WebCache.h"


@interface LyDriveSchoolDetailPicCollectionViewCell ()
{
    UIImageView             *ivImage;
}
@end



@implementation LyDriveSchoolDetailPicCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame])
    {
        ivImage = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        [ivImage setContentMode:UIViewContentModeScaleAspectFill];
        [ivImage setClipsToBounds:YES];
        
        [self addSubview:ivImage];
        
    }
    
    return self;
}



- (void)setStrUrl:(NSString *)strUrl
{
    _strUrl = strUrl;
    
    [ivImage sd_setImageWithURL:[NSURL URLWithString:_strUrl]
               placeholderImage:[LyUtil imageForImageName:@"status_pic_default" needCache:NO]
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                          if (image) {
                              [_delegate picLoadFinish:image
                                                strUrl:_strUrl
                           andDriveSchoolDetailPicCell:self];
                          }
                      }];
}


@end
