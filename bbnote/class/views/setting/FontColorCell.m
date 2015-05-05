//
//  FontColorCell.m
//  bbnote
//
//  Created by bob on 7/5/13.
//  Copyright (c) 2013 bob. All rights reserved.
//

#import "FontColorCell.h"
#import "Constant.h"    
#import "BBSkin.h"
#import "DataModel.h"
#import "DataManager.h"
#import "NSString+Help.h"

@implementation FontColorCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        arrayColors_ = [NSMutableArray arrayWithCapacity:24];
        NSDictionary *dic = [DataModel getColorsTable];
        for (int i = 24; i > 0; i--) {
            NSString *strcolor = [dic objectForKey:[NSString stringWithFormat:@"color%d", i]];
            [arrayColors_ addObject:strcolor];
        }
       
        selctView_ = [[SelectView alloc] initWithFrame:CGRectMake(20, 15, SCR_WIDTH - 40, 200) withColors:arrayColors_ cloumn:6];
        selctView_.selectDelegate = self;
        [self addSubview:selctView_];
        [self selectDefaultColor];
    }
    return self;
}


- (void)selectDefaultColor
{
    NSString *strColor = [[DataManager ShareInstance] noteSetting].strTextColor;
    for (int i = 0; i < arrayColors_.count; i++) {
        NSString *str = [arrayColors_ objectAtIndex:i];
        if([strColor isEqualToString:str])
        {
            [selctView_  didSelectAColor:i];
            break;
        }
    }
}
#pragma mark ---- SelectImageDelegate

- (void)didSelectAColor:(int )ivalue
{
    NSString *strClor = [arrayColors_ objectAtIndex:ivalue];
    [[DataManager ShareInstance] noteSetting].strTextColor = strClor;
    [[NSNotificationCenter defaultCenter] postNotificationName:kFontCellDidSelectedAColor object:nil userInfo:nil];
}

@end

@implementation FontBGColorCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        arrayColors_ = [NSMutableArray arrayWithCapacity:24];
        NSDictionary *dic = [DataModel getColorsTable];
        for (int i = 24; i > 0; i--) {
            NSString *strcolor = [dic objectForKey:[NSString stringWithFormat:@"color%d", i]];
            [arrayColors_ addObject:strcolor];
        }
        
        selctView_ = [[SelectView alloc] initWithFrame:CGRectMake(20, 15, SCR_WIDTH - 40, 200) withColors:arrayColors_ cloumn:6];
        selctView_.selectDelegate = self;
        [self addSubview:selctView_];
        [self selectDefaultColor];
    }
    return self;
}


- (void)selectDefaultColor
{
    NSString *strColor = [[DataManager ShareInstance] noteSetting].strBgColor;
    for (int i = 0; i < arrayColors_.count; i++) {
        NSString *str = [arrayColors_ objectAtIndex:i];
        if([strColor isEqualToString:str])
        {
            [selctView_  didSelectAColor:i];
            break;
        }
    }
}
#pragma mark ---- SelectImageDelegate

- (void)didSelectAColor:(int )ivalue
{
    NSString *strClor = [arrayColors_ objectAtIndex:ivalue];
    [[DataManager ShareInstance] noteSetting].strBgColor = strClor;
    [[NSNotificationCenter defaultCenter] postNotificationName:kFontCellDidSelectedAColor object:nil userInfo:nil];
}

@end
