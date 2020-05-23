#include <Foundation/Foundation.h>
#include <UIKit/UIButton.h>
#include <UIKit/UILabel.h>
#include <UIKit/UIViewController.h>
#include <UIKit/UISlider.h>
#ifndef MMCH
#define MMCH
@interface MediaControlsHeaderView : UIView

@property (nonatomic,retain) UIButton * routingButton; 

@property (nonatomic, assign) NSInteger style;

@property (nonatomic, retain) UILabel *primaryLabel;
@property (nonatomic, retain) UILabel *secondaryLabel;

@end

@interface MediaControlsVolumeSlider : UISlider

@end

@interface MediaControlsTimeControl : UIControl 

@property (nonatomic, retain) UIView *remainingTrack;
@property (nonatomic, retain) UILabel *remainingTimeLabel;

@property (nonatomic, retain) UIView *elapsedTrack;
@property (nonatomic, retain) UILabel *elapsedTimeLabel;

@end

@interface MediaControlsTransportStackView : UIView 

@property (nonatomic, assign) NSInteger style;

// not my typos ;)
@property (nonatomic, retain) NSArray *threeButtonContraints;
@property (nonatomic, retain) NSArray *fiveButtonContraints;

-(void)_updateButtonConfiguration;

@property (nonatomic, retain) UIButton *leftButton;
@property (nonatomic, retain) UIButton *middleButton;
@property (nonatomic, retain) UIButton *rightButton;

@property (nonatomic, retain) UIButton *languageOptionsButton;
@property (nonatomic, retain) UIButton *tvRemoteButton;

@end

@interface MediaControlsContainerView : UIView

@property (nonatomic, retain) MediaControlsTimeControl *timeControl;

@property (nonatomic, retain) MediaControlsTransportStackView *transportStackView;

@end

@interface MediaControlsVolumeContainerView : UIView 

@property (nonatomic, retain) MediaControlsVolumeSlider *volumeSlider;

@end

@interface MediaControlsPanelViewController : UIViewController

@property (nonatomic,retain) MediaControlsHeaderView * effectiveHeaderView;
// iOS < 13
@property (nonatomic,retain) MediaControlsHeaderView * headerView;
// end
+(id)panelViewControllerForCoverSheet;
-(NSInteger)style;
@property (nonatomic, retain) UIView *routingCornerView;
-(void)setStyle:(NSInteger)arg1 ;
@property (nonatomic, retain) MediaControlsVolumeContainerView *volumeContainerView;
-(void)headerViewLaunchNowPlayingAppButtonPressed:(id)heck;

@end

@interface MPUNowPlayingController : NSObject {
    bool  _cachedArtworkDirty;
    UIImage * _cachedNowPlayingArtwork;
    double  _currentDuration;
    double  _currentElapsed;
    NSString * _currentNowPlayingAppDisplayID;
    bool  _currentNowPlayingAppIsRunning;
    NSString * _currentNowPlayingAppParentApp;
    NSString * _currentNowPlayingArtworkDigest;
    NSDictionary * _currentNowPlayingInfo;
    bool  _hasValidCurrentNowPlayingAppDisplayID;
    long long  _isPlaying;
    bool  _isRegisteredForNowPlayingNotifications;
    bool  _isUpdatingNowPlayingApp;
    bool  _isUpdatingNowPlayingInfo;
    bool  _isUpdatingPlaybackState;
    bool  _shouldUpdateNowPlayingArtwork;
    NSObject<OS_dispatch_source> * _timeInformationTimer;
    double  _timeInformationUpdateInterval;
    bool  _wantsTimeInformationUpdates;
}

@property (nonatomic, readonly) double currentDuration;
@property (nonatomic, readonly) double currentElapsed;
@property (nonatomic, readonly) bool currentNowPlayingAppIsRunning;
@property (nonatomic, readonly) UIImage *currentNowPlayingArtwork;
@property (nonatomic, readonly) NSString *currentNowPlayingArtworkDigest;
@property (nonatomic, readonly) NSDictionary *currentNowPlayingInfo;
@property (nonatomic, readonly) bool isPlaying;
@property (nonatomic, readonly) NSString *nowPlayingAppDisplayID;
@property (nonatomic, readonly) bool nowPlayingAppIsSystemMediaApp;
@property (nonatomic, readonly) NSString *nowPlayingAppParentAppDisplayID;
@property (nonatomic) bool shouldUpdateNowPlayingArtwork;
@property (nonatomic) double timeInformationUpdateInterval;
- (bool)_isUpdatingTimeInformation;
+(id)currentArtwork;
- (void)_registerForNotifications;
- (void)_startUpdatingTimeInformation;
- (void)_stopUpdatingTimeInformation;
- (void)_unregisterForNotifications;
- (void)_updateCurrentNowPlaying;
- (void)_updateNowPlayingAppDisplayID;
- (void)_updatePlaybackState;
- (void)_updateTimeInformationAndCallDelegate:(bool)arg1;
- (double)currentDuration;
- (double)currentElapsed;
- (bool)currentNowPlayingAppIsRunning;
- (id)currentNowPlayingArtwork;
- (id)currentNowPlayingArtworkDigest;
- (id)currentNowPlayingInfo;
- (id)currentNowPlayingMetadata;
- (void)dealloc;
- (id)delegate;
- (id)init;
- (bool)isPlaying;
- (id)nowPlayingAppDisplayID;
- (bool)nowPlayingAppIsSystemMediaApp;
- (id)nowPlayingAppParentAppDisplayID;
- (void)setDelegate:(id)arg1;
- (void)setShouldUpdateNowPlayingArtwork:(bool)arg1;
- (void)setTimeInformationUpdateInterval:(double)arg1;
- (bool)shouldUpdateNowPlayingArtwork;
- (void)startUpdating;
- (void)stopUpdating;
- (double)timeInformationUpdateInterval;
- (void)update;

@end


#endif