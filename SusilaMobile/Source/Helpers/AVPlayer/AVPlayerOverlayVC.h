//
//  AVPlayerOverlayVC.h
//
//  Created by Danilo Priore on 28/04/16.
//  Copyright © 2016 Prioregroup.com. All rights reserved.
//
IB_DESIGNABLE

#define AVPlayerOverlayVCFullScreenNotification     @"AVPlayerOverlayVCFullScreen"
#define AVPlayerOverlayVCNormalScreenNotification   @"AVPlayerOverlayVCNormalScreen"

#import <UIKit/UIKit.h>

//#import "PopoverViewController.h"
@class AVPlayer;
@class Program;
@class PopoverViewController;

typedef NS_ENUM(NSInteger, AVPlayerFullscreenAutorotaionMode)
{
    AVPlayerFullscreenAutorotationDefaultMode,
    AVPlayerFullscreenAutorotationLandscapeMode
};

typedef NS_ENUM(NSInteger, PlayerViewScreenMode)
{
    HomeScreen,
    EpisodeScreen,
    None
};



@interface AVPlayerOverlayVC : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *OverlayVCBottonSpace;
@property (nonatomic, weak) IBOutlet UIView *playerBarView;
@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UIButton *playBigButton;
@property (nonatomic, weak) IBOutlet UIButton *volumeButton;
@property (nonatomic, weak) IBOutlet UIButton *fullscreenButton;
@property (nonatomic, weak) IBOutlet UISlider *videoSlider;
@property (nonatomic, weak) IBOutlet UISlider *volumeSlider;

@property (nonatomic, weak) IBOutlet UILabel *playTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *remainingTimeLabel;
@property (nonatomic, weak) IBOutlet UIButton *fastForwardButton;
@property (nonatomic, weak) IBOutlet UIButton *rewindButton;
@property (nonatomic, weak) IBOutlet UILabel *vedioTitleLabel;
@property (nonatomic, weak) IBOutlet UIView *vedioTitleView;
@property (nonatomic, strong) IBOutlet UIButton *resolutionButton;

@property (nonatomic, weak) AVPlayer *player;

@property (nonatomic, assign) IBInspectable NSTimeInterval playBarAutoideInterval;
@property (nonatomic, assign) IBInspectable AVPlayerFullscreenAutorotaionMode autorotationMode;

@property (nonatomic, assign, readonly) BOOL isFullscreen;
//@property (nonatomic, weak) UIViewController *playerViewController;
@property (nonatomic, strong) Program * program;

@property (nonatomic, weak) IBOutlet UIButton *likeButton;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;
@property (nonatomic, assign) PlayerViewScreenMode playerViewScreenMode;

@property (weak, nonatomic) IBOutlet UIStackView *controlView;
- (void)updateProgressBar;

- (void)autoHidePlayerBar;
- (void)hidePlayerBar;
- (void)showPlayerBar;

- (void)didTapGesture:(id)sender;
- (void)didPlayButtonSelected:(id)sender;
- (void)didVolumeButtonSelected:(id)sender;
- (void)didFullscreenButtonSelected:(id)sender;

- (void)didVolumeSliderValueChanged:(id)sender;

- (void)didVideoSliderTouchUp:(id)sender;
- (void)didVideoSliderTouchDown:(id)sender;
- (void)videoSliderEnabled:(BOOL)enabled;

- (void)willFullScreenModeFromParentViewController:(UIViewController*)parent;
- (void)didFullScreenModeFromParentViewController:(UIViewController*)parent;
- (void)willNormalScreenModeToParentViewController:(UIViewController*)parent;
- (void)didNormalScreenModeToParentViewController:(UIViewController*)parent;

- (void)updatePlayerResolution: (double)bitRate withIndex:(int)index;
- (void)showResolutionListPopup: (PopoverViewController*)popoverViewController;
@end
