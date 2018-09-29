//
//  BNCMenuSubviewCollectionViewCell.m
//  menuView
//
//  Created by linwei on 2017/10/26.
//  Copyright © 2017年 linwei. All rights reserved.
//

#import "BNCMenuSubviewCollectionViewCell.h"
#import "BNCMenuModuleCollectionViewCell.h"
#import "BNCMenuModel.h"

#define __GAPHEIGHT 15
@interface BNCMenuSubviewCollectionViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,BNCMenuModuleCollectionViewCellDelegate>

@property(nonatomic,strong)UICollectionView *mainCollectionView;
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,strong)UICollectionViewFlowLayout *mainCollectionLayout;
@end

@implementation BNCMenuSubviewCollectionViewCell
- (UICollectionViewFlowLayout *)mainCollectionLayout{
    if (_mainCollectionLayout == nil) {
         _mainCollectionLayout = [[UICollectionViewFlowLayout alloc]init];
        _mainCollectionLayout.sectionInset = UIEdgeInsetsMake(__GAPHEIGHT, __GAPHEIGHT, 0, __GAPHEIGHT);
        _mainCollectionLayout.minimumLineSpacing = __GAPHEIGHT;
        _mainCollectionLayout.minimumInteritemSpacing = __GAPHEIGHT;
        _mainCollectionLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    }
    return _mainCollectionLayout;
}
- (UICollectionView *)mainCollectionView{
    if (_mainCollectionView == nil) {
                _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) collectionViewLayout:self.mainCollectionLayout];
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        _mainCollectionView.bounces = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        _mainCollectionView.pagingEnabled = YES;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.delegate = self;
        [_mainCollectionView registerClass:[BNCMenuModuleCollectionViewCell class]
                forCellWithReuseIdentifier:@"SUBVIEW"];
    }
    return _mainCollectionView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubviews];
    }
    return self;
}
- (void)loadSubviews{
    [self addSubview:self.mainCollectionView];
}
- (void)reloadData:(NSArray *)array andLineNum:(NSInteger)lineNum andRowNum:(NSInteger)rowNum{
    NSInteger itemHeight = (self.bounds.size.width -__GAPHEIGHT*(rowNum +1) )/rowNum;
    self.mainCollectionLayout.itemSize = CGSizeMake(itemHeight, itemHeight);
    self.dataSource = array;
    [self.mainCollectionView reloadData];
}
#pragma mark -UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    BNCMenuModel *model = self.dataSource[indexPath.item];
    BNCMenuModuleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SUBVIEW" forIndexPath:indexPath];
    cell.delegate = self;
    [cell configCellWithBNCMenuModel:model];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item >= self.dataSource.count) {
        return;
    }
    BNCMenuModel *model = self.dataSource[indexPath.item];
    if(self.delegate &&[self.delegate respondsToSelector:@selector(didSelectItemMenuModel:)]){
        [self.delegate didSelectItemMenuModel:model];
    }
}
#pragma mark - BNCMenuModuleCollectionViewCellDelegate
-(BOOL)overflowUp:(BNCTouchView *)touchView menuModel:(BNCMenuModel *)model{
    UIWindow *keyWindow =  [UIApplication sharedApplication].keyWindow;
    CGRect mainRect = [self.superview convertRect:self.frame toView:keyWindow];
    CGRect touchViewRect = [touchView.superview convertRect:touchView.frame toView:keyWindow];
    if (mainRect.origin.y >touchViewRect.origin.y+touchViewRect.size.height) {
        if(self.delegate &&[self.delegate respondsToSelector:@selector(overflowUpMenuModel: andTouchView:)]){
            [self.delegate overflowUpMenuModel:model andTouchView:touchView];
        }
        return YES;
    }
    return NO;
}
@end
