#!/bin/bash

# Vercel Build Script for Flutter Web
echo "Installing Flutter..."
git clone https://github.com/flutter/flutter.git -b stable

# Add flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

echo "Enabling Flutter Web..."
flutter config --enable-web

echo "Fetching dependencies..."
flutter pub get

echo "Building the Flutter Web App..."
flutter build web --release
