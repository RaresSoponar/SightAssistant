//
//  CreateObstacleViewController.m
//  Sight Assistant
//
//  Created by Rares Soponar on 22/03/2017.
//  Copyright © 2017 Rares Soponar. All rights reserved.
//

#import "CreateObstacleViewController.h"

@interface CreateObstacleViewController ()

@property (weak, nonatomic) IBOutlet UITextField *obstacleNameField;
@property (weak, nonatomic) IBOutlet UITextField *obstacleShortDescriptionField;
@property (weak, nonatomic) IBOutlet UITextField *obstacleTypeField;
@property (weak, nonatomic) IBOutlet UITextField *obstacleSizeField;
@property (weak, nonatomic) IBOutlet UIPickerView *sizeOrTypePicker;
@property (nonatomic, assign) BOOL sizeWasPressed;
@property (nonatomic, assign) BOOL typeWasPressed;
@property (nonatomic, strong) NSArray *obstacleType;
@property (nonatomic, strong) NSArray *obstacleSize;
@property (weak, nonatomic) IBOutlet UITextField *longCoordField;
@property (weak, nonatomic) IBOutlet UITextField *latCoordField;
@property (weak, nonatomic) IBOutlet UIButton *getLocationButton;
@property (weak, nonatomic) IBOutlet UITextField *startLatitudeField;
@property (weak, nonatomic) IBOutlet UITextField *startLongitudeField;
@property (weak, nonatomic) IBOutlet UIButton *getStartLocation;
@property (weak, nonatomic) IBOutlet UITextField *endLatitudeField;
@property (weak, nonatomic) IBOutlet UITextField *endLongitudeField;
@property (weak, nonatomic) IBOutlet UIButton *getEndLocation;
@property (nonatomic, assign) BOOL isBigOrLongObstacle;
@property (weak, nonatomic) IBOutlet UIView *pickerView;

@property (nonatomic, assign) BOOL isSmallObstacle;
@property (nonatomic, assign) BOOL isStartOfTheObstacle;
@property (nonatomic, assign) BOOL isEndOfTheObstacle;

@property (nonatomic, strong) CLLocation *smallObstacle;
@property (nonatomic, strong) CLLocation *startOfTheObstacle;
@property (nonatomic, strong) CLLocation *endOfTheObstacle;

@end

@implementation CreateObstacleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isBigOrLongObstacle = NO;
     self.obstacleType = @[@"crowded sidewalk", @"heavy to pass", @"easy to pass"];
     self.obstacleSize = @[@"big", @"long", @"small", @"short"];
    
    self.sizeWasPressed = NO;
    self.typeWasPressed = NO;
    
    self.pickerView.hidden = YES;
    
    if (!self.isBigOrLongObstacle) {
        [self hideStartEndCoordFields:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isSmallObstacle) {
        self.latCoordField.text = [NSString stringWithFormat:@"%.8f", self.smallObstacle.coordinate.latitude];
        self.longCoordField.text = [NSString stringWithFormat:@"%.8f", self.smallObstacle.coordinate.longitude];
    } else if (self.isStartOfTheObstacle) {
        self.startLatitudeField.text = [NSString stringWithFormat:@"%.8f", self.startOfTheObstacle.coordinate.latitude];
        self.startLongitudeField.text = [NSString stringWithFormat:@"%.8f", self.startOfTheObstacle.coordinate.longitude];
    } else if (self.isEndOfTheObstacle) {
        self.endLatitudeField.text = [NSString stringWithFormat:@"%.8f", self.endOfTheObstacle.coordinate.latitude];
        self.endLongitudeField.text = [NSString stringWithFormat:@"%.8f", self.endOfTheObstacle.coordinate.longitude];
    }
    
    self.isSmallObstacle = NO;
    self.isStartOfTheObstacle = NO;
    self.isEndOfTheObstacle = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)selectObstacleType:(id)sender {
    self.typeWasPressed = YES;
    self.pickerView.hidden = NO;
    self.sizeOrTypePicker.delegate = self;
    self.sizeOrTypePicker.dataSource = self;
}

