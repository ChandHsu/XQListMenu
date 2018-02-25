//
//  XQListMenuController.m
//  分类菜单选择器
//
//  Created by 徐强 on 15/11/11.
//  Copyright © 2015年 xuqiang. All rights reserved.
//

#import "XQListMenuController.h"


#define arrowUpTitle @"---上---"
#define arrowDownTitle @"---下箭头---"

@interface NSString (XQExtension)
- (BOOL)isEqualToStringInArray:(NSArray *)stringArray;
@end

@implementation NSString (XQExtension)
- (BOOL)isEqualToStringInArray:(NSArray *)stringArray{
    for(NSString *childStr in stringArray){
        if ([self isEqualToString:childStr]) {
            return true;
        }
    }
    return false;
}
@end

@interface XQListMenuCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) UIButton *cellBtn;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL showingArrow;
@property (nonatomic, assign) BOOL disabled;
@property (nonatomic, strong) UIColor *highlightedColor;


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
    [cellBtn setBackgroundColor:[UIColor whiteColor]];
    
//    UIView *view = [[UIView alloc] initWithFrame:cellBtn.bounds];
//    view.backgroundColor = [UIColor cyanColor];
//    self.selectedBackgroundView = view;
    
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
- (void)setDisabled:(BOOL)disabled{
    if (_disabled == disabled) return;
    _disabled = disabled;
    if (disabled) {
        [self.cellBtn setTitleColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1] forState:UIControlStateDisabled];
    }else{
        [self.cellBtn setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    }
    self.userInteractionEnabled = !disabled;
}
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (!self.highlightedColor) self.highlightedColor = [UIColor cyanColor];
    if (selected) self.cellBtn.backgroundColor = self.highlightedColor;
    else  self.cellBtn.backgroundColor = [UIColor whiteColor];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.cellBtn.frame = self.bounds;
}

@end


@interface XQListMenuTitle : NSObject

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *hideTitleArray;
@property (nonatomic, strong) NSArray *disabledTitleArray;
@property (nonatomic, strong) NSArray *selectItemTitlesArray;
@property (nonatomic, strong) NSArray *disabledFlagsArray;

@property (nonatomic, assign) CGFloat normalHeight;
@property (nonatomic, assign) CGFloat hideHeight;
@property (nonatomic, assign) BOOL showingMore;
@property (nonatomic, strong) NSMutableIndexSet *selectedIndexSet;

@property (nonatomic, assign) BOOL hideFunction;
@property (nonatomic, assign) BOOL furlable;
@property (nonatomic, assign) int  beginHideLine;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) XQListMenuType menuType;
@property (nonatomic, strong) UIColor *itemHighlightedColor;

@end


@implementation XQListMenuTitle

