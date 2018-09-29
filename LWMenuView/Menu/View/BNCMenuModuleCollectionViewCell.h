//
//  BNCMenuModuleCollectionViewCell.h
//  menuView
//
//  Created by linwei on 2017/10/26.
//  Copyright © 2017年 linwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNCTouchView.h"
#import "BNCMenuModel.h"

@protocol BNCMenuModuleCollectionViewCellDelegate <NSObject>
@optional
-(BOOL)overflowUp:(BNCTouchView *)touchView menuModel:(BNCMenuModel *)model;
@end

@interface BNCMenuModuleCollectionViewCell : UICollectionViewCell
@property(nonatomic,weak) id <BNCMenuModuleCollectionViewCellDelegate> delegate;
- (void)configCellWithBNCMenuModel:(BNCMenuModel *)model;
@end
