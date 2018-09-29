//
//  BNCTouchView.h
//  menuView
//
//  Created by linwei on 2017/10/27.
//  Copyright © 2017年 linwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNCMenuModel.h"

@interface BNCTouchView : UIView

@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *titleLable;
@property(nonatomic,strong)UILabel *badgeLabel;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
- (void)inOrOutTouching:(BOOL)inOrOut animate:(BOOL )animate;
- (void)configTouchViewWithBNCMenuModel:(BNCMenuModel *)model;

@end