- (IBAction)selectObstaceSize:(id)sender {
//    self.view.alpha = 0.5;
    self.sizeWasPressed = YES;
    self.pickerView.hidden = NO;
    self.sizeOrTypePicker.delegate = self;
    self.sizeOrTypePicker.dataSource = self;
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.sizeWasPressed) {
        return self.obstacleSize.count;
    } else if (self.typeWasPressed) {
        return self.obstacleType.count;
    }
    
    return 1;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.sizeWasPressed) {
        return self.obstacleSize[row];
    } else if (self.typeWasPressed) {
        return self.obstacleType[row];
    }
    
    return self.obstacleType[0];
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.sizeWasPressed) {
        self.sizeWasPressed = NO;
        self.obstacleSizeField.text = self.obstacleSize[row];
        self.pickerView.hidden = YES;
        
        if ([self.obstacleSize[row] isEqualToString:@"big"] || [self.obstacleSize[row] isEqualToString:@"long"]) {
            [self hideCoordFields:NO];
        } else {
            [self hideCoordFields:YES];
        }
        
        self.sizeOrTypePicker.delegate = nil;
        self.sizeOrTypePicker.dataSource = nil;
    } else if (self.typeWasPressed) {
        self.typeWasPressed = NO;
        self.obstacleTypeField.text = self.obstacleType[row];
        self.pickerView.hidden = YES;
        
        self.sizeOrTypePicker.delegate = nil;
        self.sizeOrTypePicker.dataSource = nil;
    }
}

- (void)hideStartEndCoordFields:(BOOL)hidden {
    self.startLatitudeField.hidden = hidden;
    self.startLongitudeField.hidden = hidden;
    self.getStartLocation.hidden = hidden;
    
    self.endLatitudeField.hidden = hidden;
    self.endLongitudeField.hidden = hidden;
    self.getEndLocation.hidden = hidden;
}

- (void)hideCoordFields:(BOOL)hidden {
    [self hideStartEndCoordFields:hidden];
    
    self.latCoordField.hidden = !hidden;
    self.longCoordField.hidden = !hidden;
    self.getLocationButton.hidden = !hidden;
    
    self.isBigOrLongObstacle = !hidden;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AddObstacleMapViewController *controller = segue.destinationViewController;
    controller.delegate = self;
    
    if ([segue.identifier isEqualToString:@"smallObst"]) {
        controller.isSmallObstacle = YES;
        self.isSmallObstacle = YES;
    } else if ([segue.identifier isEqualToString:@"startObst"]) {
        controller.isStartOfTheObstacle = YES;
        self.isStartOfTheObstacle = YES;
    } else if ([segue.identifier isEqualToString:@"endObst"]) {
        controller.isEndOfTheObstacle = YES;
        self.isEndOfTheObstacle = YES;
    }
}

- (void)setCreatedLocationWIthLatitude:(CLLocation *)location withType:(NSString *)type {
    if ([type isEqualToString:@"small"]) {
        self.smallObstacle = location;
    } else if ([type isEqualToString:@"start"]) {
        self.startOfTheObstacle = location;
    } else if ([type isEqualToString:@"end"]) {
        self.endOfTheObstacle = location;
    }
}

- (IBAction)addObstacle:(id)sender {
    FIRDatabaseReference *newref = [[[FIRDatabase database] referenceWithPath:@"obstacles"] child:self.obstacleNameField.text];
    NSDictionary *post = @{@"name": self.obstacleNameField.text,
                           @"description": self.obstacleShortDescriptionField.text,
                           @"type": self.obstacleTypeField.text,
                           @"size": self.obstacleSizeField.text,
                           @"date": [NSString stringWithFormat:@"%@", [NSDate date]],
                           @"start": @{@"lat": self.startOfTheObstacle ? self.startLatitudeField.text : self.latCoordField.text,
                                       @"lon": self.startOfTheObstacle ? self.startLongitudeField.text : self.longCoordField.text},
                           @"end": @{@"lat": self.endOfTheObstacle ? self.endLatitudeField.text : self.latCoordField.text,
                                     @"lon": self.endOfTheObstacle ? self.endLongitudeField.text : self.longCoordField.text}};
    
    [newref setValue:post];
    
    [self.navigationController popViewControllerAnimated:YES];

}

@end