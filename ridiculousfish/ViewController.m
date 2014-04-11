//
//  ViewController.m
//  ridiculousfish
//
//  Created by AJ on 3/30/14.
//  Copyright (c) 2014 AJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Get start position
    startPositionHook = Hook.center;
    startPositionShip = Ship.center;
    startPositionWave = Wave.center;
    startPositionSky = Sky.center;
    startPositionOcean = Ocean.center;
    
    [self newGame];
    
    [Scores setFont:[UIFont fontWithName:@"Villa" size:51]];
    [Deep setFont:[UIFont fontWithName:@"Villa" size:21]];
    // Init deeps
    [Deep setText:[NSString stringWithFormat:@"%dm", currentDeeps]];
    [Deep setTextColor:[UIColor orangeColor]];
    [Scores setTextColor:[UIColor orangeColor]];
    
    //[self generateFish];
    
    //    Wave move
    waveMoveLeft = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(moverWave) userInfo:nil repeats:YES];
    //    [self performSelector:@selector(generateFish) withObject:nil afterDelay:1];
    
    [self.view bringSubviewToFront:Sky];
    [self.view bringSubviewToFront:Ship];
    [self.view bringSubviewToFront:Wave];
    [self.view bringSubviewToFront:Scores];
    [self.view bringSubviewToFront:Deep];
    //    [self.view removeConstraints:self.view.constraints];
    
    currentStyle = 1;
    gameRunning = NO;
    [self initializationFishes];
}

-(void)newGame{
    gameRunning = NO;
    [timerFishesGenerator invalidate];
    timerFishesGenerator=nil;
    [timerScrollBackground invalidate];
    timerScrollBackground=nil;
    [timerCountDeep invalidate];
    timerCountDeep=nil;
    
    Hook.center = startPositionHook;
    Ship.center = startPositionShip;
    Wave.center = startPositionWave;
    Sky.center = startPositionSky;
    Ocean.center = startPositionOcean;
    highestDeeps = 0;
    currentDeeps = 0;
    Points = 0;
    // Init score
    Points = 0;
    [Scores setText:[NSString stringWithFormat:@"%d", Points]];
    // Init deeps
    [Deep setText:[NSString stringWithFormat:@"%dm", currentDeeps]];
    for (id key in fishesArray) {
        FISH *fish = [fishesArray objectForKey:key];
        [fish.image removeFromSuperview];
        fish.image.image = nil;
    }
    fishesArray = [[NSMutableDictionary alloc] init];
    baitedFishes = [[NSMutableArray alloc] init];
    
    // Init current fish id
    currentFishId = 1;
    
    // Flag to fish have to flight
    fromFlight = NO;
    //Ship.enabled = YES;
}
-(IBAction)swichtStyle:(id)sender{
    if (gameRunning==NO) {
        switch (currentStyle) {
            case 0:
                fishesImage = [[NSMutableArray alloc]initWithObjects:@"style2_1.png", @"dstyle2_2.png", @"style2_3.png", @"style2_4.png", @"style2_5.png", @"style2_6.png", @"style2_7.png", @"style2_8.png", @"style2_9.png", @"style2_10.png", @"style2_11.png", @"style2_12.png", @"style2_13.png", @"style2_14.png", @"style2_15.png", @"style2_16.png", nil];
                Ocean.image = [UIImage imageNamed:@"ocean2.png"];
                Sky.image = [UIImage imageNamed:@"sky2.png"];
                [Deep setTextColor:[UIColor orangeColor]];
                [Scores setTextColor:[UIColor orangeColor]];
                currentStyle=1;
                break;
            case 1:
                fishesImage = [[NSMutableArray alloc]initWithObjects:@"fish1.png", @"fish2.png", @"fish3.png", @"fish4.png", @"fish5.png", @"fish6.png", @"fish7.png", @"fish8.png", @"fish9.png", @"fish10.png", @"fish11.png", @"fish12.png", @"fish13.png", @"fish14.png", @"fish15.png", @"fish16.png", @"fish17.png", @"fish18.png", nil];
                Ocean.image = [UIImage imageNamed:@"ocean1.png"];
                Sky.image = [UIImage imageNamed:@"sky1.png"];
                currentStyle=2;
                [Deep setTextColor:[UIColor blackColor]];
                [Scores setTextColor:[UIColor blackColor]];
                break;
            case 2:
                fishesImage = [[NSMutableArray alloc]initWithObjects:@"style3_1.png", @"dstyle3_2.png", @"style3_3.png", @"style3_4.png", @"style3_5.png", @"style3_6.png", @"style3_7.png", @"style3_8.png", @"style3_9.png", nil];
                Ocean.image = [UIImage imageNamed:@"ocean3.png"];
                Sky.image = [UIImage imageNamed:@"sky3.png"];
                [Deep setTextColor:[UIColor whiteColor]];
                [Scores setTextColor:[UIColor whiteColor]];
                currentStyle=0;
                break;
            default:
                break;
        }
    }
}

