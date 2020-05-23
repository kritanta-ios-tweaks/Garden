#include <UIKit/UIView.h>
#include "../../MediaControlsHeaders.h"
#include "../GardenLyricifyHeaders.h"
#include "MSHBarView.h"
@interface GardenManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, retain) UIImageView *globalArtworkView;
@property (nonatomic, retain) MPUNowPlayingController *globalMPUNowPlaying;
@property (nonatomic, retain) GardenPageView *globalGarden;
@property (nonatomic, retain) MediaControlsTimeControl *globalTimeControl;
@property (nonatomic, retain) MediaControlsVolumeSlider *globalVolumeSlider;
@property (nonatomic, retain) MediaControlsTransportStackView *globalTransportStackView;
@property (nonatomic, retain) MediaControlsHeaderView *globalHeaderView;
@property (nonatomic, retain) MRYIPCCenter *spotifyIPC;
@property (nonatomic, retain) NSMutableDictionary *cache;

@end 