//
//  MainViewController.m
//  DragonBall
//
//  Created by Sergio Perticone on 14/07/2017.
//  Copyright © 2017 Sergio Perticone. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"

@interface MainViewController ()

@property BOOL dataIsReady;
@property NSDictionary *dict;


@end

#define Server  @"https://dragonball-radar.herokuapp.com"
#define DataURL @"https://dragonball-radar.herokuapp.com/map"


@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Stuff
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"preparing for segue");
    LoginViewController *ctrl = segue.destinationViewController;
    ctrl.dict = _dict;
    ctrl.server = Server;
    

}

    
-(void)pushSelector {
    [self performSegueWithIdentifier:@"start" sender:self];
}


- (IBAction)go {

    NSURL *url = [NSURL URLWithString:DataURL];

                  
    [self downloadDataFromURL:url onSuccess:^void() { [self pushSelector]; _dataIsReady = YES; } ];
    
}

- (void)showAlertWithTitle: (NSString *)title andError: (NSError*)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:error.localizedDescription delegate:nil cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}


-(BOOL)parseData:(NSData *)data {
    NSError *error;
    _dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error != nil) {
        dispatch_async(dispatch_get_main_queue(), ^void() {
            [self showAlertWithTitle: NSLocalizedString(@"Unexpected problem", nil) andError:error];
        });
        return NO;
    }
   
    return YES;
}

    -(void)downloadDataFromURL:(NSURL *)url onSuccess:(void(^)())handler {
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        NSURLSessionTask *task = [session dataTaskWithRequest:req completionHandler:^void(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), ^void() {
                    [self showAlertWithTitle: NSLocalizedString(@"Could not download data", nil) andError:error];
                });
                return;
            }
            [self parseData: data];
            dispatch_async(dispatch_get_main_queue(), ^void() {
                    handler();
                }
            );
        }];
        [task resume];
    }


@end
