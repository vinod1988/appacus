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
@synthesize questionLevels;
@synthesize answers;
@synthesize userAnswers;
@synthesize levels;
@synthesize userLevel;
@synthesize numQuestions;
@synthesize heldAnswer;
@synthesize roundScore;
@synthesize userScore;
@synthesize userLives;
@synthesize roundComplete;
@synthesize gameOver;

- (id)init
{
  self = [super init];
  if (self){
    // Initialization variables.
    questions = [[NSMutableArray alloc] init];
    questionLevels = [[NSMutableArray alloc] init];
    answers = [[NSMutableArray alloc] init];
    userAnswers = [[NSMutableArray alloc] init];
    levels = [[NSMutableArray alloc] init];
    userLevel = 1;
    numQuestions = 0;
    heldAnswer = 0;
    roundScore = 0;
    userScore = 0;
    userLives = 3;
    roundComplete = false;
    
    // Load levels
    [levels addObject:[NSArray arrayWithObjects: [NSNumber numberWithInteger:2], [NSNumber numberWithInteger:4], [NSNumber numberWithInteger:6], nil]];
    
    [levels addObject:[NSArray arrayWithObjects: [NSNumber numberWithInteger:3], [NSNumber numberWithInteger:5], [NSNumber numberWithInteger:8], nil]];
    
    [levels addObject:[NSArray arrayWithObjects: [NSNumber numberWithInteger:7], [NSNumber numberWithInteger:9], nil]];
  }
  return self;
}

- (void)repopulateGame{
  [questions removeAllObjects];
  [questionLevels removeAllObjects];
  [answers removeAllObjects];
  [userAnswers removeAllObjects];
  heldAnswer = 0;
  roundComplete = false;
  if(numQuestions > 0){
    for (int i = 0; i < numQuestions; ++i){
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

- (int)calculateAnswer:(int)questionIndex{
  int question = [[questions objectAtIndex:questionIndex] integerValue];
  int multiplier = [[questionLevels objectAtIndex:questionIndex] integerValue];
    return multiplier * question;
}

- (int)calculateScore{
    id question;
    id userAnswer;
    int total = 0;
    for(int i=0;i<numQuestions;i++){
        question = [questions objectAtIndex:i];
        userAnswer = [userAnswers objectAtIndex:i];
        if(userAnswer != (id)[NSNull null] && [self calculateAnswer:i] == [userAnswer intValue]){
            total++;
        }
    }
    return total;
}

- (void)updateScore{
    roundScore = [self calculateScore];
    userScore = userScore + roundScore;
    if([self numAnswered] == numQuestions){
      roundComplete = true;
    }
}

- (void)updateLives{
    if(roundScore < numQuestions){
        --userLives;
    }
    if(userLives < 0){
        gameOver = true;
    }
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
    // Generate null levels and answers initially
    for (int i = 0; i < numQuestions; ++i){
        [answers addObject:[NSNull null]];
    }
    
    for(int i=0;i<numQuestions;i++) {
      // Find the multiplier from the level
      id multipliers = [levels objectAtIndex:(userLevel-1)];
      int random = arc4random() % [multipliers count];
      int multiplier = [[multipliers objectAtIndex:random] integerValue];
      [questionLevels addObject:[NSNumber numberWithInt:multiplier]];
      // Calculate the answer
      id question = [questions objectAtIndex:i];
      int answerVal = multiplier*[question intValue];
      
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
