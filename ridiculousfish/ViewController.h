//
//  ViewController.h
//  ridiculousfish
//
//  Created by AJ on 3/30/14.
//  Copyright (c) 2014 AJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FISH.h"
#import "RNGridMenu.h"
#import <Social/Social.h>

CABasicAnimation* fishAnimation;

NSMutableDictionary * fishesArray;
NSMutableArray * fishesImage;
NSMutableArray* baitedFishes;

CGPoint location;
int Points;
BOOL isKillFishes;
BOOL directionBGIsUp;
NSTimer *timerScrollBackground, *timerFishesGenerator, *timerCountDeep;
float newHookX, newHoodY, minHookX, maxHookX, minHookY, maxHookY;
BOOL hookDragging;

BOOL waveMoveLeft;

// Currents deep
int currentDeeps = 0;
int deeps = 100;
int highestDeeps = 0;

// Current fishId
int currentFishId;

// Flag for fish have to flight on Sky
BOOL fromFlight;

// Current style
int currentStyle;

// Game is runnig
BOOL gameRunning;

// Start postion
CGPoint startPositionWave;
CGPoint startPositionSky;
CGPoint startPositionHook;
CGPoint startPositionShip;
CGPoint startPositionOcean;

#define ARC4RANDOM_MAX 0x100000000

@interface ViewController : UIViewController <RNGridMenuDelegate>
{
    IBOutlet UILabel *Scores;
    IBOutlet UILabel *Deep;
    IBOutlet UIImageView *Sky;
    IBOutlet UIImageView *Ocean;
    IBOutlet UIButton *Ship;
    IBOutlet UIImageView *Hook;
    IBOutlet UIImageView *Wave;
    IBOutlet UIButton *Switch;
}

-(IBAction)startGame:(id)sender;
-(IBAction)swichtStyle:(id)sender;

@end
