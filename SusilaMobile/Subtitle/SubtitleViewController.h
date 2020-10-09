//
//  Subtitle.h
//  SusilaMobile
//
//  Created by Meuru Muthuthanthri on 6/23/18.
//  Copyright © 2018 Isuru Jayathissa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
@interface SubtitleViewController : UIView

- (void)moviePlayBackStateDidChange:(NSNotification*)notification;

- (void)displaySubtitle;

- (void)stopDisplayingSubtitle;

- (void)addSubtitles: (NSString*) xmlString;

- (void)setLanguage: (NSString*) lang;

- (void)notifyNoSubtitleAvailable;

@property(nonatomic,weak) id<IJKMediaPlayback> delegatePlayer;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end
