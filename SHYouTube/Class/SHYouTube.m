//
//  SHYouTube.m
//  SHYouTube
//
//  Created by ShengHuaWu on 2014/4/4.
//  Copyright (c) 2014年 ShengHuaWu. All rights reserved.
//

#import "SHYouTube.h"
#import "NSString+SHYouTubeHelper.h"

@implementation SHYouTube

#pragma mark - Designated initializer
- (instancetype)initWithYouTubeURL:(NSURL *)youTubeURL
{
    self = [super init];
    if (self) {
        // Create the identifier
        NSRange range = [[youTubeURL absoluteString] rangeOfString:@"www.youtube.com/embed"];
        if (range.location != NSNotFound) {
            _identifier = [[youTubeURL pathComponents] lastObject];
        } else {
            NSDictionary *youTubeDict = [[youTubeURL query] dictionaryFromQueryString];
            _identifier = youTubeDict[@"v"];
        }
    }
    
    return self;
}

#pragma mark - Public method
- (NSString *)thumbnailURLPathWithSize:(SHYouTubeThumbnailSize)size
{
    // Determine the thumbnail size
    NSString *thumbnailSizeString = nil;
    switch (size) {
        case SHYouTubeThumbnailSizeDefault:
            thumbnailSizeString = @"default";
            break;
        case SHYouTubeThumbnailSizeDefaultMedium:
            thumbnailSizeString = @"mqdefault";
            break;
        case SHYouTubeThumbnailSizeDefaultHighQuality:
            thumbnailSizeString = @"hqdefault";
            break;
        case SHYouTubeThumbnailSizeDefaultMaxQuality:
            thumbnailSizeString = @"maxresdefault";
            break;
        default:
            thumbnailSizeString = @"default";
            break;
    }
    return [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/%@.jpg", self.identifier, thumbnailSizeString];
}

#pragma mark - Synchronous method
- (UIImage *)thumbnailWithSize:(SHYouTubeThumbnailSize)size andError:(NSError *__autoreleasing *)error
{
    if (![self.identifier length]) {
        *error = [NSError errorWithDomain:@"SHYouTubeErrorDomain" code:0 userInfo:@{NSLocalizedDescriptionKey: @"Youtube identifier is nil"}];
        return nil;
    }
    // Determine the thumbnail size
    NSString *thumbnailSizeString = nil;
    switch (size) {
        case SHYouTubeThumbnailSizeDefault:
            thumbnailSizeString = @"default";
            break;
        case SHYouTubeThumbnailSizeDefaultMedium:
            thumbnailSizeString = @"mqdefault";
            break;
        case SHYouTubeThumbnailSizeDefaultHighQuality:
            thumbnailSizeString = @"hqdefault";
            break;
        case SHYouTubeThumbnailSizeDefaultMaxQuality:
            thumbnailSizeString = @"maxresdefault";
            break;
        default:
            thumbnailSizeString = @"default";
            break;
    }
    // Create a HTTP GET request
    NSString *urlString = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/%@.jpg", self.identifier, thumbnailSizeString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.79 Safari/537.4" forHTTPHeaderField:@"User-Agent"];
    // Send request synchronously
    NSError *err = nil;
    NSData *resposeData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    if (err) {
        *error = err;
        return nil;
    } else {
        return [UIImage imageWithData:resposeData];
    }
}

@end
