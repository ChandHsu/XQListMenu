//
//  XQListMenuView.m
//  分类菜单选择器
//
//  Created by 徐强 on 15/11/11.
//  Copyright © 2015年 xuqiang. All rights reserved.
//

#import "XQListMenuView.h"
#import "XQListMenuViewCell.h"
#import "XQListMenuConfig.h"
#import "XQListMenuTitle.h"

@interface XQListMenuView ()<XQListMenuViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *titleModalArray;
@property (nonatomic, assign) XQListMenuType menu_type;

@end

@implementation XQListMenuView



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    self.menu_type = menuType;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XQListMenuViewCell *cell = [XQListMenuViewCell cellWithTableView:tableView];
    cell.titleModal = (XQListMenuTitle *)self.titleModalArray[indexPath.section];
    cell.delegate = self;
    cell.indexpath = indexPath;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XQListMenuTitle *titleModal = (XQListMenuTitle *)self.titleModalArray[indexPath.section];
    
    BOOL showingMore= titleModal.showingMore;
    if (showingMore) {
        return titleModal.normalHeight;
    }else{
        return titleModal.hideHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headerBtn.frame = CGRectMake(0, 0, self.view.bounds.size.width, 40);
    [headerBtn setTitle:self.titleArray[section] forState:UIControlStateNormal];
    headerBtn.userInteractionEnabled = NO;
    headerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [headerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [headerBtn setBackgroundColor:[UIColor orangeColor]];
    return headerBtn;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)listMenuViewCellDidClickShowMore:(BOOL)showingMore indexpath:(NSIndexPath *)indexpath{
    
    XQListMenuTitle *titleModal = (XQListMenuTitle *)self.titleModalArray[indexpath.section];
    titleModal.showingMore = showingMore;
    
    [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)listMenuViewCellDidClickItenWithTitle:(NSString *)title{
    
    if (self.clickBlock) {
        self.clickBlock(title);
    }
}

- (void)setItemTitleArrays:(NSArray *)itemTitleArrays{
    _itemTitleArrays = itemTitleArrays;
    
    NSMutableArray *titleModalArray = [NSMutableArray array];
    
    for (NSArray *array in itemTitleArrays) {
        
        XQListMenuTitle *titleModal = [[XQListMenuTitle alloc] init];
        titleModal.titleArray = [NSMutableArray arrayWithArray:array];
        titleModal.showingMore = NO;
        [titleModalArray addObject:titleModal];
        
    }
    self.titleModalArray = titleModalArray;
    
}

- (NSDictionary *)getSelectedDict{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (int j=0; j<self.titleArray.count; j++) {
        
        XQListMenuTitle *titleModal = self.titleModalArray[j];
        
        NSIndexSet *indexSet = titleModal.selectedIndexSet;
        
        NSString *dictKey = [NSString stringWithFormat:@"%@",self.titleArray[j]];
        
        if (indexSet.count==0){
            dict[dictKey] = @[];
            continue;
        }
        
        NSMutableArray *seleteTitleArray = [ NSMutableArray array];
        [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *title = titleModal.titleArray[idx];
            [seleteTitleArray addObject:title];
        }];
        
        
        dict[dictKey] = seleteTitleArray;
    }
    
    return dict;
}

- (void)reverseSelectAllItem{
    
    BOOL isAllSelect = YES;//全选状态
    
    for (XQListMenuTitle *titleModal in self.titleModalArray) {
        if (titleModal.selectedIndexSet.count != titleModal.titleArray.count) {
            isAllSelect = NO;
            break;
        }
    }
    
    if (isAllSelect) {// 取消全选
        for (XQListMenuTitle *titleModal in self.titleModalArray) {
            
            [titleModal.selectedIndexSet removeAllIndexes];
            titleModal.showingMore = NO;
        }
    }else{// 全选
        for (XQListMenuTitle *titleModal in self.titleModalArray) {
            
            NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
            
            for (int i = 0; i<titleModal.titleArray.count; i++) {
                NSUInteger index = i;
                [indexSet addIndex:index];
            }
            titleModal.selectedIndexSet = indexSet;
            titleModal.showingMore = YES;
        }
    }
    
    [self.tableView reloadData];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.tableView reloadData];
}

@end
