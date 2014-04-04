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

@interface MainViewController ()
@property (nonatomic, weak) UIButton *playVideoButton;
@end

@implementation MainViewController

#pragma mark - View life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *playVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playVideoButton addTarget:self action:@selector(playVideoAction:) forControlEvents:UIControlEventTouchUpInside];
    [playVideoButton setTitle:@"Play" forState:UIControlStateNormal];
    [playVideoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    playVideoButton.titleLabel.font = [UIFont systemFontOfSize:32.0f];
    [self.view addSubview:playVideoButton];
    self.playVideoButton = playVideoButton;
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
//    NSString *videoURLString = @"https://www.youtube.com/watch?v=4Cgq9z-AoKc";
    NSString *videoURLString = @"https://www.youtube.com/embed/4Cgq9z-AoKc";
    SHYouTube *youTube = [[SHYouTube alloc] initWithYouTubeURL:[NSURL URLWithString:videoURLString]];
    SHYouTubeService *service = [SHYouTubeService sharedInstance];
    [service downloadThumbnailInBackgroundWithURLPath:[youTube thumbnailURLPathWithSize:SHYouTubeThumbnailSizeDefaultMedium] completion:^(UIImage *thumbnail) {
        [self.playVideoButton setImage:thumbnail forState:UIControlStateNormal];
        [self.playVideoButton sizeToFit];
    } andFailure:^(NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

@end
