//
//  NSURLRequest+SHYouTubeHelper.h
//  SHYouTube
//
//  Created by ShengHuaWu on 2014/4/4.
//  Copyright (c) 2014年 ShengHuaWu. All rights reserved.
//

/**
 * This category is used to create the HTTP request.
 */

#import <Foundation/Foundation.h>

@interface NSURLRequest (SHYouTubeHelper)

/**
 *  @brief This method is used to create a HTTP request.
 *
 *  @param method    The HTTP method of the request. It could be @"GET", @"POST", @"PUT", @"DELETE".
 *  @param urlString The url string of the request. It could append with the query string (http://...?...&...).
 *  @param header    The header of the request. It contains Content-Type, Accept, ...
 *  @param body      The HTTP body of the request. It could be a NSDictionary or a NSArray.
 *
 *  @return The instance of NSURLRequest
 */
+ (instancetype)requestWithHTTPMethod:(NSString *)method urlString:(NSString *)urlString header:(NSDictionary *)header andHTTPBody:(id)body;
@end
