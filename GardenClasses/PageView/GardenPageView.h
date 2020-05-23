#include <UIKit/UIView.h>
#include "../../MediaControlsHeaders.h"
#include "../GardenLyricifyHeaders.h"
#include "MSHBarView.h"

@interface GardenPageView : UIView

@property (nonatomic, assign) NSUInteger style;

@property (nonatomic, retain) MediaControlsPanelViewController *mcpvc;
@property (nonatomic, retain) UIView *backgroundGradientView;
@property (nonatomic, retain) CALayer *backgroundSolidColorLayer;
@property (nonatomic, retain) MSHView *mshView;
@property (nonatomic, retain) MSHView *mshBackingView;
@property (nonatomic, retain) MSHView *mshFurtherBackingView;
@property (nonatomic, retain) GardenLyricifyButtonContainerView *lyricifyButtonContainer;
@property (nonatomic, retain) GardenLyricifyOverlayContainerView *lyricifyOverlayContainer;
-(void)updateArtwork;

@end