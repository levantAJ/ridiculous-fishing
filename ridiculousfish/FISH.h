//
//  FISH.h
//  ridiculousfish
//
//  Created by AJ on 3/30/14.
//  Copyright (c) 2014 AJ. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FISH : NSObject
{
    UIImageView *image;
    CGPoint pos;
    BOOL alive;
    int score;
}

@property(nonatomic, retain) UIImageView *image;
@property int fishId;
@property CGPoint pos;
@property BOOL alive;
@property int score;
@property float lastY;
@property BOOL baited;
@property BOOL baitedDown;

@end
