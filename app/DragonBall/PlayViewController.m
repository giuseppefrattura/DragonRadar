//
//  PlayViewController.m
//  DragonBall
//
//  Created by Sergio Perticone on 14/07/2017.
//  Copyright © 2017 Sergio Perticone. All rights reserved.
//

#import "PlayViewController.h"

#define NSPHERES 3

struct Sphere {
    int id;
    double lat;
    double lon;
    bool found;
};

typedef struct Sphere Sphere;

Sphere spheres[NSPHERES];
bool added[100];


@interface PlayViewController ()

@end

@implementation PlayViewController

SCNVector3 nextPos;
//SCNNode *boxNode;
SCNScene *scene;


- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_sceneLocationView) {
        _sceneLocationView = [[SceneLocationView alloc] init];
    }
    
    [_sceneLocationView run];
    [self.view addSubview:_sceneLocationView];
    
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(45.4616857, 9.19444117);
    CLLocation *location = [[CLLocation alloc] initWithCoordinate:(CLLocationCoordinate2D)coordinates altitude:2];
    UIImage *palla = [UIImage imageNamed:@"ball.png"];
    LocationAnnotationNode *annotationNode = [[LocationAnnotationNode alloc] initWithLocation:location image:palla];
    [_sceneLocationView addLocationNodeWithConfirmedLocationWithLocationNode:annotationNode];
    
    /*
    // Do any additional setup after loading the view.
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
    scene = [SCNScene new];
    
    [self addSphere:scene param1:1];
    self.sceneView.scene = scene;
    
    UIImage *btnImage = [UIImage imageNamed:@"arrow.png"];
    [_indicator setImage:btnImage forState:UIControlStateNormal];
    
    NSDictionary *map =    [_dict objectForKey: @"map"];
    
    NSDictionary *dicspheres =    [map objectForKey: @"spheres"];
    
    int i = 0;
    for (NSDictionary *s in dicspheres) {
        NSNumber *sid = [s objectForKey:@"id"];
        NSNumber *longit = [s objectForKey:@"longitude"];
        NSNumber *latid = [s objectForKey:@"latitude"];
        spheres[i].id = [sid intValue];
        spheres[i].lat = [latid doubleValue];
        spheres[i].lon = [longit doubleValue];
        i++;
    }
     */
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    ARWorldTrackingSessionConfiguration *configuration = [ARWorldTrackingSessionConfiguration new];
    
    [self.sceneView.session runWithConfiguration:configuration];
    self.sceneView.session.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.sceneView.session pause];
}

- (void) session:(ARSession *)session didUpdateFrame:(nonnull ARFrame *)frame {
    nextPos = self.sceneView.pointOfView.position;
    nextPos.x += 2;
    NSLog(@"%f,%f,%f", nextPos.x, nextPos.y, nextPos.z);
}


- (void) addSphere:(SCNScene *)scene param1:(int)idsphere{
    
    SCNView *scnView = (SCNView *)self.view;
    
    SCNSphere *planetSphere = [SCNSphere sphereWithRadius:0.01];
    SCNNode *sphereNode = [SCNNode nodeWithGeometry:planetSphere];
    [scene.rootNode addChildNode:sphereNode];
    
    
    SCNMaterial *corona = [SCNMaterial material];
    corona.diffuse.contents = [UIImage imageNamed:@"dragonBall1"];
    corona.specular.contents = [UIColor colorWithWhite:0.6 alpha:1.0];
    corona.shininess = 0.5;
    [planetSphere removeMaterialAtIndex:0];
    planetSphere.materials = @[corona];
    
    // create and add a light to the scene
    scnView.autoenablesDefaultLighting = YES;
    
    // create and add a camera to the scene
    scnView.allowsCameraControl = true;

    scnView.scene = scene;
    
    
//    SCNSphere *sphere =[SCNSphere
//                        sphereWithRadius:0.1];
//
//    if (added[idsphere]) {
//        return;
//    }
//
//    added[idsphere] = true;
//
//    SCNNode *boxNode = [SCNNode nodeWithGeometry:sphere];
//    boxNode.position=self.sceneView.pointOfView.position;
//
//    SCNMaterial *corona = [SCNMaterial material];
//    corona.diffuse.contents = [UIImage imageNamed:@"ball"];
//    corona.specular.contents = [UIColor colorWithWhite:0.6 alpha:1.0];
//    corona.shininess = 0.9;
//    [sphere removeMaterialAtIndex:0];
//    sphere.materials = @[corona];
//
//    [scene.rootNode addChildNode: boxNode];
}

#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) (x * 180.0 / M_PI)

- (float)getHeadingForDirectionFromCoordinate:(CLLocationCoordinate2D)fromLoc toCoordinate:(CLLocationCoordinate2D)toLoc
{
    float fLat = degreesToRadians(fromLoc.latitude);
    float fLng = degreesToRadians(fromLoc.longitude);
    float tLat = degreesToRadians(toLoc.latitude);
    float tLng = degreesToRadians(toLoc.longitude);
    
    float degree = radiansToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)));
    
    if (degree >= 0) {
        return degree;
    } else {
        return 360+degree;
    }
}


// callback
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSString *fmt = @"%f";
    
 
    int i;
    CLLocation *minLoc = 0;
    double min = 0.0;
    for (i=0; i<NSPHERES; i++) {
        if (spheres[i].found) {
            continue;
        }
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)spheres[i].lat longitude: (CLLocationDegrees)spheres[i].lon];
        CLLocationDistance distance = [newLocation distanceFromLocation:loc];
        NSLog(@"distance: %d %f", spheres[i].id, distance);
        if (distance < min) {
            min = distance;
            minLoc = loc;
        }
        if (distance < 10) {
            [self addSphere:scene param1:spheres[i].id];
        }
    }
    _distance.text = [NSString stringWithFormat:@"%f", min];
    float angle = [self getHeadingForDirectionFromCoordinate: newLocation.coordinate toCoordinate:minLoc.coordinate];
    NSLog(@"angle: %f", angle);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
