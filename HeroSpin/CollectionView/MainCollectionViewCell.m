//
//  MainCollectionViewCell.m
//  HeroSpin
//
//  Created by Riddhi Ojha on 5/13/16.
//  Copyright © 2016 Riddhi Ojha. All rights reserved.
//

#import "MainCollectionViewCell.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MainCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIView *videoCollectionView;
@end



@implementation MainCollectionViewCell

- (void)configureWithURL:(NSURL *)url {
    
    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
    [playerViewController.view setFrame:CGRectMake(self.videoCollectionView.frame.origin.x,
                                                   self.videoCollectionView.frame.origin.y,
                                                   self.videoCollectionView.frame.size.width,
                                                   self.videoCollectionView.frame.size.height)];
    AVPlayerItem* item=[[AVPlayerItem alloc]initWithURL:url];
    playerViewController.player=[AVPlayer playerWithPlayerItem:item];
    playerViewController.player.muted = YES;
    playerViewController.view.contentMode = UIViewContentModeScaleAspectFill;
    playerViewController.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[playerViewController.player currentItem]];
    
    [playerViewController.player play];
    [self.videoCollectionView addSubview:playerViewController.view];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}


@end
