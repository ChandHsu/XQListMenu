//
//  XQListMenuView.m
//  分类菜单选择器
//
//  Created by 徐强 on 15/11/11.
//  Copyright © 2015年 xuqiang. All rights reserved.
//

#import "XQListMenuView.h"
#import "XQListMenuConfig.h"


#define arrowUpTitle @"---上---"
#define arrowDownTitle @"---下箭头---"

@interface XQListMenuCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) UIButton *cellBtn;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL showingArrow;

@end


@implementation XQListMenuCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addControl];
    }
    return self;
}
- (void)addControl{
    
    UIButton *cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cellBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cellBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cellBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    cellBtn.enabled = NO;
    [cellBtn setBackgroundColor:[UIColor clearColor]];
    
    //    cellBtn.backgroundColor = [UIColor cyanColor];
    
    UIView *view = [[UIView alloc] initWithFrame:cellBtn.bounds];
    view.backgroundColor = itemHighlightedColor;
    self.selectedBackgroundView = view;
    
    [self.contentView addSubview:cellBtn];
    
    self.cellBtn = cellBtn;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 0.3;
}
- (void)setTitle:(NSString *)title{
    _title = title;
    
    if ([title isEqualToString:arrowDownTitle]) {
        
        [self.cellBtn setImage:[UIImage imageNamed:@"images.bundle/arrow_down"] forState:UIControlStateNormal];
        [self.cellBtn setTitle:nil forState:UIControlStateNormal];
        return;
    }else if ([title isEqualToString:arrowUpTitle]){
        [self.cellBtn setImage:[UIImage imageNamed:@"images.bundle/arrow_up"] forState:UIControlStateNormal];
        [self.cellBtn setTitle:nil forState:UIControlStateNormal];
        return;
    }
    
    [self.cellBtn setImage:nil forState:UIControlStateNormal];
    [self.cellBtn setTitle:title forState:UIControlStateNormal];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.cellBtn.frame = self.bounds;
}

@end


@interface XQListMenuTitle : NSObject

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *hideTitleArray;
@property (nonatomic, assign) CGFloat normalHeight;
@property (nonatomic, assign) CGFloat hideHeight;
@property (nonatomic, assign) BOOL showingMore;
@property (nonatomic, strong) NSMutableIndexSet *selectedIndexSet;

@end


@implementation XQListMenuTitle

- (NSMutableIndexSet *)selectedIndexSet{
    if (!_selectedIndexSet) {
        _selectedIndexSet = [NSMutableIndexSet indexSet];
    }
    return _selectedIndexSet;
}
- (void)setTitleArray:(NSMutableArray *)titleArray{
    
    int simpleLineItemCount = [UIScreen mainScreen].bounds.size.width/itemWidth;
    
    int beginLine_example = beginHideLine;
    
    int beginLine = abs(beginLine_example);
    
    if (hideFunction) {
        
        int lineCount = (int)titleArray.count/simpleLineItemCount + (int)(titleArray.count % simpleLineItemCount?1:0);
        
        if (titleArray.count<=simpleLineItemCount) {
            self.normalHeight = 20 + itemHeight;
            self.hideHeight = self.normalHeight;
            self.showingMore = NO;
            self.hideTitleArray = titleArray;
        }else{//  || lineCount<=beginHideLine
            
            if (lineCount<=beginLine) {
                self.normalHeight = 20 + itemHeight * lineCount;
                self.hideHeight = self.normalHeight;
                self.showingMore = NO;
                self.hideTitleArray = titleArray;
                
            }else{
                
                if (furlable) {// 如果支持收拢
                    [titleArray addObject:arrowUpTitle];
                }
                
                int lineCount_behind = (int)titleArray.count/simpleLineItemCount + (int)(titleArray.count % simpleLineItemCount?1:0);
                CGFloat normalHeight = 20 + lineCount_behind*itemHeight;
                self.normalHeight = normalHeight;
                self.showingMore = NO;
                
                CGFloat hideHeight = 20 + (beginLine == 0?((int)lineCount_behind/2*itemHeight + (int)(lineCount_behind%2?itemHeight:0)):(itemHeight * beginLine));
                self.hideHeight = hideHeight;
                
                int hideLineLocation = hideHeight/itemHeight;// 隐藏的所在行
                
                
                if (furlable&&(!beginLine)) {// 添加收拢箭头之前的正常高度
                    
                    CGFloat normalHeight_before = ((int)(titleArray.count-1)/simpleLineItemCount + (int)((titleArray.count-1) % simpleLineItemCount?1:0))*itemHeight+20;
                    
                    if ((normalHeight != normalHeight_before)&&(normalHeight_before/hideHeight<2)) {
                        
                        int lineCount_before = normalHeight_before/itemHeight;
                        
                        if (lineCount_before/hideLineLocation!=2) {
                            
                            int remainNum = (int)lineCount_before%2;
                            
                            if (remainNum) {
                                hideLineLocation = (int)lineCount_before/2+1;
                            }else{
                                hideLineLocation = (int)lineCount_before/2;
                            }
                            
                            self.hideHeight = hideLineLocation*itemHeight+20;
                        }
                        
                    }
                }
                
                NSMutableArray *hideTitleArray = [NSMutableArray array];
                
                for (int i=0; i<simpleLineItemCount*hideLineLocation-1; i++) {
                    NSString *title = titleArray[i];
                    [hideTitleArray addObject:title];
                }
                NSString *arrowTitle = arrowDownTitle;// 添加箭头栏
                [hideTitleArray addObject:arrowTitle];
                self.hideTitleArray = hideTitleArray;
                
            }
            
        }
    }else{
        int lineCount = (int)titleArray.count/simpleLineItemCount + (int)(titleArray.count % simpleLineItemCount?1:0);
        self.normalHeight = 20 + lineCount*itemHeight;
        self.hideHeight = self.normalHeight;
        self.hideTitleArray = titleArray;
        
    }
    
    _titleArray = titleArray;
    
    
}

@end

@interface XQListMenuLayout : UICollectionViewFlowLayout
@end


@implementation XQListMenuLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray* attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    for(int i = 1; i < [attributes count]; ++i) {
        
        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        
        UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];
        // 设置间距为000
        NSInteger maximumSpacing = 0;
        
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        
        //防止单行显示
        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    return attributes;
}

@end

@protocol XQListMenuViewCellDelegate <NSObject>

@required
- (void)listMenuViewCellDidClickShowMore:(BOOL)showingMore indexpath:(NSIndexPath *)indexpath;
- (void)listMenuViewCellDidClickItenWithTitle:(NSString *)title;

@end

@interface XQListMenuViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,retain)  NSIndexPath *indexpath;
@property (nonatomic, retain) XQListMenuTitle *titleModal;
@property (nonatomic, weak) id <XQListMenuViewCellDelegate> delegate;
@property (nonatomic, weak)  UICollectionView *collectionview;
@property (nonatomic, assign) XQListMenuType menu_type;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

@implementation XQListMenuViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"XQListMenuViewCell";
    XQListMenuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[XQListMenuViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addCollectionview];
    }
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    return self;
}
- (void)addCollectionview{
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
- (void)layoutSubviews{
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
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
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
    if (self.menu_type == XQListMenuTypeSimpleSelect) return nil;
    
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
    if (self.menu_type == XQListMenuTypeSimpleSelect) return;
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
