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

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answerButtons;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

-(IBAction)touchAnswer:(id)sender;

-(IBAction)touchTarget:(id)sender;

-(IBAction)checkAnswers:(id)sender;

@end

GameController *game;

