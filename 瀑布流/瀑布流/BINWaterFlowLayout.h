//
//  BINWaterFlowLayout.h
//  瀑布流
//
//  Created by 梦想 on 2016/12/3.
//  Copyright © 2016年 zhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BINWaterFlowLayout;
@protocol BINWaterFlowLayoutDelegate <NSObject>

@required
- (CGFloat)waterFlowLayout:(BINWaterFlowLayout *)layout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)width;

@optional
- (CGFloat)columnCountInWaterFlowLayout:(BINWaterFlowLayout *)layout;
- (CGFloat)columnMarginInWaterFlowLayout:(BINWaterFlowLayout *)layout;
- (CGFloat)rowMarginInWaterFlowLayout:(BINWaterFlowLayout *)layout;
- (UIEdgeInsets)edgeInWaterFlowLayout:(BINWaterFlowLayout *)layout;

@end

@interface BINWaterFlowLayout : UICollectionViewLayout

@property (nonatomic, weak)id<BINWaterFlowLayoutDelegate> delegate;

@end
