import os
import torch

# Check which GPU was assigned
print(f"Node: {os.environ.get('HOSTNAME', 'Unknown')}")
print(f"GPU: {os.environ.get('CUDA_VISIBLE_DEVICES', 'Not set')}")

# Verify PyTorch can access GPU
print(f"\nPyTorch version: {torch.__version__}")
print(f"CUDA available: {torch.cuda.is_available()}")

if torch.cuda.is_available():
    print(f"GPU name: {torch.cuda.get_device_name(0)}")
    print(f"GPU memory: {torch.cuda.get_device_properties(0).total_memory / 1024**3:.1f} GB")
