#!/bin/bash

# Set the static repository URL
repository_url="git@github.com:bigearsenal/xcodegen-scaffold.git"

# Function to clone the static GitHub repository and perform replacements
clone_and_configure() {
    local app_name="$1"
    local bundle_id="$2"
    
    # Clone the static repository
    git clone "$repository_url" "$app_name"
    
    # Change directory to the cloned repository
    cd "$app_name"
    
    # Find and replace "Scaffold" with the provided app name in project.yml
    sed -i.bak "s/info.bigears.Scaffold/$bundle_id/gI" project.yml
    sed -i.bak "s/Scaffold/$app_name/gI" project.yml
    rm project.yml.bak

    # Find and replace "Scaffold" with the provided app name in .gitignore
    sed -i.bak "s/Scaffold/$app_name/gI" .gitignore
    rm .gitignore.bak

    # Rename the ScaffoldKit in the Packages directory to <app_name>Kit
    mv "Packages/ScaffoldKit" "Packages/${app_name}Kit"
    
    # Rename the ScaffoldUI in the Scaffold directory to <app_name>UI
    mv "Scaffold/ScaffoldUI" "Scaffold/${app_name}UI"
    
    # Rename the Scaffold folder
    mv Scaffold "$app_name"

    # Rename the ScaffoldApp file to <app_name>App
    mv "${app_name}/Application/ScaffoldApp.swift" "${app_name}/Application/${app_name}App.swift"

    # Replace "ScaffoldApp" with ${app_name}App in ${app_name}App.swift
    sed -i.bak "s/ScaffoldApp/${app_name}App/gI" "${app_name}/Application/${app_name}App.swift"
    rm "${app_name}/Application/${app_name}App.swift.bak"

    # Replace "Scaffold" with ${app_name} in Packages/${app_name}Kit/Package.swift
    sed -i.bak "s/Scaffold/${app_name}/gI" "Packages/${app_name}Kit/Package.swift"
    rm "Packages/${app_name}Kit/Package.swift.bak"

    # Replace "Scaffold" with ${app_name} in Packages/${app_name}Kit/Package.swift
    sed -i.bak "s/Scaffold/${app_name}/gI" "Packages/${app_name}Kit/Package.swift"
    rm "Packages/${app_name}Kit/Package.swift.bak"

    # Rename Packages/${app_name}Kit/Sources/ScaffoldKit
    mv "Packages/${app_name}Kit/Sources/ScaffoldKit" "Packages/${app_name}Kit/Sources/${app_name}Kit"
    mv "Packages/${app_name}Kit/Sources/${app_name}Kit/ScaffoldKit.swift" "Packages/${app_name}Kit/Sources/${app_name}Kit/${app_name}Kit.swift"
    sed -i.bak "s/Scaffold/${app_name}/gI" "Packages/${app_name}Kit/Sources/${app_name}Kit/${app_name}Kit.swift"
    rm "Packages/${app_name}Kit/Sources/${app_name}Kit/${app_name}Kit.swift.bak"

    # Rename Packages/${app_name}Kit/Sources/ScaffoldKit
    mv "Packages/${app_name}Kit/Tests/ScaffoldKitTests" "Packages/${app_name}Kit/Tests/${app_name}KitTests"
    mv "Packages/${app_name}Kit/Tests/${app_name}KitTests/ScaffoldKitTests.swift" "Packages/${app_name}Kit/Tests/${app_name}KitTests/${app_name}Tests.swift"
    sed -i.bak "s/Scaffold/${app_name}/gI" "Packages/${app_name}Kit/Tests/${app_name}KitTests/${app_name}Tests.swift"
    rm "Packages/${app_name}Kit/Tests/${app_name}KitTests/${app_name}Tests.swift.bak"
    
    # Create an empty Config.xcconfig file in the Application folder
    touch "$app_name/Application/Config.xcconfig"

    # xcodegen
    xcodegen

    # Initialize a new Git repository
    rm -rf ".git"
    git init
    
    # Create an initial commit
    git add .
    git commit -m "Initial commit"

    xed .
}

# Main script starts here

# Check if the required number of arguments is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <app_name> <bundle_id> <team_id>"
    exit 1
fi

app_name="$1"
bundle_id="$2"

# Check if the directory already exists
if [ -d "$app_name" ]; then
    echo "Directory '$app_name' already exists. Please choose a different name or delete the existing directory."
    exit 1
fi

# Call the function to clone the repository and configure
clone_and_configure "$app_name" "$bundle_id"

echo "Setup completed for $app_name."