- (NSMutableIndexSet *)selectedIndexSet{
    if (!_selectedIndexSet) {
        _selectedIndexSet = [NSMutableIndexSet indexSet];
    }
    return _selectedIndexSet;
}
- (void)setTitleArray:(NSMutableArray *)titleArray{
    if (_titleArray == titleArray) return;
    _titleArray = titleArray;
    [self caculateHeight];
    [self handleDisabledTitles];
    [self handleSelectedTitles];
}
- (void)setHideFunction:(BOOL)hideFunction{
    if (_hideFunction == hideFunction) return;
    _hideFunction = hideFunction;
    [self caculateHeight];
}
- (void)setFurlable:(BOOL)furlable{
    if (_furlable == furlable) return;
    _furlable = furlable;
    [self caculateHeight];
}
- (void)setBeginHideLine:(int)beginHideLine{
    if (_beginHideLine == beginHideLine) return;
    _beginHideLine = beginHideLine;
    [self caculateHeight];
}
- (void)setItemSize:(CGSize)itemSize{
    if (CGSizeEqualToSize(itemSize, _itemSize)) return;
    _itemSize = itemSize;
    [self caculateHeight];
}
- (void)caculateHeight{
    
    if (self.titleArray.count==0) return;
    if (CGSizeEqualToSize(self.itemSize, CGSizeZero)) _itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-20)/4, 35);
    
    CGFloat itemWidth = self.itemSize.width;
    CGFloat itemHeight = self.itemSize.height;
    int simpleLineItemCount = [UIScreen mainScreen].bounds.size.width/itemWidth;
    
    int beginLine_example = self.beginHideLine;
    
    int beginLine = abs(beginLine_example);
    
    if (self.hideFunction) {
        
        int lineCount = (int)self.titleArray.count/simpleLineItemCount + (int)(self.titleArray.count % simpleLineItemCount?1:0);
        
        if (self.titleArray.count<=simpleLineItemCount) {
            self.normalHeight = 20 + itemHeight;
            self.hideHeight = self.normalHeight;
            self.showingMore = NO;
            self.hideTitleArray = self.titleArray;
        }else{//  || lineCount<=beginHideLine
            
            if (lineCount<=beginLine) {
                self.normalHeight = 20 + itemHeight * lineCount;
                self.hideHeight = self.normalHeight;
                self.showingMore = NO;
                self.hideTitleArray = self.titleArray;
                
            }else{
                
                if (self.furlable) [self.titleArray addObject:arrowUpTitle];
                
                int lineCount_behind = (int)self.titleArray.count/simpleLineItemCount + (int)(self.titleArray.count % simpleLineItemCount?1:0);
                CGFloat normalHeight = 20 + lineCount_behind*itemHeight;
                self.normalHeight = normalHeight;
                self.showingMore = NO;
                
                CGFloat hideHeight = 20 + (beginLine == 0?((int)lineCount_behind/2*itemHeight + (int)(lineCount_behind%2?itemHeight:0)):(itemHeight * beginLine));
                self.hideHeight = hideHeight;
                
                int hideLineLocation = hideHeight/itemHeight;// 隐藏的所在行
                
                
                if (self.furlable&&(!beginLine)) {// 添加收拢箭头之前的正常高度
                    
                    CGFloat normalHeight_before = ((int)(self.titleArray.count-1)/simpleLineItemCount + (int)((self.titleArray.count-1) % simpleLineItemCount?1:0))*itemHeight+20;
                    
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
                    NSString *title = self.titleArray[i];
                    [hideTitleArray addObject:title];
                }
                NSString *arrowTitle = arrowDownTitle;// 添加箭头栏
                [hideTitleArray addObject:arrowTitle];
                self.hideTitleArray = hideTitleArray;
                
            }
            
        }
    }else{
        int lineCount = (int)self.titleArray.count/simpleLineItemCount + (int)(self.titleArray.count % simpleLineItemCount?1:0);
        self.normalHeight = 20 + lineCount*itemHeight;
        self.hideHeight = self.normalHeight;
        self.hideTitleArray = self.titleArray;
        
    }
}

- (void)setDisabledTitleArray:(NSArray *)disabledTitleArray{
    _disabledTitleArray = disabledTitleArray;
    [self handleDisabledTitles];
}
- (void)setSelectItemTitlesArray:(NSArray *)selectItemTitlesArray{
    _selectItemTitlesArray = selectItemTitlesArray;
    [self handleSelectedTitles];
}
- (void)setMenuType:(XQListMenuType)menuType{
    if (_menuType == menuType) return;
    _menuType = menuType;
    [self handleSelectedTitles];
}
- (void)handleDisabledTitles{
    
    if (self.titleArray.count==0||self.disabledTitleArray.count==0) return;
    NSMutableArray *disabledFlagsArray = [NSMutableArray array];
    
    for (NSString *title in self.titleArray) {
        if ([title isEqualToStringInArray:self.disabledTitleArray]) {
            
            [disabledFlagsArray addObject:[NSNumber numberWithBool:true]];
            
            if ([self.selectItemTitlesArray containsObject:title]) {
                NSInteger index = [self.titleArray indexOfObject:title];
                [self.selectedIndexSet removeIndex:index];
            }
            
        }else{
            [disabledFlagsArray addObject:[NSNumber numberWithBool:false]];
        }
    }
    
    self.disabledFlagsArray = disabledFlagsArray;
}
- (void)handleSelectedTitles{
    if (self.titleArray.count==0||self.selectItemTitlesArray.count==0) return;
    for (NSString *title in self.selectItemTitlesArray) {
        if ([self.disabledTitleArray containsObject:title]) continue;
        NSInteger index = [self.titleArray indexOfObject:title];
        [self.selectedIndexSet addIndex:index];
    }
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
- (void)listMenuViewCellDidClickItemWithTitle:(NSString *)title indexpath:(NSIndexPath *)indexpath;

@end

@interface XQListMenuViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, retain)  NSIndexPath *indexpath;
@property (nonatomic, retain) XQListMenuTitle *titleModal;
@property (nonatomic, weak) id <XQListMenuViewCellDelegate> delegate;
@property (nonatomic, weak)  UICollectionView *collectionview;

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
    cell.highlightedColor = self.titleModal.itemHighlightedColor;
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
    cell.disabled = [self.titleModal.disabledFlagsArray[indexPath.row] boolValue];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XQListMenuCollectionViewCell *cell = (XQListMenuCollectionViewCell *)[self.collectionview cellForItemAtIndexPath:indexPath];
    if (cell.disabled) return;
    
    if ([cell.title isEqualToString:arrowDownTitle]||[cell.title isEqualToString:arrowUpTitle]) {
        if ([self.delegate respondsToSelector:@selector(listMenuViewCellDidClickShowMore:indexpath:)]) {
            
            self.titleModal.showingMore = !self.titleModal.showingMore;
            [self.delegate listMenuViewCellDidClickShowMore:self.titleModal.showingMore indexpath:self.indexpath];
            [self.collectionview deselectItemAtIndexPath:indexPath animated:YES];
            cell.selected = NO;
        }
    }else {
        
        if (self.titleModal.menuType == XQListMenuTypeMultiSelect) return;
        
        if ([self.delegate respondsToSelector:@selector(listMenuViewCellDidClickItemWithTitle:indexpath:)]) {
            [self.delegate listMenuViewCellDidClickItemWithTitle:cell.title indexpath:indexPath];
            [self.titleModal.selectedIndexSet removeAllIndexes];
            [self.titleModal.selectedIndexSet addIndex:indexPath.item];
        }
    }
    
