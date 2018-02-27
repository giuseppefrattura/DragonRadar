//
//  LoginViewController.h
//  DragonBall
//
//  Created by Sergio Perticone on 14/07/2017.
//  Copyright © 2017 Sergio Perticone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *text;

@property NSDictionary *dict;
@property NSString* server;
	
@end
