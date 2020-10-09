//
//  Subtitle.m
//  SusilaMobile
//
//  Created by Meuru Muthuthanthri on 6/24/18.
//  Copyright © 2018 Isuru Jayathissa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubtitleViewController.h"
#import "SusilaMobile-Swift.h"

@interface SubtitleViewController()
@property (strong, nonatomic)SubtitleModel *subtitleModel;

@end

@implementation SubtitleViewController {
    BOOL *isSubtitleVisible;
    NSString *selectedLang;
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    switch (_delegatePlayer.playbackState) {
        case IJKMPMoviePlaybackStatePlaying: {
            if (isSubtitleVisible) {
                [self displaySubtitle];
            }
            break;
        }
        case IJKMPMoviePlaybackStateStopped:
        case IJKMPMoviePlaybackStatePaused: {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(displaySubtitle) object:nil];
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            break;
        }
        default: {
            break;
        }
    }
}

- (void)displaySubtitle {
    NSString *sub = [self.subtitleModel getSubtitleWithTime:_delegatePlayer.currentPlaybackTime];
    [self.subtitleLabel setText:sub];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(displaySubtitle) object:nil];
    [self performSelector:@selector(displaySubtitle) withObject:nil afterDelay:0.5];
}

- (void)stopDisplayingSubtitle {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(displaySubtitle) object:nil];
    isSubtitleVisible = false;
}

-(void)addSubtitles:(NSString *)xmlString {
    if (self.subtitleModel == nil) {
        self.subtitleModel = [[SubtitleModel alloc] init];
    }
    NSArray *availableLanguages = [self.subtitleModel setSubtitleXmlWithXml:xmlString];
    if (selectedLang) {
        [self setLanguage:selectedLang];
    }
}

-(void)setLanguage:(NSString *)lang {
    NSString *language = [[lang lowercaseString] substringToIndex:3];
    isSubtitleVisible = ![language isEqual: @"non"];
    selectedLang = lang;
    if (isSubtitleVisible) {
        [self.subtitleModel setLanguageWithLanguage:language];
        [self displaySubtitle];
        self.subtitleLabel.hidden = false;
    } else {
        [self stopDisplayingSubtitle];
        self.subtitleLabel.hidden = true;
    }
}

-(void)notifyNoSubtitleAvailable {
    isSubtitleVisible = false;
    self.subtitleLabel.hidden = true;
}

@end
