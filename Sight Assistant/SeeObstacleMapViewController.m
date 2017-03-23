//
//  SeeObstacleMapViewController.m
//  Sight Assistant
//
//  Created by Rares Soponar on 19/03/2017.
//  Copyright © 2017 Rares Soponar. All rights reserved.
//

#import "SeeObstacleMapViewController.h"

@interface SeeObstacleMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) double regionCenterLat;
@property (nonatomic) double regionCenterLon;

@end

@implementation SeeObstacleMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    [self initView];
    [self addAllPins];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)initView {
    for (Obstacle *obst in self.obstacles) {
        self.regionCenterLat = self.regionCenterLat + obst.start.coordinate.latitude + obst.end.coordinate.latitude;
        self.regionCenterLon = self.regionCenterLon + obst.start.coordinate.longitude + obst.end.coordinate.longitude;
    }
    
    CLLocation *centerCoord = [[CLLocation alloc] initWithLatitude:self.regionCenterLat/(self.obstacles.count * 2) longitude:self.regionCenterLon/(self.obstacles.count * 2)];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centerCoord.coordinate, 1000, 1000);
    
    [self.mapView setRegion:region animated:NO];
}

-(void)addAllPins {
    for (Obstacle *obst in self.obstacles) {
        MKPointAnnotation *startMapPin = [[MKPointAnnotation alloc] init];
        MKPointAnnotation *endMapPin = [[MKPointAnnotation alloc] init];
        
        double startLatitude = obst.start.coordinate.latitude;
        double startLongitude = obst.start.coordinate.longitude;
        
        double endLatitude = obst.end.coordinate.latitude;
        double endLongitude = obst.end.coordinate.longitude;
        
        CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake(startLatitude, startLongitude);
        CLLocationCoordinate2D endCoordinate = CLLocationCoordinate2DMake(endLatitude, endLongitude);
        
        startMapPin.coordinate = startCoordinate;
        endMapPin.coordinate = endCoordinate;
        
        [self.mapView addAnnotation:startMapPin];
        [self.mapView addAnnotation:endMapPin];
        
        // Create 2 placemarks, one for the blind user and one for helper
        MKPlacemark *p1 = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(startLatitude, startLongitude) addressDictionary:nil];
        MKPlacemark *p2 = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(endLatitude, endLongitude) addressDictionary:nil];
        
        // Create 2 mapitems from that 2 placemarks
        MKMapItem *mi1 = [[MKMapItem alloc] initWithPlacemark:p1];
        MKMapItem *mi2 = [[MKMapItem alloc] initWithPlacemark:p2];
        
        // Create directionRequest to set the destination and the source
        MKDirectionsRequest *directionRequest = [[MKDirectionsRequest alloc] init];
        directionRequest.source = mi2;
        directionRequest.destination = mi1;
        directionRequest.transportType = MKDirectionsTransportTypeWalking;
        directionRequest.requestsAlternateRoutes = NO;
        
        // Get directions for the route and put it on the mapview
        MKDirections *directions = [[MKDirections alloc] initWithRequest:directionRequest];
        
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error){
            MKRoute *route = response.routes[0];
            [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        }];

    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *polyLineView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    polyLineView.strokeColor = [UIColor blueColor];
    polyLineView.lineWidth = 4.0;
    
    return polyLineView;
}

@end