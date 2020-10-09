/*
 * Copyright (C) 2013-2015 Bilibili
 * Copyright (C) 2013-2015 Zhang Rui <bbcallen@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "IJKVideoViewController.h"
#import "IJKMediaControl.h"
#import "IJKCommon.h"
#import "IJKDemoHistory.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "SusilaMobile-Swift.h"
#import <SDWebImage/UIImageView+WebCache.h>
//#import "FirebaseRemoteConfig"
//@import FirebaseRemoteConfig;

typedef NS_ENUM(NSInteger, AVPlayerFullscreenAutorotaionMode)
{
    AVPlayerFullscreenAutorotationDefaultMode,
    AVPlayerFullscreenAutorotationLandscapeMode
};
#define AVPlayerOverlayVCFullScreenNotification     @"AVPlayerOverlayVCFullScreen"
#define AVPlayerOverlayVCNormalScreenNotification   @"AVPlayerOverlayVCNormalScreen"
#define VideoPlaybackReachedEndNotification @"VideoPlaybackReachedEnd"

@interface IJKVideoViewController ()


//--------To full screen-------------------------
@property (nonatomic, weak) IBOutlet UIButton *fullscreenButton;
@property (nonatomic, weak) UIWindow *mainWindow;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) CGRect currentFrame;
@property (nonatomic, weak) UIViewController *mainParent;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, assign, readonly) BOOL isFullscreen;
@property (weak, nonatomic) IBOutlet UILabel *blockingLabel;
@property (nonatomic, assign) IBInspectable AVPlayerFullscreenAutorotaionMode autorotationMode;
@property (weak, nonatomic) IBOutlet UIView *programTitleView;
@property (weak, nonatomic) IBOutlet UILabel *programTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, assign) UIDeviceOrientation currentOrientation;
//-------------------------------------------------

@property (weak, nonatomic) IBOutlet UIView *subtitleMenuView;
@property (weak, nonatomic) IBOutlet UIView *resolutionMenuView;
@property (weak, nonatomic) IBOutlet SubtitleViewController *subtitleView;
@property (weak, nonatomic) IBOutlet UIView *advertiesemetnView;
@property (weak, nonatomic) IBOutlet UIButton *subtitleButton;
@property (weak, nonatomic) IBOutlet UIButton *resolutionButton;
@property (weak, nonatomic) AdvertisementViewController *advetisementViewContoller;
@property (nonatomic, strong) SMPlayerViewModel * playerViewModel;
@property (weak, nonatomic) IBOutlet UIView *subcriptionView;
@property (weak, nonatomic) IBOutlet UIImageView *subcriptionImage;
@property (weak, nonatomic) IBOutlet UIView *playerControllerVw;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc;
@property (weak, nonatomic) IBOutlet UIButton *BtnSubscribe;
@property (weak, nonatomic) IBOutlet UIButton *BtnBack;
@property (weak, nonatomic) IBOutlet UILabel *labelSubscribeToWatech;

//@property (weak, nonatomic) FIRRemoteConfig *remoteConfig;

@end

@implementation IJKVideoViewController

- (void)dealloc
{
    [self.player shutdown];
    [self removeMovieNotificationObservers];
}

+ (void)presentFromViewController:(UIViewController *)viewController withTitle:(NSString *)title URL:(NSURL *)url completion:(void (^)(void))completion {
    IJKDemoHistoryItem *historyItem = [[IJKDemoHistoryItem alloc] init];
    
    historyItem.title = title;
    historyItem.url = url;
    [[IJKDemoHistory instance] add:historyItem];
    
    [viewController presentViewController:[[IJKVideoViewController alloc] initWithURL:url] animated:YES completion:completion];
}

- (instancetype)initWithURL:(NSURL *)url {
    self = [self initWithNibName:@"IJKVideoViewController" bundle:nil];
    if (self) {
        self.url = url;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)prefersHomeIndicatorAutoHidden{
    return true;
}

#define EXPECTED_IJKPLAYER_VERSION (1 << 16) & 0xFF) | 
- (void)viewDidLoad
{
    
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//
////    [[UIApplication sharedApplication] setStatusBarHidden:YES];
////    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
//
//#ifdef DEBUG
//    [IJKFFMoviePlayerController setLogReport:YES];
//    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
//#else
//    [IJKFFMoviePlayerController setLogReport:NO];
//    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
//#endif
//
//    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
//    // [IJKFFMoviePlayerController checkIfPlayerVersionMatch:YES major:1 minor:0 micro:0];
//
//    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
//    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:options];
//
////    self.player = [[IJKFFMoviePlayerController alloc] init];
//    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    self.player.view.frame = self.view.bounds;
//    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
//    self.player.shouldAutoplay = YES;
//
//    self.view.autoresizesSubviews = YES;
//    [self.view addSubview:self.player.view];
//    [self.view addSubview:self.mediaControl];
//
//    self.mediaControl.delegatePlayer = self.player;
    
    //-----------------------------------------------------
    
    [super viewDidLoad];
    _labelSubscribeToWatech.text = NSLocalizedString(@"SubscribeToWatch", nil);
    // Do any additional setup after loading the view from its nib.

    //    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];

//#ifdef DEBUG
//    [IJKFFMoviePlayerController setLogReport:YES];
//    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
//#else
    [IJKFFMoviePlayerController setLogReport:NO];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
//#endif

    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    // [IJKFFMoviePlayerController checkIfPlayerVersionMatch:YES major:1 minor:0 micro:0];


    //-----------------------------------------------------
    
//    [super viewDidLoad];
//    // Do any additional setup after loading the view from its nib.
//
//    //    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    //    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
//
//#ifdef DEBUG
//    [IJKFFMoviePlayerController setLogReport:YES];
//    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
//#else
//    [IJKFFMoviePlayerController setLogReport:NO];
//    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
//#endif
//
//    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
//    // [IJKFFMoviePlayerController checkIfPlayerVersionMatch:YES major:1 minor:0 micro:0];
//
////    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
////    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:options];
//
//        self.player = [[IJKFFMoviePlayerController alloc] init];
//    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    self.player.view.frame = self.view.bounds;
//    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
//    self.player.shouldAutoplay = YES;
//
//    self.view.autoresizesSubviews = YES;
//    [self.view insertSubview:self.player.view belowSubview:self.mediaControl];
//
//    self.mediaControl.delegatePlayer = self.player;

    
    _autorotationMode = AVPlayerFullscreenAutorotationLandscapeMode;//AVPlayerFullscreenAutorotationDefaultMode;//
    _isFullscreen = NO;
    [self showHideVideoTitle];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.subtitleMenuView.layer.cornerRadius = 5;
    self.resolutionMenuView.layer.cornerRadius = 5;
    
   
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_playerViewModel) {
        _playerViewModel = [[SMPlayerViewModel alloc] init];
    }
    
    [self installMovieNotificationObservers];
    if (@available(iOS 11.0, *)) {
        self.advertiesemetnView.layer.zPosition = 1;
        self.subtitleView.layer.zPosition = 2;
        _blockingLabel.layer.zPosition = 3;
        self.mediaControl.layer.zPosition = 4;
        self.subtitleMenuView.layer.zPosition = 5;
        self.resolutionMenuView.layer.zPosition = 5;
        [ _blockingLabel setHidden:!UIScreen.mainScreen.captured];
    }
    
    NSString *resolution = [[NSUserDefaults standardUserDefaults] stringForKey:@"videoResolution"];
    if (resolution == nil || [resolution  isEqual: @""]) {
        resolution = @"480";
        [[NSUserDefaults standardUserDefaults] setInteger:480 forKey:@"videoResolution"];
    }
    [_resolutionButton setTitle:[NSString stringWithFormat:@"%@ P", resolution] forState:UIControlStateNormal];
    //_lblTitle.text = NSLocalizedString(@"SubscribeToWatch", @"SubscribeToWatch");
    _lblTitle.text = NSLocalizedString(@"SubscribeToWatch", nil);
     //NSLocalizedString(@"SubscribeToWatch", @"SubscribeToWatch");
    //_lblDesc.text = NSLocalizedString(@"PleaseActivatePackage", @"PleaseActivatePackage");
    //[_BtnSubscribe setTitle:NSLocalizedString(@"SubscribeNow", @"") forState:UIControlStateNormal];
    //[_BtnBack setTitle:NSLocalizedString(@"GoBack", @"") forState:UIControlStateNormal];

//    [self.player prepareToPlay];
    NSInteger ti = (NSInteger) self.player.currentPlaybackTime;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    [_playerViewModel sendAnalyticsWithActionType:@"start" contendId:_program.episode.id currentTime:[NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds]];
}



- (void)viewDidDisappear:(BOOL)animated {
    [self stopAction];
    self.subtitleButton.hidden = false;
    self.subtitleButton.enabled = false;

    [self hideSubMenus];
    [self.subtitleViewController notifyNoSubtitleAvailable];
    [self.subtitleViewController stopDisplayingSubtitle];
    [self.advetisementViewContoller stopDisplayingAdvertisements];
    [super viewDidDisappear:animated];
    [self.player shutdown];
    [self removeMovieNotificationObservers];
   
    
//    [self.player pause];
//    [self.mediaControl refreshMediaControl];
}

- (void)exitPalyer {
    [self.player stop];
}

- (void) didRotate:(NSNotification *)notification {
    NSLog(@"Device rotation detected");
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    UIViewController *parent = self;
    if (UIDeviceOrientationIsLandscape(orientation) && !_isFullscreen) {
        _isFullscreen = YES;
        NSLog(@"Attempting to put the video into fullscreen mode");
        [self showHideVideoTitle];
        if (_mainWindow == nil)
        self.mainWindow = [UIApplication sharedApplication].keyWindow;
        
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
        
        [UIView animateKeyframesWithDuration:0.5
                                       delay:0
                                     options:UIViewKeyframeAnimationOptionLayoutSubviews
                                  animations:^{
            self->_window.frame = CGRectMake(0, 0, self->_mainWindow.bounds.size.height, self->_mainWindow.bounds.size.width);
                                  } completion:^(BOOL finished) {
//                                      _fullscreenButton.transform = CGAffineTransformMakeScale(-1.0, -1.0);
//                                      [_fullscreenButton setImage:[UIImage imageNamed:@"smallScreen"] forState:UIControlStateNormal];
                                  }];
    } else if (UIDeviceOrientationIsPortrait(orientation) && _isFullscreen){
//        _isFullscreen = NO;
//        NSLog(@"Attempting to put exit the fullscreen mode");
//        [self showHideVideoTitle];
//        _window.frame = _mainWindow.bounds;
//        [UIView animateKeyframesWithDuration:0.5
//                                       delay:0
//                                     options:UIViewKeyframeAnimationOptionLayoutSubviews
//                                  animations:^{
//                                      _window.frame = _currentFrame;
//                                  } completion:^(BOOL finished) {
//                                      [parent.view removeFromSuperview];
//                                      _window.rootViewController = nil;
//                                      
//                                      [_mainParent addChildViewController:parent];
//                                      [_containerView addSubview:parent.view];
//                                      parent.view.frame = _containerView.bounds;
//                                      [parent didMoveToParentViewController:_mainParent];
//                                      
//                                      [_mainWindow makeKeyAndVisible];
//                                      
////                                      _fullscreenButton.transform = CGAffineTransformIdentity;
////                                      [_fullscreenButton setImage:[UIImage imageNamed:@"fullScreen"] forState:UIControlStateNormal];
//                                      _window = nil;
//                                      
//                                      [self didNormalScreenModeToParentViewController:parent];
//                                  }];
    }
}


- (BOOL) shouldAutorotate {
    return YES;
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBAction

- (IBAction)onClickMediaControl:(id)sender
{
    [self.mediaControl showAndFade];
    [self performSelector:@selector(hideSubMenus) withObject:nil afterDelay:5];
    [self.advetisementViewContoller advertisementTappedWithUiViewContoroller:self];
}

-(void)hideSubMenus {
    self.subtitleMenuView.hidden = true;
    self.resolutionMenuView.hidden = true;
//    _programTitleLabel.hidden  = true;
//    _fullscreenButton.hidden = true;
    
}

- (IBAction)onClickOverlay:(id)sender
{
    if ([_playerControllerVw isUserInteractionEnabled]){
    [self.mediaControl hide];
    [self hideSubMenus];
    [self.advetisementViewContoller advertisementTappedWithUiViewContoroller:self];
    }
}

- (IBAction)onClickDone:(id)sender
{
    NSInteger ti = (NSInteger) self.player.currentPlaybackTime;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    [_playerViewModel sendAnalyticsWithActionType:@"stop" contendId:_program.episode.id currentTime:[NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds]];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    
   
}

- (IBAction)onClickShare:(id)sender {
    if (_program) {
        [self.player pause];
        NSString* kShareUrl = @"https://cdn.kiki.lk/social/share/episode/";
        
        NSString* stringURL = [NSString stringWithFormat:@"%@%ld",kShareUrl, _program.episode.id];
        NSURL* url = [[NSURL alloc] initWithString:stringURL];
        [Common shareVideoViaUIActivitityWithUrlString:url viewController:self];
    }
}

- (IBAction)onClickHUD:(UIBarButtonItem *)sender
{
    if ([self.player isKindOfClass:[IJKFFMoviePlayerController class]]) {
        IJKFFMoviePlayerController *player = self.player;
        player.shouldShowHudView = !player.shouldShowHudView;
        
        sender.title = (player.shouldShowHudView ? @"HUD On" : @"HUD Off");
    }
}

-(void)setCorrectResolutionVideoUrl{
    if (![_program.type isEqual: @"vod"]) {
        return;
    }
    NSString *resolution = [[NSUserDefaults standardUserDefaults] stringForKey:@"videoResolution"];
    if (resolution == nil || [resolution  isEqual: @""]) {
        resolution = @"480";
        [[NSUserDefaults standardUserDefaults] setInteger:480 forKey:@"videoResolution"];
    }
    
    self.url = [NSURL URLWithString: [[[self.url absoluteString] stringByReplacingOccurrencesOfString:@".smil" withString:[NSString stringWithFormat:@"_%@.mp4", resolution]] stringByReplacingOccurrencesOfString:@"smil:" withString:@"mp4:"]];
}

- (void)setupToPlayWithTitle:(NSString *)title{
    [self.player shutdown];
    [self setCorrectResolutionVideoUrl];
    [self hideSubMenus];
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:options];

    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = self.view.bounds;
    self.player.scalingMode = IJKMPMovieScalingModeAspectFill;
    
    NSString *trailer_only = [[NSUserDefaults standardUserDefaults] stringForKey:@"trailer_only"];

    if ([trailer_only isEqualToString:@"true"]){
//        _program.im
//        _subcriptionImage.af_setImage(withURL: URL(string: ad.imageURL.removingPercentEncoding!)!)
//        let imageURL = dict.value(forKey: "image") as? String
//        let imageLink = imageURL?.removingPercentEncoding ?? imageURL?.removingPercentEncoding ?? ""
        NSString *imageURL = _program.image.stringByRemovingPercentEncoding;
        
        _subcriptionImage.contentMode = UIViewContentModeScaleAspectFill;
        [_subcriptionImage sd_setImageWithURL:[NSURL URLWithString:imageURL]
                     placeholderImage:[UIImage imageNamed:@"placeholder.png"]];

//        _subcriptionImage.image = [UIImage imageNamed:@"smallScreen"];
        _playerControllerVw.userInteractionEnabled = NO;
        _subtitleView.hidden = YES;
        self.player.shouldAutoplay = NO;
        _subcriptionView.hidden = NO;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IsSubcriptionView"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    else{
    self.player.shouldAutoplay = YES;
        _subcriptionView.hidden = YES;
    }
    self.view.autoresizesSubviews = YES;
//    [self.view addSubview:self.player.view];
    [self.view insertSubview:self.player.view belowSubview:self.mediaControl];
    
    self.mediaControl.delegatePlayer = self.player;
    self.subtitleViewController.delegatePlayer = self.player;
    
    [self.player prepareToPlay];
    _programTitleLabel.text = title;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    // remove the observer
    [[NSNotificationCenter defaultCenter] addObserver:self.subtitleViewController
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    
//////    [self.player shutdown];
////    bool hasUrl = NO;
////    if(self.player.urlString){
////        hasUrl = YES;
////    }
//    [self.player stop];
//    [self.player contentURL:self.url];
//
////    if (hasUrl){
////        [self.player play];
////    }else{
////      [self.player prepareToPlay];
////    }
//    [self.player prepareToPlay];
    
}

- (void)addSubtiles:(NSString *)xmlString {
    [self.subtitleViewController addSubtitles:xmlString];
    self.subtitleButton.hidden = false;
    self.subtitleButton.enabled = true;
}

- (void)notifyNoSubtitleAvailable {
    [self.subtitleViewController notifyNoSubtitleAvailable];
    self.subtitleButton.hidden = false;
    self.subtitleButton.enabled = false;
}

- (void)showAdvertisements:(NSArray *)advertisements {
    [self.advetisementViewContoller showAdvertisementWithAdvertisements:advertisements delegatePlayer:self.mediaControl.delegatePlayer];
}
- (IBAction)onClickResolutionButton:(id)sender {
    _resolutionMenuView.hidden = !_resolutionMenuView.hidden;
    if (!_resolutionMenuView.hidden) {
        NSString *resolution = [[NSUserDefaults standardUserDefaults] stringForKey:@"videoResolution"];
        for (UIView* v in self.resolutionMenuView.subviews) {
            if ([v isKindOfClass:UIButton.class]) {
                UIButton *button = (UIButton *)v;
                BOOL buttonSelected = [button.titleLabel.text containsString:resolution];
                [button setSelected:buttonSelected];
                [button setEnabled:!buttonSelected];
            }
        }
    }
}

- (IBAction)onClickResolutionItem:(id)sender {
    self.resolutionMenuView.hidden = true;
    NSTimeInterval time = self.player.currentPlaybackTime;
    int resolution = [((UIButton *)sender).titleLabel.text intValue];
    [[NSUserDefaults standardUserDefaults] setInteger:resolution forKey:@"videoResolution"];
    [_resolutionButton setTitle:[NSString stringWithFormat:@"%d P", resolution] forState:UIControlStateNormal];
    [self setupToPlayWithTitle:_programTitleLabel.text];
    [self performSelector:@selector(hideSubMenus) withObject:nil afterDelay:5];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.player setCurrentPlaybackTime:time];
    });
}

- (IBAction)onClickSubtitleButton:(id)sender {
    _subtitleMenuView.hidden = !_subtitleMenuView.hidden;
}

- (IBAction)onSelectSubtitleLanguage:(id)sender {
    [self.subtitleViewController setLanguage:((UIButton *)sender).titleLabel.text];
    self.subtitleMenuView.hidden = true;
    for (UIView* v in self.subtitleMenuView.subviews) {
        if ([v isKindOfClass:UIButton.class]) {
            ((UIButton *)v).backgroundColor = [UIColor whiteColor];
        }
    }
    ((UIButton *)sender).backgroundColor = [UIColor grayColor];
}

- (IBAction)onClickFastForward:(id)sender
{
//    [self.player pause];
    
//    [self.mediaControl beginDragMediaSlider];
//    self.player.currentPlaybackTime = self.mediaControl.mediaProgressSlider.value + 10;
    
    NSTimeInterval changeTime = self.mediaControl.mediaProgressSlider.value + 10;
    if(self.player.duration < changeTime){
        changeTime = self.player.duration - 0.5;
    }
    [self.player setCurrentPlaybackTime:changeTime];
    
//    self.mediaControl.mediaProgressSlider.value = self.player.currentPlaybackTime;
//    [self.mediaControl endDragMediaSlider];
//    [self.mediaControl continueDragMediaSlider];
    
//    [self.player play];
}

- (IBAction)onClickRewind:(id)sender
{
//    [self.player pause];
//    [self.mediaControl beginDragMediaSlider];
    
    NSTimeInterval changeTime = self.mediaControl.mediaProgressSlider.value - 10;
    if(0 > changeTime){
        changeTime =  0.5;
    }
    [self.player setCurrentPlaybackTime:changeTime];
    
//    [self.mediaControl endDragMediaSlider];
//    [self.mediaControl continueDragMediaSlider];
    
//    [self.player play];
}
- (NSString *)getCurrentTimes {
    
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    NSLog(@"newDateString %@", newDateString);
    return newDateString;
}

- (IBAction)onClickPlay:(id)sender
{
    
    if (![self.advetisementViewContoller isFullScreenAdvertisementVisibile]) {
        [self.player play];
        [self.mediaControl refreshMediaControl];
    }
   
    NSInteger ti = (NSInteger) self.player.currentPlaybackTime;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    [_playerViewModel sendAnalyticsWithActionType:@"start" contendId:_program.episode.id currentTime:[NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds]];
}

- (IBAction)onClickPause:(id)sender
{
    NSInteger ti = (NSInteger) self.player.currentPlaybackTime;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    [self.player pause];
    [self.mediaControl refreshMediaControl];
    [_playerViewModel sendAnalyticsWithActionType:@"pause" contendId:_program.episode.id currentTime:[NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds]];
}

/*- (void) stopAction {
    
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    
    [self.player pause];
    [self.mediaControl refreshMediaControl];
    [_playerViewModel sendAnalyticsWithActionType:@"stop" contendId:_program.episode.id currentTime:newDateString];
     //NSLog(@"Donedgdg");
}*/

