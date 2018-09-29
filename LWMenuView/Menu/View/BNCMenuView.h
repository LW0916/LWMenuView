//
//  BNCMenuView.h
//  menuView
//
//  Created by linwei on 2017/10/26.
//  Copyright © 2017年 linwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNCMenuModel.h"

@class BNCMenuView,BNCTouchView;

@protocol BNCMenuViewDelegate <NSObject>
@optional
//item超过整个菜单回调
- (void)overflowUpMenuModel:(BNCMenuModel *)model andMenuView:(BNCMenuView *)menuView andTouchView:(BNCTouchView *)touchView;
//item点击回调
- (void)didSelectItemMenuModel:(BNCMenuModel *)model andMenuView:(BNCMenuView *)menuView;
//点击关闭按钮和空白处回调
- (void)closeButtonActionAndBlankTapAction:(UIButton *)sender andMenuView:(BNCMenuView *)menuView;

@end

@interface BNCMenuView : UIView
@property(nonatomic,strong)UIButton *backView;
@property(nonatomic,strong)UIView *mainMenuView;
@property(nonatomic,strong)UIButton *closeButton;
@property(nonatomic,strong)UICollectionView *mainCollectionView;
@property(nonatomic,strong)UIPageControl * pageControl;

@property(nonatomic,weak) id <BNCMenuViewDelegate> delegate;
//初始化数据
- (id)initWithFrame:(CGRect)frame  showCloseButton:(BOOL )isShow lineNum:(NSInteger )lineNum rowNum:(NSInteger)rowNum;
- (void)reloadMenuData:(NSArray *)array ;
@end
