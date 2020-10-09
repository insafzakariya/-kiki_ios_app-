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

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "SubtitleViewController.h"

@class Program;

@class IJKMediaControl;


@interface IJKVideoViewController : UIViewController

@property(atomic,strong) NSURL *url;
@property (nonatomic, strong) Program *program;
@property(atomic, retain) id<IJKMediaPlayback> player;

- (id)initWithURL:(NSURL *)url;

+ (void)presentFromViewController:(UIViewController *)viewController withTitle:(NSString *)title URL:(NSURL *)url completion:(void(^)(void))completion;

- (IBAction)onClickMediaControl:(id)sender;
- (IBAction)onClickOverlay:(id)sender;
- (IBAction)onClickDone:(id)sender;
- (IBAction)onClickPlay:(id)sender;
- (IBAction)onClickPause:(id)sender;
- (IBAction)onClickFullScreen:(id)sender;

- (IBAction)didSliderTouchDown;
- (IBAction)didSliderTouchCancel;
- (IBAction)didSliderTouchUpOutside;
- (IBAction)didSliderTouchUpInside;
- (IBAction)didSliderValueChanged;

- (void)setupToPlayWithTitle: (NSString*) title;
- (void)addSubtiles: (NSString*) xmlString;
- (void)notifyNoSubtitleAvailable;
- (void)showAdvertisements: (NSArray*) advertisements;
- (void)exitPalyer;
@property(nonatomic,strong) IBOutlet IJKMediaControl *mediaControl;
@property (weak, nonatomic) IBOutlet SubtitleViewController *subtitleViewController;

@end
