//
//  AVPlayerVC.m
//
//  Created by Danilo Priore on 28/04/16.
//  Copyright © 2016 Prioregroup.com. All rights reserved.
//

#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import "AVPlayerVC.h"
#import "SusilaMobile-Swift.h"

static AVPlayerVC *sharedManager = nil;

@implementation AVPlayerVC

//+ (BOOL)sharedManager {
//    static BOOL sharedManager = true;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedManager = false;
////        sharedMyManager = [self initWithCoder:aDecoder];//[[self alloc] init];
//    });
//    return sharedManager;
//}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        if (self = [super initWithCoder:aDecoder]) {
//            sharedManager = self;
//            _videoBackground = NO;
//            _overlayStoryboardId = @"AVPlayerOverlayVC";
//        }
//    });
//    return sharedManager;
    
    sharedManager = nil;
    if (sharedManager == nil){
        if (self = [super initWithCoder:aDecoder]) {
            sharedManager = self;
            _videoBackground = NO;
            _overlayStoryboardId = @"AVPlayerOverlayVC";
            
            [[AVAudioSession sharedInstance]
             setCategory: AVAudioSessionCategoryPlayback
             error: nil];
        }
    }
    
    return sharedManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.showsPlaybackControls = NO;
    
    
    if (_videoBackground) {
        // audio/video background
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillResignActiveNotification:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillEnterForegroundNotification:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(avPlayerVCSetVideoURLNotification:)
                                                 name:AVPlayerVCSetVideoURLNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(avPlayerVCSetFullScreenVideoNotification:)
                                                 name:AVPlayerVCSetFullScreenVideoNotification
                                               object:nil];

    
    
    _overlayVC = [self.storyboard instantiateViewControllerWithIdentifier:_overlayStoryboardId];
    
//    [self addChildViewController:_overlayVC];
//
////    [self.contentOverlayView addSubview:_overlayVC.view];
//    [self.view addSubview:_overlayVC.view];
////    [self.view bringSubviewToFront:_overlayVC.view];
////    [self.view insertSubview:_overlayVC.view atIndex:100];
////    [self.view insertSubview:_overlayVC.view aboveSubview:self.view];
//    [_overlayVC didMoveToParentViewController:self];
    
    
    
}
    
//    - (void)viewDidAppear:(BOOL)animated
//    {
//        
//        [self addChildViewController:_overlayVC];
//        [self.view addSubview:_overlayVC.view];
//        [_overlayVC didMoveToParentViewController:self];
//    }

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//
//    [self addChildViewController:_overlayVC];
//    [self.view addSubview:_overlayVC.view];
//    [_overlayVC didMoveToParentViewController:self];
//
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self addChildViewController:_overlayVC];
    [self.view addSubview:_overlayVC.view];
    [_overlayVC didMoveToParentViewController:self];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _overlayVC.view.frame = self.view.bounds;
    
    
//    CGRect frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + 70, self.view.bounds.size.width, self.view.bounds.size.height);
//    _overlayVC.view.frame = frame;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)setPlayer:(AVPlayer *)player
{
    [super setPlayer:player];
    
    _overlayVC.player = self.player;
    
}

- (void)setVideoURL:(NSURL *)videoURL
{
    @synchronized (self) {
        _videoURL = videoURL;
        
        self.player = [AVPlayer playerWithURL:videoURL];
    }
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    
#ifdef DEBUG
    //NSLog(@"Remote control event %i subtype %i", event.type, event.subtype);
     NSLog(@"Remote control event %li subtype %li", (long)event.type, (long)event.subtype);
#endif

    if (event.type == UIEventTypeRemoteControl && self.player) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
            case UIEventSubtypeRemoteControlPause:
            case UIEventSubtypeRemoteControlStop:
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [_overlayVC didPlayButtonSelected:self];
                break;
            default:
                break;
        }
    }
}

- (void)dealloc
{
    _overlayVC = nil;
    
    [self.player pause], self.player = nil;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Video (only audio) on background

- (void)playInBackground:(BOOL)play
{
    static BOOL isPlay;
    
    isPlay = self.player.rate != 0;
    AVPlayerItem *playerItem = [self.player currentItem];
    
    NSArray *tracks = [playerItem tracks];
    for (AVPlayerItemTrack *playerItemTrack in tracks)
    {
        // find video tracks
        if ([playerItemTrack.assetTrack hasMediaCharacteristic:AVMediaCharacteristicVisual])
        {
            playerItemTrack.enabled = !play;
            break;
        }
    }
    
    if (isPlay)
        [self.player performSelector:@selector(play) withObject:nil afterDelay:1.0];
}

#pragma mark - Notifications

- (void)applicationWillResignActiveNotification:(NSNotification*)note
{
    [self playInBackground:YES];
}

- (void)applicationWillEnterForegroundNotification:(NSNotification*)note
{
    [self playInBackground:NO];
}

- (void)avPlayerVCSetVideoURLNotification:(NSNotification*)note
{
    self.videoURL = note.object;
   
//    [_overlayVC.player play];
    [_overlayVC updatePlayerResolution:1794100 withIndex:3];
//    [_overlayVC updatePlayerResolution:1794100];
    [_overlayVC.resolutionButton setTitle:@"480p" forState:UIControlStateNormal];
    
}



- (void)avPlayerVCSetFullScreenVideoNotification:(NSNotification*)note
{
    //_overlayVC.autorotationMode = AVPlayerFullscreenAutorotationLandscapeMode;
    
    Episode *episode = note.object;
//    NSString *videoName = episode.name;
    //self.videoName.text = videoName
//    _overlayVC.vedioTitleLabel.text = videoName;
    
    
    
    if (episode.videoLink != nil){
        
        self.videoURL = [Common getNSURLFromStringWithUrlString:episode.videoLink];//Common.getNSURLFromString(episode.videoLink);
    }
    
    
    
//    [_overlayVC setPlayerViewScreenMode: EpisodeScreen];
    [_overlayVC didFullscreenButtonSelected:nil];
    [_overlayVC didPlayButtonSelected:nil];
    
    
}


@end
