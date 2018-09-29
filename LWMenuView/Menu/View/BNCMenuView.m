//
//  BNCMenuView.m
//  menuView
//
//  Created by linwei on 2017/10/26.
//  Copyright © 2017年 linwei. All rights reserved.
//

#import "BNCMenuView.h"
#import "BNCMenuSubviewCollectionViewCell.h"

#define __PAGEHEIGHT 20

@interface BNCMenuView ()<UICollectionViewDelegate,UICollectionViewDataSource,BNCMenuSubviewCollectionViewCellDelegate,UIGestureRecognizerDelegate>{
    NSInteger _lineNum;
    NSInteger _rowNum;
    BOOL _showClose;
}
@property(nonatomic,strong)NSArray *dataSource;
@end


@implementation BNCMenuView
- (UIButton *)backView{
    if (_backView == nil) {
        _backView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backView setFrame:self.bounds];
        [_backView addTarget:self action:@selector(defaultTopTap:) forControlEvents:UIControlEventTouchUpInside];
        _backView.backgroundColor=[UIColor clearColor];
    }
    return _backView;
}
- (UIView *)mainMenuView{
    if (_mainMenuView == nil ) {
        CGFloat width = self.frame.size.width;
        CGFloat height = width /_rowNum*_lineNum+ __PAGEHEIGHT;
        if (_showClose) {
            height += self.closeButton.frame.size.height;
        }
        _mainMenuView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - height, width, height)];
        _mainMenuView.backgroundColor = [UIColor clearColor];
    }
    return  _mainMenuView;
}
- (UIButton *)closeButton{
    if (_closeButton == nil) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setFrame:CGRectMake(self.mainMenuView.frame.size.width -50, 0, 40, 40)];
        _closeButton.hidden = !_showClose;
    }
    return _closeButton;
    
}
- (UICollectionView *)mainCollectionView{
    if (_mainCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(self.mainMenuView.bounds.size.width, self.mainMenuView.bounds.size.height-__PAGEHEIGHT);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat originY = 0;
        if (_showClose) {
            originY = CGRectGetMaxY(self.closeButton.frame);
        }
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,originY , self.mainMenuView.bounds.size.width, self.mainMenuView.bounds.size.height - __PAGEHEIGHT) collectionViewLayout:layout];
        _mainCollectionView.backgroundColor = [UIColor clearColor];
        _mainCollectionView.bounces = NO;
        _mainCollectionView.showsHorizontalScrollIndicator = NO;
        _mainCollectionView.pagingEnabled = YES;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.delegate = self;
        [_mainCollectionView registerClass:[BNCMenuSubviewCollectionViewCell class] forCellWithReuseIdentifier:@"CELLID"];
    }
    return _mainCollectionView;
}
-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.mainMenuView.frame.size.height - __PAGEHEIGHT, self.mainMenuView.frame.size.width, __PAGEHEIGHT)];
        _pageControl.currentPage = 0; //当前页
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.defersCurrentPageDisplay = YES;
        _pageControl.backgroundColor = [UIColor clearColor];
        [_pageControl addTarget:self action:@selector(pageChaged:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}
- (id)initWithFrame:(CGRect)frame  showCloseButton:(BOOL )isShow lineNum:(NSInteger )lineNum rowNum:(NSInteger)rowNum{
    self = [super initWithFrame:frame];
    if (self) {
        _lineNum = lineNum;
        _rowNum = rowNum;
        _showClose = isShow;
        [self loadSubviews];
    }
    return self;
}

- (void)loadSubviews{
    [self addSubview:self.backView];
    [self addSubview:self.mainMenuView];
    [self.mainMenuView addSubview:self.closeButton];
    [self.mainMenuView addSubview:self.mainCollectionView];
    [self.mainMenuView bringSubviewToFront:self.mainCollectionView];
    [self.mainMenuView addSubview:self.pageControl];
}
- (void)reloadMenuData:(NSArray *)array{
    //解析数据
    NSMutableArray *menuArr = [[NSMutableArray alloc]init];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i=0; i<array.count; i++) {
        [tempArray addObject:array[i]];
        if ((i+1)%(_rowNum*_lineNum) == 0 || (i+1 == array.count)) {
            NSArray *tempNewArray = [[NSArray alloc]initWithArray:tempArray];
            [menuArr addObject:tempNewArray];
            [tempArray removeAllObjects];
        }
    }
    self.dataSource = menuArr;
    _pageControl.numberOfPages = self.dataSource.count;
    [self.mainCollectionView reloadData] ;
}
- (void)closeButtonAction:(UIButton *)sender{
    if(self.delegate &&[self.delegate respondsToSelector:@selector(closeButtonActionAndBlankTapAction: andMenuView:)]){
        [self.delegate closeButtonActionAndBlankTapAction:sender andMenuView:self];
    }
}
-(void)defaultTopTap:(UIButton *)sender{
    if(self.delegate &&[self.delegate respondsToSelector:@selector(closeButtonActionAndBlankTapAction: andMenuView:)]){
        [self.delegate closeButtonActionAndBlankTapAction:sender andMenuView:self];
    }
}
#pragma mark - 点击小点点(UIPageControl)调整scrollView的contentOffset
-(void)pageChaged:(UIPageControl *)pageControl{
    [UIView animateWithDuration:0.3 animations:^{
        self->_mainCollectionView.contentOffset = CGPointMake(self->_mainCollectionView.bounds.size.width * pageControl.currentPage, 0);
    }];
}
#pragma mark -UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSArray *array = self.dataSource[indexPath.item];
    BNCMenuSubviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELLID" forIndexPath:indexPath];
    cell.delegate = self;
    [cell reloadData:array andLineNum:_lineNum andRowNum:_rowNum];
    return cell;
}
#pragma mark - 视图在滚动过程中时刻调用的方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint currentPoint = scrollView.contentOffset;
    float i = currentPoint.x/self.mainCollectionView.bounds.size.width;
    int j = i;
    if ((i - (float)j) > 0.5) {
        _pageControl.currentPage =j+1;
    }else if((i - (float)j) < 0.5){
        _pageControl.currentPage =j;
    }
}
#pragma mark - BNCMenuSubviewCollectionViewCell
- (void)overflowUpMenuModel:(BNCMenuModel *)model andTouchView:(BNCTouchView *)touchView{
    if(self.delegate &&[self.delegate respondsToSelector:@selector(overflowUpMenuModel: andMenuView: andTouchView:)]){
        [self.delegate overflowUpMenuModel:model andMenuView:self andTouchView:touchView];
    }
}
- (void)didSelectItemMenuModel:(BNCMenuModel *)model{
    if(self.delegate &&[self.delegate respondsToSelector:@selector(didSelectItemMenuModel: andMenuView:)]){
        [self.delegate didSelectItemMenuModel:model andMenuView:self];
    }
}

@end
