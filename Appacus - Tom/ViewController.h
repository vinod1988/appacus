//
//  ViewController.h
//  Appacus - Tom
//
//  Created by Matthew Nieuwenhuys on 28/12/2012.
//  Copyright (c) 2012 Matthew Nieuwenhuys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameController.h"


@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *questionLabels;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *targetButtons;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *answerLabels;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answerButtons;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *livesLabel;

@property int gameLevel;

@property BOOL userNotified;

@property (nonatomic, retain) NSMutableArray *answerButtonPositions;

-(void)initialise;

- (IBAction)dragAnswer:(id)sender forEvent:(UIEvent *)event;

- (IBAction)releaseAnswer:(id)sender forEvent:(UIEvent *)event;

-(IBAction)touchUpTarget:(id)sender;

-(IBAction)touchDownTarget:(id)sender;

-(IBAction)roundAction:(id)sender;

-(IBAction)touchAnswer:(id)sender;

-(IBAction)backAction:(id)sender;

@end

GameController *game;

