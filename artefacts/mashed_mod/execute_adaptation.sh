#!/bin/sh

# Function to display usage information
usage() {
    echo "Usage: $0 -m <adaptation> [options]"
    echo
    echo "This script runs Scenic experiments with different adaptation strategies and models."
    echo
    echo "Options:"
    echo "  -m <strategy>  Adaptation strategy (behaviour or model)"
    echo
    echo "Adaptation-specific options:"
    echo "  Behaviour Adaptation:"
    echo "    No additional options required"
    echo
    echo "  Model Adaptation:"
    echo "    -y <type>    YOLOv5 model type (s, m, fine_tune, few_shot)"
    echo
    echo "Examples:"
    echo "  $0 -m behaviour"
    echo "  $0 -m model -y m"
    echo "  $0 -m model -y fine_tune"
    exit 1
}

# Initialize variables
adaptation=""
yolo_model=""

# Parse command line arguments
while [ $# -gt 0 ]; do
    case "$1" in
        -m) adaptation="$2"; shift 2 ;;
        -y) yolo_model="$2"; shift 2 ;;
        -h) usage ;;
        *) echo "Unknown option: $1"; usage ;;
    esac
done

# Function to run Scenic file
run_scenic() {
    file="scenic-repo/demonstrators/$1"
    if [ -f "$file" ]; then
        echo "Running: $file with YOLO model: $YOLO_MODEL"
        scenic "$file" --2d --simulate
    else
        echo "Error: File $file not found."
        exit 1
    fi
}

# Run scenarios based on user input
case "$adaptation" in
    behaviour)
        export YOLO_MODEL="yolov5s"
        run_scenic "behaviour_adaptation.scenic"
        ;;
    model)
        if [ -z "$yolo_model" ]; then
            echo "Error: YOLO model type (-y) is required for model mitigation."
            usage
        fi
        case "$yolo_model" in
            s)
                export YOLO_MODEL="yolov5s"
                ;;
            m)
                export YOLO_MODEL="yolov5m"
                ;;
            fine_tune)
                export YOLO_MODEL="fine_tune"
                ;;
            few_shot)
                export YOLO_MODEL="few_shot"
                ;;
            # <your-model-name>)
            #     export YOLO_MODEL="<your-model-name>"
            #     ;;
            *)
                echo "Error: Invalid YOLO model specified."
                usage
                ;;
        esac
        run_scenic "model_architecture_mitigation.scenic"
        ;;
    *)
        echo "Error: Invalid adaptation strategy or missing required arguments."
        usage
        ;;
esac