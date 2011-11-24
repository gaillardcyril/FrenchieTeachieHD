//
//  MultiLayerScene.m
//  ScenesAndLayers
//
//  Created by Steffen Itterheim on 28.07.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "GameStatus.h"

@implementation GameStatus
@synthesize gameStatusList,statusPlistPath;
@synthesize gameName,gameType,idxArray,gameNumber,names;

static GameStatus *sharedGameStatus;

+(GameStatus*) sharedGameStatus{
	@synchronized(self)
	{
		if (!sharedGameStatus){
			sharedGameStatus = [[GameStatus alloc] init];            
		}
		return sharedGameStatus;
	}	
}

-(BOOL) gamePurchased{    
    if ([[ gameStatusList objectForKey:@"Purchased"]intValue]) {
        return YES;
    }
    return NO;
}

-(void)initIdxArray: (NSInteger) numItems{
    [idxArray removeAllObjects];
    for (NSInteger i=0; i<numItems; i++) {
        [idxArray addObject:[NSNumber numberWithInt:i]];
    }
}
-(void) gameCompleted:(NSInteger) gameIdx{
    NSMutableArray *tempGameStatus = [[NSMutableArray alloc] initWithArray: [gameStatusList objectForKey:@"GameCompleted"]];

    [tempGameStatus replaceObjectAtIndex:[gameNumber intValue] withObject:[NSNumber numberWithInt:1]];
    
    [gameStatusList setObject:tempGameStatus forKey:@"GameCompleted"];
    [self updatePListFile];
    
}
-(void)updatePListFile{
    [gameStatusList writeToFile:statusPlistPath atomically:YES];
}

-(void) dealloc{
	[super dealloc];
}

@end

@implementation NSMutableArray (Shuffling)

- (void)shuffle{
    for (NSInteger i = [self count] - 1; i > 0; --i) {
        [self exchangeObjectAtIndex: arc4random() % (i+1) withObjectAtIndex: i];
    }
}

@end
