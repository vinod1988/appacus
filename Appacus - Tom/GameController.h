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
    NSMutableArray *answers;
    NSMutableArray *userAnswers;
    int level;
    int numQuestions;
    int heldAnswer;
    int total;
}

@property (nonatomic, retain) NSMutableArray *questions;
@property (nonatomic, retain) NSMutableArray *answers;
@property (nonatomic, retain) NSMutableArray *userAnswers;
@property int level;
@property int numQuestions;
@property int heldAnswer;
@property int total;

-(void)resetGame;
-(int)calculateScore;

@end