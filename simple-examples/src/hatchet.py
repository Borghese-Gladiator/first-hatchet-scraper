import os
from hatchet_sdk import Hatchet
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Access the SERVER_GRPC_PORT environment variable
server_grpc_port = os.getenv('SERVER_GRPC_PORT')

if server_grpc_port:
    print(f"SERVER_GRPC_PORT: {server_grpc_port}")
else:
    print("SERVER_GRPC_PORT environment variable is not set.")

# Create a Hatchet instance that will be shared across all workflows
hatchet = Hatchet(debug=True)
