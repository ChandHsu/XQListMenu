//
//  XQListMenuViewCell.h
//  分类菜单选择器
//
//  Created by 徐强 on 15/11/11.
//  Copyright © 2015年 xuqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQListMenuTitle.h"

@protocol XQListMenuViewCellDelegate <NSObject>

@required
- (void)listMenuViewCellDidClickShowMore:(BOOL)showingMore indexpath:(NSIndexPath *)indexpath;

@end

@interface XQListMenuViewCell : UITableViewCell

@property (nonatomic,retain)  NSIndexPath *indexpath;
@property (nonatomic, retain) XQListMenuTitle *titleModal;

@property (nonatomic, weak) id <XQListMenuViewCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
