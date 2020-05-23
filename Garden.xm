//
//  Garden.xm
//  Garden
//
//  This contains all hooks, but it likely will not compile
//  Doing so is left as an exercise to the user, if they so desire.
//

#include "Garden.h"

static CGFloat globalCurrentDockAndPageControlOffset;

static BOOL _pfFiveButton = YES;
static BOOL _pfSmallButtons = YES;

%hook SBRootFolderView

- (NSUInteger)_leadingCustomPageCount
{
    int x = [GardenManager sharedManager].globalArtworkView.image ? 1 : 0;
    if ([GardenManager sharedManager].globalGarden && !x)
        [GardenManager sharedManager].globalGarden.hidden = YES;
    return %orig()+x;
}

- (NSUInteger)_minusPageCount 
{
    int x = [GardenManager sharedManager].globalArtworkView.image ? 1 : 0;
    if ([GardenManager sharedManager].globalGarden && !x)
        [GardenManager sharedManager].globalGarden.hidden = YES;
    return %orig()+x;
}

- (NSInteger)_pageIndexForTodayViewPage
{
    NSInteger x = %orig();
    return x==-1?-2:x;
}

- (NSInteger)pageState 
{
    NSInteger x = %orig();
    if (x==2 && self.currentPageIndex != -2)
        return 0;
    return x;
}

- (void)resetIconListViews
{
    %orig;
    [self scrollViewDidScroll:self.scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    %orig(scrollView);
    if (![GardenManager sharedManager].globalArtworkView.image)
    {
        [self _setParallaxDisabled:NO forReason:@"GardenPageAppeared"];
        [self setPageControlHidden:NO];
        [self.dockView setHidden:NO];
        return;
    }

    if (scrollView.contentOffset.x <= [[UIScreen mainScreen] bounds].size.width*2)
    {
        CGFloat o = [[UIScreen mainScreen] bounds].size.width*2 - scrollView.contentOffset.x;
        globalCurrentDockAndPageControlOffset = o;
        self.dockView.frame = CGRectMake(o, self.dockView.frame.origin.y, self.dockView.frame.size.width, self.dockView.frame.size.height);
        self.pageControl.frame = CGRectMake(o, self.pageControl.frame.origin.y, self.pageControl.frame.size.width, self.pageControl.frame.size.height);
        CGFloat beans = 1.0- (ABS(([[UIScreen mainScreen] bounds].size.width) - scrollView.contentOffset.x)/[[UIScreen mainScreen] bounds].size.width);
        [GardenManager sharedManager].globalGarden.backgroundGradientView.alpha = beans;
        if (beans == 1)
        {
            [self _setParallaxDisabled:YES forReason:@"GardenPageAppeared"];
            [self setPageControlHidden:YES];
            [self.dockView setHidden:YES];
        }
        else
        {
            [self _setParallaxDisabled:NO forReason:@"GardenPageAppeared"];
            [self setPageControlHidden:NO];
            [self.dockView setHidden:NO];
        }
    }
}

%end




%hook SBIconScrollView

- (void)didMoveToSuperview
{
    if ([self.superview.superview class] == [%c(SBRootFolderView) class])
    {
        [self addSubview:[[GardenPageView alloc] initWithFrame:CGRectOffset([[UIScreen mainScreen] bounds], [[UIScreen mainScreen] bounds].size.width, 0)]];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView *subview in self.subviews.reverseObjectEnumerator) {
        if (subview!=[GardenManager sharedManager].globalGarden)
            continue;
        CGPoint subPoint = [subview convertPoint:point fromView:self];
        UIView *result = [subview hitTest:subPoint withEvent:event];

        if (result) 
            return result;
        
    }

    return %orig(point, event);
}

%end


%hook MediaControlsHeaderView

- (void)setStyle:(NSInteger)style
{
    if (style == 4)
    {
        %orig(1);
        return;
    }
    %orig(style);
}

- (id)launchNowPlayingAppButton
{
    UIButton *x = %orig();
    if ([self style] == 1)
        x.hidden = YES;
    return x;
}

%end


%hook MediaControlsTransportStackView

%property (nonatomic, retain) UIButton *customRemoteButton;

- (void)layoutSubviews
{
    if (self.superview.superview.superview.superview.superview==[GardenManager sharedManager].globalGarden)
    {
        [GardenManager sharedManager].globalTransportStackView = self;
        [self _updateButtonConfiguration];
        self.style = _pfSmallButtons ? 2 : 4;
        self.tvRemoteButton.hidden = NO;
        self.languageOptionsButton.hidden = NO;
        if (!self.customRemoteButton)
        {
            [[GardenManager sharedManager].spotifyIPC addTarget:self action:@selector(updateRemoteButtonWithData:)];
            self.customRemoteButton = [[UIButton alloc] initWithFrame:[self tvRemoteButton].frame];
            [self addSubview:self.customRemoteButton];
        }
    }
}


- (void)updateRemoteButtonWithData:(NSDictionary *)args
{
    [self.customRemoteButton removeFromSuperview];
    self.customRemoteButton = [[UIButton alloc] initWithFrame:[self tvRemoteButton].frame];
    NSData *imageData = args[@"image"];
    [self.customRemoteButton setImage:[NSKeyedUnarchiver unarchiveObjectWithData:imageData] forState:UIControlStateNormal];
    [self.customRemoteButton addTarget:self action:@selector(customShufflePressed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.customRemoteButton];
}


- (void)customShufflePressed
{
    [[GardenManager sharedManager].spotifyIPC callExternalVoidMethod:@selector(gardenShufflePressed:) withArguments:@{@"blah" : @"blah"}];
}

- (NSInteger)style
{
    if (self.superview.superview.superview.superview.superview==[GardenManager sharedManager].globalGarden)
        return _pfSmallButtons ? 2 : 4;
    return %orig;
}

- (void)setStyle:(NSInteger)arg
{
    if (self.superview.superview.superview.superview.superview==[GardenManager sharedManager].globalGarden)
    {
      %orig(_pfSmallButtons ? 2 : 4);
    }
    else %orig(arg);
}

- (NSArray *)threeButtonContraints
{
    if (self.superview.superview.superview.superview.superview==[GardenManager sharedManager].globalGarden)
    {
        if (_pfFiveButton)
        {

            for (NSLayoutConstraint *constraint in %orig()) 
            {
                constraint.active = NO;
                constraint.priority = 999;
            }
            for (NSLayoutConstraint *constraint in [self fiveButtonContraints])
            {
                constraint.active = YES;
            }
            return [self fiveButtonContraints];
        }
        else
            return %orig();
    }
    return %orig();
}

- (void)setThreeButtonConstraints:(id)arg
{
    if (self.superview.superview.superview.superview.superview==[GardenManager sharedManager].globalGarden)
    {
        arg = [self fiveButtonContraints];
        %orig([self fiveButtonContraints]);
        return;
    }
    %orig(arg);

}
- (NSArray *)fiveButtonContraints
{
    NSArray *constraints = %orig();

    if (self.superview.superview.superview.superview.superview==[GardenManager sharedManager].globalGarden)
    {
        for (NSLayoutConstraint *constraint in constraints)
        {
            constraint.active = YES;
            constraint.priority = 100;
        }
    }
    return constraints;
}

- (void)_updateButtonLayout
{
    if (!(self.superview.superview.superview.superview.superview==[GardenManager sharedManager].globalGarden))
        %orig();
}


- (UIButton *)tvRemoteButton
{
    if (!(self.superview.superview.superview.superview.superview==[GardenManager sharedManager].globalGarden))
        return %orig();
    UIButton *originalButton = %orig();
    for (UIView *view in originalButton.subviews)
    {
        [view removeFromSuperview];
    }
    originalButton.hidden = NO;
    return originalButton;
}


%end //MediaControlsTransportStackView's end

%hook MediaControlsTimeControl
- (void)layoutSubviews
{
    %orig();

    if (self.superview.superview.superview.superview.superview.superview.superview==[GardenManager sharedManager].globalGarden)
    {
        [GardenManager sharedManager].globalTimeControl = self;
        [GardenManager sharedManager].globalTransportStackView = ((MediaControlsContainerView *)self.superview.superview.superview).transportStackView;
    }

}
%end


%hook SBMediaController

- (void)_nowPlayingInfoChanged
{
    %orig();
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 1);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        char i = 0x0;
        if (![GardenManager sharedManager].globalArtworkView.image)
            [[%c(SBIconController) sharedInstance].model layout];
        else 
            i = 0x1;
        if ([GardenManager sharedManager].globalGarden) 
            [[GardenManager sharedManager].globalGarden updateArtwork];
        
        if (![GardenManager sharedManager].globalArtworkView.image && i==0x1)
            [[%c(SBIconController) sharedInstance].model layout];
        
        [[GardenManager sharedManager].globalGarden.mcpvc setStyle:4];
    });

}


