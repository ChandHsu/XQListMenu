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

#define furlable  YES //能够收拢

#define itemWidth (([UIScreen mainScreen].bounds.size.width-20)/4)
#define itemHeight 35

#define itemHighlightedColor  [UIColor cyanColor]




#endif /* XQListMenuConfig_h */
