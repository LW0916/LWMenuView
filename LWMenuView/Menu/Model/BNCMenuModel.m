//
//  BNCMenuModel.m
//  menuView
//
//  Created by linwei on 2017/10/26.
//  Copyright © 2017年 linwei. All rights reserved.
//

#import "BNCMenuModel.h"

@implementation BNCMenuModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)customModelWithDictionary:(NSDictionary *)dict
{
    return [[self alloc]initWithDictionary:dict];
}
@end
