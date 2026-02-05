#!/bin/bash
#SBATCH --job-name=test_python_gpu
#SBATCH --time=15:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --partition=batch_gpu
#SBATCH --gpus-per-node=1
#SBATCH --account=ts_acer_chi
#SBATCH --output=python_test_output.txt

echo "Node: $(hostname)"
echo "GPU: $CUDA_VISIBLE_DEVICES"

module load cuda12.2/toolkit/12.2.2
module load python3

python3 test_python_gpu.py
