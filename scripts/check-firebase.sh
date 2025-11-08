#!/usr/bin/env bash
set -e

echo "🔍 Checking Firebase Android Configuration..."
echo ""

# Check if google-services.json exists
if [ -f "android/app/google-services.json" ]; then
    echo "✅ google-services.json found"
    
    # Check if it's still the template
    if grep -q "_comment.*TEMPLATE" "android/app/google-services.json" 2>/dev/null; then
        echo "⚠️  WARNING: google-services.json appears to be the template file"
        echo "   Please download the actual file from Firebase Console"
        echo ""
        echo "📝 Instructions:"
        echo "   1. Go to https://console.firebase.google.com/"
        echo "   2. Select your project"
        echo "   3. Settings → Project settings → Your apps"
        echo "   4. Download google-services.json for Android app (com.example.fbla)"
        echo "   5. Replace android/app/google-services.json with the downloaded file"
        echo ""
        exit 1
    else
        echo "✅ google-services.json appears to be a valid configuration"
    fi
else
    echo "❌ google-services.json NOT found"
    echo ""
    echo "📝 To fix this:"
    echo "   1. Go to Firebase Console: https://console.firebase.google.com/"
    echo "   2. Select your project (or create one)"
    echo "   3. Add an Android app with package name: com.example.fbla"
    echo "   4. Download google-services.json"
    echo "   5. Place it at: android/app/google-services.json"
    echo ""
    echo "💡 See FIREBASE_SETUP.md for detailed instructions"
    exit 1
fi

# Check if Google Services plugin is in build.gradle
if grep -q "google-services" "android/app/build.gradle.kts"; then
    echo "✅ Google Services plugin configured in build.gradle.kts"
else
    echo "⚠️  Google Services plugin not found in build.gradle.kts"
fi

echo ""
echo "✅ Firebase configuration check complete!"
echo ""
echo "🚀 Ready to run: bash scripts/start-emulator-and-run.sh"
