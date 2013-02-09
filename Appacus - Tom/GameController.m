//
//  GameController.m
//  Appacus - Tom
//
//  Created by Tom Beynon on 29/12/2012.
//  Copyright (c) 2012 Matthew Nieuwenhuys. All rights reserved.
//

#import "GameController.h"

@implementation GameController
@synthesize questions;
@synthesize answers;
@synthesize userAnswers;
@synthesize level;
@synthesize numQuestions;
@synthesize heldAnswer;
@synthesize total;
@synthesize userScore;
@synthesize complete;

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization variables.
        questions = [[NSMutableArray alloc] init];
        answers = [[NSMutableArray alloc] init];
        userAnswers = [[NSMutableArray alloc] init];
        level = 0;
        numQuestions = 0;
        heldAnswer = 0;
        total = 0;
        userScore = 0;
        complete = false;
    }
    
    return self;
}

- (void)repopulateGame{
    [questions removeAllObjects];
    [answers removeAllObjects];
    [userAnswers removeAllObjects];
    heldAnswer = 0;
    total = 0;
    complete = false;
    if(numQuestions > 0){
        for (int i = 0; i < numQuestions; ++i)
        {
            [userAnswers addObject:[NSNull null]];
        }
    }
    [self generateQuestions];
    [self generateAnswers];
}

- (int)numAnswered{
    int num = 0;
    id userAnswer;
    for(userAnswer in userAnswers){
        if(userAnswer != [NSNull null]){
            num++;
        }
    }
    return num;
}

- (int)calculateAnswer:(int)question{
    return level * question;
}

- (int)calculateScore{
    id question;
    id userAnswer;
    total = 0;
    NSLog(@"%@",questions);
    for(int i=0;i<numQuestions;i++){
        question = [questions objectAtIndex:i];
        userAnswer = [userAnswers objectAtIndex:i];
        if(userAnswer != (id)[NSNull null] && [self calculateAnswer:[question intValue]] == [userAnswer intValue]){
            total++;
        }
    }
    return total;
}

- (void)updateScore{
    userScore = userScore + [self calculateScore];
}

- (void)notifyScore{
    id alertMessage = [NSString stringWithFormat:@"You scored %i out of %i", total, numQuestions];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Well Done!"
                                                    message:alertMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)generateQuestions{
    for(int i=0;i<numQuestions;i++) {
        // Generates a unique question and assigns to questions array
        int questionVal = 0;
        while (questionVal == 0 || [questions containsObject:[NSNumber numberWithInt:questionVal]]) {
            questionVal = arc4random() % 12; // between 0 and 11
            questionVal++;
        }
        [questions addObject:[NSNumber numberWithInt:questionVal]];
    }
}

- (void)generateAnswers{
    // Generate null answers initially
    for (int i = 0; i < numQuestions; ++i){
        [answers addObject:[NSNull null]];
    }
    
    for(int i=0;i<numQuestions;i++) {
        // Calculate the answer
        id question = [questions objectAtIndex:i];
        int answerVal = level*[question intValue];
        
        // Find a random answerLabel (not on the same-line ideally) to place the answer
        int answerPos = arc4random() % 5; // between 0 and 4;
        // Loop if answerPosition has already been used, or it's on the same line as the question
        while([answers objectAtIndex:answerPos] != (id)[NSNull null] || answerPos == i){
            answerPos = arc4random() % 5; // between 0 and 4
            // If we're generating the last answer position, and we've found a free position, it must be the only one available
            if(i >= numQuestions-1 && [answers objectAtIndex:answerPos] == (id)[NSNull null]){
                break;
            }
        }
        
        // Add answer to answers array at answerPos
        [answers replaceObjectAtIndex:answerPos withObject:[NSNumber numberWithInt:answerVal]];
    }
}

@end
