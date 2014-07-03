//
//  JoeyBot.m
//  RobotWar
//
//  Created by MakeGamesWith.Us on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "JoeyBot.h"
typedef NS_ENUM(NSInteger, RobotState) {
    RobotStateDefault,
    RobotStateTurnaround,
    RobotStateFiring,
    RobotStateSearching,
    RobotStateHugging
};

@implementation JoeyBot {
    RobotState _currentRobotState;
    //    RobotState _robotHug;
    CGPoint _lastKnownPosition;
    CGFloat _lastKnownPositionTimestamp;
}

#pragma mark - robot strategy

- (void)run {
    while (true) {
        if (_currentRobotState == RobotStateDefault)
        {
            CGPoint coords = [self getCoordinates];
            CCLOG(@"coordinates: (%f,%f)", coords.x, coords.y);
            //            _robotHug = 1;
            _currentRobotState = RobotStateHugging;
        }
        if (_currentRobotState == RobotStateHugging)
        {
            CGPoint coords = [self getCoordinates];
            if (coords.x < 26 && coords.y > 200)
            {
                [self moveBack:100];
                [self turnRobotLeft:90];
                [self moveAhead:100];
                [self turnRobotRight:90];
                //                _robotHug = 0;
            }
        }
    }
}

- (void)hitWall:(RobotWallHitDirection)hitDirection hitAngle:(CGFloat)angle {
    if (_currentRobotState != RobotStateTurnaround) {
        [self cancelActiveAction];
        
        // RobotState previousState = _currentRobotState;
        _currentRobotState = RobotStateTurnaround;
        
        // always turn to head straight away from the wall
        if (angle >= 0) {
            [self turnRobotLeft:abs(angle)];
        }
        else {
            [self turnRobotRight:abs(angle)];
        }
        CGPoint coords = [self getCoordinates];
        CCLOG(@"coordinates: (%f,%f)", coords.x, coords.y);
        
        //        _robotHug = 1;
        
        _currentRobotState = RobotStateHugging;
    }
}

# pragma mark - helper methods

- (CGPoint)getCoordinates
{
    CGRect _boundingBox = [self robotBoundingBox];
    return ccp(_boundingBox.origin.x, _boundingBox.origin.y);
}

@end