- (void) stopAction {
    
    //NSDate * now = [NSDate date];
    //NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    //[outputFormatter setDateFormat:@"HH:mm:ss"];
    //NSString *newDateString = [outputFormatter stringFromDate:now];
    
    [self.player pause];
    [self.mediaControl refreshMediaControl];
    
    //NSTimeInterval duration = self.player.duration;
    //NSString *intervalString = [NSString stringWithFormat:@"%f", duration];
    NSInteger ti = (NSInteger) self.player.currentPlaybackTime;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    [_playerViewModel sendAnalyticsWithActionType:@"stop" contendId:_program.episode.id currentTime:[NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds]];
     //NSLog(@"Donedgdg");
}


- (IBAction)onClickFullScreen:(id)sender{
    
    UIViewController *parent = self; //_playerViewController.parentViewController;//// AVPlayerViewController


    if (_mainWindow == nil)
        self.mainWindow = [UIApplication sharedApplication].keyWindow;

    if (_window == nil)
    {
//        _resolutionButton.hidden = false;
//        self.vedioTitleLabel.hidden = false;
//        self.vedioTitleView.hidden = false;

        _isFullscreen = YES;
        [self showHideVideoTitle];
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

//        [self willFullScreenModeFromParentViewController:parent];
        [self didFullScreenModeFromParentViewController:parent];
        [UIView animateKeyframesWithDuration:0.5
                                       delay:0
                                     options:UIViewKeyframeAnimationOptionLayoutSubviews
                                  animations:^{
//                                      UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//                                      if((orientation) == UIDeviceOrientationPortrait || (orientation) == UIDeviceOrientationPortraitUpsideDown || (orientation) == UIDeviceOrientationUnknown){
            self->_window.frame = CGRectMake(0, 0, self->_mainWindow.bounds.size.height, self->_mainWindow.bounds.size.width);//_mainWindow.bounds;
//                                      }else{
//                                          _window.frame = _mainWindow.bounds;
//                                      }
                                      
                                  } completion:^(BOOL finished) {
//                                      _fullscreenButton.transform = CGAffineTransformMakeScale(-1.0, -1.0);
//                                      [_fullscreenButton setImage:[UIImage imageNamed:@"smallScreen"] forState:UIControlStateNormal];

//                                      [self didFullScreenModeFromParentViewController:parent];
                                  }];

    } else {
        _isFullscreen = NO;
        [self showHideVideoTitle];
//        _resolutionButton.hidden = false;
//
//        self.vedioTitleLabel.hidden = true;
//        self.vedioTitleView.hidden = true;
//        switch (_playerViewScreenMode) {
//            case HomeScreen:
//                NSLog(@"-------HomeScreen");
//                break;
//
//            case EpisodeScreen:
//                NSLog(@"-------EpisodeScreen");
//                [self playerPause];
//
//                break;
//
//            case None:
//                NSLog(@"-------None");
//        }

//        [self dismissViewControllerAnimated:NO completion:^{
//
//        }];

//        [self willNormalScreenModeToParentViewController:parent];
        _window.frame = _mainWindow.bounds;
        
        
        
        [UIView animateKeyframesWithDuration:0.5
                                       delay:0
                                     options:UIViewKeyframeAnimationOptionLayoutSubviews
                                  animations:^{
//                                      self.player.view.hidden = YES;
                                      
            self->_window.frame = self->_currentFrame;
                                      
                                  } completion:^(BOOL finished) {
//                                      self.player.view.hidden = NO;
                                      
                                      
                                      
                                      [parent.view removeFromSuperview];
                                      self->_window.rootViewController = nil;

                                      [self->_mainParent addChildViewController:parent];
                                      [self->_containerView addSubview:parent.view];
                                      parent.view.frame = self->_containerView.bounds;
                                      [parent didMoveToParentViewController:self->_mainParent];

                                      [self->_mainWindow makeKeyAndVisible];
                                      
//                                      _fullscreenButton.transform = CGAffineTransformIdentity;
//                                      [_fullscreenButton setImage:[UIImage imageNamed:@"fullScreen"] forState:UIControlStateNormal];
                                      self->_window = nil;

                                      //                                              _autorotationMode = AVPlayerFullscreenAutorotationDefaultMode;
                                      [self didNormalScreenModeToParentViewController:parent];
                                  }];



        //                break;
        //
        //        }

    }
    
}

