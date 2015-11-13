//
//  XQListMenuCollectionViewCell.m
//  分类菜单选择器
//
//  Created by 徐强 on 15/11/12.
//  Copyright © 2015年 xuqiang. All rights reserved.
//

#import "XQListMenuCollectionViewCell.h"

@implementation XQListMenuCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addControl];
    }
    return self;
}

- (void)addControl{
    
    UIButton *cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cellBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cellBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cellBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    cellBtn.userInteractionEnabled = NO;
    cellBtn.enabled = NO;
    [cellBtn setBackgroundColor:[UIColor clearColor]];
    
//    cellBtn.backgroundColor = [UIColor cyanColor];
    
//    UIView *view = [[UIView alloc] initWithFrame:cellBtn.bounds];
//    view.backgroundColor = [UIColor redColor];
//    self.selectedBackgroundView = view;
    
    [self.contentView addSubview:cellBtn];
    
    self.cellBtn = cellBtn;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 0.3;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    
    if ([title isEqualToString:@"---隐藏箭头---"]) {
        
        [self.cellBtn setImage:[UIImage imageNamed:@"images.bundle/arrow_down_gray"] forState:UIControlStateNormal];
        [self.cellBtn setTitle:nil forState:UIControlStateNormal];
        return;
    }
    [self.cellBtn setImage:nil forState:UIControlStateNormal];
    [self.cellBtn setTitle:title forState:UIControlStateNormal];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.cellBtn.frame = self.bounds;
}




@end
