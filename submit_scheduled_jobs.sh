#!/bin/bash

# ============================================
# SLURM JOB CONFIGURATION
# ============================================
# These #SBATCH lines tell SLURM what resources you need
# They MUST come before any other commands (except comments)

#SBATCH --job-name=recurring_python           # Name shown in squeue (keep it short and descriptive)
#SBATCH --time=01:00:00                       # Maximum runtime (HH:MM:SS) - job killed if it exceeds this
#SBATCH --nodes=1                             # Number of compute nodes (usually 1 unless doing multi-node MPI)
#SBATCH --ntasks=1                            # Number of tasks/processes (1 for single Python script)
#SBATCH --partition=batch_gpu                 # Which partition to use (batch_gpu has GPUs)
#SBATCH --gpus-per-node=1                     # Request 1 GPU (remove this line if you don't need GPU)
#SBATCH --account=ts_acer_chi                 # Your account/allocation (required on Chicago Compute)
#SBATCH --mem=4G                              # Memory needed (4GB - adjust based on your script)
#SBATCH --output=logs/job_%j.out              # Where to save output (%j = job ID number)
#SBATCH --error=logs/job_%j.err               # Where to save errors (%j = job ID number)

# ============================================
# SCHEDULE CONFIGURATION - PICK YOUR SCHEDULE TYPE
# ============================================
# STEP 1: Set SCHEDULE_TYPE to ONE of these exact words:
#         "minutes" OR "hourly" OR "daily" OR "weekly" OR "custom"
#
# STEP 2: Customize the interval in the matching section below

SCHEDULE_TYPE="minutes"    # ← Change this to: minutes, hourly, daily, weekly, or custom

# ============================================
# SCHEDULE OPTIONS - YOU CAN USE ANY NUMBER!
# ============================================
# After setting SCHEDULE_TYPE above, set ANY interval you want below
# The examples shown are just common choices - feel free to customize!

case $SCHEDULE_TYPE in
    "minutes")
        # Run every X minutes (good for testing, monitoring)
        # You can use ANY number: 1, 23, 45, 90, etc.
        # ↓ CHANGE TO YOUR DESIRED NUMBER ↓
        INTERVAL="1 minute"    
        # Common examples: "1 minute", "5 minutes", "15 minutes", "23 minutes", "30 minutes", "45 minutes"
        ;;
    
    "hourly")
        # Run every X hours (good for frequent data collection)
        # You can use ANY number: 1, 3, 8, 18, etc.
        # ↓ CHANGE TO YOUR DESIRED NUMBER ↓
        INTERVAL="3 hours"       
        # Common examples: "1 hour", "2 hours", "3 hours", "6 hours", "8 hours", "12 hours", "18 hours"
        ;;
    
    "daily")
        # Run every X days (good for daily reports, backups)
        # You can use ANY number: 1, 2, 3, 5, 10, etc.
        # ↓ CHANGE TO YOUR DESIRED NUMBER ↓
        INTERVAL="1 day"         
        # Common examples: "1 day", "2 days", "3 days", "5 days", "10 days"
        ;;
    
    "weekly")
        # Run every X days (good for weekly summaries)
        # You can use ANY number of days: 7, 10, 14, 21, etc.
        # ↓ CHANGE TO YOUR DESIRED NUMBER ↓
        INTERVAL="7 days"        
        # Common examples: "7 days" (weekly), "10 days", "14 days" (biweekly), "21 days", "30 days"
        ;;
    
    "custom")
        # Run at specific times instead of intervals
        # This gives you more control over WHEN it runs
        
        # ---- CHOOSE ONE OPTION BELOW (uncomment by removing #) ----
        
        # Option 1: Run tomorrow at same time
        NEXT_TIME="tomorrow"
        
        # Option 2: Run at specific time today (or tomorrow if time has passed)
        # Use 24-hour format (HH:MM)
        # NEXT_TIME="09:00"              # 9 AM
        # NEXT_TIME="14:30"              # 2:30 PM
        # NEXT_TIME="16:45"              # 4:45 PM
        # NEXT_TIME="23:00"              # 11 PM
        
        # Option 3: Run tomorrow at specific time
        # NEXT_TIME="tomorrow 09:00"     # Tomorrow at 9 AM
        # NEXT_TIME="tomorrow 13:15"     # Tomorrow at 1:15 PM
        # NEXT_TIME="tomorrow 17:00"     # Tomorrow at 5 PM
        
        # Option 4: Run on specific day of week
        # NEXT_TIME="Monday"             # Next Monday (any time)
        # NEXT_TIME="Monday 09:00"       # Next Monday at 9 AM
        # NEXT_TIME="Wednesday 14:30"    # Next Wednesday at 2:30 PM
        # NEXT_TIME="Friday 17:00"       # Next Friday at 5 PM
        
        # Option 5: Run on specific date and time (YYYY-MM-DDTHH:MM:SS format)
        # NEXT_TIME="2026-02-15T09:00:00"   # Feb 15, 2026 at 9 AM
        # NEXT_TIME="2026-03-01T14:30:00"   # March 1, 2026 at 2:30 PM
        # NEXT_TIME="2026-12-25T08:00:00"   # Dec 25, 2026 at 8 AM
        
        # Option 6: Run at start of next month at specific time
        # NEXT_TIME="$(date -d 'next month' +%Y-%m-01)T09:00:00"
        # NEXT_TIME="$(date -d 'next month' +%Y-%m-01)T14:30:00"
        
        # Option 7: Run on first Monday of next month
        # NEXT_TIME="$(date -d 'next month first Monday' +%Y-%m-%d)T09:00:00"

        # Option 8: Run on last day of next month at midnight
        #
        # The line at the bottom of this option looks dense, so here is what
        # each piece does (read from the inside out):
        #
        #   date +%Y-%m-01
        #       The `date` command with a format string.
        #       %Y = 4-digit year, %m = 2-digit month, "01" is the literal text "01".
        #       Result: today's year and month with the day forced to the 1st.
        #       Example on May 8, 2026  →  "2026-05-01"
        #
        #   $(...)
        #       Bash command substitution. Runs the command inside and drops
        #       its output back into the surrounding string.
        #
        #   date -d "DATE +2 months -1 day"
        #       The -d flag means "don't use the current time, use the string
        #       I'm giving you." GNU date supports relative arithmetic inside
        #       that string ("+2 months", "-1 day", etc.) and applies it
        #       left to right.
        #       Example: "2026-05-01 +2 months -1 day"
        #          +2 months  →  "2026-07-01"
        #          -1 day     →  "2026-06-30"
        #
        #   +%Y-%m-%d
        #       Format the resulting date as YYYY-MM-DD  (e.g. "2026-06-30").
        #
        #   T00:00:00
        #       Literal text appended to the end. SLURM's --begin flag wants
        #       ISO 8601 format: YYYY-MM-DDTHH:MM:SS. The "T" separates the
        #       date from the time, and 00:00:00 is midnight.
        #
        # Final value of NEXT_TIME on May 8, 2026:  "2026-06-30T00:00:00"
        #
        # Why not the simpler `date -d 'next month'`? It's broken on short months.
        # From Jan 31 it gives March 3 (skips February entirely, because Feb 31
        # doesn't exist, so it rolls forward 3 days into March). From May 31 it
        # gives July 1 (skips June). Doing the math from day 01 — which always
        # exists in every month — avoids that trap.
        #
        # NEXT_TIME="$(date -d "$(date +%Y-%m-01) +2 months -1 day" +%Y-%m-%d)T00:00:00"
        ;;
    
    *)
        # This catches typos in SCHEDULE_TYPE
        echo "ERROR: Invalid SCHEDULE_TYPE='$SCHEDULE_TYPE'"
        echo "Must be one of: minutes, hourly, daily, weekly, custom"
        exit 1
        ;;
