//
//  BNCTouchView.m
//  menuView
//
//  Created by linwei on 2017/10/27.
//  Copyright © 2017年 linwei. All rights reserved.
//

#import "BNCTouchView.h"
#import "UIImageView+WebCache.h"

#define TITLTHEIGHT 30
#define BADGEHEIGHT 12
@interface BNCTouchView(){
    CGRect _originalRect;
}

@end

@implementation BNCTouchView
-(float)getTextSizeWithInOrOut:(BOOL)inOrOut{
    if (inOrOut) {
        return 15.0;
    }else{
        return 12.0;
    }
}
- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(TITLTHEIGHT/2, 0, CGRectGetWidth(self.frame)- TITLTHEIGHT, CGRectGetHeight(self.frame)- TITLTHEIGHT)];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}
- (UILabel *)titleLable{
    if (_titleLable == nil) {
        _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)- TITLTHEIGHT , CGRectGetWidth(self.frame), TITLTHEIGHT)];
        _titleLable.font =  [UIFont systemFontOfSize:[self getTextSizeWithInOrOut:NO]];
        _titleLable.textColor = [UIColor whiteColor];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.adjustsFontSizeToFitWidth = YES;
        _titleLable.numberOfLines = 0;
    }
    return _titleLable;
}
- (UILabel *)badgeLabel{
    if (_badgeLabel == nil) {
        _badgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, BADGEHEIGHT, BADGEHEIGHT)];
        CGRect imageRect = self.imageView.frame;
        _badgeLabel.center = CGPointMake(CGRectGetMidX(imageRect) + CGRectGetWidth(self.imageView.frame)/3,BADGEHEIGHT/2);
        _badgeLabel.layer.cornerRadius = BADGEHEIGHT/2;
        _badgeLabel.clipsToBounds = YES;
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_badgeLabel setBackgroundColor:[UIColor redColor]];
        [_badgeLabel setFont:[UIFont systemFontOfSize:11]];

    }
    return _badgeLabel;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _originalRect = frame;
        [self loadSubviews];
    }
    return self;
}
- (void)loadSubviews{
    [self addSubview:self.imageView];
    [self addSubview:self.titleLable];
    [self addSubview:self.badgeLabel];
}
- (void)layoutSubviews{
    [self.imageView setFrame:CGRectMake(TITLTHEIGHT/2, 0, CGRectGetWidth(self.frame)- TITLTHEIGHT, CGRectGetHeight(self.frame)- TITLTHEIGHT)];
    [self.titleLable setFrame:CGRectMake(0, CGRectGetHeight(self.frame)- TITLTHEIGHT , CGRectGetWidth(self.frame), TITLTHEIGHT)];
    CGRect imageRect = self.imageView.frame;
    self.badgeLabel.center = CGPointMake(CGRectGetMidX(imageRect) + CGRectGetWidth(self.imageView.frame)/3,BADGEHEIGHT/2 );

}
- (void)configTouchViewWithBNCMenuModel:(BNCMenuModel *)model{
    self.titleLable.text = model.title;
    [self.imageView  sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:model.placeholderImage];
    if ([model.badgeNum isEqualToString:@"0"] || model.badgeNum.length == 0) {
        self.badgeLabel.hidden = YES;
    }else{
        self.badgeLabel.hidden = NO;
        self.badgeLabel.text = model.badgeNum;
        CGRect tempRect = self.badgeLabel.frame;
        CGSize numberSize = [model.badgeNum sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
        numberSize.width = numberSize.width +5;
        (numberSize.width > BADGEHEIGHT) ? (tempRect.size.width = numberSize.width):(tempRect.size.width = BADGEHEIGHT);
        self.badgeLabel.frame = tempRect;
    }
}
-(void)inOrOutTouching:(BOOL)inOrOut animate:(BOOL )animate{
    CGAffineTransform newT=CGAffineTransformMakeScale(1.1, 1.1);
    CGAffineTransform reverseT=CGAffineTransformInvert(newT);
    static BOOL aninimated=NO;
    if (inOrOut&&!aninimated) {
        if (!animate) {
            self.transform=CGAffineTransformConcat(self.transform, newT);
//            self.alpha = 0.7;
            self.titleLable.font =  [UIFont systemFontOfSize:[self getTextSizeWithInOrOut:YES]];
            aninimated=YES;
        }
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.transform=CGAffineTransformConcat(self.transform, newT);
//            self.alpha = 0.7;
            self.titleLable.font =  [UIFont systemFontOfSize:[self getTextSizeWithInOrOut:YES]];
            aninimated=YES;
        } completion:nil];
    }else if(!inOrOut&&aninimated) {
        if (!animate) {
            self.transform=CGAffineTransformConcat(self.transform, reverseT);
            self.alpha = 1.0;
            self.titleLable.font =  [UIFont systemFontOfSize:[self getTextSizeWithInOrOut:NO]];
            aninimated=NO;
            return;
        }
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.transform=CGAffineTransformConcat(self.transform, reverseT);
            self.alpha = 1.0;
            self.titleLable.font =  [UIFont systemFontOfSize:[self getTextSizeWithInOrOut:NO]];
            aninimated=NO;
        } completion:nil];
    }
}


@end
