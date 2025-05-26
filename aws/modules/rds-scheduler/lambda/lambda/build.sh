#!/bin/bash
set -e

# Create a temporary directory for building
BUILD_DIR="build"
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR

# Copy source code and rename the main file
cp -r src/* $BUILD_DIR/
mv $BUILD_DIR/rds_scheduler.py $BUILD_DIR/lambda_function.py

# Install dependencies into the build directory
pip install -r src/requirements.txt --target $BUILD_DIR

# Create deployment package
cd $BUILD_DIR
zip -r ../lambda_function.zip .
cd ..

# Cleanup
rm -rf $BUILD_DIR

# Return a valid JSON output for the external data source
echo '{"status": "success", "timestamp": "'$(date +%s)'"}' 