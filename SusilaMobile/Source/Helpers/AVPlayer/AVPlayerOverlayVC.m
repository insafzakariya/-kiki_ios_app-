//
//  AVPlayerOverlayVC.m
//
//  Created by Danilo Priore on 28/04/16.
//  Copyright © 2016 Prioregroup.com. All rights reserved.
//
#import "AVPlayerOverlayVC.h"
//#import "SMPlayerViewModel-Swift.h"
#import "SusilaMobile-Swift.h"
//#import "VKThemeManager.h"

@import AVFoundation;
@import MediaPlayer;

@interface AVPlayerOverlayVC ()

@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIWindow *mainWindow;
@property (nonatomic, weak) UIViewController *mainParent;
@property (nonatomic, weak) UISlider *mpSlider;

@property (nonatomic, assign) CGRect currentFrame;

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) MPVolumeView *volume;

@property (nonatomic, strong) id timeObserver;
@property (nonatomic, assign) BOOL isVideoSliderMoving;

@property (nonatomic, assign) UIDeviceOrientation currentOrientation;

@property (nonatomic, strong) SMPlayerViewModel * playerViewModel;
//@property (nonatomic, weak) UIStackView *controlView;

@end

@implementation AVPlayerOverlayVC

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _playerViewModel = [[SMPlayerViewModel alloc] init];
        _isFullscreen = NO;
        [_fullscreenButton setImage:[UIImage imageNamed:@"fullScreen"] forState:UIControlStateNormal];
        _isVideoSliderMoving = NO;
        _playBarAutoideInterval = 5.0;
        _autorotationMode = AVPlayerFullscreenAutorotationLandscapeMode;///AVPlayerFullscreenAutorotationDefaultMode; //
        _playerViewScreenMode = None;
