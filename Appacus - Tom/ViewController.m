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
@synthesize answerLabels;
@synthesize answerButtons;
@synthesize levelLabel;
@synthesize scoreLabel;
@synthesize livesLabel;
@synthesize userNotified;
@synthesize gameLevel;

// Run once scene (viewController) has loaded
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self initialise];
}

- (void)initialise{
  [self initElementArrays];
  [self resetGame];
}


// 'Hold' the answer if it hasn't been placed already
- (IBAction)touchAnswer:(id)sender
{
    // Only trigger an action if game is in progress
    if(![game roundComplete]){
        UIButton *button = (UIButton *)sender;
        int position = [answerButtons indexOfObject:button]; // Get button position
        id answer = [[game answers] objectAtIndex:position]; // Use button position as the index of answer in answers array
        
        // Is this answer in hand, or been placed already?
        if([answer intValue] != [game heldAnswer] && ![[game userAnswers] containsObject:answer]){
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
- (IBAction)touchDownTarget:(id)sender{
  // Only trigger an action if game is in progress
  if(![game roundComplete]){
    UIButton *targetButton = (UIButton *)sender;
    int position = [targetButtons indexOfObject:targetButton];
    // Check if there is an answer in-hand
    if([game heldAnswer] > 0){
      int answerIndex = [[game answers] indexOfObject:[NSNumber numberWithInt:[game heldAnswer]]];
      id answerButton = [answerButtons objectAtIndex:answerIndex];
      // Check if this target has already been used
      if([[game userAnswers] objectAtIndex:position] != (id)[NSNull null]){
          [self replaceTarget:targetButton];
      }
      // Set that targetButton to the answer and remove the answerButton
      [self setTarget:targetButton withAnswer:answerButton];
      [game setHeldAnswer:0]; // Reset held answer
    }else{
        // User isn't dropping anything on the target. 
        // Reset buttons if possible
        [self replaceTarget:targetButton];
        
    }
  }
}

-(IBAction)touchUpTarget:(id)sender{
  
}

- (IBAction)roundAction:(id)sender{
    
    if([game numAnswered] == [game numQuestions]){
      UIButton *checkButton = (UIButton *)sender;
      
      if(userNotified){
        if([game gameOver]){
          // Button intended to reset game
          [self resetGame];
          [checkButton setTitle:[NSString stringWithFormat:@"Check"] forState:UIControlStateNormal];
        }else if([game gameComplete]){
          [self nextLevel];
          [checkButton setTitle:[NSString stringWithFormat:@"Check"] forState:UIControlStateNormal];
        }else if([game levelComplete]){
          [self nextLevel];
          [checkButton setTitle:[NSString stringWithFormat:@"Check"] forState:UIControlStateNormal];
        }else if([game roundComplete]){
          // Button intended to retry round
          [self resetRound];
          [checkButton setTitle:[NSString stringWithFormat:@"Check"] forState:UIControlStateNormal];
        }
        userNotified = false;
      }else{
        // Button intended to check answers
        [self checkAnswers];
        if([game gameOver]){
          // Warn of game over and update button to reset
          [self notifyGameOver];
          [checkButton setTitle:[NSString stringWithFormat:@"Start Again"] forState:UIControlStateNormal];
        }else if([game levelComplete]){
          // Continue to the next level!
          [self notifyLevelComplete];
          [checkButton setTitle:[NSString stringWithFormat:@"Next Level"] forState:UIControlStateNormal];
        }else{
          // Notify score and allow to retry round
          [self notifyFailure];
          [checkButton setTitle:[NSString stringWithFormat:@"Try Again"] forState:UIControlStateNormal];
        }
        userNotified = true;
      }
      
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please attempt all questions"
                                                        message:@"Please attempt all questions before checking your answers"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)backAction:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)checkAnswers{
  [game updateScore];
  [game updateLives];
  
  if(![game gameOver]){
    [livesLabel setText:[NSString stringWithFormat:@"%i",[game userLives]]];
  }
  
  [scoreLabel setText:[NSString stringWithFormat:@"%i",[game userScore]]];
  
  // Colour answers to show correct/incorrect
  for(int i=0;i<[game numQuestions];i++) {
    id targetButton = [targetButtons objectAtIndex:i];
    id userAnswer = [[game userAnswers] objectAtIndex:i];
    //id question = [[game questions] objectAtIndex:i];
    int correctAnswer = [game calculateAnswer:i];
    if(userAnswer != (id)[NSNull null] && correctAnswer == [userAnswer intValue]){
      // Correct answer
      [targetButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    }else{
      // Incorrect answer
      id answerLabel = [answerLabels objectAtIndex:i]; // Find the answer label
      [answerLabel setText:[NSString stringWithFormat:@"The correct answer was %i", correctAnswer]];
      [targetButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
  }
  
}

- (void)notifyGameComplete{
  
  id alertMessage = [NSString stringWithFormat:@"You've completed all the levels"];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Well done!"
                                                  message:alertMessage
                                                 delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  [alert show];
}

- (void)notifyLevelComplete{
  
  id alertMessage = [NSString stringWithFormat:@"You answered every question correctly"];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Well done!"
                                                  message:alertMessage
                                                 delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  [alert show];
}

- (void)notifyFailure{
  
    id alertMessage = [NSString stringWithFormat:@"You scored %i out of %i", [game roundScore], [game numQuestions]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Try again"
                                                    message:alertMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)notifyGameOver{
  id alertMessage = [NSString stringWithFormat:@"You scored %i", [game userScore]];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                  message:alertMessage
                                                 delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  [alert show];
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

- (void)nextLevel{
  [game setUserLevel:[game userLevel]+1];
  [self resetRound];
}

- (void)resetGame{
  game = [[GameController alloc] init];
  [game setUserTimesTable:gameLevel];
  [game setNumQuestions:5];
  
  [game repopulateGame];
  [self resetView];
}

// (Re)set the round and populate the game elements with corresponding answers and questions
- (void)resetRound{
  [game repopulateGame];
  [self resetView];
}

- (void)resetView{
  
  [levelLabel setText:[NSString stringWithFormat:@"%i",[game userLevel]]];
  [livesLabel setText:[NSString stringWithFormat:@"%i",[game userLives]]];
  [scoreLabel setText:[NSString stringWithFormat:@"%i",[game userScore]]];
  
  // Set the labels from the answer and question arrays
  for(int i=0;i<[game numQuestions];i++) {
    // Set questionLabel text
    id questionLabel = [questionLabels objectAtIndex:i];
    id question = [[game questions] objectAtIndex:i];
    [questionLabel setText:[NSString stringWithFormat:@"%i x %i = ", [game userTimesTable], [question intValue]]];
    
    // Reset target button style
    id targetButton = [targetButtons objectAtIndex:i];
    [targetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [targetButton setTitle:[NSString stringWithFormat:@""]  forState: UIControlStateNormal];
    [targetButton setBackgroundImage:[UIImage imageNamed:@"TransparentAnswerBox.png"] forState: UIControlStateNormal];
    
    // Clear the answerLabel text
    id answerLabel = [answerLabels objectAtIndex:i];
    [answerLabel setText:[NSString stringWithFormat:@""]];
    
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
  
  // Order targetButtons array by tag
  self.answerLabels = [self.answerLabels sortedArrayUsingComparator:^NSComparisonResult(id label1, id label2) {
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
