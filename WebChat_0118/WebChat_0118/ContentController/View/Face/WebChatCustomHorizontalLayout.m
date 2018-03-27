//
//  WebChatCustomHorizontalLayout.m
//  WebChat
//
//  Created by Jack on 2018/2/6.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "WebChatCustomHorizontalLayout.h"
@interface WebChatCustomHorizontalLayout () <UICollectionViewDelegateFlowLayout>
{
    //一页显示多少行
    NSUInteger     _rowCount;
    //一行中 cell 的个数
    NSUInteger     _itemCountPerRow;
    //item 个数
    NSMutableArray *itemAttributes;
}
@end
@implementation WebChatCustomHorizontalLayout
-(instancetype)initWithitemCountPerRow:(NSInteger)itemCountPerRow AndrowCount:(NSInteger)rowCount{
    
    self =[super init];
    if (self) {
        _rowCount        = rowCount;
        _itemCountPerRow = itemCountPerRow;
    }
    return self;
}
- (void)prepareLayout
{
    [super prepareLayout];
    
    itemAttributes = [[NSMutableArray alloc]init];
    
    NSInteger sections = [self.collectionView numberOfSections];
    for (int i = 0; i < sections; i++)
    {
        NSMutableArray * tmpArray = [[NSMutableArray alloc]init];
        NSUInteger count = [self.collectionView numberOfItemsInSection:i];
        
        for (NSUInteger j = 0; j<count; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [tmpArray addObject:attributes];
        }
        
        [itemAttributes addObject:tmpArray];
    }
}
- (CGSize)collectionViewContentSize
{
    return [super collectionViewContentSize];
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger item = indexPath.item;
    NSUInteger x;
    NSUInteger y;
    [self targetPositionWithItem:item resultX:&x resultY:&y];
    NSUInteger item2 = [self originItemAtX:x y:y];
    NSIndexPath *theNewIndexPath = [NSIndexPath indexPathForItem:item2 inSection:indexPath.section];
    
    UICollectionViewLayoutAttributes *theNewAttr = [super layoutAttributesForItemAtIndexPath:theNewIndexPath];
    theNewAttr.indexPath = indexPath;
    return theNewAttr;
}
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    NSMutableArray *tmp = [NSMutableArray array];
    
    for (UICollectionViewLayoutAttributes *attr in attributes) {
        for (NSMutableArray *attributes in itemAttributes)
        {
            for (UICollectionViewLayoutAttributes *attr2 in attributes) {
                if (attr.indexPath.item == attr2.indexPath.item) {
                    [tmp addObject:attr2];
                    break;
                }
            }
        }
    }
    return tmp;
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
// 根据 item 计算目标item的位置
// x 横向偏移  y 竖向偏移
- (void)targetPositionWithItem:(NSUInteger)item
                       resultX:(NSUInteger *)x
                       resultY:(NSUInteger *)y
{
    NSUInteger page = item/(_itemCountPerRow * _rowCount);
    
    NSUInteger theX = item % _itemCountPerRow + page * _itemCountPerRow;
    NSUInteger theY = item / _itemCountPerRow - page * _rowCount;
    if (x != NULL) {
        *x = theX;
    }
    if (y != NULL) {
        *y = theY;
    }
}
// 根据偏移量计算item
- (NSUInteger)originItemAtX:(NSUInteger)x
                          y:(NSUInteger)y
{
    NSUInteger item = x * _rowCount + y;
    return item;
}
@end