- (void) showHideVideoTitle {
    _programTitleView.hidden = !_isFullscreen;
}

- (IBAction)didSliderTouchDown
{
    [self.mediaControl beginDragMediaSlider];
}

- (IBAction)didSliderTouchCancel
{
    [self.mediaControl endDragMediaSlider];
}

- (IBAction)didSliderTouchUpOutside
{
    [self.mediaControl endDragMediaSlider];
}

- (IBAction)didSliderTouchUpInside
{
    self.player.currentPlaybackTime = self.mediaControl.mediaProgressSlider.value;
    [self.mediaControl endDragMediaSlider];
}

- (IBAction)didSliderValueChanged
{
    [self.mediaControl continueDragMediaSlider];
}
- (IBAction)gotoSubcription:(id)sender {
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDelegate getRemoteConfig];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    SMWebViewController *webController =
    [storyboard instantiateViewControllerWithIdentifier:@"SMWebViewController"];
    [webController setFromEpisode:@"true"];
//    [webController setWebViewLink: packagePageUrl + "?token=\(packageSubscribe["tokenHash"].string ?? "")"];
    [self presentViewController:webController
                       animated:YES
                     completion:nil];

//    SMWebViewController *controller = [[SMWebViewController alloc]initWithNibName:@"SMWebViewController" bundle:nil];
//    [self presentViewController:controller animated:YES completion:nil];

