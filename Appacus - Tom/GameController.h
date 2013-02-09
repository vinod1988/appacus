//
//  GameController.h
//  Appacus - Tom
//
//  Created by Tom Beynon on 29/12/2012.
//  Copyright (c) 2012 Matthew Nieuwenhuys. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface GameController : NSObject
{
  NSMutableArray *questions;
  NSMutableArray *questionLevels;
  NSMutableArray *answers;
  NSMutableArray *userAnswers;
  NSMutableArray *levels;
  int userLevel;
  int numQuestions;
  int heldAnswer;
  int roundScore;
  int userScore;
  int userLives;
  BOOL roundComplete;
  BOOL gameOver;
}

@property (nonatomic, retain) NSMutableArray *questions;
@property (nonatomic, retain) NSMutableArray *questionLevels;
@property (nonatomic, retain) NSMutableArray *answers;
@property (nonatomic, retain) NSMutableArray *userAnswers;
@property (nonatomic, retain) NSMutableArray *levels;
@property int userLevel;
@property int userScore;
@property int userLives;
@property int numQuestions;
@property int heldAnswer;
@property int roundScore;
@property BOOL roundComplete;
@property BOOL gameOver;

-(void)repopulateGame;
-(int)numAnswered;
-(int)calculateAnswer:(int)question;
-(int)calculateScore;
-(void)updateScore;
-(void)updateLives;

@end