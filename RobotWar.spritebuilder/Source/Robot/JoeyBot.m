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
    RobotStateSearching
};

@implementation JoeyBot {
    RobotState _currentRobotState;
    RobotState _robotHug;
    RobotState _beingScanned;
    RobotState _ouchie;
    CGPoint _lastKnownPosition;
    CGFloat _lastKnownPositionTimestamp;
    CGSize _arenaDimensions;
    CGPoint _currentDirection;
}

#pragma mark - robot strategy

- (void)run {
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
                        _ouchie = FALSE;
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
                    [self turnGunRight:10];
                    [self shoot];
                    angle = [self angleBetweenGunHeadingDirectionAndWorldPosition:_lastKnownPosition];
                    int i = 0;
                    if (angle == -4) {
                        for (i = 0; i < 10; i++) {
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
//                CCLOG(@"gun angle: (%f)", angle);
                
                while (angle > -104 && angle < 3) {
                    [self turnGunRight:10];
                    [self shoot];
                    angle = [self angleBetweenGunHeadingDirectionAndWorldPosition:_lastKnownPosition];
                    int i = 0;
//                    CCLOG(@"gun angle: (%f)", angle);
                    if (angle == -104) {
                        for (i = 0; i < 10; i++) {
                            [self turnGunLeft:10];
                            [self shoot];
                            angle = [self angleBetweenGunHeadingDirectionAndWorldPosition:_lastKnownPosition];
                        }
                    }
                }
                _robotHug = 0;
            }
            if (_ouchie == TRUE && _beingScanned == TRUE) {
                [self moveAhead:300];
                
            }
        }
    }
}


//- (void)scannedRobot:(Robot *)robot atPosition:(CGPoint)position {
//    CGPoint currentPosition = [self position];
//    CGSize arenaSize = [self arenaDimensions];
//    float bodyLength = [self robotBoundingBox].size.width; //offset is 2 so we dont trigger hit wall
//    _beingScanned = TRUE;
//    CCLOG(@"being scanned");
//
//    if (_ouchie == TRUE) {
//        if (currentPosition.y < arenaSize.height/2) {
////            [self moveAhead:(currentPosition.y - bodyLength)];
//            [self turnRobotLeft:90];
//            [self moveAhead:200];
//            [self turnGunLeft:90];
//        }
//        if (currentPosition.y > arenaSize.height/2) {
//            CCLOG(@"AHHH!");
//            [self turnRobotRight:180];
//        } else {
//            [self moveBack:(arenaSize.height - (currentPosition.y + bodyLength))];
//        }    
//    }
//}


- (void)hitWall:(RobotWallHitDirection)hitDirection hitAngle:(CGFloat)angle {
    if (_currentRobotState != RobotStateTurnaround) {
        [self cancelActiveAction];
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
        _robotHug = 1;
    }
}

- (void)bulletHitEnemy:(Bullet *)bullet {
    [self shoot];
    _ouchie = TRUE;
    CCLOG(@"I shot the sheriff");
}


- (CGPoint)getCoordinates
{
    CGRect _boundingBox = [self robotBoundingBox];
    return ccp(_boundingBox.origin.x, _boundingBox.origin.y);
}

- (void)printStatus
{
    CCLOG(@"state = %d", _currentRobotState);
    
    CGPoint coords = [self getCoordinates];
    CCLOG(@"coordinates: (%f,%f)", coords.x, coords.y);
    
    CGPoint direction = [self headingDirection];
    CCLOG(@"Heading direction: (%f,%f)", direction.x, direction.y);
}

@end
