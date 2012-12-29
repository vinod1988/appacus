//
//  ViewController.h
//  Appacus - Tom
//
//  Created by Matthew Nieuwenhuys on 28/12/2012.
//  Copyright (c) 2012 Matthew Nieuwenhuys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

-(IBAction)initialiseAction:(id)sender;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *questionLabels;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *answerLabels;

@end
