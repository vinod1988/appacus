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
@synthesize answerButtonPositions;
@synthesize levelLabel;
@synthesize scoreLabel;
@synthesize livesLabel;
@synthesize timeLabel;
@synthesize userNotified;
@synthesize gameLevel;
@synthesize labels;
@synthesize buttons;

// Run once scene (viewController) has loaded
- (void)viewDidLoad
{
  [scoreLabel setFont:[UIFont fontWithName:@"Architects Daughter" size:34]];
  [levelLabel setFont:[UIFont fontWithName:@"Architects Daughter" size:34]];
  [livesLabel setFont:[UIFont fontWithName:@"Architects Daughter" size:34]];
  UIFont *newFont = [UIFont fontWithName:@"Architects Daughter" size:30];
  [questionLabels setValue:newFont forKey:@"font"];
  [answerButtons setValue:newFont forKey:@"font"];
  [targetButtons setValue:newFont forKey:@"font"];
   UIFont *labelsFont = [UIFont fontWithName:@"Architects Daughter" size:20];
  [labels setValue:labelsFont forKey:@"font"];
  [buttons setValue:labelsFont forKey:@"font"];
  [answerLabels setValue:labelsFont forKey:@"font"];
   
  [super viewDidLoad];
  [self initialise];
}

- (void)initialise{
  [self initElementArrays];
  [self resetGame];
}

- (IBAction)touchAnswer:(id)sender
{
    // Only trigger an action if game is in progress
    if(![game roundComplete]){
        UIButton *button = (UIButton *)sender;
      // Get button position
      int position = [answerButtons indexOfObject:button];
        
      // Store the original position of the answer
      if([answerButtonPositions objectAtIndex:position] == (id)[NSNull null]){
        CGPoint buttonLocation = [button center];
        [answerButtonPositions replaceObjectAtIndex:position withObject:[NSValue valueWithCGPoint:buttonLocation]];
      }
    }
}

- (IBAction)dragAnswer:(id)sender forEvent:(UIEvent *)event {
  CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
  UIControl *answer = sender;
  answer.center = point;
}


- (IBAction)releaseAnswer:(id)sender forEvent:(UIEvent *)event {
  UIButton *button = (UIButton *)sender;
  int position = [answerButtons indexOfObject:button]; // Get button position
  int droppedTarget;
  bool found = false;
  for(int i=0;i<[targetButtons count];++i){
    id targetButton = [targetButtons objectAtIndex:i];
    CGSize targetSize = [targetButton size];
    CGPoint targetCenter = [targetButton center];
    float targetTop = targetCenter.y + (targetSize.height / 2);
    float targetRight = targetCenter.x + (targetSize.width / 2);
    float targetBottom = targetCenter.y - (targetSize.height / 2);
    float targetLeft = targetCenter.x - (targetSize.width / 2);
    CGPoint buttonCenter = [button center];
    if((buttonCenter.x > targetLeft &&
        buttonCenter.x < targetRight) &&
       (buttonCenter.y > targetBottom && buttonCenter.y < targetTop)){
      droppedTarget = i;
      found = true;
      break;
    }
  }
  if(found){
    // Check if this target has already been used
    if([[game userAnswers] objectAtIndex:droppedTarget] == (id)[NSNull null]){
      // Set that targetButton to the answer and remove the answerButton
      [self setTarget:droppedTarget withAnswer:position];
    }
  }else{
    id originalPosition = [answerButtonPositions objectAtIndex:position];
    [button setCenter:[originalPosition CGPointValue]];
  }
}

- (IBAction)touchUpTarget:(id)sender {
  
}
// Place the answer on the target if target is available. Otherwise, reset the question current in target
- (IBAction)touchDownTarget:(id)sender{
  // Only trigger an action if game is in progress
  if(![game roundComplete]){
    UIButton *targetButton = (UIButton *)sender;
    int targetIndex = [targetButtons indexOfObject:targetButton];
    [self replaceTarget:targetIndex];
  }
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
- (void)setTarget:(int)targetIndex withAnswer:(int)answerIndex{
  id targetButton = [targetButtons objectAtIndex:targetIndex];
  id answerButton = [answerButtons objectAtIndex:answerIndex];
  int answer = [[[game answers] objectAtIndex:answerIndex] integerValue];
  [answerButton setCenter:[targetButton center]];
  [[game userAnswers] replaceObjectAtIndex:targetIndex withObject:[NSNumber numberWithInt:answer]];
}

// Replace the questionButton currently 'on' targetButton.
- (void)replaceTarget:(int)position{
  id userAnswer = [[game userAnswers] objectAtIndex:position];
  
  if(userAnswer != [NSNull null]){
    
    int answerIndex = [[game answers] indexOfObject:userAnswer];
    id originalPosition = [answerButtonPositions objectAtIndex:answerIndex];
    id answerButton = [answerButtons objectAtIndex:answerIndex];
    [answerButton setCenter:[originalPosition CGPointValue]];
    // Remove from the userAnswers array
    [[game userAnswers] replaceObjectAtIndex:position withObject:[NSNull null]]; 
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
    [targetButton setBackgroundImage:[UIImage imageNamed:@"StarStroke.png"] forState: UIControlStateNormal];
    
    // Clear the answerLabel text
    id answerLabel = [answerLabels objectAtIndex:i];
    [answerLabel setText:[NSString stringWithFormat:@""]];
    
    // Set the answerButton text and style
    id answerButton = [answerButtons objectAtIndex:i];
    if([answerButtonPositions count] > 0){
      id originalPosition = [answerButtonPositions objectAtIndex:i];
      if(originalPosition != [NSNull null]){
        [answerButton setCenter:[originalPosition CGPointValue]];
      }
    }
    id answer = [[game answers] objectAtIndex:i];
    [answerButton setTitle:[NSString stringWithFormat:@"%i", [answer intValue]] forState: UIControlStateNormal];
    [answerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [answerButton setBackgroundImage:[UIImage imageNamed:@"Star Final.png"] forState: UIControlStateNormal];
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
    
  // Fill the answerButtonPositions array with null values
  answerButtonPositions = [[NSMutableArray alloc] init];
  for (int i = 0; i < [answerButtons count]; ++i){
    [answerButtonPositions addObject:[NSNull null]];
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
