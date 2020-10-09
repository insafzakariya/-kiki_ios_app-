//
//  AVPlayerVC.h
//
//  Created by Danilo Priore on 28/04/16.
//  Copyright © 2016 Prioregroup.com. All rights reserved.
//
IB_DESIGNABLE

#define AVPlayerVCSetVideoURLNotification @"avplayervcsetvideourl"
#define AVPlayerVCSetFullScreenVideoNotification @"avplayervcsetfullScreenvideourl"

#import <AVKit/AVKit.h>
#import "AVPlayerOverlayVC.h"

@interface AVPlayerVC : AVPlayerViewController

@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) AVPlayerOverlayVC *overlayVC;

@property (nonatomic, assign) IBInspectable BOOL videoBackground;
@property (nonatomic, strong) IBInspectable NSString *overlayStoryboardId;

//@property (nonatomic, weak) UIViewController *playerViewController;
//@property (nonatomic, strong) Program * program;

- (void)playInBackground:(BOOL)play;

@end