//    [self.collectionview deselectItemAtIndexPath:indexPath animated:YES];
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.titleModal.itemSize.width, self.titleModal.itemSize.height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    CGSize size = self.titleModal.itemSize;
    int simpleLineItemCount = [UIScreen mainScreen].bounds.size.width/size.width;
    
    CGFloat totalW = simpleLineItemCount * size.width;
    
    CGFloat margin = (self.collectionview.frame.size.width - totalW)/2;
    
    return UIEdgeInsetsMake(margin, margin, margin, margin);
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.collectionview.frame = self.bounds;
    [self.collectionview reloadData];
}
- (void)setTitleModal:(XQListMenuTitle *)titleModal{
    if (_titleModal == titleModal) return;
    _titleModal = titleModal;
    self.collectionview.allowsMultipleSelection = self.titleModal.menuType == XQListMenuTypeMultiSelect;
    [self.collectionview reloadData];
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XQListMenuCollectionViewCell *cell = (XQListMenuCollectionViewCell *)[self.collectionview cellForItemAtIndexPath:indexPath];
    if (self.titleModal.menuType == XQListMenuTypeMultiSelect) {
        if (!([cell.title isEqualToString:arrowDownTitle]||[cell.title isEqualToString:arrowUpTitle])) {
            [self.titleModal.selectedIndexSet addIndex:indexPath.item];
        }
    }
    
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.titleModal.menuType == XQListMenuTypeMultiSelect) {
        [self.titleModal.selectedIndexSet removeIndex:indexPath.item];
        
    }
    return YES;
}

@end


@interface XQListMenuController ()<XQListMenuViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *titleModalArray;

@end

