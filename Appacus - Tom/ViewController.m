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
@synthesize question1;
@synthesize question2;
@synthesize question3;
@synthesize question4;
@synthesize question5;


- (IBAction)initialiseAction:(id)sender{
    NSMutableArray *chosenNumbers = [NSMutableArray array];
    
    for (int i=0 ;i<5 ;i++) {
        int num = 0;
        while (num == 0 || [chosenNumbers containsObject:[NSNumber numberWithInt:num]]) {
            num = arc4random() % 11;
            num++;
        }
        [chosenNumbers addObject:[NSNumber numberWithInt:num]];
        NSLog(@"%i",num);
        NSLog(@"2 x %@ = ", [chosenNumbers objectAtIndex:i]);
    }
    //NSLog(@"2 x %@ = ", [chosenNumbers objectAtIndex:2]);
    //[question1 setText:(@"2 x %@ =",[chosenNumbers objectAtIndex:1])];
    [question1 setText:[NSString stringWithFormat:@"2 x %@ = ", [chosenNumbers objectAtIndex:0]]];
    [question2 setText:[NSString stringWithFormat:@"2 x %@ = ", [chosenNumbers objectAtIndex:1]]];
    [question3 setText:[NSString stringWithFormat:@"2 x %@ = ", [chosenNumbers objectAtIndex:2]]];
    [question4 setText:[NSString stringWithFormat:@"2 x %@ = ", [chosenNumbers objectAtIndex:3]]];
    [question5 setText:[NSString stringWithFormat:@"2 x %@ = ", [chosenNumbers objectAtIndex:4]]];
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