//    self.remoteConfig = [FIRRemoteConfig remoteConfig];
//
//    controller.webViewLink = [FIRRemoteConfig licenseAgreementConfigKey];

//    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)loadStateDidChange:(NSNotification*)notification
{
    //    MPMovieLoadStateUnknown        = 0,
    //    MPMovieLoadStatePlayable       = 1 << 0,
    //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started

    IJKMPMovieLoadState loadState = _player.loadState;

    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    //    MPMovieFinishReasonPlaybackEnded,
    //    MPMovieFinishReasonPlaybackError,
    //    MPMovieFinishReasonUserExited
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];

    switch (reason)
    {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
            [[NSNotificationCenter defaultCenter] postNotificationName:VideoPlaybackReachedEndNotification object:notification];
            break;

        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;

        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;

        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    NSLog(@"mediaIsPreparedToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    //    MPMoviePlaybackStateStopped,
    //    MPMoviePlaybackStatePlaying,
    //    MPMoviePlaybackStatePaused,
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    switch (_player.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
//            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

#pragma mark Install Movie Notifications

/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];

	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    if (@available(iOS 11.0, *)) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(screenCaptureChanged:)
                                                     name:UIScreenCapturedDidChangeNotification
                                                   object:nil];
    }
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


#pragma mark Remove Movie Notification Handlers

/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
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
                [self onClickFullScreen:nil];
            } else if (UIDeviceOrientationIsPortrait(orientation) && self->_isFullscreen) {
                [self onClickFullScreen:nil];
            }
        }
    }];
}

- (void) screenCaptureChanged: (NSNotification *) notification {
    if (@available(iOS 11.0, *)) {
        UIScreen* object = notification.object;
        [_blockingLabel setHidden:!object.captured];
    }
}

@end
