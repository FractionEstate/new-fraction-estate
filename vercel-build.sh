#!/bin/bash
set -e

# Function to log messages
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check and install dependencies
check_dependencies() {
    log "Checking dependencies..."
    if ! command_exists node; then
        log "Node.js not found. Installing Node.js 22.x..."
        curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
        apt-get install -y nodejs
    fi

    if ! command_exists npm; then
        log "npm not found. Installing npm..."
        apt-get install -y npm
    fi

    if ! command_exists git; then
        log "Git not found. Installing Git..."
        apt-get install -y git
    fi
}

# Setup Git configuration
setup_git() {
    log "Setting up Git configuration..."
    git config --global user.email "daniel@fraction.estate"
    git config --global user.name "Fraction Estate"

    if [ ! -d .git ]; then
        log "Initializing Git repository..."
        git init
        git remote add origin https://github.com/FractionEstate/new-fraction-estate.git
    fi

    if ! git remote get-url origin >/dev/null 2>&1; then
        log "Setting Git remote..."
        git remote add origin https://github.com/FractionEstate/new-fraction-estate.git
    fi
}

# Run Next.js build
run_nextjs_build() {
    log "Installing dependencies..."
    npm ci

    log "Running Next.js build..."
    npm run build
}

# Commit and push changes
commit_and_push() {
    log "Committing changes..."
    git add .
    git commit -m "Vercel build update $(date '+%Y-%m-%d %H:%M:%S')"

    log "Pushing to GitHub..."
    if [ -z "$GITHUB_TOKEN" ]; then
        log "Error: GITHUB_TOKEN is not set. Please set it in your Vercel project settings."
        exit 1
    fi
    git push https://${GITHUB_TOKEN}@github.com/FractionEstate/new-fraction-estate.git HEAD:main --force
}

# Main execution
main() {
    log "Starting build process..."
    check_dependencies
    setup_git
    run_nextjs_build

    log "Running complete_build.sh script..."
    bash SmartContracts/dapp/complete_build.sh

    commit_and_push
    log "Build process completed successfully."
}

# Run the main function
main
