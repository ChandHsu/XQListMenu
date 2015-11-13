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
    XQListMenuLayout *flowLayout    = [[XQListMenuLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    UICollectionView  *collectionview   = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.titleModal.hideHeight) collectionViewLayout:flowLayout];
    
    collectionview.backgroundColor = [UIColor whiteColor];
    
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
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.collectionview deselectItemAtIndexPath:indexPath animated:YES];
    
    XQListMenuCollectionViewCell *cell = (XQListMenuCollectionViewCell *)[self.collectionview cellForItemAtIndexPath:indexPath];
    
    if ([cell.title isEqualToString:@"---隐藏箭头---"]) {
        if ([self.delegate respondsToSelector:@selector(listMenuViewCellDidClickShowMore:indexpath:)]) {
            
            self.titleModal.showingMore = !self.titleModal.showingMore;
            
            [self.delegate listMenuViewCellDidClickShowMore:self.titleModal.showingMore indexpath:self.indexpath];
            [self.collectionview reloadData];
        }
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(itemWidth, itemHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
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




@end
