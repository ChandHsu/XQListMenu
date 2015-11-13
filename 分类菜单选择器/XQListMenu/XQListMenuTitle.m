//
//  XQListMenuTitle.m
//  分类菜单选择器
//
//  Created by 徐强 on 15/11/12.
//  Copyright © 2015年 xuqiang. All rights reserved.
//

#import "XQListMenuTitle.h"
#import "XQListMenuConfig.h"

@implementation XQListMenuTitle


- (void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    
    int simpleLineItemCount = [UIScreen mainScreen].bounds.size.width/itemWidth;
    NSArray *array = titleArray;
    int lineCount = (int)array.count/simpleLineItemCount + (int)(array.count % simpleLineItemCount?1:0);
    CGFloat normalHeight = 20 + lineCount*itemHeight;
    CGFloat hideHeight = 20 + (int)lineCount/2*itemHeight + (int)(lineCount%2?itemHeight:0);
    
    self.normalHeight = normalHeight;
    self.hideHeight = hideHeight;
    self.showingMore = NO;
    
    int hideLineLocation = self.hideHeight/itemHeight;// 隐藏的所在行
    NSMutableArray *hideTitleArray = [NSMutableArray array];
    
    for (int i=0; i<4*hideLineLocation-1; i++) {
        NSString *title = array[i];
        [hideTitleArray addObject:title];
    }
    NSString *arrowTitle = @"---隐藏箭头---";// 添加箭头栏
    [hideTitleArray addObject:arrowTitle];
    self.hideTitleArray = hideTitleArray;
    
}


@end
