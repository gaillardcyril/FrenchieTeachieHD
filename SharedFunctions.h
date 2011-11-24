//
//  SharedFunctions.h
//  MooeeMath
//
//  Created by Cyril Gaillard on 3/01/11.
//  Copyright 2011 Voila Design. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "GADBannerView.h"

#define kLoopNumber_10 10

void shakeNumberToPick (CCMenu *itemsMenu,  NSInteger spriteTag);
void shakeNumberSprite (CCSprite *spriteToShake);
void displayBackground (CCSpriteBatchNode *currentBatch, NSString *BGString);
CCSpriteBatchNode *loadBatchNode (CCLayer *currentLayer, NSString *batchName);
NSDictionary *read_pList(NSString *plistName);
void gameEnded(CCLayer *currentLayer, NSInteger score, NSInteger numberQsts);
void displayBackHomeButton (CCLayer *currentLayer );
void displayBackSelButton (CCLayer *currentLayer );
void showSelectionPage();

void displayAd(CGSize adSize);
void removeAd();
void buyAllCharacters();
void clearTextures(CCSpriteBatchNode *batchNode);

