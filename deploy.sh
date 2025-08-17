#!/bin/bash

# Exit on error
set -e

echo "Starting deployment process..."

# Step 1: Render the website
echo "Rendering website with Quarto..."
quarto render

# Step 2: Initialize git in docs folder if needed
cd docs
if [ ! -d .git ]; then
    git init
fi

# Step 3: Add remote if not exists
if ! git remote | grep -q "origin"; then
    git remote add origin https://github.com/INFO523-Fall25-101-201/website-release.git
fi

# Step 4: Stage all files
echo "Staging all files in docs folder..."
git add -A

# Step 5: Commit changes
echo "Committing changes..."
git commit -m "Deploy website $(date '+%Y-%m-%d %H:%M:%S')" || echo "No changes to commit"

# Step 6: Force push to main branch
echo "Force pushing to website-release repository..."
git push -f origin main

echo "Deployment complete!"