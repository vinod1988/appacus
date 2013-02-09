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
@synthesize levels;
@synthesize userLevel;
@synthesize userTimesTable;
@synthesize numQuestions;
@synthesize heldAnswer;
@synthesize roundScore;
@synthesize userScore;
@synthesize userLives;
@synthesize gameOver;

- (id)init
{
  self = [super init];
  if (self){
    // Initialization variables.
    questions = [[NSMutableArray alloc] init];
    answers = [[NSMutableArray alloc] init];
    userAnswers = [[NSMutableArray alloc] init];
    levels = [[NSMutableArray alloc] init];
    userLevel = 1;
    userTimesTable = 2;
    numQuestions = 0;
    heldAnswer = 0;
    roundScore = 0;
    userScore = 0;
    userLives = 3;
    
    // Load levels
    [levels addObject:[NSArray arrayWithObjects: [NSNumber numberWithInteger:1], [NSNumber numberWithInteger:2], [NSNumber numberWithInteger:5], [NSNumber numberWithInteger:6], [NSNumber numberWithInteger:10], nil]];
    
    [levels addObject:[NSArray arrayWithObjects: [NSNumber numberWithInteger:3], [NSNumber numberWithInteger:4], [NSNumber numberWithInteger:5], [NSNumber numberWithInteger:6], [NSNumber numberWithInteger:11], nil]];
    
    [levels addObject:[NSArray arrayWithObjects: [NSNumber numberWithInteger:3], [NSNumber numberWithInteger:7], [NSNumber numberWithInteger:8], [NSNumber numberWithInteger:9], [NSNumber numberWithInteger:12], nil]];
  }
  return self;
}

- (void)repopulateGame{
  [questions removeAllObjects];
  [answers removeAllObjects];
  [userAnswers removeAllObjects];
  heldAnswer = 0;
  if(numQuestions > 0){
    for (int i = 0; i < numQuestions; ++i){
      [userAnswers addObject:[NSNull null]];
    }
  }
  [self generateQuestions];
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
  return userTimesTable * question;
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
}

- (BOOL)gameComplete{
  if(userLevel >= [levels count] && [self levelComplete]){
    return true;
  }else{
    return false;
  }
}

- (BOOL)levelComplete{
  if([self roundScore] == numQuestions){
    return true;
  }else{
    return false;
  }
}

- (BOOL)roundComplete{
  if([self numAnswered] == numQuestions){
    return true;
  }else{
    return false;
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
  // Generate null answers initially
  for (int i = 0; i < numQuestions; ++i){
    [answers addObject:[NSNull null]];
  }

  for(int i=0;i<numQuestions;i++) {
    // Find the multiplier from the level
    id questionRange;
    if(userLevel > [levels count]){
      questionRange = [[NSMutableArray alloc] init];
      for(int i=1;i<=12;++i){
        [questionRange addObject:[NSNumber numberWithInt:i]];
      }
    }else{
      questionRange = [levels objectAtIndex:(userLevel-1)];
    }
    // Generates a question with a unique answer and assigns to questions array
    int questionVal = 0;
    while (questionVal == 0 || [questions containsObject:[NSNumber numberWithInt:questionVal]]) {
      int randomIndex = arc4random() % [questionRange count]; // between 0 and count-1
      questionVal = [[questionRange objectAtIndex:randomIndex] intValue];
    }
    [questions addObject:[NSNumber numberWithInt:questionVal]];
    
    int answerVal = userTimesTable*questionVal;
    int answerPos = arc4random() % 5; // between 0 and 4;
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
