#!/bin/bash
# Tells the system to execute this script using the bash shell

# === SLURM Resource Requests ===
#SBATCH --job-name=mpi_parallel        # Name of job (appears in squeue)
#SBATCH --time=4:00:00                 # Max runtime: 4 hours (HH:MM:SS)
#SBATCH --nodes=2                      # Number of compute nodes
#SBATCH --ntasks-per-node=8            # MPI processes per node
#SBATCH --ntasks=16                    # Total MPI tasks (nodes × tasks-per-node)
#SBATCH --partition=batch              # Queue/partition to submit to
#SBATCH --account=ts_acer_chi          # Account for resource allocation tracking
#SBATCH --output=output_from_example_2.txt  # File for stdout/stderr

# === Calculate total tasks if SLURM_NTASKS not set ===
if [ -z "$SLURM_NTASKS" ]; then
    SLURM_NTASKS=$((SLURM_JOB_NUM_NODES * SLURM_NTASKS_PER_NODE))
fi

# === Job Status ===
echo "Starting MPI job with $SLURM_NTASKS total tasks"
echo "Using $SLURM_JOB_NUM_NODES nodes"

# === Load Required Software ===
module load OpenMPI/4.1.1-GCC-11.2.0

# === Compile MPI Program ===
mpicxx -O2 example_2_code.cpp -o example_2_code

if [ ! -f ./example_2_code ]; then
    echo "ERROR: Compilation failed!"
    exit 1
fi

# === Run MPI Program ===
echo "=== Running with mpirun ==="

# Note: You may see warnings about "link speed" - these are harmless and can be ignored

mpirun -np $SLURM_NTASKS ./example_2_code

echo "MPI job completed"
