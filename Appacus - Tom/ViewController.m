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
@synthesize questions;
@synthesize answers;

int level = 2;

- (IBAction)initialiseAction:(id)sender{
    NSMutableArray *chosenQuestions = [NSMutableArray array];
    NSMutableArray *answerPositions = [NSMutableArray array];
    // Generates a unique x in (level * x), assigns to array and sets label text
    int i = 0;
    id question;
    for(question in questions) {
        // Generate random question and add to chosenQuestions array
        int questionVal = 0;
        while (questionVal == 0 || [chosenQuestions containsObject:[NSNumber numberWithInt:questionVal]]) {
            questionVal = arc4random() % 12; // between 0 and 11
            questionVal++;
        }
        [chosenQuestions addObject:[NSNumber numberWithInt:questionVal]];
        [question setText:[NSString stringWithFormat:@"%i x %i = ",level, questionVal]];
        i++;
    }
    
    // Finds a unique index to randomize answer positions
    for(i=0;i<5;i++){
        int answerPos = arc4random() % 5; // between 0 and 4;
        while([answerPositions containsObject:[NSNumber numberWithInt:answerPos]] && answerPos != i){
            answerPos = arc4random() % 5; // between 0 and 4
        }
        // Add to answerPos to answerPositions array
        // This gives us an array of keys 0-4 (question position) with values 0-4 (answer position)
        [answerPositions addObject:[NSNumber numberWithInt:answerPos]];
    }
    // Find answerVal and set answer text
    id answer;
    id answerIndex;
    int answerVal = 0;
    int answerCounter = 0;
    
    for(answer in answers){
        // Find the answer position for question at answerCounter
        answerIndex = [answerPositions objectAtIndex:answerCounter];
        // Find question
        question = [chosenQuestions objectAtIndex: [answerIndex intValue]];
        answerVal = level*[question intValue];
        [answer setText:[NSString stringWithFormat:@"%i", answerVal]];
        answerCounter++;
    }

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
