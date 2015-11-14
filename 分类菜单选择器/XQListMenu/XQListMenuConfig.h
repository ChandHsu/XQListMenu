//
//  XQListMenuConfig.h
//  分类菜单选择器
//
//  Created by 徐强 on 15/11/12.
//  Copyright © 2015年 xuqiang. All rights reserved.
//

#ifndef XQListMenuConfig_h
#define XQListMenuConfig_h

typedef enum{
    XQListMenuTypeSimpleSelect,
    XQListMenuTypeMultiSelect
}XQListMenuType;

#define menuType  XQListMenuTypeMultiSelect

#define hideFunction YES
#define furlable  YES

#define beginHideLine 0

#define itemWidth (([UIScreen mainScreen].bounds.size.width-20)/4)
#define itemHeight 35

#define itemHighlightedColor  [UIColor cyanColor]


#endif /* XQListMenuConfig_h */
