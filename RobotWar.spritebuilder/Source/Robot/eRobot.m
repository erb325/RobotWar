//
//  eRobot.m
//  RobotWar
//
//  Created by Ember Baker on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "eRobot.h"


@implementation eRobot {
    CGPoint _lastKnownPosition;
    CGFloat _lastKnownPositionTimestamp;
        RobotState _robotHug;
    
    int actionIndex;
}

- (void)run {
    actionIndex = 0;
    while (true) {
        
        while (_currentRobotState == RobotStateFiring) {
            [self performNextFiringAction];
        }
        
        while (_currentRobotState == RobotStateSearching) {
            [self performNextSearchingAction];
        }
        
        while (_currentRobotState == RobotStateDefault) {
            [self performNextDefaultAction];
        }
    }
}

- (void)performNextDefaultAction {
    while (true) {
        if (_currentRobotState == RobotStateDefault)
        {
            CGPoint coords = [self getCoordinates];
            CCLOG(@"coordinates: (%f,%f)", coords.x, coords.y);
            _robotHug = 1;
        }
        if (_robotHug == 1) {
            CGPoint coords = [self getCoordinates];
            CCLOG(@"coordinates: (%f,%f)", coords.x, coords.y);
            
            // robot turns towards wall
            
            // top left
            if (coords.x < 26)
            {
                [self moveBack:100];
                [self turnRobotLeft:90];
                [self moveAhead:210];
                [self turnRobotRight:90];
                CGFloat angle = [self angleBetweenGunHeadingDirectionAndWorldPosition:_lastKnownPosition];
                
                // sprinkler spray
                while (angle < 97 && angle > 0) {
                    [self shoot];
                    [self turnGunRight:10];
                    [self shoot];
                    angle = [self angleBetweenGunHeadingDirectionAndWorldPosition:_lastKnownPosition];
                    int i = 0;
                    if (angle == -4) {
                        for (i = 0; i < 10; i++) {
                            [self shoot];
                            [self turnGunLeft:10];
                            [self shoot];
                            angle = [self angleBetweenGunHeadingDirectionAndWorldPosition:_lastKnownPosition];
                        }
                    }
                }
                _robotHug = 0;
                
            }
            
            // bottom right
            if (coords.x > 404)
            {
                [self moveBack:100];
                [self turnRobotRight:90];
                [self moveBack:180];
                [self turnRobotLeft:90];
                CGFloat angle = [self angleBetweenGunHeadingDirectionAndWorldPosition:_lastKnownPosition];
                
                // sprinkler spray
                angle = [self angleBetweenGunHeadingDirectionAndWorldPosition:_lastKnownPosition];
                CCLOG(@"gun angle: (%f)", angle);
                
                while (angle > -104 && angle < 3) {
                    [self shoot];
                    [self turnGunRight:10];
                    [self shoot];
                    angle = [self angleBetweenGunHeadingDirectionAndWorldPosition:_lastKnownPosition];
                    int i = 0;
                    CCLOG(@"gun angle: (%f)", angle);
                    if (angle == -104) {
                        for (i = 0; i < 10; i++) {
                            [self shoot];
                            [self turnGunLeft:10];
                            [self shoot];
                            angle = [self angleBetweenGunHeadingDirectionAndWorldPosition:_lastKnownPosition];
                        }
                    }
                }
                _robotHug = 0;
            }
        }
    }
}


- (void) performNextFiringAction {
    if ((self.currentTimestamp - _lastKnownPositionTimestamp) > 1.f) {
        self.currentRobotState = RobotStateSearching;
    } else {
        CGFloat angle = [self angleBetweenGunHeadingDirectionAndWorldPosition:_lastKnownPosition];
        if (angle >= 0) {
            [self turnGunRight:abs(angle)];
            
        } else {
            [self turnGunLeft:abs(angle)];
            
        }
        [self shoot];
    }
}

- (void)performNextSearchingAction {
//    switch (actionIndex%4) {
//        case 0:
//            [self moveAhead:50];
//            break;
//            
//        case 1:
//            [self turnRobotLeft:20];
//            break;
//            
//        case 2:
//            [self moveAhead:50];
//            break;
//            
//        case 3:
//            [self turnRobotRight:20];
//            break;
//    }
//    actionIndex++;
}

- (void)bulletHitEnemy:(Bullet *)bullet {
    
  [self shoot];
//    if (_currentRobotState == RobotStateFiring) {
//           }
    
}

- (void)scannedRobot:(Robot *)robot atPosition:(CGPoint)position {
    if (_currentRobotState != RobotStateFiring) {
        [self cancelActiveAction];
    }
  

    
    _lastKnownPosition = position;
    _lastKnownPositionTimestamp = self.currentTimestamp;
    self.currentRobotState = RobotStateFiring;
}

- (void)hitWall:(RobotWallHitDirection)hitDirection hitAngle:(CGFloat)angle {
//    if (_currentRobotState != RobotStateTurnaround) {
//        [self cancelActiveAction];
//        
//        RobotState previousState = _currentRobotState;
//        self.currentRobotState = RobotStateTurnaround;
//        
//        // always turn to head straight away from the wall
//        if (angle >= 0) {
//            [self turnRobotLeft:abs(90)];
//            [self moveAhead:50];
//        } else {
//            [self turnRobotRight:abs(90)];
//           [self moveAhead:50];
//            
//        }
//        
//        [self moveAhead:20];
//        
//        self.currentRobotState = previousState;
//    }
}

- (void)setCurrentRobotState:(RobotState)currentRobotState {
    _currentRobotState = currentRobotState;
    actionIndex = 0;
}


- (CGPoint)getCoordinates
{
    CGRect _boundingBox = [self robotBoundingBox];
    return ccp(_boundingBox.origin.x, _boundingBox.origin.y);
}


@end
