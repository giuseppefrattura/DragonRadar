//
//  LoginViewController.m
//  DragonBall
//
//  Created by Sergio Perticone on 14/07/2017.
//  Copyright © 2017 Sergio Perticone. All rights reserved.
//

#import "LoginViewController.h"
#import "PlayViewController.h"

@interface LoginViewController ()


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

- (IBAction)doLogin :(id)sender {
    
    NSLog(@"trying to logging in");
    NSString *username = _text.text;
    /* TODO: perform login */
    [self pushSelector];
}


#pragma mark - Stuff
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"preparing for segue");
    PlayViewController *ctrl = segue.destinationViewController;
    ctrl.dict = _dict;
    ctrl.server = _server;
    
    
}

#define Server  @"https://enthousiaste-choucroute-38294.herokuapp.com"
#define DataURL @"https://enthousiaste-choucroute-38294.herokuapp.com/map"


-(void)pushSelector {
    [self performSegueWithIdentifier:@"play" sender:self];
}



@end
