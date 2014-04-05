# SHYouTube
This project is a rewrite version of [HCYouTubeParser](https://github.com/hellozimi/HCYoutubeParser).
Please read more informations in the header file.

## Usage
Asynchronously fetch the video urls and play the medium video.

		[SHYouTube youtubeInBackgroundWithYouTubeURL:url completion:^(SHYouTube *youTube) {
			NSURL *videoURL = [NSURL URLWithString:youTube.mediumURLPath];
        	MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    		[self presentViewController:player animated:YES completion:nil];
    	} andFailure:^(NSError *error) {
        	NSLog(@"[Debug] SHYouTube fetch info error: %@", [error localizedDescription]);
    	}];

Asynchronously download the thumbnail for a particular size .

		SHYouTubeService *service = [SHYouTubeService sharedInstance];
		NSString *thumbnailPath = [youTube thumbnailURLPathWithSize:SHYouTubeThumbnailSizeDefaultMedium];
        [service downloadThumbnailInBackgroundWithURLPath:thumbnailPath completion:^(UIImage *thumbnail) {
        	// Retrieve the thumbnail image here
        } andFailure:^(NSError *error) {
            NSLog(@"[Debug] SHYouTubeService download thumbnail error: %@", [error localizedDescription]);
        }];

## Future work
Probably, we can store the video at the temporary directory of the device.
Furthermore, we can set this class as a property of the _NSManagedObject_ subclass.