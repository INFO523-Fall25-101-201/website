#!/bin/bash

# Exit on error
set -e

echo "Starting deployment process..."

# Step 1: Render the website
echo "Rendering website with Quarto..."
quarto render

# Step 2: Clone the repository into doc-temp
echo "Cloning repository into doc-temp..."
rm -rf doc-temp
git clone https://github.com/INFO523-Fall25-101-201/info523-fall25-101-201.github.io.git doc-temp --depth 1

# Step 3: Change to doc-temp and pull latest changes
cd doc-temp
echo "Pulling latest changes..."
git pull origin main

# Step 4: Delete all existing files (except .git)
echo "Deleting all existing files..."
find . -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +

# Step 5: Copy docs folder contents
echo "Copying docs folder contents..."
cp -r ../docs/* .
cp -r ../docs/.[^.]* . 2>/dev/null || true

# Step 6: Stage all files
echo "Staging all files..."
git add -A

# Step 7: Commit changes
echo "Committing changes..."
git commit -m "Deploy website $(date '+%Y-%m-%d %H:%M:%S')" || echo "No changes to commit"

# Step 8: Push to main branch
echo "Pushing to website-release repository..."
git push origin main

# Step 9: Clean up
cd ..
rm -rf doc-temp

echo "Deployment complete!"