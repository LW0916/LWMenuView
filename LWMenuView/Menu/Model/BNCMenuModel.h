//
//  BNCMenuModel.h
//  menuView
//
//  Created by linwei on 2017/10/26.
//  Copyright © 2017年 linwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNCMenuModel : NSObject
@property(nonatomic,copy)NSString *itemId;
@property(nonatomic,copy)NSString *imageUrl;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *badgeNum;
@property(nonatomic,strong)UIImage *placeholderImage;
@property(nonatomic,assign)BOOL isDrag;
+ (instancetype)customModelWithDictionary:(NSDictionary*)dict;
@end
