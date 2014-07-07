//
//  eRobot.h
//  RobotWar
//
//  Created by Ember Baker on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Robot.h"


typedef NS_ENUM(NSInteger, RobotState) {
    RobotStateDefault,
    RobotStateTurnaround,
    RobotStateFiring,
    RobotStateSearching,
    RobotStateWaiting
};

@interface eRobot : Robot


@property (nonatomic, assign) RobotState currentRobotState;

@end
