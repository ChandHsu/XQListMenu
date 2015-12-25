//
//  XQListMenuView.h
//  分类菜单选择器
//
//  Created by 徐强 on 15/11/11.
//  Copyright © 2015年 xuqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickBlock)(NSString *showText);

@interface XQListMenuView : UITableViewController

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *itemTitleArrays;
@property (nonatomic, copy  ) ClickBlock clickBlock;

/***  获取所有选中的item,key就是大标题  **/
- (NSDictionary *)getSelectedDict;
/***  全选,反选  **/
-(void)reverseSelectAllItem;

@end
