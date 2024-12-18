# SET SCENARIO PARAMETERS AND MODEL 
import carla
import logging
import time
import os
import sys
import random

# Define the weather conditions
weather = {
    "cloudiness":50,
    "precipitation":0,
    "sun_azimuth_angle":120,
    "sun_altitude_angle":60,
    "fog_density": 0
}

# Apply the weather conditions to the scenario
param map = localPath('/opt/carla/CarlaUE4/Content/Carla/Maps/OpenDrive/Town01.xodr')
param carla_map = 'Town01'
model scenic.simulators.carla.model  # Here the definitions of all referenceables are defined (vehicle types, road library, etc) 
import scenic.simulators.carla as carla_simulator
param weather = weather
# SCENARIO CONSTANTS 
EGO_MODEL = "vehicle.tesla.model3"
PEDESTRIAN_MODEL = "walker.pedestrian.0048"
EGO_SPEED = 7
BRAKE_INTENSITY = 1.0
PEDESTRIAN_MIN_SPEED = 1.5
THRESHOLD = 15

# SENSOR ATTRIBUTES
attrs = {"image_size_x": 640,
         "image_size_y": 640}

## DEFINING SPATIAL RELATIONS
all_lane = (network.lanes)
lane = all_lane[2] # lane2 => clean, lane 20 => cluttered
spot = new OrientedPoint on lane.centerline
vending_spot = new OrientedPoint following roadDirection from spot for -3

behavior Exp_EgoBehaviour():
    try:
        do FollowLaneBehavior(target_speed = EGO_SPEED)
    interrupt when checkPedestrianDectectedFlag(ego.observations["front_rgb"], pedestrian.position, ego.position):
        print('yolo emergency braking')
        take YoloEmergencyBraking()

behavior PedestrianBehavior(min_speed=1, threshold=THRESHOLD):
    do CrossingBehavior(ego, min_speed, threshold)

pedestrian = new Pedestrian at (3, 7, 0) relative to spot,  
    with heading 180 deg relative to roadDirection,  
    with regionContainedIn None,
    with behavior PedestrianBehavior(PEDESTRIAN_MIN_SPEED, THRESHOLD),
    with blueprint PEDESTRIAN_MODEL


vending_machine = new VendingMachine right of vending_spot by 3,
    with heading 90 deg relative to vending_spot.heading,
    with regionContainedIn None  # Allow the actor to spawn outside the driving lanes

ego = new Car following roadDirection from spot for -15,
    with blueprint EGO_MODEL,
    with sensors {"front_rgb": RGBSensor(offset=(1.6, 0, 1.7), attributes=attrs)}, #(201 -> low) (x-> horizontal front back, y -> horizontal left right, z -> vertical up down)
    with behavior Exp_EgoBehaviour()

# RECORDING SETUP
record ego.observations["front_rgb"] as "front_rgb"
require monitor RecordingMonitor(ego, path=localPath(f"/home/recording/temp"), recording_start=5, subsample=2)

# REQUIREMENTS
require (distance to intersection) > 30
require (distance from spot to intersection) > 30
require always (ego.laneSection._slowerLane is None)
require always (ego.laneSection._fasterLane is None)

# TERMINATION CONDITION
terminate when (distance to spot) > 30