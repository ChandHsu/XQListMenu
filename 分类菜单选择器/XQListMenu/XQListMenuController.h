//
//  XQListMenuController.h
//  分类菜单选择器
//
//  Created by 徐强 on 15/11/11.
//  Copyright © 2015年 xuqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XQListMenuControllerDelegate <NSObject>

@optional
- (UIView   *)headerViewForXQListMenuControllerForSection:(NSInteger)section;
- (UIView   *)footerViewForXQListMenuControllerForSection:(NSInteger)section;
- (NSString *)titleforHeaderForXQListMenuControllerForSection:(NSInteger)section;
- (NSString *)titleforFooterForXQListMenuControllerForSection:(NSInteger)section;
- (CGFloat   )heightForHeaderForXQListMenuControllerForSection:(NSInteger)section;
- (CGFloat   )heightForFooterForXQListMenuControllerForSection:(NSInteger)section;

@end


typedef enum{
    XQListMenuTypeSimpleSelectSection,//组单选
    XQListMenuTypeSimpleSelectGlobal,//全局单选
    XQListMenuTypeMultiSelect//多选
}XQListMenuType;

typedef struct{
    XQListMenuType menuType;
    CGSize itemSize;
    BOOL furlable;//收拢开关
    BOOL hideFunction;//隐藏开关
    int  beginHideLine;//开始隐藏的行
}XQListMenuConfig;

CG_INLINE XQListMenuConfig
XQListMenuConfigMake(XQListMenuType menuType,CGSize itemSize,BOOL furlable,BOOL hideFunction,int beginHideLine){
    XQListMenuConfig config;
    config.menuType = menuType;
    config.itemSize = itemSize;
    config.hideFunction = hideFunction;
    config.furlable = furlable;
    config.beginHideLine = beginHideLine;
    return config;
}

typedef void (^ClickBlock)(NSString *showText);

@interface XQListMenuController : UITableViewController

@property (nonatomic, assign) UITableViewStyle tableViewStyle;
@property (nonatomic, strong) UIColor *itemHighlightedColor;
@property (nonatomic, assign) XQListMenuConfig config;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *itemTitlesArray;
@property (nonatomic, strong) NSArray *disabledItemTitlesArray;

@property (nonatomic, strong) NSArray *selectItemTitlesArray;//预选中

@property (nonatomic, copy  ) ClickBlock clickBlock;

@property (nonatomic, weak  ) id <XQListMenuControllerDelegate> delegate;

/***  获取所有选中的item,key就是大标题  **/
- (NSDictionary *)getSelectedDict;
/***  全选,反选  **/
-(void)reverseSelectAllItem;

@end
