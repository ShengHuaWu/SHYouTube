//
//  SHYouTubeService.h
//  SHYouTube
//
//  Created by ShengHuaWu on 2014/4/4.
//  Copyright (c) 2014年 ShengHuaWu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SHYouTubeServiceCompletion) (NSData *responseData);
typedef void (^SHYouTubeServiceThumbnail) (UIImage *thumbnail);
typedef void (^SHYouTubeServiceFailure) (NSError *error);

@interface SHYouTubeService : NSObject
@property (nonatomic, strong, readonly) NSOperationQueue *operationQueue;

+ (instancetype)sharedInstance;

/**
 *  @brief Create a HTTP GET request and send it synchronously.
 *
 *  @param urlString  The url string
 *  @param header     It contains Content-Type, Accept, ...
 *  @param parameters It will be converted to a query string.
 *  @param error      The networking error
 *
 *  @return The respose data of the http GET request
 */
+ (NSData *)httpGetRequestWithURLString:(NSString *)urlString header:(NSDictionary *)header parameters:(NSDictionary *)parameters andError:(NSError **)error;

/**
 *  @brief Create a HTTP GET request and send it asynchronously. The completion block and the failure block are called in the main thread.
 *
 *  @param urlString  The url string
 *  @param header     It contains Content-Type, Accept, ...
 *  @param parameters It will be converted to a query string.
 *  @param completion Return the response data
 *  @param failure    Return an error
 */
+ (void)httpGetRequestInBackgroundWithURLString:(NSString *)urlString header:(NSDictionary *)header parameters:(NSDictionary *)parameters completion:(SHYouTubeServiceCompletion)completion andFailure:(SHYouTubeServiceFailure)failure;

/**
 *  @brief Download the thumbnail image from the url asynchronously. The completion block and the failure block are called in the main thread.
 *
 *  @param path       The path of the thumbnail url. You can get this path by call the method of SHYouTube
 *  @param completion Return the thumbnail image
 *  @param failure    Return an error
 */
- (void)downloadThumbnailInBackgroundWithURLPath:(NSString *)path completion:(SHYouTubeServiceThumbnail)completion andFailure:(SHYouTubeServiceFailure)failure;
@end
