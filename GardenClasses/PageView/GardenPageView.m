#include "../../Garden.h"
#include "../Management/GardenManager.h"

@implementation GardenPageView

- (instancetype)initWithFrame:(CGRect)frame 
{
	self = [super initWithFrame:frame];
	if (self)
	{
		[GardenManager sharedManager].globalGarden = self;
		UIView *view = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];

		CAGradientLayer *gradient = [[CAGradientLayer alloc] init];

		gradient.frame = view.frame;

		gradient.colors = @[ (id)[[UIColor clearColor] CGColor], (id)[[UIColor colorWithWhite:0.0 alpha:0.5] CGColor] ];

		gradient.locations = @[@0.0, @1.0];

		[view.layer addSublayer:gradient];

		self.backgroundGradientView = view;

		[self addSubview: self.backgroundGradientView];

		self.backgroundGradientView.alpha = 0;

		self.backgroundGradientView.layer.cornerRadius = ([[UIScreen mainScreen] _displayCornerRadius] > 0) ? [[UIScreen mainScreen] _displayCornerRadius]-2 : [[UIScreen mainScreen] _displayCornerRadius];
		self.backgroundGradientView.layer.masksToBounds = YES;


		self.mcpvc = ([objc_getClass("MediaControlsPanelViewController") panelViewControllerForCoverSheet]);
		if (@available(iOS 13, *)) 
		{
			[GardenManager sharedManager].globalHeaderView = self.mcpvc.effectiveHeaderView;
			[self.mcpvc setStyle:4];
		} 
		else 
		{
			[GardenManager sharedManager].globalHeaderView = self.mcpvc.headerView;
		}
		[[GardenManager sharedManager].globalHeaderView setStyle:1];
		[GardenManager sharedManager].globalHeaderView.routingButton.hidden = YES;
		self.mcpvc.view.frame = CGRectMake(0, .57*[[UIScreen mainScreen] bounds].size.height, self.frame.size.width, .395*self.frame.size.height); // y 469
		self.mcpvc.routingCornerView.hidden = YES;
		[self addSubview:self.mcpvc.view];
		//
		UIImageView *artworkView = [[UIImageView alloc] initWithFrame:CGRectMake(.075 *[[UIScreen mainScreen] bounds].size.width,.57*[[UIScreen mainScreen] bounds].size.height-.85*[[UIScreen mainScreen] bounds].size.width,.85*[[UIScreen mainScreen] bounds].size.width,.85*[[UIScreen mainScreen] bounds].size.width)];
		[artworkView setImage:[objc_getClass("MPUNowPlayingController") currentArtwork]];
		
		self.mshFurtherBackingView = [[MSHBarView alloc] initWithFrame:artworkView.frame];
		[(MSHBarView*)self.mshFurtherBackingView setBarSpacing:3];
		[(MSHBarView*)self.mshFurtherBackingView  setBarCornerRadius:0.0];

		//[self.mshFurtherBackingView start];

		self.mshFurtherBackingView.autoHide = YES;
		self.mshFurtherBackingView.displayLink.preferredFramesPerSecond = 24;
		self.mshFurtherBackingView.numberOfPoints = 20;
		self.mshFurtherBackingView.waveOffset = self.mshFurtherBackingView.frame.size.height - 10;
		self.mshFurtherBackingView.gain = 20;
		self.mshFurtherBackingView.limiter = 50;
		self.mshFurtherBackingView.sensitivity = 3;
		self.mshFurtherBackingView.audioProcessing.fft = YES;
		self.mshFurtherBackingView.disableBatterySaver = NO;
		[self.mshFurtherBackingView updateWaveColor:[UIColor whiteColor] subwaveColor:[UIColor whiteColor]];

		self.mshFurtherBackingView.clipsToBounds=YES;


		self.mshBackingView = [[MSHBarView alloc] initWithFrame:artworkView.frame];
		[(MSHBarView*)self.mshBackingView setBarSpacing:3];
		[(MSHBarView*)self.mshBackingView  setBarCornerRadius:0.0];

		//[self.mshBackingView start];

		self.mshBackingView.autoHide = YES;
		self.mshBackingView.displayLink.preferredFramesPerSecond = 24;
		self.mshBackingView.numberOfPoints = 20;
		self.mshBackingView.waveOffset = self.mshBackingView.frame.size.height - 10;
		self.mshBackingView.gain = 20;
		self.mshBackingView.limiter = 50;
		self.mshBackingView.sensitivity = 2;
		self.mshBackingView.audioProcessing.fft = YES;
		self.mshBackingView.disableBatterySaver = NO;
		[self.mshBackingView updateWaveColor:[UIColor whiteColor] subwaveColor:[UIColor whiteColor]];

		self.mshBackingView.clipsToBounds=YES;


		self.mshView = [[MSHBarView alloc] initWithFrame:artworkView.frame];
		[(MSHBarView*)self.mshView setBarSpacing:3];
		[(MSHBarView*)self.mshView  setBarCornerRadius:0.0];

		//[self.mshView start];

		self.mshView.autoHide = YES;
		self.mshView.displayLink.preferredFramesPerSecond = 24;
		self.mshView.numberOfPoints = 20;
		self.mshView.waveOffset = self.mshView.frame.size.height - 10;
		self.mshView.gain = 20;
		self.mshView.limiter = 50;
		self.mshView.sensitivity = 2;
		self.mshView.audioProcessing.fft = YES;
		self.mshView.disableBatterySaver = NO;
		[self.mshView updateWaveColor:[UIColor whiteColor] subwaveColor:[UIColor whiteColor]];

		self.mshView.clipsToBounds=YES;



		[GardenManager sharedManager].globalArtworkView = artworkView;
		[GardenManager sharedManager].globalVolumeSlider = self.mcpvc.volumeContainerView.volumeSlider;
		[self addSubview:[GardenManager sharedManager].globalArtworkView];
        [self addSubview:self.mshFurtherBackingView];
		[self.mshFurtherBackingView start];
        [self addSubview:self.mshBackingView];
		[self.mshBackingView start];
        [self addSubview:self.mshView];
		[self.mshView start];
		self.lyricifyButtonContainer = [[GardenLyricifyButtonContainerView alloc] initWithFrame:CGRectMake(375-70,40,60,60)];
		[self addSubview:self.lyricifyButtonContainer];
		self.lyricifyOverlayContainer = [[GardenLyricifyOverlayContainerView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		[self addSubview:self.lyricifyOverlayContainer];
		[self bringSubviewToFront:self.lyricifyOverlayContainer];
		self.lyricifyOverlayContainer.hidden = YES;

		[[GardenManager sharedManager].globalTransportStackView _updateButtonConfiguration];
		[self updateArtwork];
	}
	return self;
}
+ (NSString *)nameForStyle:(NSInteger)style 
{
	return @[
		@"Spotty" // Page Style inspired by spotify
	][style];
}
//- (void)update
- (void)updateArtwork
{
	self.alpha = [GardenManager sharedManager].globalArtworkView.image ? 1 : 0;
    if ([GardenManager sharedManager].globalArtworkView.image)
        [GardenManager sharedManager].globalGarden.hidden = NO;
	[self.mshFurtherBackingView start];
	[self.mshBackingView start];
	[self.mshView start];
	[[GardenManager sharedManager].globalTransportStackView threeButtonContraints];
	[[GardenManager sharedManager].globalTransportStackView _updateButtonConfiguration];
	[GardenManager sharedManager].globalArtworkView.image = [objc_getClass("MPUNowPlayingController") currentArtwork];
	CozySchema *schema = [GardenSchemaCache schemaForArtworkDigest:[GardenManager sharedManager].globalMPUNowPlaying.currentNowPlayingArtworkDigest];
	if (schema==nil)
		return;
	UIColor *backgroundColor = [[schema backgroundColor] getColor];
	[self.mshFurtherBackingView updateWaveColor:[[schema backgroundColor] getColor] subwaveColor:[[schema backgroundColor] getColor]];
	CozyColor *backingColor = [CozySchema lighterColorForColor:[schema backgroundColor] byFraction:0.1];
	[self.mshBackingView updateWaveColor:[backingColor getColor] subwaveColor:[backingColor getColor]];
	[self.mshView updateWaveColor:[[schema commonColor] getColor] subwaveColor:[[schema contrastColor] getColor]];
	if (!self.backgroundSolidColorLayer) 
	{
		self.backgroundSolidColorLayer = [[CALayer alloc] init];
		self.backgroundSolidColorLayer.frame = self.backgroundGradientView.frame;
		[[self.backgroundGradientView layer] insertSublayer:self.backgroundSolidColorLayer atIndex:0];
	}
	self.backgroundSolidColorLayer.backgroundColor = backgroundColor.CGColor;
	[GardenManager sharedManager].globalTimeControl.elapsedTrack.backgroundColor = [[schema secondaryControlColor] getColor];
	[GardenManager sharedManager].globalTimeControl.remainingTrack.backgroundColor = [[schema tertiaryControlColor] getColor];
	[GardenManager sharedManager].globalVolumeSlider.minimumTrackTintColor = [[schema secondaryControlColor] getColor];
	[GardenManager sharedManager].globalVolumeSlider.maximumTrackTintColor = [[schema tertiaryControlColor] getColor];
	[GardenManager sharedManager].globalHeaderView.primaryLabel.textColor = [[schema labelColor] getColor];
	[GardenManager sharedManager].globalHeaderView.secondaryLabel.textColor = [[schema secondaryLabelColor] getColor];
	[GardenManager sharedManager].globalTransportStackView.leftButton.tintColor = [[schema controlColor] getColor];
	[GardenManager sharedManager].globalTransportStackView.middleButton.tintColor = [[schema controlColor] getColor];
	[GardenManager sharedManager].globalTransportStackView.rightButton.tintColor = [[schema controlColor] getColor];
	[GardenManager sharedManager].globalTransportStackView.languageOptionsButton.tintColor = [[schema controlColor] getColor];
	//globalHeaderView.secondaryLabel.text = [NSString stringWithFormat:@" Found: %c", [schema foundColors]];
}


@end
