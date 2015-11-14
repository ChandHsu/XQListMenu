//
//  XQListMenuViewCell.m
//  分类菜单选择器
//
//  Created by 徐强 on 15/11/11.
//  Copyright © 2015年 xuqiang. All rights reserved.
//

#import "XQListMenuViewCell.h"
#import "XQListMenuLayout.h"
#import "XQListMenuCollectionViewCell.h"


@interface XQListMenuViewCell()
<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak)  UICollectionView *collectionview;
@property (nonatomic, assign) XQListMenuType menu_type;


@end

@implementation XQListMenuViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"XQListMenuViewCell";
    XQListMenuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[XQListMenuViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addCollectionview];
    }
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    return self;
}


- (void)addCollectionview
{
    self.menu_type = menuType;
    
    XQListMenuLayout *flowLayout    = [[XQListMenuLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    UICollectionView  *collectionview   = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.titleModal.hideHeight) collectionViewLayout:flowLayout];
    
    collectionview.backgroundColor = [UIColor whiteColor];
    
    if (self.menu_type == XQListMenuTypeMultiSelect) {
        collectionview.allowsMultipleSelection = YES;
    }
    
    collectionview.dataSource = self;
    collectionview.delegate = self;
    [collectionview registerClass:[XQListMenuCollectionViewCell class] forCellWithReuseIdentifier:@"XQListMenuViewCellCollectionviewCell"];
    collectionview.scrollEnabled = NO;
    self.collectionview = collectionview;
    [self.contentView addSubview:collectionview];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.titleModal.showingMore) {
        return self.titleModal.titleArray.count;
    }else{
        return self.titleModal.hideTitleArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"XQListMenuViewCellCollectionviewCell";
    
    XQListMenuCollectionViewCell *cell = (XQListMenuCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (self.titleModal.showingMore) {
        cell.title =  self.titleModal.titleArray[indexPath.row];
    }else{
        cell.title =  self.titleModal.hideTitleArray[indexPath.row];
    }
    
    if ([self.titleModal.selectedIndexSet containsIndex:indexPath.item]) {
        
        if (!([cell.title isEqualToString:arrowDownTitle]||[cell.title isEqualToString:arrowUpTitle])) {
            [self.collectionview selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            cell.selected = YES;
        }
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XQListMenuCollectionViewCell *cell = (XQListMenuCollectionViewCell *)[self.collectionview cellForItemAtIndexPath:indexPath];
    
    if ([cell.title isEqualToString:arrowDownTitle]||[cell.title isEqualToString:arrowUpTitle]) {
        if ([self.delegate respondsToSelector:@selector(listMenuViewCellDidClickShowMore:indexpath:)]) {
            
            self.titleModal.showingMore = !self.titleModal.showingMore;
            [self.delegate listMenuViewCellDidClickShowMore:self.titleModal.showingMore indexpath:self.indexpath];
            [self.collectionview deselectItemAtIndexPath:indexPath animated:YES];
            cell.selected = NO;
        }
    }else {
        
        if (self.menu_type == XQListMenuTypeMultiSelect) return;
        
        if ([self.delegate respondsToSelector:@selector(listMenuViewCellDidClickItenWithTitle:)]) {
            [self.delegate listMenuViewCellDidClickItenWithTitle:cell.title];
        }
    }
    
    [self.collectionview deselectItemAtIndexPath:indexPath animated:YES];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(itemWidth, itemHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    int simpleLineItemCount = [UIScreen mainScreen].bounds.size.width/itemWidth;
    
    CGFloat totalW = simpleLineItemCount * itemWidth;
    
    CGFloat margin = (self.collectionview.frame.size.width - totalW)/2;
    
    return UIEdgeInsetsMake(margin, margin, margin, margin);
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionview.frame = self.bounds;
}

- (void)setTitleModal:(XQListMenuTitle *)titleModal{
    _titleModal = titleModal;
    
    [self.collectionview reloadData];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XQListMenuCollectionViewCell *cell = (XQListMenuCollectionViewCell *)[self.collectionview cellForItemAtIndexPath:indexPath];
    if (self.menu_type == XQListMenuTypeMultiSelect) {
        if (!([cell.title isEqualToString:arrowDownTitle]||[cell.title isEqualToString:arrowUpTitle])) {
            
            [self.titleModal.selectedIndexSet addIndex:indexPath.item];
        }
    }
    
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.menu_type == XQListMenuTypeMultiSelect) {
        [self.titleModal.selectedIndexSet removeIndex:indexPath.item];
        
    }
    return YES;
}






@end
