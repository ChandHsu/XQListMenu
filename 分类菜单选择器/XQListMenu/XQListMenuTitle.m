//
//  XQListMenuTitle.m
//  分类菜单选择器
//
//  Created by 徐强 on 15/11/12.
//  Copyright © 2015年 xuqiang. All rights reserved.
//

#import "XQListMenuTitle.h"
#import "XQListMenuConfig.h"
#import "XQListMenuCollectionViewCell.h"

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
