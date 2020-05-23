#include "../../Garden.h"
#include "GardenManager.h"

@implementation GardenManager

+ (instancetype)sharedManager
{
    static GardenManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[[self class] alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];

    if (self) {
        self.spotifyIPC = [MRYIPCCenter centerNamed:@"me.kritanta.gardenspotifyipc"];
        self.cache = [@{} mutableCopy];
    }

    return self;
}

@end