-(IBAction)startGame:(id)sender{
    if (gameRunning==NO) {
        directionBGIsUp=NO;
        isKillFishes = NO;
        //Ship.enabled = NO;
        gameRunning =YES;
        // Init score
        Points = 0;
        [Scores setText:[NSString stringWithFormat:@"%d", Points]];
        
        // Init deeps
        [Deep setText:[NSString stringWithFormat:@"%d/%dm", currentDeeps, deeps]];
        
        // Start generate fishes
        timerFishesGenerator = [NSTimer scheduledTimerWithTimeInterval:0.9 target:self selector:@selector(generateFishes) userInfo:nil repeats:YES];
        
        // start croll backgroud
        timerScrollBackground = [NSTimer scheduledTimerWithTimeInterval:0.015 target:self selector:@selector(moverBackground) userInfo:nil repeats:YES];
        
        // start croll backgroud
        timerCountDeep = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(countDeep) userInfo:nil repeats:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)countDeep{
    if (directionBGIsUp==YES) {
        if (currentDeeps>0) {
            currentDeeps--;
        }
    }else{
        currentDeeps++;
        highestDeeps = currentDeeps;
    }
    [Deep setText:[NSString stringWithFormat:@"%d/%dm", currentDeeps, deeps]];
}

-(void)moverWave{
    @try {
        if (waveMoveLeft==YES) {
            Wave.center = CGPointMake(Wave.center.x-1, Wave.center.y);
        }else{
            Wave.center = CGPointMake(Wave.center.x+1, Wave.center.y);
        }
        if (Wave.center.x<0) {
            waveMoveLeft=NO;
        }
        if (Wave.center.x > self.view.bounds.size.width) {
            waveMoveLeft=YES;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
}

#pragma Fishes configuration

-(void)initializationFishes{
    fishesImage = [[NSMutableArray alloc]initWithObjects:@"style2_1.png", @"dstyle2_2.png", @"style2_3.png", @"style2_4.png", @"style2_5.png", @"style2_6.png", @"style2_7.png", @"style2_8.png", @"style2_9.png", @"style2_10.png", @"style2_11.png", @"style2_12.png", @"style2_13.png", @"style2_14.png", @"style2_15.png", @"style2_16.png", nil];
}

-(BOOL)checkBaited:(UIImageView*)hook theFish:(UIImageView*)fish theFishId:(int)fishId{
    @try {
        float minX = hook.center.x - hook.bounds.size.width/2;
        float maxX = hook.center.x + hook.bounds.size.width/2;
        float minY = hook.center.y + hook.bounds.size.height/2 - 25;
        float maxY = hook.center.y + hook.bounds.size.height/2;
        if (fish.center.x >= minX && fish.center.x <= maxX && fish.center.y >= minY && fish.center.y <= maxY) {
            if ([baitedFishes containsObject:[NSNumber numberWithInt:fishId]]==NO) {
                [baitedFishes addObject:[NSNumber numberWithInt:fishId]];
            }
            return YES;
        }
        if ((fish.center.x-fish.bounds.size.width/2) >= minX && (fish.center.x-fish.bounds.size.width/2) <= maxX && fish.center.y >= minY && fish.center.y <= maxY) {
            if ([baitedFishes containsObject:[NSNumber numberWithInt:fishId]]==NO) {
                [baitedFishes addObject:[NSNumber numberWithInt:fishId]];
            }
            return YES;
        }
        if ((fish.center.x+fish.bounds.size.width/2) >= minX && (fish.center.x+fish.bounds.size.width/2) <= maxX && fish.center.y >= minY && fish.center.y <= maxY) {
            if ([baitedFishes containsObject:[NSNumber numberWithInt:fishId]]==NO) {
                [baitedFishes addObject:[NSNumber numberWithInt:fishId]];
            }
            return YES;
        }
        if (fish.center.x >= minX && fish.center.x <= maxX && (fish.center.y-fish.bounds.size.height/2) >= minY && (fish.center.y-fish.bounds.size.height/2) <= maxY) {
            if ([baitedFishes containsObject:[NSNumber numberWithInt:fishId]]==NO) {
                [baitedFishes addObject:[NSNumber numberWithInt:fishId] ];
            }
            return YES;
        }
        if (fish.center.x >= minX && fish.center.x <= maxX && (fish.center.y+fish.bounds.size.height/2) >= minY && (fish.center.y+fish.bounds.size.height/2) <= maxY) {
            if ([baitedFishes containsObject:[NSNumber numberWithInt:fishId]]==NO) {
                [baitedFishes addObject:[NSNumber numberWithInt:fishId]];
            }
            return YES;
        }
        return NO;
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
}

-(void)generateFishes{
    @try {
        [self generateFish];
        [self generateFish];
        [self generateFish];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
}

-(void)generateFish{
    @try {
        UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed: fishesImage[arc4random()%fishesImage.count]]];
        imageview.frame = CGRectMake(arc4random() % (int)self.view.bounds.size.width, self.view.bounds.size.height, imageview.frame.size.width, imageview.frame.size.height);
        FISH *fish = [[FISH alloc] init];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        fish.image = imageview;
        if (arc4random()%2==0) {
            fish.pos = CGPointMake(0.7, 2);
        }else{
            // drand48()
            fish.pos = CGPointMake(-0.7, 1.9);
            //        fish.image.image = [UIImage imageWithCGImage:[fish.image image].CGImage scale:[fish.image image].scale orientation:UIImageOrientationUp];
            fish.image.transform = CGAffineTransformScale(fish.image.transform, -1, 1);
        }
        
        fish.alive = YES;
        fish.score = 1;
        fish.fishId = currentFishId;
        currentFishId ++;
        fish.lastY = fish.image.center.y;
        fish.baited = NO;
        fish.baitedDown = NO;
        [fishesArray setObject:fish forKey:[NSNumber numberWithInt:fish.fishId]];
        [self fishAction:fish theOption:UIViewAnimationOptionCurveEaseIn];
        [self.view addSubview:imageview];
        [self.view bringSubviewToFront:imageview];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    
}

#pragma Move fish by it self
-(void)fishAction:(FISH*)fish theOption:(UIViewAnimationOptions)options{
    @try {
        [UIView animateWithDuration: 0.01f
                              delay: 0.0f
                            options: options
                         animations: ^{
                             if (fish.image.center.y < Wave.center.y) {
                                 fish.image.transform = CGAffineTransformRotate(fish.image.transform, M_PI / 21);
                             }
                             if ([baitedFishes containsObject:[NSNumber numberWithInt:fish.fishId]] || [self checkBaited:Hook theFish:fish.image theFishId:fish.fishId]==YES) { // is bait
                                 
                                 directionBGIsUp = YES;
                                 fish.baited = YES;
                                 /// There is baited fishes stay in Ocean
                                 //                             if (fish.image.center.y > Wave.center.y) {
                                 if (fromFlight==NO) {
                                     fish.image.center = CGPointMake(Hook.center.x, Hook.center.y+Hook.bounds.size.height/2+fish.image.bounds.size.height/2-5);
                                     
                                 }else{
                                     isKillFishes=YES;
                                     [self fishMover:fish];
                                     //NSLog(@"%f, %f, %f, %f", fish.image.center.x, fish.image.center.y, fish.pos.x, fish.pos.y);
                                 }
                                 
                             }else{
                                 [self fishMover:fish];
                             }
                         }
                         completion: ^(BOOL finished) {
                             if (finished) {
                                 if (fish.alive) {
                                     // if flag still set, keep spinning with constant speed
                                     [self fishAction:fish theOption:UIViewAnimationOptionCurveLinear];
                                 } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                     // one last spin, with deceleration
                                     [self fishAction:fish theOption:UIViewAnimationOptionCurveEaseOut];
                                 }
                             }
                         }];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
}

-(void)fishMover:(FISH*)fish{
    @try {
        // x axis
        if (fish.image.center.x-fish.image.frame.size.width/2>self.view.bounds.size.width || fish.image.center.x+fish.image.frame.size.width<0) {
            fish.pos = CGPointMake(-fish.pos.x, fish.pos.y);
            if (fish.image.center.y > Wave.center.y) {
                fish.image.transform = CGAffineTransformScale(fish.image.transform, -1, 1);
            }
            
        }
        // y axis
        // down
        if(directionBGIsUp==YES){
            if (fish.baited==NO) {
                fish.pos = CGPointMake(fish.pos.x, -fabs(fish.pos.y));
            }else{
                // is baited
                if (fish.image.center.y <= 0) {
                    fish.baitedDown = YES; // fish wars started down
                }
                if (fish.baitedDown==NO) {
                    if (fish.lastY < fish.image.center.y - fish.pos.y) {
                        fish.pos = CGPointMake(fish.pos.x, -fish.pos.y);
                    }
                }else{
                    if (fish.image.center.y>=Wave.center.y) {
                        fish.image.hidden = YES;
                        fish.alive = NO;
                    }
                    fish.pos = CGPointMake(fish.pos.x, -fabs(fish.pos.y)); // fish is downing
                    
                }
            }
            fish.image.center = CGPointMake(fish.image.center.x + (1.5*fish.pos.x), fish.image.center.y - (1.7*fish.pos.y));
            //        fish.image.frame = CGRectMake(fish.image.frame.origin.x + fish.pos.x, fish.image.frame.origin.y-(1.5*fish.pos.y), fish.image.frame.size.width, fish.image.frame.size.height);
        }else{
            fish.image.center = CGPointMake(fish.image.center.x + (1.5*fish.pos.x), fish.image.center.y - (1.5*fish.pos.y));
        }
        fish.lastY = fish.image.center.y;
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
}

#pragma Mover background
-(void)moverBackground{
    @try {
        if (directionBGIsUp==YES) {
            // Turn off timer
            [timerFishesGenerator invalidate];
            timerFishesGenerator = nil;
            if (Wave.center.y + 50 < self.view.bounds.size.height) {
                Sky.center = CGPointMake(Sky.center.x, Sky.center.y+2);
                Ship.center = CGPointMake(Ship.center.x, Ship.center.y+2);
                Wave.center = CGPointMake(Wave.center.x, Wave.center.y+2);
                if (Wave.center.y-Hook.center.y >= startPositionWave.y-startPositionHook.y) {
                    Hook.center = CGPointMake(Hook.center.x, Hook.center.y+2);
                    fromFlight = YES;
                }
            }else{
                fromFlight=YES;
            }
            
            // check game over
            // NSLog(@"%f, %f", Hook.center.y, Wave.center.y);
            if ([self gameOver]==YES) {
                [timerScrollBackground invalidate];
                timerScrollBackground = nil;
                [self showGrid];
            }
            
            if (currentDeeps>92) {
                Hook.center = CGPointMake(Hook.center.x, Hook.center.y-1);
            }
        }else{
            if (Ocean.center.y + Ocean.bounds.size.height/2 > self.view.bounds.size.height) {
                //            NSLog(@"%f", Background.center.y + Background.bounds.size.height/2);
                Sky.center = CGPointMake(Sky.center.x, Sky.center.y-2);
                Ocean.center = CGPointMake(Ocean.center.x, Ocean.center.y-2);
                Ship.center = CGPointMake(Ship.center.x, Ship.center.y-2);
                Wave.center = CGPointMake(Wave.center.x, Wave.center.y-2);
            }else{
                if (currentDeeps < deeps) {
                    Sky.center = CGPointMake(Sky.center.x, Sky.center.y-2);
                    //                Ocean.center = CGPointMake(Ocean.center.x, Ocean.center.y-2);
                    Ship.center = CGPointMake(Ship.center.x, Ship.center.y-2);
                    Wave.center = CGPointMake(Wave.center.x, Wave.center.y-2);
                    //                if (Hook.center.y + Hook.bounds.size.height/2 < self.view.bounds.size.height) {
                    if (deeps - currentDeeps < 8 && Hook.center.y + Hook.bounds.size.height/2 < self.view.bounds.size.height) {
                        Hook.center = CGPointMake(Hook.center.x, Hook.center.y+1);
                    }
                }else{
                    directionBGIsUp=YES; // Is limitted
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
}

-(BOOL)gameOver{
    @try {
        if (isKillFishes==YES) {
            FISH *fish;
            for (int i=0; i<baitedFishes.count; i++) {
                fish = [fishesArray objectForKey:baitedFishes[i]];
                if (fish.alive==YES) {
                    return NO;
                }
            }
            return YES;
        }
        return  NO;
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
}

#pragma Moving hook
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    @try {
        if(isKillFishes==YES){
            UITouch *touch = [[event allTouches] anyObject];
            location = [touch locationInView:touch.view];
            FISH *fish;
            for (int i=0; i<baitedFishes.count; i++) {
                fish = [fishesArray objectForKey:baitedFishes[i]];
                if (fish.alive==YES && location.x-fish.image.bounds.size.width/2 <= fish.image.center.x && location.x+fish.image.bounds.size.width/2 >= fish.image.center.x && location.y-fish.image.bounds.size.height/2 <= fish.image.center.y && location.y+fish.image.bounds.size.height/2 >= fish.image.center.y) {
                    //fish.image.hidden = YES;
                    fish.alive = NO;
                    [fish.image removeFromSuperview];
                    
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(fish.image.frame.origin.x, fish.image.frame.origin.y, 28, 30)];
                    imageview.image = [UIImage imageNamed:@"blood.png"];
                    Points += fish.score;
                    [Scores setText:[NSString stringWithFormat:@"%d", Points]];
                    imageview.hidden = NO;
                    [self.view addSubview:imageview];
                    [UIView animateWithDuration:2.0 delay:2.0 options:0 animations:^{
                        // Animate the alpha value of your imageView from 1.0 to 0.0 here
                        imageview.alpha = 0.1f;
                    } completion:^(BOOL finished) {
                        // Once the animation is completed and the alpha has gone to 0.0, hide the view for good
                        imageview.hidden = YES;
                    }];
                    break;
                }
            }
        }else{
            UITouch *touch = [[event allTouches] anyObject];
            CGPoint touchLocation = [touch locationInView:touch.view];
            maxHookX = Hook.center.x + Hook.bounds.size.width/2;
            minHookX = Hook.center.x - Hook.bounds.size.width/2;
            maxHookY = Hook.center.y + Hook.bounds.size.height/2;
            minHookY = Hook.center.y + Hook.bounds.size.height/2 - 30;
            if(touchLocation.x>=minHookX && touchLocation.x <=maxHookX
               && touchLocation.y >=minHookY && touchLocation.y <=maxHookY){
                hookDragging = YES;
                newHookX = touchLocation.x;
                newHoodY = touchLocation.y;
            }
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (isKillFishes==NO) {
        hookDragging = NO;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    @try {
        if(isKillFishes==NO){
            UITouch *touch = [[event allTouches] anyObject];
            CGPoint touchLocation = [touch locationInView:touch.view];
            if (hookDragging==YES) {
                CGPoint point = Hook.center;
                point.x = touchLocation.x;
                //point.y = touchLocation.y - Hook.bounds.size.height/2;
                Hook.center = point;
                FISH *fish;
                for (int i=0; i<baitedFishes.count; i++) {
                    fish = [fishesArray objectForKey:baitedFishes[i]];
                    fish.image.center = CGPointMake(Hook.center.x, Hook.center.y+Hook.bounds.size.height/2+fish.image.bounds.size.height/2-5);
                    
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    
}



#pragma Show popup
- (void)showGrid {
    NSInteger numberOfOptions = 5;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"ship.png"] title:[NSString stringWithFormat:@"%d", Points]],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"deephook.png"] title:[NSString stringWithFormat:@"%d", highestDeeps]],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"facebook.png"] title:@"Facebook"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"twitter.png"] title:@"Twitter"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"newgame.png"] title:@"NEW GAME"]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    av.itemFont =[UIFont fontWithName:@"Villa" size:15];
    //    av.bounces = NO;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Unlogin in Facebook"
                                                        message:@"Please login to Facebook first!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    UIImage *image = [self screenshot];
    NSString *message = [NSString stringWithFormat:@"Ridiculous Fishing - Here we go, my score :) - deep: %dm, kills: %d", highestDeeps, Points];
    switch (itemIndex) {
        case 2:
            // Share facebook
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
            {
                SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                [facebookSheet setInitialText:message];
                [facebookSheet addImage:image];
                [facebookSheet addURL:[NSURL URLWithString:@"https://www.facebook.com/levantai"]];
                [self presentViewController:facebookSheet animated:YES completion:nil];
            }else{
                alertView.title = @"Sorry";
                alertView.message = @"You can't send a status right now, make sure your device has an internet connection and you have at least one Facebook account setup!";
                
                [alertView show];
            }
            break;
        case 3:
            // Share twitter
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                [tweetSheet setInitialText:message];
                // Share image
                [tweetSheet addImage:image];
                // Share link
                [tweetSheet addURL:[NSURL URLWithString:@"@levantAJ"]];
                
                [self presentViewController:tweetSheet animated:YES completion:nil];
            }
            else{
                alertView.title = @"Sorry";
                alertView.message = @"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup!";
                [alertView show];
            }
            break;
        default:
            break;
    }
    [self newGame];
}

#pragma Take sapshot
- (UIImage *) screenshot{
    CGRect rect;
    rect=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