//        _OverlayVCBottonSpace.constant = -70;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor clearColor];
    
    // system volume
    self.volume = [[MPVolumeView alloc] initWithFrame:CGRectZero];
    for (id view in _volume.subviews) {
        if ([view isKindOfClass:[UISlider class]]) {
            _mpSlider = view;
            break;
        }
    }
    [_videoSlider setThumbImage:[UIImage imageNamed:@"sliderThumb"] forState:UIControlStateNormal];
    [_videoSlider setThumbImage:[UIImage imageNamed:@"sliderThumb"] forState:UIControlStateFocused];
    [_videoSlider setThumbImage:[UIImage imageNamed:@"sliderThumb"] forState:UIControlStateSelected];
    [_videoSlider setThumbImage:[UIImage imageNamed:@"sliderThumb"] forState:UIControlStateHighlighted];

    

    
    _volumeSlider.hidden = YES;
    _volumeSlider.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _volumeSlider.value = [AVAudioSession sharedInstance].outputVolume;
    
    _playBigButton.layer.borderWidth = 1.0;
    _playBigButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _playBigButton.layer.cornerRadius = _playBigButton.frame.size.width / 2.0;
    
    [self videoSliderEnabled:NO];
    
    // actions
    [_playButton addTarget:self action:@selector(didPlayButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [_volumeButton addTarget:self action:@selector(didVolumeButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [_fullscreenButton addTarget:self action:@selector(didFullscreenButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [_playBigButton addTarget:self action:@selector(didPlayButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [_videoSlider addTarget:self action:@selector(didVideoSliderTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [_videoSlider addTarget:self action:@selector(didVideoSliderTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_volumeSlider addTarget:self action:@selector(didVolumeSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [_videoSlider addTarget:self action:@selector(didVideoSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_fastForwardButton addTarget:self action:@selector(didFastForwardButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [_rewindButton addTarget:self action:@selector(didRewindButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [_shareButton addTarget:self action:@selector(didShareButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    [_resolutionButton addTarget:self action:@selector(didResulutionButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    // tap gesture
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapGesture:)];
    [self.view addGestureRecognizer:tap];
    
    // device rotation
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [self.view layoutIfNeeded];
    [self autoHidePlayerBar];
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    if (_timeObserver)
        [_player removeTimeObserver:_timeObserver];
    _timeObserver = nil;

    _volume = nil;
    _player = nil;

    (void)([_window removeFromSuperview]), _window = nil;
    [_mainWindow makeKeyAndVisible];
    
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)setPlayer:(AVPlayer *)player
{
    @synchronized (self) {
        _player = player;

        if (_player == nil) {
            
            if (_timeObserver)
                [_player removeTimeObserver:_timeObserver];
            _timeObserver = nil;
            
            _volumeSlider.value = 1.0;
            _videoSlider.value = 0.0;

        } else {
            
            __weak typeof(self) wself = self;
            self.timeObserver =  [_player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0 / 60.0, NSEC_PER_SEC)
                                                                       queue:NULL
                                                                  usingBlock:^(CMTime time){
                                                                      [wself updateProgressBar];
                                                                  }];
            _videoSlider.value = 0;
            _volumeSlider.value = _player.volume;
        }
        
        _playButton.selected = NO;
        _playBigButton.hidden = NO;
        _playBigButton.selected = NO;

        [self showPlayerBar];
        [self autoHidePlayerBar];
        [self videoSliderEnabled:NO];
    }
}
//
//- (NSString*)getTimeFormat:(NSString *) inputVal{
//
//    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
//    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
//    [formatter setGroupingSeparator:@""];
//    [formatter setDecimalSeparator:@"."];
//    
//    // Decimal values read from any db are always written with no grouping separator and a comma for decimal.
//    
//    NSNumber *numberFromString = [formatter numberFromString:inputVal];
//    
//    [formatter setGroupingSeparator:@""]; // Whatever you want here
//    [formatter setDecimalSeparator:@":"]; // Whatever you want here
//    
//    NSString *finalValue = [formatter stringFromNumber:numberFromString];
//    
//    return finalValue;
//}

- (void)updateTimeLabel: (float) currentVal withTotalVal:(float)totalVal{
    
    int currentMinutes = (int)currentVal / 60;
    int currentSeconds = (int)currentVal % 60;
    
    int remainingMinutes = (int)(totalVal - currentVal) / 60;
    int remainingSeconds = (int)(totalVal - currentVal) % 60;
    
//    int currentMinutes = Int(currentVal) / 60 % 60;
//    let currentSeconds = Int(currentVal) % 60
    
    
    _playTimeLabel.text = [NSString stringWithFormat:@"%02i:%02i", currentMinutes, currentSeconds];
    
    _remainingTimeLabel.text = [NSString stringWithFormat:@"%02i:%02i", remainingMinutes, remainingSeconds];//[self getTimeFormat:[NSString stringWithFormat:@"%.2f", (totalVal - currentVal) / 60]];
}

- (void)updateProgressBar
{
    Float64 duration = CMTimeGetSeconds(_player.currentItem.duration);
    if (!_isVideoSliderMoving && !isnan(duration)) {
        _videoSlider.maximumValue = duration;
        _videoSlider.value = CMTimeGetSeconds(_player.currentTime);
        
        [self videoSliderEnabled:YES];
        
        [self updateTimeLabel:_videoSlider.value withTotalVal:duration];

        
    } else if (_videoSlider.isUserInteractionEnabled) {
        
        [self videoSliderEnabled:NO];
    }
}

- (void)setConstraintValue:(CGFloat)value
              forAttribute:(NSLayoutAttribute)attribute
                  duration:(NSTimeInterval)duration
                animations:(void(^)(void))animations
                completion:(void(^)(BOOL finished))completion
{
    NSArray *constraints = self.view.constraints;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d", attribute];
    NSArray *filteredArray = [constraints filteredArrayUsingPredicate:predicate];
    NSLayoutConstraint *constraint = [filteredArray firstObject];
    if (constraint.constant != value) {
        [self.view removeConstraint:constraint];
        constraint.constant = value;
        [self.view addConstraint:constraint];
        
        [UIView animateWithDuration:duration animations:^{
            if (animations)
                animations();
            [self.view layoutIfNeeded];
        } completion:completion];
    }
}

#pragma mark - PlayerBar

- (void)autoHidePlayerBar
{
    
    if (_playBarAutoideInterval > 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidePlayerBar) object:nil];
        [self performSelector:@selector(hidePlayerBar) withObject:nil afterDelay:_playBarAutoideInterval];
    }
}

- (void)hidePlayerBar
{
//    if (_isFullscreen){
    
        CGFloat height = _playerBarView.frame.size.height;
        
        __weak typeof(self) wself = self;
        [self setConstraintValue:height
                    forAttribute:NSLayoutAttributeBottom
                        duration:1.0
                      animations:^{
                          wself.volumeSlider.alpha = 0.0;
                          wself.playBigButton.alpha = 0.0;
                      } completion:^(BOOL finished) {
                          wself.volumeSlider.hidden = YES;
                          wself.playerBarView.hidden = YES;
                          wself.playBigButton.hidden = YES;
                      }];
//    }
}

- (void)showPlayerBar
{
    _playerBarView.hidden = NO;
    _playBigButton.hidden = NO;

    __weak typeof(self) wself = self;
    [self setConstraintValue:0
                forAttribute:NSLayoutAttributeBottom
                    duration:0.5
                  animations:^{
                      wself.playBigButton.alpha = 1.0;
                  }
                  completion:^(BOOL finished) {
                      [wself autoHidePlayerBar];
                  }];
}

#pragma mark - Actions

- (void)playerPause
{
    if (_player.currentItem != nil)
    {
        if (_player.rate == 0)
        {
            
        } else {
            [_player pause];
            
            _playButton.selected = NO;
            _playBigButton.selected = NO;
            
        }
    }
}

- (void)didResulutionButtonSelected:(UIButton*)sender
{
    
//    func showResolutionList(sender: UIButton, viewController: UIViewController){
    
    if (_isFullscreen){
        [_playerViewModel showResolutionListWithSender:sender viewController:self perentViewController:self];
    }else{
        [_playerViewModel showResolutionListWithSender:sender viewController:self perentViewController:self];
    }
    
}

- (void)showResolutionListPopup: (PopoverViewController*)popupViewController{
//    viewController.showDetailViewController(popupViewController, sender: nil)
    
//    [self.view addSubview:popupViewController.view];
//    [self showDetailViewController:popupViewController sender:nil];
    
//    [self presentViewController:popupViewController animated:YES completion:^{
//        
//    }];
    
    
    [UIView performWithoutAnimation:^{
        [self showDetailViewController:popupViewController sender:nil];
    }];
}

- (void)updatePlayerResolution: (double)bitRate withIndex:(int)index{
    
//    AVAsset *currentPlayerAsset = _player.currentItem.asset;
//    NSArray<AVAssetTrack *> * sdsf = [currentPlayerAsset tracksWithMediaType:AVMediaTypeSubtitle];
    
    AVPlayerItem *playerItem = [_player currentItem];
    playerItem.preferredPeakBitRate = bitRate;
    _resolutionButton.tag = index;
}

- (void)didShareButtonSelected:(UIButton*)sender
{
    NSString* kShareUrl = @"https://cdn.kiki.lk/social/share/episode/";
    
    NSString* stringURL = [NSString stringWithFormat:@"%@%ld",kShareUrl,(long)_program.episode.id];
    NSURL* url = [[NSURL alloc] initWithString:stringURL];
    [Common shareVideoViaUIActivitityWithUrlString:url viewController:self];
}

-(NSURL *)urlOfCurrentlyPlayingInPlayer:(AVPlayer *)player{
    // get current asset
    AVAsset *currentPlayerAsset = player.currentItem.asset;
    // make sure the current asset is an AVURLAsset
    if (![currentPlayerAsset isKindOfClass:AVURLAsset.class]) return nil;
    // return the NSURL
    return [(AVURLAsset *)currentPlayerAsset URL];
}


- (void)didFastForwardButtonSelected:(id)sender
{
    _videoSlider.value = _videoSlider.value + 5;
    [_videoSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didRewindButtonSelected:(id)sender
{
    _videoSlider.value = _videoSlider.value - 5;
    [_videoSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didTapGesture:(id)sender
{
//    [_playerViewModel removereSolutionSelector];
//    _playerViewModel.removereSolutionSelector();
    if (_playerBarView.hidden)
    {
        [self showPlayerBar];
    }
    else if (_volumeSlider.hidden)
    {
        [self didPlayButtonSelected:sender];
    }else{
//        [self autoHidePlayerBar];
        [self hidePlayerBar];
    }
}

/*- (NSString *) getDataFrom:(NSString *)url{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];

    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;

    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];

    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        printf("Action Updated");
        return nil;
    }

    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}*/

- (void)didPlayButtonSelected:(id)sender
{
    //[self getDataFrom:@"http://35.200.234.252/mobile-tv-webservice/api/v1/analytics/screen/9/16/1/0:00"];
    _controlView.hidden = NO;
    
    if (_player.currentItem != nil)
    {
        if (_player.rate == 0)
        {
            [_player play];
            
            _playButton.selected = YES;
            _playBigButton.selected = YES;
            
        } else {
            [_player pause];
            
            _playButton.selected = NO;
            _playBigButton.selected = NO;
            
        }
    }
    
    [self autoHidePlayerBar];
}

- (void)didVolumeButtonSelected:(id)sender
{
    if (_volumeSlider.hidden)
    {
        _volumeSlider.alpha = 0.0;
        _volumeSlider.hidden = NO;
        _volumeSlider.value = [AVAudioSession sharedInstance].outputVolume;
        [UIView animateWithDuration:0.25
                         animations:^{
            self->_volumeSlider.alpha = 1.0;
                         }];
        
    }
    else
    {
        _volumeSlider.alpha = 1.0;
        [UIView animateWithDuration:0.25
                         animations:^{
            self->_volumeSlider.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             self->_volumeSlider.hidden = YES;
                         }];
    }
    
    [self autoHidePlayerBar];
}

- (void)didFullscreenButtonSelected:(id)sender
{
    UIViewController *parent = self.parentViewController; //_playerViewController.parentViewController;//// AVPlayerViewController
    
    
    if (_mainWindow == nil)
        self.mainWindow = [UIApplication sharedApplication].keyWindow;

    if (_window == nil)
    {
        _resolutionButton.hidden = false;
        self.vedioTitleLabel.hidden = false;
        self.vedioTitleView.hidden = false;
        
        self.mainParent = parent.parentViewController;
        self.currentFrame = [parent.view convertRect:parent.view.frame toView:_mainWindow];
        self.containerView = parent.view.superview;
        
        [parent removeFromParentViewController];
        [parent.view removeFromSuperview];
        [parent willMoveToParentViewController:nil];
        
        self.window = [[UIWindow alloc] initWithFrame:_currentFrame];
        _window.backgroundColor = [UIColor blackColor];
        _window.windowLevel = UIWindowLevelNormal;
        [_window makeKeyAndVisible];
        
        _window.rootViewController = parent;
        parent.view.frame = _window.bounds;
        
        [self willFullScreenModeFromParentViewController:parent];
        [UIView animateKeyframesWithDuration:0.5
                                       delay:0
                                     options:UIViewKeyframeAnimationOptionLayoutSubviews
                                  animations:^{
            self->_window.frame = self->_mainWindow.bounds;
                                  } completion:^(BOOL finished) {
                                      self->_fullscreenButton.transform = CGAffineTransformMakeScale(-1.0, -1.0);
                                      self->_isFullscreen = YES;
                                      [self->_fullscreenButton setImage:[UIImage imageNamed:@"smallScreen"] forState:UIControlStateNormal];
                                      
                                      [self didFullScreenModeFromParentViewController:parent];
                                  }];
        
    } else {
       // _isFullscreen = NO;
        _resolutionButton.hidden = false;
        
        self.vedioTitleLabel.hidden = true;
        self.vedioTitleView.hidden = true;
        switch (_playerViewScreenMode) {
            case HomeScreen:
                NSLog(@"-------HomeScreen");
                break;
                
            case EpisodeScreen:
                NSLog(@"-------EpisodeScreen");
                [self playerPause];
                
                break;
                
            case None:
                NSLog(@"-------None");
        }
        
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
        
                [self willNormalScreenModeToParentViewController:parent];
                
                _window.frame = _mainWindow.bounds;
                [UIView animateKeyframesWithDuration:0.5
                                               delay:0
                                             options:UIViewKeyframeAnimationOptionLayoutSubviews
                                          animations:^{
                    self->_window.frame = self->_currentFrame;
                                          } completion:^(BOOL finished) {
                                              
                                              [parent.view removeFromSuperview];
                                              self->_window.rootViewController = nil;
                                              
                                              [self->_mainParent addChildViewController:parent];
                                              [self->_containerView addSubview:parent.view];
                                              parent.view.frame = self->_containerView.bounds;
                                              [parent didMoveToParentViewController:self->_mainParent];
                                              
                                              [self->_mainWindow makeKeyAndVisible];
                                              
                                              self->_fullscreenButton.transform = CGAffineTransformIdentity;
                                              self->_isFullscreen = NO;
                                              [self->_fullscreenButton setImage:[UIImage imageNamed:@"fullScreen"] forState:UIControlStateNormal];
                                              self->_window = nil;
                                              
//                                              _autorotationMode = AVPlayerFullscreenAutorotationDefaultMode;
                                              [self didNormalScreenModeToParentViewController:parent];
                                          }];
                

                
//                break;
//                
//        }
        
    }
    
    [self autoHidePlayerBar];
}

#pragma mark - Overridable Methods

- (void)willFullScreenModeFromParentViewController:(UIViewController*)parent
{
    // NOP
}

- (void)didFullScreenModeFromParentViewController:(UIViewController*)parent
{
    if (_autorotationMode == AVPlayerFullscreenAutorotationLandscapeMode)
    {
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        // force fullscreen for landscape device rotation
        [self forceDeviceOrientation:UIInterfaceOrientationUnknown];
        if (orientation == UIDeviceOrientationLandscapeRight) {
            [self forceDeviceOrientation:UIInterfaceOrientationLandscapeLeft];
        } else {
            [self forceDeviceOrientation:UIInterfaceOrientationUnknown];
            [self forceDeviceOrientation:UIInterfaceOrientationLandscapeRight];
        }
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:AVPlayerOverlayVCFullScreenNotification object:self];
}

- (void)willNormalScreenModeToParentViewController:(UIViewController*)parent
{
        if (_autorotationMode == AVPlayerFullscreenAutorotationLandscapeMode)
            [self forceDeviceOrientation:UIInterfaceOrientationPortrait];
}

- (void)didNormalScreenModeToParentViewController:(UIViewController*)parent
{
    if (_autorotationMode == AVPlayerFullscreenAutorotationLandscapeMode)
        [self forceDeviceOrientation:UIInterfaceOrientationPortrait];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AVPlayerOverlayVCNormalScreenNotification object:self];
}

#pragma mark - Volume Slider

- (void)didVolumeSliderValueChanged:(id)sender
{
    _mpSlider.value = ((UISlider*)sender).value;
    [_mpSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    [self autoHidePlayerBar];
}

#pragma mark - Video Slider

- (void)didVideoSliderValueChanged:(id)sender
{
    _videoSlider.value = ((UISlider*)sender).value;
    [_videoSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    
    Float64 duration = CMTimeGetSeconds(_player.currentItem.duration);
    if (!isnan(duration)) {
        //_videoSlider.maximumValue = duration;
        _videoSlider.value = CMTimeGetSeconds(_player.currentTime);
        
        [self updateTimeLabel:_videoSlider.value withTotalVal:duration];
        
    }
}
- (void)didVideoSliderTouchUp:(id)sender
{
    if (_player.status == AVPlayerStatusReadyToPlay)
    {
        Float64 timeStart = ((UISlider*)sender).value;
        
        Float64 duration = CMTimeGetSeconds(_player.currentItem.duration);
        [self updateTimeLabel:_videoSlider.value withTotalVal:duration];
        
        int32_t timeScale = _player.currentItem.asset.duration.timescale;
        CMTime seektime = CMTimeMakeWithSeconds(timeStart, timeScale);
        if (CMTIME_IS_VALID(seektime))
            [_player seekToTime:seektime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    }
    
    _isVideoSliderMoving = NO;
    [self autoHidePlayerBar];
}

- (void)didVideoSliderTouchDown:(id)sender
{
    _isVideoSliderMoving = YES;
    [self autoHidePlayerBar];
}

- (void)videoSliderEnabled:(BOOL)enabled
{
    if (!_isVideoSliderMoving) {
        if (enabled && !_videoSlider.isUserInteractionEnabled) {
            _videoSlider.userInteractionEnabled = YES;
            [UIView animateWithDuration:0.25 animations:^{
                self->_videoSlider.alpha = 1.0;
            }];
        } else if (!enabled && _videoSlider.isUserInteractionEnabled) {
            _videoSlider.userInteractionEnabled = NO;
            [UIView animateWithDuration:0.25 animations:^{
                self->_videoSlider.alpha = 0.3;
            }];
        }
    }
}

#pragma mark - Device rotation

- (void)forceDeviceOrientation:(UIInterfaceOrientation)orientation
{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[UIDevice currentDevice] setValue:@(orientation) forKey:@"orientation"];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification
{
//    if (_overlayMode == Outter){
//        return;
//    }
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
//    if ((orientation) == UIDeviceOrientationFaceUp || (orientation) == UIDeviceOrientationFaceDown || (orientation) == UIDeviceOrientationUnknown) {
//        _OverlayVCBottonSpace.constant = -70;
//    }else{
//        _OverlayVCBottonSpace.constant = -40;
//    }
    
    if ((orientation) == UIDeviceOrientationFaceUp || (orientation) == UIDeviceOrientationFaceDown || (orientation) == UIDeviceOrientationUnknown || _currentOrientation == orientation) {
        return;
    }
    
    _currentOrientation = orientation;
    
    [[NSOperationQueue currentQueue] addOperationWithBlock:^{
        if (self->_autorotationMode == AVPlayerFullscreenAutorotationLandscapeMode) {
            // force fullscreen for landscape device rotation
            if (UIDeviceOrientationIsLandscape(orientation) && !self->_isFullscreen) {
                [self didFullscreenButtonSelected:nil];
            } else if (UIDeviceOrientationIsPortrait(orientation) && self->_isFullscreen) {
                [self didFullscreenButtonSelected:nil];
            }
        }
    }];
}


@end
