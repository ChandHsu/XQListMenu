//
//  XQListMenuController.h
//  分类菜单选择器
//
//  Created by 徐强 on 15/11/11.
//  Copyright © 2015年 xuqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    XQListMenuTypeSimpleSelect,
    XQListMenuTypeMultiSelect
}XQListMenuType;

typedef void (^ClickBlock)(NSString *showText);

@protocol XQListMenuControllerDelegate <NSObject>

@optional
- (UIView   *)headerViewForXQListMenuControllerForSection:(NSInteger)section;
- (UIView   *)footerViewForXQListMenuControllerForSection:(NSInteger)section;
- (NSString *)titleforHeaderForXQListMenuControllerForSection:(NSInteger)section;
- (NSString *)titleforFooterForXQListMenuControllerForSection:(NSInteger)section;
- (CGFloat   )heightForHeaderForXQListMenuControllerForSection:(NSInteger)section;
- (CGFloat   )heightForFooterForXQListMenuControllerForSection:(NSInteger)section;

@end


@interface XQListMenuController : UITableViewController

@property (nonatomic, assign) BOOL hideFunction;
@property (nonatomic, assign) BOOL furlable;
@property (nonatomic, assign) int  beginHideLine;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) XQListMenuType menuType;
@property (nonatomic, assign) UITableViewStyle tableViewStyle;
@property (nonatomic, strong) UIColor *itemHighlightedColor;

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
