//
//  XQListMenuTitle.h
//  分类菜单选择器
//
//  Created by 徐强 on 15/11/12.
//  Copyright © 2015年 xuqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XQListMenuTitle : NSObject

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *hideTitleArray;

@property (nonatomic, assign) CGFloat normalHeight;
@property (nonatomic, assign) CGFloat hideHeight;
@property (nonatomic, assign) BOOL showingMore;

@end
