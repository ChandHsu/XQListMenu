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
    XQListMenuTypeSimpleSelect,// 单选回调
    XQListMenuTypeMultiSelect  // 多选回调
}XQListMenuType;

#define menuType  XQListMenuTypeMultiSelect

#define hideFunction NO // 隐藏功能
#define furlable  YES //能够收拢(如果 hideFunction 为 NO,此项设置无效)

#define itemWidth (([UIScreen mainScreen].bounds.size.width-20)/4)
#define itemHeight 35

#define itemHighlightedColor  [UIColor cyanColor]




#endif /* XQListMenuConfig_h */
