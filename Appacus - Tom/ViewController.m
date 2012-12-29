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
    for(i=0;i<[questions count];i++){
        int answerPos = arc4random() % 5; // between 0 and 4;
        int loopCount = 1; // Variable to ensure loop doesn't get stuck
        while([answerPositions containsObject:[NSNumber numberWithInt:answerPos]] || answerPos == i){
            answerPos = arc4random() % 5; // between 0 and 4
            loopCount++;
            // If loop runs more than 2 * questionCount, and answerPosition is available, go with it anyway.
            // This means the answer position is the same as question position
            // This functionality prevents same-row questions and answers *most* of the time
            // Without this, the system could run out positions _other_ than a same-row, and loop forever
            if(loopCount > ([questions count]*2) && ![answerPositions containsObject:[NSNumber numberWithInt:answerPos]]){
                break;
            }
        }
        // Add to answerPos to answerPositions array
        // This gives us an array of keys 0-4 (question position) with values 0-4 (answer position)
        [answerPositions addObject:[NSNumber numberWithInt:answerPos]];
    }
    
    // Loop through questions, calculate answers and update labels
    id answer;
    id answerIndex;
    int answerVal = 0;
    int questionCounter = 0;
    
    for(i=0;i<[questions count];i++){
        // Find the question and answer position
        question = [chosenQuestions objectAtIndex:questionCounter];
        answerIndex = [answerPositions objectAtIndex:questionCounter];
        // Work out the answer
        answerVal = level*[question intValue];
        // Find the answer element and update it's text
        answer = [answers objectAtIndex:[answerIndex intValue]];
        [answer setText:[NSString stringWithFormat:@"%i", answerVal]];
        // Move on to the next question
        questionCounter++;
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
