#!/bin/bash

# SLURM job configuration
#SBATCH --job-name=gpu_job
#SBATCH --time=2:00:00                    # Maximum runtime: 2 hours
#SBATCH --nodes=1                         # Use 1 compute node
#SBATCH --ntasks=1                        # Run 1 task (process)
#SBATCH --partition=batch_gpu             # Submit to GPU partition
#SBATCH --gres=gpu:1g.10gb:1              # Request 1 small GPU slice (10GB memory)
#SBATCH --account=ts_acer_chi             # Billing account
#SBATCH --output=output_from_example_3_cuda.txt

# Print job information
echo "GPU job starting on node: $(hostname)"
echo "GPU allocated: $CUDA_VISIBLE_DEVICES"

# Load CUDA toolkit
module load cuda12.2/toolkit/12.2.2

# Check GPU status
echo "=== GPU Information ==="
nvidia-smi

# Compile CUDA program
echo "=== Compiling CUDA code ==="
nvcc -o example_3_cuda_code example_3_cuda_code.cu

# Run GPU program
echo "=== Running CUDA program ==="
./example_3_cuda_code

echo "GPU job completed"
