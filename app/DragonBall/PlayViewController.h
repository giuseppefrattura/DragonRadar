//
//  PlayViewController.h
//  DragonBall
//
//  Created by Sergio Perticone on 14/07/2017.
//  Copyright © 2017 Sergio Perticone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>
#import "ARCL-Swift.h"

@interface PlayViewController : UIViewController<CLLocationManagerDelegate, ARSessionDelegate> {
   	
    CLLocationManager *locationManager;

}

@property NSDictionary *dict;
@property NSString* server;
@property SceneLocationView *sceneLocationView;
@property (nonatomic, strong) IBOutlet ARSCNView *sceneView;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UIButton *indicator;



@end
