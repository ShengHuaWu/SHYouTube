//
//  SHYouTubeService.m
//  SHYouTube
//
//  Created by ShengHuaWu on 2014/4/4.
//  Copyright (c) 2014年 ShengHuaWu. All rights reserved.
//

#import "SHYouTubeService.h"
#import "NSURLRequest+SHYouTubeHelper.h"

@implementation SHYouTubeService

#pragma mark - Shared instance
+ (instancetype)sharedInstance
{
    static SHYouTubeService *sharedNetworking = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNetworking = [[self alloc] init];
    });
    return sharedNetworking;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 3;
    }
    return self;
}

#pragma mark - Synchronously method
+ (NSData *)httpGetRequestWithURLString:(NSString *)urlString header:(NSDictionary *)header parameters:(NSDictionary *)parameters andError:(NSError *__autoreleasing *)error
{
    NSURLRequest *request = [NSURLRequest requestWithHTTPMethod:@"GET" urlString:urlString header:header andHTTPBody:nil];
    
    NSError *err = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    if (err) {
        *error = err;
        NSLog(@"[Debug]Send GET request error. Error: %@", [err localizedDescription]);
        return nil;
    }
    
    return responseData;
}

#pragma mark - Asynchronously method
+ (void)httpGetRequestInBackgroundWithURLString:(NSString *)urlString header:(NSDictionary *)header parameters:(NSDictionary *)parameters completion:(SHYouTubeServiceCompletion)completion andFailure:(SHYouTubeServiceFailure)failure
{
    // Send the GET request in a background thread
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperationWithBlock:^{
        NSError *error = nil;
        NSData *responseData = [self httpGetRequestWithURLString:urlString header:header parameters:parameters andError:&error];
        // Back to the main thread
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (error) {
                if (failure) {
                    failure(error);
                }
            } else {
                if (completion) {
                    completion(responseData);
                }
            }
        }];
    }];
}

#pragma mark - Download
- (void)downloadThumbnailInBackgroundWithURLPath:(NSString *)path completion:(SHYouTubeServiceThumbnail)completion andFailure:(SHYouTubeServiceFailure)failure
{
    // If the operation queue is suspended or the path is nil, do not add download operaton.
    if (self.operationQueue.isSuspended || ![path length]) return;
    
    // Download the image data from the url path in background queue
    [self.operationQueue addOperationWithBlock:^{
        // Create a HTTP GET request
        NSURLRequest *request = [NSURLRequest requestWithHTTPMethod:@"GET" urlString:path header:@{@"User-Agent": @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.79 Safari/537.4"} andHTTPBody:nil];
        // Send request
        NSError *error = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        UIImage *thumbnail = [UIImage imageWithData:responseData];
        // Back to the main queue
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (error) {
                if (failure) {
                    failure(error);
                }
            } else {
                if (completion) {
                    completion(thumbnail);
                }
            }
        }];
    }];
}

@end
