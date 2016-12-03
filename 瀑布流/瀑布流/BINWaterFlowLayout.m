//
//  BINWaterFlowLayout.m
//  瀑布流
//
//  Created by 梦想 on 2016/12/3.
//  Copyright © 2016年 zhai. All rights reserved.
//

#import "BINWaterFlowLayout.h"

/**
 默认多少列
 */
static const NSInteger defaultColumnCount = 3 ;
/**
 每列之间的间距
 */
static const CGFloat defaultColumnMargin = 10;
/**
 每行之间的间距
 */
static const CGFloat defaultRowMargin = 10;
/**
 上下左右间距
 */
static const UIEdgeInsets defaultEdgInsets = {10, 10, 10, 10};
@interface BINWaterFlowLayout ()
//存放所有cell的布局属性
@property (nonatomic, strong) NSMutableArray *attrsArr;
//存放所有列的最大高度
@property (nonatomic, strong) NSMutableArray *columnHeights;


- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (CGFloat)columnCount;
- (UIEdgeInsets)edgInsets;

@end

@implementation BINWaterFlowLayout

- (NSMutableArray *)attrsArr{
    if (!_attrsArr) {
        _attrsArr = [NSMutableArray array];
    }
    return _attrsArr;
}

- (NSMutableArray *)columnHeights{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}
#pragma mark----常见数据处理
- (CGFloat)rowMargin{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterFlowLayout:)]) {
        return [self.delegate rowMarginInWaterFlowLayout:self];
    }else{
        return defaultRowMargin;
    }
}
- (CGFloat)columnMargin{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterFlowLayout:)]) {
        return [self.delegate columnMarginInWaterFlowLayout:self];
    }else{
        return defaultColumnMargin;
    }
}
- (CGFloat)columnCount{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterFlowLayout:)]) {
        return [self.delegate columnCountInWaterFlowLayout:self];
    }else{
        return defaultColumnCount;
    }
}
- (UIEdgeInsets)edgInsets{
    if ([self.delegate respondsToSelector:@selector(edgeInWaterFlowLayout:)]) {
        return [self.delegate edgeInWaterFlowLayout:self];
    }else{
        return defaultEdgInsets;
    }
}
/**
 初始化
 */
- (void)prepareLayout{
    
    //清除以前计算的所有高度
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.edgInsets.top)];
    }
    
    //清除之前所有的布局属性
    [self.attrsArr removeAllObjects];
    [self arrayWithAttributes];
}
/**
 决定cell的排列
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrsArr;
}
/**
 返回indePath位置cell的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //创建布局属性
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //宽度
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    
    CGFloat w = (collectionViewW - self.edgInsets.left - self.edgInsets.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
    CGFloat h = [self.delegate waterFlowLayout:self heightForItemAtIndex:indexPath.row itemWidth:w];
    
    //找出所有列的最小Y值
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    
    for (NSInteger i = 1; i < self.columnCount; i++) {
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (columnHeight < minColumnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat x = self.edgInsets.left + destColumn * (w + self.columnMargin);
    
    CGFloat y = minColumnHeight;
    if (y != self.edgInsets.top) {
        y += self.rowMargin;
    }
    
    //设置布局属性的frame
    attr.frame = CGRectMake(x, y, w, h);
    
    //更新最短的Y值
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attr.frame));
    
    return attr;
}
/**
 返回view的contentSize
 */
- (CGSize)collectionViewContentSize{
    
    NSInteger destColumn = 0;
    CGFloat maxColumnHeight = [self.columnHeights[0] doubleValue];
    
    for (NSInteger i = 1; i < self.columnCount; i++) {
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (columnHeight > maxColumnHeight) {
            maxColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    return CGSizeMake(0, maxColumnHeight + self.edgInsets.bottom);
}
/**
 存放所有cell的布局属性
 */
- (NSArray *)arrayWithAttributes{
    //创建每一个cell对应的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [self.attrsArr addObject:attr];
    }
    return self.attrsArr;
}



@end
