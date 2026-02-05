#!/bin/bash
#SBATCH --time=4:00:00
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=8
#SBATCH --partition=batch
#SBATCH --account=ts_acer_chi
#SBATCH --output=output_from_example_2.txt

echo "Starting MPI job with $SLURM_NTASKS total tasks"
echo "Using $SLURM_JOB_NUM_NODES nodes"

# Load proper OpenMPI from EasyBuild
module load OpenMPI/4.1.1-GCC-11.2.0

echo "=== Loaded modules ==="
module list

echo "=== Checking for mpicxx ==="
which mpicxx # This is just to confirm the module loaded correctly. It shows the full path to the executable

# Compile
mpicxx -O2 example_2_code.cpp -o example_2_code

if [ ! -f ./example_2_code ]; then
    echo "ERROR: Compilation failed!"
    exit 1
fi

echo "=== Running ==="
srun ./example_2_code

echo "MPI job completed"
