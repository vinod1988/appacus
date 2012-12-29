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
@synthesize questionLabels;
@synthesize answerLabels;

int level = 2;

- (IBAction)initialiseAction:(id)sender{
    
    NSMutableArray *questions = [NSMutableArray array]; // Holds the generated questions in order
    NSMutableArray *answerPositions = [NSMutableArray array]; // Holds the index of answers when placed
    
    for(int i=0;i<[questionLabels count];i++) {
        // Generates a unique question and assigns to questions array
        int questionVal = 0;
        while (questionVal == 0 || [questions containsObject:[NSNumber numberWithInt:questionVal]]) {
            questionVal = arc4random() % 12; // between 0 and 11
            questionVal++;
        }
        [questions addObject:[NSNumber numberWithInt:questionVal]];
        
        // Set questionLabel text
        id question = [questionLabels objectAtIndex:i];
        [question setText:[NSString stringWithFormat:@"%i x %i = ",level, questionVal]];
        
        // Calculate the answer
        int answerVal = level*questionVal;
        
        // Find a random answerLabel (not on the same-line ideally) to place the answer
        int answerPos = arc4random() % 5; // between 0 and 4;
        int loopCount = 0; // Variable to ensure loop doesn't get stuck
        // Loop if answerPosition has already been used, or it's on the same line as the question
        while([answerPositions containsObject:[NSNumber numberWithInt:answerPos]] || answerPos == i){
            answerPos = arc4random() % 5; // between 0 and 4
            loopCount++;
            // If loop runs more than 4 * questionCount, and answerPosition is available, go with it anyway.
            // This means the answer position is the same as question position
            // This functionality prevents same-row questionLabels and answerLabels *most* of the time
            // Without this, the system could run out positions _other_ than a same-row, and loop forever
            if(loopCount > ([questionLabels count]*4) && ![answerPositions containsObject:[NSNumber numberWithInt:answerPos]]){
                break;
            }
        }
        // Add answerPos to answerPositions array so we know it's been used
        [answerPositions addObject:[NSNumber numberWithInt:answerPos]];
        
        // Find the answer element and update it's text
        id answer = [answerLabels objectAtIndex:answerPos];
        [answer setText:[NSString stringWithFormat:@"%i", answerVal]];
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
