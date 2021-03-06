//
//  SeeObstacleMapViewController.h
//  Sight Assistant
//
//  Created by Rares Soponar on 19/03/2017.
//  Copyright © 2017 Rares Soponar. All rights reserved.
//

#import "ViewController.h"
#import "Obstacle.h"
#import <MapKit/MapKit.h>

@interface SeeObstacleMapViewController : ViewController <MKMapViewDelegate>

@property (nonatomic, assign) BOOL showAllObstacles;
@property (nonatomic, strong) Obstacle *obstacle;
@property (nonatomic, strong) NSMutableArray *obstacles;

@property (nonatomic, strong) CLLocation *startOfObstacle;
@property (nonatomic, strong) CLLocation *endOfObstacle;
@property (nonatomic, strong) CLLocation *smallObstacle;

@end
