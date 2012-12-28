//
//  ViewController.h
//  Appacus - Tom
//
//  Created by Matthew Nieuwenhuys on 28/12/2012.
//  Copyright (c) 2012 Matthew Nieuwenhuys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

-(IBAction)initialiseAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *question1;

@property (weak, nonatomic) IBOutlet UILabel *question2;

@property (weak, nonatomic) IBOutlet UILabel *question3;

@property (weak, nonatomic) IBOutlet UILabel *question4;

@property (weak, nonatomic) IBOutlet UILabel *question5;

@property (weak, nonatomic) IBOutlet UILabel *answer1;

@property (weak, nonatomic) IBOutlet UILabel *answer2;

@property (weak, nonatomic) IBOutlet UILabel *answer3;

@property (weak, nonatomic) IBOutlet UILabel *answer4;

@property (weak, nonatomic) IBOutlet UILabel *answer5;


@end
