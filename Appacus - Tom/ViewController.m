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
@synthesize targetButtons;
@synthesize answerButtons;

// Run once scene (viewController) has loaded
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initElementArrays];
    
    // Initialise GameController object if not initialized
    if(![game isKindOfClass:[GameController class]]){
        // Reset the game
        [self resetGame];
    }
}

// 'Hold' the answer if it hasn't been placed already
- (IBAction)touchAnswer:(id)sender
{
    // Only trigger an action if game is in progress
    if(![game complete]){
        UIButton *button = (UIButton *)sender;
        int position = [answerButtons indexOfObject:button]; // Get button position
        id answer = [[game answers] objectAtIndex:position]; // Use button position as the index of answer in answers array
        
        // Has this answer been placed already?
        if(![[game userAnswers] containsObject:answer]){
            // Highlight button colour
            [button setTitleColor:[UIColor colorWithWhite:1 alpha:1] forState:UIControlStateNormal];
            // Reset currently held answer to it's original position if available
            if([game heldAnswer] > 0){
                int previousIndex = [[game answers] indexOfObject:[NSNumber numberWithInt:[game heldAnswer]]];
                id previousButton = [answerButtons objectAtIndex:previousIndex];
                [previousButton setTitleColor:[UIColor colorWithWhite:0 alpha:1] forState:UIControlStateNormal];
            }
            // This answer has been 'picked up'
            [game setHeldAnswer:[answer intValue]];
        }
    }
}

// Place the answer on the target if target is available. Otherwise, reset the question current in target
- (IBAction)touchTarget:(id)sender
{
    // Only trigger an action if game is in progress
    if(![game complete]){
        UIButton *targetButton = (UIButton *)sender;
        int position = [targetButtons indexOfObject:targetButton];
        int answer = [game heldAnswer];
        // Check if there is an answer in-hand
        if(answer > 0){
            int answerIndex = [[game answers] indexOfObject:[NSNumber numberWithInt:answer]];
            id answerButton = [answerButtons objectAtIndex:answerIndex];
            // Check if this target has already been used
            if([[game userAnswers] objectAtIndex:position] == (id)[NSNull null]){
                // Set that targetButton to the answer and remove the answerButton
                NSLog(@"%i", answer);
                [self setTarget:targetButton withAnswer:answerButton]; 
                [game setHeldAnswer:0]; // Reset held answer
            }
        }else{
            // User isn't dropping anything on the target. 
            // Reset buttons if possible
            [self replaceTarget:targetButton];
            
        }
    }
}