@implementation XQListMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.tableView.bounds style:self.tableViewStyle];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
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
    if ([self.delegate respondsToSelector:@selector(headerViewForXQListMenuControllerForSection:)]) {
        return [self.delegate headerViewForXQListMenuControllerForSection:section];
    }
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headerBtn.frame = CGRectMake(0, 0, self.view.bounds.size.width, 40);
    [headerBtn setTitle:self.titleArray[section] forState:UIControlStateNormal];
    headerBtn.userInteractionEnabled = NO;
    headerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [headerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [headerBtn setBackgroundColor:[UIColor orangeColor]];
    return headerBtn;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(footerViewForXQListMenuControllerForSection:)]) {
        return [self.delegate footerViewForXQListMenuControllerForSection:section];
    }
    return nil;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(titleforHeaderForXQListMenuControllerForSection:)]) {
        return [self.delegate titleforHeaderForXQListMenuControllerForSection:section];
    }
    return @" ";
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(titleforFooterForXQListMenuControllerForSection:)]) {
        return [self.delegate titleforFooterForXQListMenuControllerForSection:section];
    }
    return @" ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(heightForHeaderForXQListMenuControllerForSection:)]) {
        return [self.delegate heightForHeaderForXQListMenuControllerForSection:section];
    }
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(heightForFooterForXQListMenuControllerForSection:)]) {
        return [self.delegate heightForFooterForXQListMenuControllerForSection:section];
    }
    return 0.0000001;
}
- (void)listMenuViewCellDidClickShowMore:(BOOL)showingMore indexpath:(NSIndexPath *)indexpath{
    XQListMenuTitle *titleModal = (XQListMenuTitle *)self.titleModalArray[indexpath.section];
    titleModal.showingMore = showingMore;
    [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
    
}
- (void)listMenuViewCellDidClickItemWithTitle:(NSString *)title indexpath:(NSIndexPath *)indexpath{
    if (self.config.menuType == XQListMenuTypeSimpleSelectGlobal) {
        for (int j=0; j<self.titleArray.count; j++) {
            XQListMenuTitle *titleModal = self.titleModalArray[j];
            NSMutableIndexSet *indexSet = titleModal.selectedIndexSet;
            
            if (indexSet.count>0) {
                NSInteger index = [indexSet firstIndex];
                NSString *text = titleModal.titleArray[index];
                if (![text isEqualToString:title]) {
                    [indexSet removeAllIndexes];
                    [self.tableView reloadData];
                    break;
                }
            }
        }
    }
    if (self.clickBlock) {
        self.clickBlock(title);
    }
}
- (void)setConfig:(XQListMenuConfig)config{
    _config = config;
    for (XQListMenuTitle *titleModal in self.titleModalArray) {
        titleModal.menuType = config.menuType;
        titleModal.itemSize = config.itemSize;
        titleModal.beginHideLine = config.beginHideLine;
        titleModal.hideFunction = config.hideFunction;
        titleModal.furlable = config.furlable;
    }
}
- (void)setItemTitlesArray:(NSArray *)itemTitlesArray{
    _itemTitlesArray = itemTitlesArray;
    NSMutableArray *titleModalArray = [NSMutableArray array];
    
    for (NSArray *array in itemTitlesArray) {
        
        XQListMenuTitle *titleModal = [[XQListMenuTitle alloc] init];
        titleModal.titleArray = [NSMutableArray arrayWithArray:array];
        titleModal.showingMore = NO;
        if (!CGSizeEqualToSize(self.config.itemSize, CGSizeZero)) titleModal.itemSize = self.config.itemSize;
        titleModal.beginHideLine = self.config.beginHideLine;
        titleModal.hideFunction  = self.config.hideFunction;
        titleModal.furlable      = self.config.furlable;
        titleModal.menuType      = self.config.menuType;
        titleModal.itemHighlightedColor = self.itemHighlightedColor;
        [titleModalArray addObject:titleModal];
        
    }
    self.titleModalArray = titleModalArray;
}
- (void)setItemHighlightedColor:(UIColor *)itemHighlightedColor{
    _itemHighlightedColor = itemHighlightedColor;
    for (XQListMenuTitle *titleModal in self.titleModalArray) {
        titleModal.itemHighlightedColor = itemHighlightedColor;
    }
}
- (void)setDisabledItemTitlesArray:(NSArray *)disabledItemTitlesArray{
    _disabledItemTitlesArray = disabledItemTitlesArray;
    for (int i = 0; i<self.titleModalArray.count; i++) {
        XQListMenuTitle *titleModal = self.titleModalArray[i];
        titleModal.disabledTitleArray = disabledItemTitlesArray[i];
    }
}
- (void)setSelectItemTitlesArray:(NSArray *)selectItemTitlesArray{
    _selectItemTitlesArray = selectItemTitlesArray;
    if (self.config.menuType == XQListMenuTypeMultiSelect) {
        for (int i = 0; i<self.titleModalArray.count; i++) {
            XQListMenuTitle *titleModal = self.titleModalArray[i];
            titleModal.selectItemTitlesArray = selectItemTitlesArray[i];
        }
    }else{
        for (NSArray *array in selectItemTitlesArray) {
            if (array.count>0) {
                NSInteger i = [selectItemTitlesArray indexOfObject:array];
                XQListMenuTitle *titleModal = self.titleModalArray[i];
                titleModal.selectItemTitlesArray = selectItemTitlesArray[i];
                break;
            }
        }
    }
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
    if (self.config.menuType != XQListMenuTypeMultiSelect) return;
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