esac

# ============================================
# CREATE LOG DIRECTORY
# ============================================
# This creates a "logs" folder to store output files
# The -p flag means "don't error if it already exists"
mkdir -p logs

# ============================================
# PRINT JOB START INFORMATION
# ============================================
# These echo commands help you debug and track your jobs
echo "=========================================="
echo "Job Information:"
echo "=========================================="
echo "Job ID: $SLURM_JOB_ID"                    # Unique ID for this job
echo "Job Name: $SLURM_JOB_NAME"                # Name you set above
echo "Node: $HOSTNAME"                          # Which compute node is running this
echo "Started at: $(date)"                      # Current date and time
echo "Schedule type: $SCHEDULE_TYPE"            # Which schedule you're using

# Show what interval/time is being used
if [ "$SCHEDULE_TYPE" == "custom" ]; then
    echo "Next run time: $NEXT_TIME"
else
    echo "Run interval: $INTERVAL"
fi

# GPU-specific information (only if you requested a GPU)
if [ -n "$CUDA_VISIBLE_DEVICES" ]; then
    echo "GPU assigned: $CUDA_VISIBLE_DEVICES"
fi

echo "=========================================="
echo ""

# ============================================
# LOAD REQUIRED SOFTWARE MODULES
# ============================================
# These "module load" commands make software available to your script
# They're like activating a virtual environment

# Load CUDA for GPU support (only needed if using GPU)
module load cuda12.2/toolkit/12.2.2

# Load Python (use the version installed on your cluster)
module load python3

# Alternative: If you have your own conda/venv, activate it instead
# source /home/yourname/myenv/bin/activate

# Print loaded modules for debugging
echo "Loaded modules:"
module list
echo ""

# ============================================
# RUN YOUR PYTHON SCRIPT
# ============================================
# This is where your actual work happens
# Replace "test_python_gpu.py" with your script name

echo "Running Python script..."
python3 test_python_gpu.py

# Check if the script succeeded or failed
if [ $? -eq 0 ]; then
    echo "Script completed successfully!"
