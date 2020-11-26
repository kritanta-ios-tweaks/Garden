#include "GardenClasses/PageView/GardenPageView.h"
#include <UIKit/UIScreen.h>
#include <UIKit/UIImageView.h>
#include <Cozy/Cozy.h>
#include "MRYIPCCenter.h"
#include <objc/runtime.h>

@interface GardenSchemaCache : NSObject

+ (CozySchema *)schemaForArtworkDigest:(NSString *)digest;

@end


@interface MediaControlsTransportStackView (Garden)

@property (nonatomic, retain) UIButton *customRemoteButton;

@end

@interface SBIconScrollView : UIView

@end

@interface SBRootFolderView : UIView

@property (nonatomic, retain) UIView *pageControl;
@property (nonatomic, retain) UIView *dockView;
@end


@interface UIScreen (Private)

- (CGFloat)_displayCornerRadius;

@end
