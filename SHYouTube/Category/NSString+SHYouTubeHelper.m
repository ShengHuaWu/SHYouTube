//
//  NSString+SHYouTubeHelper.m
//  SHYouTube
//
//  Created by ShengHuaWu on 2014/4/4.
//  Copyright (c) 2014年 ShengHuaWu. All rights reserved.
//

#import "NSString+SHYouTubeHelper.h"

@implementation NSString (SHYouTubeHelper)

- (NSDictionary *)dictionaryFromQueryString
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSArray *components = [self componentsSeparatedByString:@"&"];
    for (NSString *pair in components) {
        NSArray *pairArray = [pair componentsSeparatedByString:@"="];
        if ([pairArray count] < 2) continue; // The value is null.
        
        NSString *key = [[pairArray firstObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *value = [[pairArray lastObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [parameters setObject:value forKey:key];
    }
    
    return parameters;
}

@end
