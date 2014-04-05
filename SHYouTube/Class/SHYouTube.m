//
//  SHYouTube.m
//  SHYouTube
//
//  Created by ShengHuaWu on 2014/4/4.
//  Copyright (c) 2014年 ShengHuaWu. All rights reserved.
//

#import "SHYouTube.h"
#import "NSString+SHYouTubeHelper.h"
#import "SHYouTubeService.h"

@implementation SHYouTube

#pragma mark - Fetch YouTube
+ (void)youtubeInBackgroundWithYouTubeURL:(NSURL *)youTubeURL completion:(SHYouTubeCompletion)completion andFailure:(SHYouTubeFailure)failure
{
    // Create a YouTube object
    SHYouTube *youTube = [[SHYouTube alloc] initWithYouTubeURL:youTubeURL];
    // Send HTTP GET request synchronously
    NSString *urlString = [NSString stringWithFormat:@"http://www.youtube.com/get_video_info?video_id=%@", youTube.identifier];
    [SHYouTubeService httpGetRequestInBackgroundWithURLString:urlString header:@{@"User-Agent": @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.79 Safari/537.4"} parameters:nil completion:^(NSData *responseData) {
        // Parse info data in a background queue
        NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
        [operationQueue addOperationWithBlock:^{
            [youTube parseVideoInfo:responseData];
            // Back to the main queue
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (completion) completion(youTube);
            }];
        }];
    } andFailure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

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

#pragma mark - Thumbnail path
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

#pragma mark - Parse data
- (void)parseVideoInfo:(NSData *)data
{
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *parts = [responseString dictionaryFromQueryString];
    NSString *fmtStreamMapString = parts[@"url_encoded_fmt_stream_map"];
    NSArray *fmtStreamMapArray = [fmtStreamMapString componentsSeparatedByString:@","];
    for (NSString *videoEncodedString in fmtStreamMapArray) {
        NSDictionary *videoComponents = [videoEncodedString dictionaryFromQueryString];
        // Exclude the 3D video
        if (!videoComponents[@"stereo3d"]) {
            NSString *signature = videoComponents[@"itag"];
            NSString *type = [videoComponents[@"type"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSRange range = [type rangeOfString:@"mp4"];
            if (signature && range.location != NSNotFound) {
                NSString *urlString = [videoComponents[@"url"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                urlString = [NSString stringWithFormat:@"%@&signature=%@", urlString, signature];
                if ([videoComponents[@"quality"] isEqualToString:@"hd720"]) {
                    self.hd720URLPath = urlString;
                } else if ([videoComponents[@"quality"] isEqualToString:@"medium"]) {
                    self.mediumURLPath = urlString;
                }
            }
        }
    }
}

@end
