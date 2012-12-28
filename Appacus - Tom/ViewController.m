//
//  ViewController.m
//  Appacus - Tom
//
//  Created by Matthew Nieuwenhuys on 28/12/2012.
//  Copyright (c) 2012 Matthew Nieuwenhuys. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize question1;
@synthesize question2;
@synthesize question3;
@synthesize question4;
@synthesize question5;
@synthesize answer1;
@synthesize answer2;
@synthesize answer3;
@synthesize answer4;
@synthesize answer5;

int level = 2;

- (IBAction)initialiseAction:(id)sender{
    NSMutableArray *chosenQuestions = [NSMutableArray array];
    NSMutableArray *answerPositions = [NSMutableArray array];

    for (int i=0 ;i<5 ;i++) {
        // Generate random question and add to chosenQuestions array
        int question = 0;
        while (question == 0 || [chosenQuestions containsObject:[NSNumber numberWithInt:question]]) {
            question = arc4random() % 11;
            question++;
        }
        [chosenQuestions addObject:[NSNumber numberWithInt:question]];
        
        // Generate answers from random questions 
        int answerPosition = 0;
        while (answerPosition == 0 || [answerPositions containsObject:[NSNumber numberWithInt:answerPosition]]) {
            answerPosition = arc4random() % 4;
            answerPosition++;
        }
        [answerPositions addObject:[NSNumber numberWithInt:answerPosition]];
    }
    
    //input the random questions from the chosenQuestions Array
    [question1 setText:[NSString stringWithFormat:@"%i x %@ = ",level, [chosenQuestions objectAtIndex:0]]];
    [question2 setText:[NSString stringWithFormat:@"%i x %@ = ",level, [chosenQuestions objectAtIndex:1]]];
    [question3 setText:[NSString stringWithFormat:@"%i x %@ = ",level, [chosenQuestions objectAtIndex:2]]];
    [question4 setText:[NSString stringWithFormat:@"%i x %@ = ",level, [chosenQuestions objectAtIndex:3]]];
    [question5 setText:[NSString stringWithFormat:@"%i x %@ = ",level, [chosenQuestions objectAtIndex:4]]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
