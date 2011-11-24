//
//  MultiLayerScene.h
//  ScenesAndLayers
//
//  Created by Steffen Itterheim on 28.07.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// Using an enum to define tag values has the upside that you can select


@interface GameStatus : NSObject {
	NSMutableDictionary *gameStatusList;
    NSString* statusPlistPath;
    NSString *gameName;
    NSString *gameType;
    NSMutableArray *idxArray;
    NSNumber *gameNumber;
    NSArray* names;
}

// Accessor methods to access the various layers of this scene
+(GameStatus*) sharedGameStatus;
-(void)updatePListFile;
-(BOOL) gamePurchased;
-(void)initIdxArray: (NSInteger) numItems;
@property (nonatomic,retain) NSMutableDictionary *gameStatusList;
@property (nonatomic,retain) NSString* statusPlistPath;
@property (nonatomic,retain) NSString *gameName;
@property (nonatomic,retain) NSString *gameType;
@property (nonatomic,retain) NSMutableArray *idxArray;
@property (nonatomic,retain) NSNumber *gameNumber;
@property (nonatomic, retain) NSArray *names;
@end

@interface NSMutableArray (Shuffling)
- (void)shuffle;
@end

