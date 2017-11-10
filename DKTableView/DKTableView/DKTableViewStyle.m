//
//  DKTableViewStyle.m
//  DKTableView
//
//  Created by bill on 2017/11/9.
//  Copyright © 2017年 bill. All rights reserved.
//

#import "DKTableViewStyle.h"

@implementation DKTableViewStyle

+(instancetype)share{
    static dispatch_once_t onceToken;
    static DKTableViewStyle * style;
    dispatch_once(&onceToken, ^{
        style = [DKTableViewStyle new];
    });
    return style;
}


-(UIFont *)font{
    if (!_font) {
        _font = [UIFont systemFontOfSize:14];
    }
    return _font;
}


-(UIColor *)textColor{
    if (!_textColor) {
        _textColor = [UIColor colorWithRed:125/255.0 green:127/255.0 blue:127/255.0 alpha:1.0];
    }
    return _textColor;
}





@end