- (void)_mediaRemoteNowPlayingInfoDidChange:(id)arg1
{
    %orig(arg1);

    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 1);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        char i = 0x0;
        if (![GardenManager sharedManager].globalArtworkView.image)
            [[%c(SBIconController) sharedInstance].model layout];
        else 
            i = 0x1;
        if ([GardenManager sharedManager].globalGarden) 
            [[GardenManager sharedManager].globalGarden updateArtwork];
        
        if (![GardenManager sharedManager].globalArtworkView.image && i==0x1)
            [[%c(SBIconController) sharedInstance].model layout];
        
        [[GardenManager sharedManager].globalGarden.mcpvc setStyle:4];
    });

}

%end


%hook MPUNowPlayingController

- (MPUNowPlayingController*)init
{
    id orig = %orig();

    if (orig) {
        [GardenManager sharedManager].globalMPUNowPlaying = orig;
        if ([GardenManager sharedManager].globalGarden) [[GardenManager sharedManager].globalGarden updateArtwork];
    }
    return orig;
}

%new
+ (id)_current_MPUNowPlayingController
{
    return [GardenManager sharedManager].globalMPUNowPlaying;
}

%new
+ (id)currentArtwork
{
    if (![GardenManager sharedManager].globalMPUNowPlaying)
    {
        /* There was some DRM code here, so if ur a pulandres wannabe look around this area */

        MPUNowPlayingController *nowPlayingController = [[objc_getClass("MPUNowPlayingController") alloc] init];
        [nowPlayingController startUpdating];
        return [nowPlayingController currentNowPlayingArtwork];
    }

    return [[GardenManager sharedManager].globalMPUNowPlaying currentNowPlayingArtwork];
}

%end 
