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
@synthesize questions;
@synthesize userAnswers;

- (IBAction)initialiseAction:(id)sender
{
    // Order questionLabels array by Y position
    self.questionLabels = [self.questionLabels sortedArrayUsingComparator:^NSComparisonResult(id label1, id label2) {
        if ([label1 frame].origin.y < [label2 frame].origin.y) return NSOrderedAscending;
        else if ([label1 frame].origin.y > [label2 frame].origin.y) return NSOrderedDescending;
        else return NSOrderedSame;
    }];
    
    
    // Order targetButtons array by Y position
    self.targetButtons = [self.targetButtons sortedArrayUsingComparator:^NSComparisonResult(id label1, id label2) {
        if ([label1 frame].origin.y < [label2 frame].origin.y) return NSOrderedAscending;
        else if ([label1 frame].origin.y > [label2 frame].origin.y) return NSOrderedDescending;
        else return NSOrderedSame;
    }];
    
    // Order answerButtons array by Y position
    self.answerButtons = [self.answerButtons sortedArrayUsingComparator:^NSComparisonResult(id label1, id label2) {
        if ([label1 frame].origin.y < [label2 frame].origin.y) return NSOrderedAscending;
        else if ([label1 frame].origin.y > [label2 frame].origin.y) return NSOrderedDescending;
        else return NSOrderedSame;
    }];
    
    // Initialise GameController object
    game = [[GameController alloc] init];
    
    // Set the level
    [game setLevel:2];
    
    // Set the number of questions. This could be calculated from the labels.. but this feels safer
    [game setNumQuestions:5];
    
    // Reset the game
    [game resetGame];
    
    // Set the labels from the answer and question arrays
    for(int i=0;i<[game numQuestions];i++) {
        // Set questionLabel text
        id questionLabel = [questionLabels objectAtIndex:i];
        id question = [[game questions] objectAtIndex:i];
        [questionLabel setText:[NSString stringWithFormat:@"%i x %i = ",level, [question intValue]]];
        
        // Find the answer element and update it's text
        id answerLabel = [answerButtons objectAtIndex:i];
        id answer = [[game answers] objectAtIndex:i];
        [answerLabel setTitle:[NSString stringWithFormat:@"%i", [answer intValue]] forState: UIControlStateNormal];
    }

}

- (IBAction)touchAnswer:(id)sender
{
    UIButton *button = (UIButton *)sender;
    // Get button position
    int position = [answerButtons indexOfObject:button];
    // Use button position as the index of answer in answers array
    id answer = [[game answers] objectAtIndex:position];
    
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

- (IBAction)touchTarget:(id)sender
{
    UIButton *targetButton = (UIButton *)sender;
    int position = [targetButtons indexOfObject:targetButton];
    int answer = [game heldAnswer];
    // Check if there is an answer in-hand
    if(answer > 0){
        int answerIndex = [[game answers] indexOfObject:[NSNumber numberWithInt:answer]];
        id answerButton = [answerButtons objectAtIndex:answerIndex];
        // Check if this target has already been used
        if([[game userAnswers] objectAtIndex:position] == (id)[NSNull null]){
            [[game userAnswers] replaceObjectAtIndex:position withObject:[NSNumber numberWithInt:answer]];
            [game setHeldAnswer:0]; // Reset held answer
            // Remove answer from answerButton
            [answerButton setTitleColor:[UIColor colorWithWhite:0 alpha:1] forState:UIControlStateNormal];
            [answerButton setTitle:[NSString stringWithFormat:@""]  forState: UIControlStateNormal];
            [answerButton setBackgroundImage:nil forState: UIControlStateNormal];
            // Appear to move the answer onto the target
            [targetButton setTitle:[NSString stringWithFormat:@"%i", answer]  forState: UIControlStateNormal];
            [targetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [targetButton setBackgroundImage:[UIImage imageNamed:@"AnswerBox.png"] forState: UIControlStateNormal];
            
        }
    }else{
        // User isn't dropping anything on the target. 
        // Check if there is an answer in this targetButton
        id userAnswer = [[game userAnswers] objectAtIndex:position];
        if(userAnswer != [NSNull null]){
            // Assume they want to revert it to blank 
            int originalPosition = [[game answers] indexOfObject:userAnswer];
            id originalButton = [answerButtons objectAtIndex:originalPosition];
            // Remove from the userAnswers array
            [[game userAnswers] replaceObjectAtIndex:position withObject:[NSNull null]];
            // Reset button states
            [originalButton setTitle:[NSString stringWithFormat:@"%i", [userAnswer intValue]]  forState: UIControlStateNormal];
            [originalButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [originalButton setBackgroundImage:[UIImage imageNamed:@"AnswerBox.png"] forState: UIControlStateNormal];
            [targetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [targetButton setTitle:[NSString stringWithFormat:@""]  forState: UIControlStateNormal];
            [targetButton setBackgroundImage:[UIImage imageNamed:@"TransparentAnswerBox.png"] forState: UIControlStateNormal];
        }
        
    }
}

- (IBAction)checkAnswers:(id)sender{
    
    int total = [game calculateScore];
    
    for(int i=0;i<[game numQuestions];i++) {
        id targetButton = [targetButtons objectAtIndex:i];
        id userAnswer = [[game userAnswers] objectAtIndex:i];
        id question = [[game questions] objectAtIndex:i];
        if(userAnswer != (id)[NSNull null] && level * [question intValue] == [userAnswer intValue]){
            [targetButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        }else{
            [targetButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
    }
    
    id alertMessage = [NSString stringWithFormat:@"You scored %i out of %i", total, [game numQuestions]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Well Done!"
                                                    message:alertMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    // Call initialiseAction to reset game
    //[self initialiseAction:nil];
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
