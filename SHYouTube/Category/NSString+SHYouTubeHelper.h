//
//  NSString+SHYouTubeHelper.h
//  SHYouTube
//
//  Created by ShengHuaWu on 2014/4/4.
//  Copyright (c) 2014年 ShengHuaWu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SHYouTubeHelper)

/**
 *  @brief Convert the query string to the dictionary.
 *
 *  @return The dictionary with the query string key/value pair.
 */
- (NSDictionary *)dictionaryFromQueryString;
@end
