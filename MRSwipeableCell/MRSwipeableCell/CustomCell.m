//
//  CustomCell.m
//  MRSwipeableCell
//
//  Created by maqinjun on 15/11/9.
//  Copyright © 2015年 micro-robot. All rights reserved.
//

#import "CustomCell.h"

@interface CustomCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation CustomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier containingTableView:containingTableView leftUtilityButtons:leftUtilityButtons rightUtilityButtons:rightUtilityButtons];
    
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.f, 10.f, 100.f, 40.f)];
        _titleLabel.textColor = [UIColor blueColor];
        [self.cellContentView addSubview:_titleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _titleLabel.text = title;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
