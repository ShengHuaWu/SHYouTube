//
//  SHYouTube.h
//  SHYouTube
//
//  Created by ShengHuaWu on 2014/4/4.
//  Copyright (c) 2014年 ShengHuaWu. All rights reserved.
//

/**
 *  This class contains the YouTube informations from a YouTube url.
 *  You can get the thumbnail and vidoe url from this class.
 */

#import <Foundation/Foundation.h>

@class SHYouTube;

typedef NS_ENUM(NSInteger, SHYouTubeThumbnailSize) {
    SHYouTubeThumbnailSizeUnknow = -1,
    SHYouTubeThumbnailSizeDefault = 0,
    SHYouTubeThumbnailSizeDefaultMedium,
    SHYouTubeThumbnailSizeDefaultHighQuality,
    SHYouTubeThumbnailSizeDefaultMaxQuality
};

typedef void (^SHYouTubeCompletion) (SHYouTube *youTube);
typedef void (^SHYouTubeFailure) (NSError *error);

@interface SHYouTube : NSObject
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *mediumURLPath;
@property (nonatomic, strong) NSString *hd720URLPath;

/**
 *  @brief Create an instance of this class. Fetch the video informations and parse the informations. The completion and failure block are called in the main thread.
 *
 *  @param youTubeURL The YouTube url that you want to fetch the video informations
 *  @param completion Return an instance of this class
 *  @param failure    Return an internet error
 */
+ (void)youtubeInBackgroundWithYouTubeURL:(NSURL *)youTubeURL completion:(SHYouTubeCompletion)completion andFailure:(SHYouTubeFailure)failure;

/**
 *  @brief This method is the designated initializer. It will create the YouTube identifier from the YouTube url.
 *
 *  @param youTubeURL The YouTube url
 *
 *  @return The instance of this class
 */
- (instancetype)initWithYouTubeURL:(NSURL *)youTubeURL;

/**
 *  @brief Get the thumbnail url path with a particular size. Combine with the method of SHYouTubeService to download the thumbnail.
 *
 *  @param size The size of the thumbnail that you want to get
 *
 *  @return The thumbnail path
 */
- (NSString *)thumbnailURLPathWithSize:(SHYouTubeThumbnailSize)size;

/**
 *  @brief Parse the video informations. It will set the medium and hd 720 url path.
 *
 *  @param data The video informations data
 */
- (void)parseVideoInfo:(NSData *)data;
@end
