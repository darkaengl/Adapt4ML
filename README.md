# Adapt4ML
Repository with the demonstrators for Adaptations For Machines the Learn (Adapt4ML).

## Introduction

This document provides instructions for setting up and running the Adapt4ML demonstrator. The project creates a virtual environment for running experiments and simulations.

The Demo video is given below :

[Demo Video](https://streamable.com/g3lhu4)


## Prerequisites

Before you begin, ensure you have the following installed on your system:
- Ubuntu 20.04
- Nvidia drivers for GPU
- Git

## Setup Python Environment

1. make sure `python 3.8` or higher is installed  
   ```
   $ python --version
   ```
2. make sure `pip` is installed
   ```
   $ pip --version
   ```
3. Install virtualenv 
   ```
   $ pip install virtualenv 
   ``` 
4. create virtual environment
   ```
   $ python3 -m virtualenv .venv
   ```
5. Activate the virtual environment
   ```
   $ source ~/.venv/bin/activate
   ```
6. Install `pygame` and `numpy`
   ```
   $ pip install numpy pygame
   ```

## Install CARLA simulator
1. Go to [documentation](https://carla.readthedocs.io/en/latest/start_quickstart/) for carla simulator and follow package installation instructions

2. click on the link to [carla repository](https://github.com/carla-simulator/carla/blob/master/Docs/download.md)

3. click on the [link to 0.9.15](https://github.com/carla-simulator/carla/releases/tag/0.9.15/) version

4. download tar.gz file for [carla](https://tiny.carla.org/carla-0-9-15-linux) 

5. download the tar.gz file for [Additional Maps](https://tiny.carla.org/additional-maps-0-9-15-linux)

6. open new terminal and go to the directory where the files are downloaded
   ```
   $ cd ~/Downloads
   ``` 
7. create a directory `/opt/carla` with `sudo` permission
   ```
   $ sudo mkdir /opt/carla
   ```
8. extract the `tar.gz` file for carla into `/opt/carla directory`
   ```
   $ sudo tar -xvzf CARLA_0.9.15.tar.gz -C /opt/carla
   ```
9. move the `tar.gz` file for additional maps to `/opt/carla/Import`
   ```
   $ sudo mv AdditionalMaps_0.9.15.tar.gz /opt/carla/Import/
   ```
10. change the directory into `/opt/carla/` and verify all the files are moved properly

      ```
      $ cd /opt/carla
      $ ls
      ```
11. give execution permission for `ImportAssets.sh` file
      ```
      $ sudo chmod +x ImportAssets.sh
      ```
12. execute ImportAssets.sh file
      ```
      $ sudo sh ImportAssets.sh
      ```
13. Add execution permission to `CarlaUE4.sh`
      ```
      $ sudo chmod +x CarlaUE4.sh
      ```
14. Identify your user and group using 
      ```
      $ whoami
      $ groups
      ```
15. change the ownership of everything inside `/opt/carla` to your user and group
      ```
      $ sudo chown -R <user>:<group> /opt/carla
      ```
16. finally execute `CarlaUE4.sh` and verify the installation works
      ```
      $ ./CarlaUE4.sh
      ```
17. Make sure `GPU` is utilized for rendering the simulations
      ```
      $ nvidia-smi
      ```

## Install Scenic

1. Dowmnload and navvigate to Adapt4ML artefact repository:
   ```
   cd Adapt4ML
   ```

2. Switch to the `main` branch:
   ```
   git checkout main
   ```

3. activate the virtual environment created earlier
   ```
   $ source ~/.venv/bin/activate
   ```

4. navigate to `artefacts/mashed_mod/scenic-repo/Scenic`
   ```
   $ cd artefacts/mashed_mod/scenic-repo/Scenic
   ```

5. update `apt-get`
   ```
   $ sudo update apt-get
   ```

6. install `python3-tk` 
   ```
   $ sudo apt-get install python3-tk
   ```

7. install `scenic` using pip as follows
   ```
   python -m pip install -e .
   ```

8. install `pythonAPI` for `carla` using pip
   ```
   $ pip install carla
   ```

9. install `ultralytics` package for using `YOLO` models
   ```
   $ pip install ultralytics
   ```
   
## Running the Project
1. Open a new terminal and run `carla server`
   ```
   $ cd /opt/carla
   $ ./CarlaUE4.sh -prefernvidia -RenderOffScreen
   ```

2. Open a new terminal and run experiments
   ```
   $ cd Adapt4ML/artefacts/mashed_mod
   $ ./execute_experiments.sh -e <experiment> [options]
   ```

## Running Experiments

To run experiments, use the `execute_experiments.sh` script. This script allows you to run various Scenic experiments with different parameters.

Usage:
```
./execute_experiments.sh -e <experiment> [options]
```

Options:
- `-e <number>`: Experiment number (1, 2, 3, or 4)

Experiment-specific options:
1. Experiment 1:
   - `-a <group>`: Age group (adult or child)
   - `-m <type>`: YOLOv5 model type (s for small, m for medium) [optional]

2. Experiment 2:
   - `-d <length>`: Distance (short or long)
   - `-p <dir>`: Position (LR or RL)
   - `-a <group>`: Age group (adult or child)

3. Experiment 3:
   - `-a <group>`: Age group (adult or child)
   - `-c <type>`: Condition (light or dark)

4. Experiment 4:
   - `-a <group>`: Age group (adult or child)

Examples:
```
./execute_experiments.sh -e 1 -a adult -m s
./execute_experiments.sh -e 2 -a child -d short -p LR
./execute_experiments.sh -e 3 -a adult -c light
./execute_experiments.sh -e 4 -a child
```

## Running Adaptations

To run adaptation strategies, use the `execute_adaptation.sh` script. This script allows you to run Scenic experiments with different adaptation strategies and models.

Usage:
```
./execute_adaptation.sh -m <adaptation> [options]
```

Options:
- `-m <strategy>`: adaptation strategy (behaviour or model)

adaptation-specific options:
1. Behaviour adaptation:
   - No additional options required

2. Model adaptation:
   - `-y <type>`: YOLOv5 model type (s, m, fine_tune, few_shot)

Examples:
```
./execute_adaptation.sh -m behaviour
./execute_adaptation.sh -m model -y m
./execute_adaptation.sh -m model -y fine_tune
```

## Notes on Running Scripts

1. Make sure the scripts are executable. If they're not, you can make them executable using:
   ```
   chmod +x execute_experiments.sh execute_adaptation.sh
   ```

2. The scripts will run Scenic simulations based on the provided parameters. Ensure that all necessary Scenic files are present in the `scenic-repo/demonstrators/` directory .

4. For experiments, the script will automatically set the YOLO_MODEL environment variable based on the parameters you provide.

5. For adaptation, you can choose between behaviour adaptation (which uses YOLOv5s by default) and model adaptation (where you can specify the YOLO model type).

6. If you encounter any "file not found" errors, double-check that the Scenic files are in the correct location within the container.

7. You can always use the -h option with either script to display the usage information:
   ```
   ./execute_experiments.sh -h
   ./execute_adaptation.sh -h
   ```

By using these scripts, you can easily run different experiments and adaptation strategies as part of the Adapt4ML project. The scripts provide a convenient way to set up the correct parameters and environment variables for each scenario.


## Notes on adding new Adaptations

#### Data / Model related Adaptation

- Train a new model for pedestrian detection ( Either use new data to train the existing YOLO models we used or train a new model )

- Edit the `Adapt4ML/artefacts/mashed_mod/execute_adaptations.sh` file and uncomment the lines from 76 to 78 and replace `<your-model-name>` with the actual model name you wat to try out

- Go to `Adapt4ML/artefacts/mashed_mod/scenic-repo/Scenic/src/scenic/domains/driving/model.scenic` and edit the `get_model()` function and edit the business logic

    - The model name is fetched from the environment variable `YOLO_MOLDEL` (which you have already updated in the )

    - Now add an if condition to add the business logic for loading your model

    - Also edit the `checkPedestrianDectectedFlag` function to include the inference logic of your model using an if condition 

#### Any other behavioural Adaptation

- This requires you define custom functions in the `Adapt4ML/artefacts/mashed_mod/scenic-repo/Scenic/src/scenic/domains/driving/model.scenic` file

- You may refer to `checkCautionBehaviour` function defined in the same file to get a better understanding for defining new behavioural adaptations