else
    echo "ERROR: Script failed with exit code $?"
    # You could choose NOT to reschedule if script fails:
    # exit 1
fi

echo ""
echo "Job completed at: $(date)"
echo "=========================================="

# ============================================
# SCHEDULE NEXT RUN
# ============================================
# This part automatically submits another job to run later
# $0 means "this same script file"

if [ "$SCHEDULE_TYPE" == "custom" ]; then
    # Use specific time scheduling
    sbatch --begin="${NEXT_TIME}" "$0"
    echo "✓ Next job scheduled for: ${NEXT_TIME}"
else
    # Use interval-based scheduling (X hours/days from now)
    sbatch --begin="now+${INTERVAL}" "$0"
    echo "✓ Next job scheduled in: ${INTERVAL}"
fi

echo "=========================================="

# ============================================
# HOW TO STOP RECURRING JOBS
# ============================================
# ⚠️ IMPORTANT: These jobs will keep resubmitting forever!
# You MUST manually stop them when you're done.
#
# Understanding the Job Chain:
# ----------------------------
# When you submit this script, it creates a "chain" of jobs:
# - Job 1 runs NOW → schedules Job 2 for LATER
# - Job 2 runs LATER → schedules Job 3 for LATER
# - Job 3 runs LATER → schedules Job 4 for LATER
# ... and so on forever until you stop it!
#
# What You'll See:
# ---------------
# At any moment, you'll typically have:
# - 1 job RUNNING (ST = R) - currently executing
# - 1 job PENDING (ST = PD) - scheduled for next run
#
# ============================================
# STEP-BY-STEP: How to Stop the Job Chain
# ============================================
#
# STEP 1: Check your current jobs
# --------------------------------
# Run this command to see all your jobs:
#
#    squeue -u $USER
#
# You'll see output like this:
#
#    JOBID  PARTITION     NAME           USER     ST  TIME  NODES  START_TIME
#    12345  batch_gpu     recurring_py   nassar   R   0:05  1      N/A
#    12346  batch_gpu     recurring_py   nassar   PD  0:00  1      2026-02-07T14:00:00
#
# Explanation:
# - Job 12345: Currently RUNNING (ST = R)
# - Job 12346: PENDING (ST = PD), scheduled to start at 2PM tomorrow
#
# STEP 2: Cancel the PENDING job
# -------------------------------
# This is the MOST IMPORTANT step - it breaks the chain!
#
#    scancel 12346
#
# Replace "12346" with YOUR pending job ID from step 1
#
# What happens:
# - The currently running job (12345) will finish normally
# - The next scheduled job (12346) is cancelled
# - No new jobs will be scheduled after that
# - The chain is BROKEN ✓
#
# STEP 3: (Optional) Cancel the running job too
# ----------------------------------------------
# If you want to stop everything immediately:
#
#    scancel 12345 12346
#
# Or cancel ALL your jobs at once:
#
#    scancel -u $USER
#
# ⚠️ WARNING: This cancels EVERYTHING, including non-recurring jobs!
#
# ============================================
# ADVANCED: Cancel Only Recurring Jobs
# ============================================
#
# If you have other jobs running and only want to cancel
# the recurring ones, use the job name:
#
#    scancel --name=recurring_python
#
# This cancels all jobs with that specific name, but leaves
# your other jobs running.
#
# ============================================
# VERIFICATION: Make Sure It Stopped
# ============================================
#
# After canceling, check again:
#
#    squeue -u $USER
#
# You should see:
# - Either NO jobs (if you cancelled everything)
# - Or only your OTHER jobs (not the recurring ones)
#
# If you still see pending recurring jobs, repeat STEP 2
#
# ============================================
# COMMON MISTAKES TO AVOID
# ============================================
#
# ❌ MISTAKE 1: Only canceling the running job
#    - The pending job will still start later!
#    - Always cancel the PENDING job to break the chain
#
# ❌ MISTAKE 2: Forgetting you have recurring jobs
#    - Set a reminder to check your jobs periodically
#    - Or add this to your crontab:
#      0 9 * * * squeue -u $USER | mail -s "Your SLURM jobs" your@email.com
#
# ❌ MISTAKE 3: Using scancel -u $USER without thinking
#    - This cancels EVERYTHING, even important non-recurring jobs
#    - Use --name instead if you have multiple job types
#
# ============================================
# QUICK REFERENCE COMMANDS
# ============================================
#
# See all your jobs:
#    squeue -u $USER
#
# See only pending jobs:
#    squeue -u $USER -t PD
#
# See only running jobs:
#    squeue -u $USER -t R
#
# Cancel specific job:
#    scancel <job_id>
#
# Cancel all your jobs:
#    scancel -u $USER
#
# Cancel by job name:
#    scancel --name=recurring_python
#
# Cancel multiple specific jobs:
#    scancel 12345 12346 12347
#
# See job history (past 24 hours):
#    sacct -u $USER --starttime=now-1day
#
# ============================================
