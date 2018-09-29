//
//  BNCMenuSubviewCollectionViewCell.h
//  menuView
//
//  Created by linwei on 2017/10/26.
//  Copyright © 2017年 linwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNCMenuModel.h"
@class BNCTouchView;
@protocol BNCMenuSubviewCollectionViewCellDelegate <NSObject>
@optional
//item超过整个菜单背景的位置
- (void)overflowUpMenuModel:(BNCMenuModel *)model andTouchView:(BNCTouchView *)touchView;
- (void)didSelectItemMenuModel:(BNCMenuModel *)model;
@end

@interface BNCMenuSubviewCollectionViewCell : UICollectionViewCell
@property(nonatomic,weak) id <BNCMenuSubviewCollectionViewCellDelegate> delegate;
- (void)reloadData:(NSArray *)array andLineNum:(NSInteger)lineNum andRowNum:(NSInteger)rowNum;
@end
