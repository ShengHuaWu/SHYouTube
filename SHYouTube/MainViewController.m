//
//  MainViewController.m
//  SHYoutubeParser
//
//  Created by ShengHuaWu on 2014/4/3.
//  Copyright (c) 2014年 ShengHuaWu. All rights reserved.
//

#import "MainViewController.h"
#import "SHYouTube.h"
#import "SHYouTubeService.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MainViewController ()
@property (nonatomic, weak) UIButton *playVideoButton;
@property (nonatomic, strong) NSString *videoString;
@property (nonatomic, strong) SHYouTube *youTube;
@end

@implementation MainViewController

#pragma mark - View life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.videoString = @"https://www.youtube.com/embed/VpZmIiIXuZ0";
    
    UIButton *playVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playVideoButton addTarget:self action:@selector(playVideoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playVideoButton];
    self.playVideoButton = playVideoButton;
    
    // Fetch YouTube info
    [SHYouTube youtubeInBackgroundWithYouTubeURL:[NSURL URLWithString:self.videoString] completion:^(SHYouTube *youTube) {
        self.youTube = youTube;
        
        // Download the thumbnail
        SHYouTubeService *service = [SHYouTubeService sharedInstance];
        [service downloadThumbnailInBackgroundWithURLPath:[youTube thumbnailURLPathWithSize:SHYouTubeThumbnailSizeDefaultMedium] completion:^(UIImage *thumbnail) {
            [self.playVideoButton setImage:thumbnail forState:UIControlStateNormal];
            [self.playVideoButton sizeToFit];
        } andFailure:^(NSError *error) {
            NSLog(@"[Debug] SHYouTubeService download thumbnail error: %@", [error localizedDescription]);
        }];
    } andFailure:^(NSError *error) {
        NSLog(@"[Debug] SHYouTube fetch info error: %@", [error localizedDescription]);
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.playVideoButton sizeToFit];
    self.playVideoButton.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
}

#pragma mark - Button action
- (void)playVideoAction:(UIButton *)sender
{
    // Play video
    MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:self.youTube.mediumURLPath]];
    [self presentViewController:mp animated:YES completion:nil];
}

@end
