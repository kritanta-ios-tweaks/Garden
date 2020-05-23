#include "../../Garden.h"
#include "GardenManager.h"

@implementation GardenSchemaCache

+ (CozySchema *)schemaForArtworkDigest:(NSString *)digest
{
	if (digest==nil)
		return nil;
	if ([GardenManager sharedManager].cache[digest]==nil)
	{
		NSArray *options = @[ @"fullBlack", @"alwaysLightForeground", @"darkenBackgroundTillReadable", @"preferCoolBackground"];
		CozySchema *schema = [CozyAnalyzer schemaForImage:[GardenManager sharedManager].globalArtworkView.image withOptions:options];
		[[GardenManager sharedManager].cache setObject:schema forKey:digest];
	}
	return [GardenManager sharedManager].cache[digest];
}

@end