- (IBAction)checkAnswers:(id)sender{
    
    UIButton *checkButton = (UIButton *)sender;
    
    // Only trigger an action if game is in progress
    if(![game complete]){
    
        [game calculateScore];
        
        for(int i=0;i<[game numQuestions];i++) {
            id targetButton = [targetButtons objectAtIndex:i];
            id userAnswer = [[game userAnswers] objectAtIndex:i];
            id question = [[game questions] objectAtIndex:i];
            if(userAnswer != (id)[NSNull null] && [game calculateAnswer:[question intValue]] == [userAnswer intValue]){
                [targetButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            }else{
                [targetButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
        
        [game notifyScore];
        
        // Check if user has answered all questions. If so, allow user to reset game.
        // This could be used to send the user elsewhere, such as into the next level
        if([game numAnswered] == [game numQuestions]){
            [game setComplete:true]; // Tell game that it's now complete
            [checkButton setTitle:[NSString stringWithFormat:@"Reset game"] forState:UIControlStateNormal]; // Switch checkButton title to 'Reset game'. checkAnswers handles the rest
        }
    }else{
        // Reset view and game
        [self resetGame];
        [checkButton setTitle:[NSString stringWithFormat:@"Check"] forState:UIControlStateNormal]; // Switch checkButton title back to 'Check'
    }
}

// Set the targetButton to answerButton and 'remove' answerButton
- (void)setTarget:(id)targetButton withAnswer:(id)answerButton{
    int targetPosition = [targetButtons indexOfObject:targetButton];
    int answerPosition = [answerButtons indexOfObject:answerButton];
    // Find the answer from the answerPosition
    int value = [[[game answers] objectAtIndex:answerPosition] intValue];
    [[game userAnswers] replaceObjectAtIndex:targetPosition withObject:[NSNumber numberWithInt:value]];
    // Remove answer from answerButton
    [answerButton setTitleColor:[UIColor colorWithWhite:0 alpha:1] forState:UIControlStateNormal];
    [answerButton setTitle:[NSString stringWithFormat:@""]  forState: UIControlStateNormal];
    [answerButton setBackgroundImage:nil forState: UIControlStateNormal];
    // Appear to move the answer onto the target
    [targetButton setTitle:[NSString stringWithFormat:@"%i", value]  forState: UIControlStateNormal];
    [targetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [targetButton setBackgroundImage:[UIImage imageNamed:@"AnswerBox.png"] forState: UIControlStateNormal];
}

// Replace the questionButton currently 'on' targetButton.
- (void)replaceTarget:(id)targetButton{
    int targetindex = [targetButtons indexOfObject:targetButton];
    id userAnswer = [[game userAnswers] objectAtIndex:targetindex];
    if(userAnswer != [NSNull null]){
        // Find the original position of the answer currently 'on' the targetButton
        int originalPosition = [[game answers] indexOfObject:userAnswer];
        id originalButton = [answerButtons objectAtIndex:originalPosition];
        [[game userAnswers] replaceObjectAtIndex:targetindex withObject:[NSNull null]]; // Remove from the userAnswers array
        // Reset answer to it's original button
        [originalButton setTitle:[NSString stringWithFormat:@"%i", [userAnswer intValue]]  forState: UIControlStateNormal];
        [originalButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [originalButton setBackgroundImage:[UIImage imageNamed:@"AnswerBox.png"] forState: UIControlStateNormal];
        // Reset targetButton to empty style
        [targetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [targetButton setTitle:[NSString stringWithFormat:@""]  forState: UIControlStateNormal];
        [targetButton setBackgroundImage:[UIImage imageNamed:@"TransparentAnswerBox.png"] forState: UIControlStateNormal];
    }
}

// (Re)set the game and populate the game elements with corresponding answers and questions
- (void)resetGame{
    game = [[GameController alloc] init];
    
    [game setLevel:2];
    [game setNumQuestions:5];
    
    // Reset the game
    [game repopulateGame];
    
    // Set the labels from the answer and question arrays
    for(int i=0;i<[game numQuestions];i++) {
        // Set questionLabel text
        id questionLabel = [questionLabels objectAtIndex:i];
        id question = [[game questions] objectAtIndex:i];
        [questionLabel setText:[NSString stringWithFormat:@"%i x %i = ",[game level], [question intValue]]];
        
        // Reset target button style
        id targetButton = [targetButtons objectAtIndex:i];
        [targetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [targetButton setTitle:[NSString stringWithFormat:@""]  forState: UIControlStateNormal];
        [targetButton setBackgroundImage:[UIImage imageNamed:@"TransparentAnswerBox.png"] forState: UIControlStateNormal];
        
        // Set the answerButton text and style
        id answerButton = [answerButtons objectAtIndex:i];
        id answer = [[game answers] objectAtIndex:i];
        [answerButton setTitle:[NSString stringWithFormat:@"%i", [answer intValue]] forState: UIControlStateNormal];
        [answerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [answerButton setBackgroundImage:[UIImage imageNamed:@"AnswerBox.png"] forState: UIControlStateNormal];
    }
}

- (void)initElementArrays{
    // Order questionLabels array by tag
    self.questionLabels = [self.questionLabels sortedArrayUsingComparator:^NSComparisonResult(id label1, id label2) {
        if ([label1 tag] < [label2 tag]) return NSOrderedAscending;
        else if ([label1 tag] > [label2 tag]) return NSOrderedDescending;
        else return NSOrderedSame;
    }];
    
    
    // Order targetButtons array by tag
    self.targetButtons = [self.targetButtons sortedArrayUsingComparator:^NSComparisonResult(id label1, id label2) {
        if ([label1 tag] < [label2 tag]) return NSOrderedAscending;
        else if ([label1 tag] > [label2 tag]) return NSOrderedDescending;
        else return NSOrderedSame;
    }];
    
    // Order answerButtons array by tag
    self.answerButtons = [self.answerButtons sortedArrayUsingComparator:^NSComparisonResult(id label1, id label2) {
        if ([label1 tag] < [label2 tag]) return NSOrderedAscending;
        else if ([label1 tag] > [label2 tag]) return NSOrderedDescending;
        else return NSOrderedSame;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
