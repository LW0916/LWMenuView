//
//  BNCMenuModuleCollectionViewCell.m
//  menuView
//
//  Created by linwei on 2017/10/26.
//  Copyright © 2017年 linwei. All rights reserved.
//

#import "BNCMenuModuleCollectionViewCell.h"

@interface BNCMenuModuleCollectionViewCell(){
    CGPoint _oldCenter;
}
@property(nonatomic,strong)BNCTouchView *touchView;
@property(nonatomic,strong)BNCMenuModel *menumodel;
@property(nonatomic,strong)BNCTouchView *tempView;

@end

@implementation BNCMenuModuleCollectionViewCell
- (BNCTouchView *)touchView{
    if (_touchView == nil) {
        _touchView = [[BNCTouchView alloc]initWithFrame:self.bounds];
    }
    return _touchView;
}
- (BNCTouchView *)tempView{
    if (_tempView == nil) {
        _tempView = [[BNCTouchView alloc]init];
    }
    return _tempView;
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubviews];
    }
    return self;
}
- (void)loadSubviews{
    [self addSubview:self.touchView];
}
- (void)configCellWithBNCMenuModel:(BNCMenuModel *)model {
    self.menumodel = model;
    if (model.isDrag) {
        _touchView.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapAct:)];
        [_touchView addGestureRecognizer:_touchView.longPress];
    }
    [_touchView configTouchViewWithBNCMenuModel:model];
}

-(void)longTapAct:(UILongPressGestureRecognizer *)longPress{
    static CGPoint touchPoint;
    static CGFloat offsetX;
    static CGFloat offsetY;
    BNCTouchView *touchView = (BNCTouchView *)longPress.view;
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [self.tempView setFrame:touchView.frame];
        self.tempView.titleLable.text = touchView.titleLable.text;
        self.tempView.imageView.image = touchView.imageView.image;
        self.tempView.badgeLabel.text = touchView.badgeLabel.text;
        self.tempView.badgeLabel.hidden = touchView.badgeLabel.hidden;
        self.tempView.badgeLabel.frame = touchView.badgeLabel.frame;
        self.tempView.alpha = 0.3;
        [self addSubview: self.tempView];
        [[UIApplication sharedApplication].keyWindow  addSubview:touchView];
        [touchView  inOrOutTouching:YES animate:YES];
        _oldCenter = touchView.center;
        //这是为了计算手指在view上的偏移位置
        touchPoint = [longPress locationInView:self.tempView];
        CGPoint centerPoint = CGPointMake(self.tempView.frame.size.width/2, self.tempView.frame.size.height/2);
        offsetX = touchPoint.x - centerPoint.x;
        offsetY = touchPoint.y - centerPoint.y;
        CGPoint movePoint = [longPress locationInView:[UIApplication sharedApplication].keyWindow];
        touchView.center = CGPointMake(movePoint.x - offsetX, movePoint.y - offsetY);
    }else if(longPress.state == UIGestureRecognizerStateChanged){
        CGPoint movePoint = [longPress locationInView:[UIApplication sharedApplication].keyWindow];
        touchView.center = CGPointMake(movePoint.x - offsetX, movePoint.y - offsetY);
    }else if(longPress.state == UIGestureRecognizerStateEnded){
        BOOL isOver = NO;
        if(self.delegate &&[self.delegate respondsToSelector:@selector(overflowUp: menuModel:)]){
             isOver = [self.delegate overflowUp:touchView menuModel:self.menumodel];
        }
        if (isOver) {
            [UIView animateWithDuration:0.5 animations:^{
                touchView.alpha = 0.1;
            } completion:^(BOOL finished) {
                if (finished ) {
                    [self addSubview:touchView];
                    [touchView  inOrOutTouching:NO animate:NO];
                    touchView.center = _oldCenter;
                    [self.tempView removeFromSuperview];
                }
            }];
        }else{
            [self addSubview:touchView];
            [touchView  inOrOutTouching:NO animate:YES];
            touchView.center = _oldCenter;
            [self.tempView removeFromSuperview];
        }
    }else if(longPress.state == UIGestureRecognizerStateCancelled){
    }else if(longPress.state == UIGestureRecognizerStateFailed){
    }
}
@end
