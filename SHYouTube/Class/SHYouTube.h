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

typedef NS_ENUM(NSInteger, SHYouTubeThumbnailSize) {
    SHYouTubeThumbnailSizeUnknow = -1,
    SHYouTubeThumbnailSizeDefault = 0,
    SHYouTubeThumbnailSizeDefaultMedium,
    SHYouTubeThumbnailSizeDefaultHighQuality,
    SHYouTubeThumbnailSizeDefaultMaxQuality
};

@interface SHYouTube : NSObject
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *mediumVideoURLPath;
@property (nonatomic, strong) NSString *localThumbnailPath;

/**
 *  @brief This method is the designated initializer. It will create the YouTube identifier from the YouTube url.
 *
 *  @param youTubeURL The YouTube url
 *
 *  @return The instance of this class
 */
- (instancetype)initWithYouTubeURL:(NSURL *)youTubeURL;

/**
 *  @brief Get the thumbnail url path with a particular size.
 *
 *  @param size The size of the thumbnail that you want to get
 *
 *  @return The thumbnail path
 */
- (NSString *)thumbnailURLPathWithSize:(SHYouTubeThumbnailSize)size;
@end
