//
//  LyConsultMessageTableViewCell.m
//  student
//
//  Created by MacMini on 2016/12/29.
//  Copyright © 2016年 517xueche. All rights reserved.
//

#import "LyConsultMessageTableViewCell.h"

@interface LyConsultMessageTableViewCell ()
{
    
}

@property (strong, nonatomic)       UITableView     *tableView;

@end


@implementation LyConsultMessageTableViewCell

static NSString *const lyConsultMessageReplyTableViewCellReuseIdentifier = @"lyConsultMessageReplyTableViewCellReuseIdentifier";

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    
    return self;
}

- (void)initSubviews {
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        
    }
    
    return _tableView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
