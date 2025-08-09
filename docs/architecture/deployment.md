# Deployment

## iOS App Deployment

### TestFlight (Beta)
```yaml
name: iOS Beta Release
on:
  push:
    branches: [release/*]

jobs:
  deploy:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - name: Build for iOS 15+ compatibility
        run: |
          xcodebuild -scheme d_n_w -configuration Release \
            IPHONEOS_DEPLOYMENT_TARGET=15.0 \
            archive -archivePath d_n_w.xcarchive
      - name: Upload to TestFlight
        env:
          APP_STORE_CONNECT_API_KEY: ${{ secrets.APP_STORE_KEY }}
        run: |
          xcodebuild -exportArchive -archivePath d_n_w.xcarchive
          xcrun altool --upload-app --file d_n_w.ipa
```

## Backend Deployment

### Self-Hosted Deployment
```bash