#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#include "Tweak.h"

// currently broken?

@interface SPTNowPlayingShuffleButton : UIButton
@end

static MRYIPCCenter *gardenServer;

@interface SPTNowPlayingPlaybackActionsHandlerImplementation

- (void)toggleShuffle:(id)arg;

@end 

@interface SPTNowPlayingDefaultPremuimHeadUnitViewController

@property (nonatomic, retain) SPTNowPlayingPlaybackActionsHandlerImplementation *playbackActionsHandler;

@end

%hook SPTNowPlayingPlaybackActionsHandlerImplementation

- (id)initWithModel:(id)arg skipLimitReachedMessageRequester:(id)arg2 logger:(id)arg3
{
	self = %orig(arg, arg2, arg3);
	gardenServer = [MRYIPCCenter centerNamed:@"me.kritanta.gardenspotifyipc"];
	@try {
		[gardenServer addTarget:self action:@selector(gardenShufflePressed:)];
	}
	@catch(NSException *ex){}
	return self;
}

%new 
- (void)gardenShufflePressed:(NSDictionary *)args 
{
	[self toggleShuffle:nil];
}

%end

%hook SPTNowPlayingDefaultPremuimHeadUnitViewController
- (id)initWithModel:(id)arg1 playbackActionsHandler:(id)arg2 testManager:(id)arg3 theme:(id)arg4 
{
	self = %orig(arg1, arg2, arg3, arg4);
	return self;
}
%end

%hook SPTNowPlayingShuffleButton

- (id)initWithFrame:(CGRect)frame 
{
	self = %orig(frame);
	return self;
}

- (void)applyIcon
{
	%orig;
}
- (void)setShuffling:(BOOL)arg
{
	%orig(arg);
	NSData *heck = [NSKeyedArchiver archivedDataWithRootObject:[self imageForState:UIControlStateNormal]];
	[gardenServer callExternalVoidMethod:@selector(updateRemoteButtonWithData:) withArguments:@{@"image" : heck}];
}

%end

@interface RootSettingsViewController : UIViewController 

@end

%hook RootSettingsViewController

- (instancetype)init
{
	self = %orig;
    NSURL *url = [NSURL URLWithString:@"data:image/png;base64,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"];

    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *img = [UIImage imageWithData:imageData];

	UIBarButtonItem *locationItem = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:nil action:nil]; 

	self.navigationController.navigationItem.rightBarButtonItem = locationItem;
	return %orig;
}

%end


%ctor {
	NSLog(@"Garden: spotify init");
}