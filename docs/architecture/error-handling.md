# Error Handling

## iOS Error Handling
```swift
enum PM5Error: LocalizedError {
    case bluetoothNotAvailable
    case deviceNotFound
    case connectionFailed(String)
    case dataParsingError
    case syncFailed(Error)
    case deviceCapabilityLimitReached
    
    var errorDescription: String? {
        switch self {
        case .bluetoothNotAvailable:
            return "Bluetooth is not available"
        case .deviceNotFound:
            return "PM5 monitor not found"
        case .connectionFailed(let reason):
            return "Connection failed: \(reason)"
        case .dataParsingError:
            return "Unable to parse PM5 data"
        case .syncFailed(let error):
            return "Sync failed: \(error.localizedDescription)"
        case .deviceCapabilityLimitReached:
            return "Feature not available on this device. Consider upgrading to a newer iPhone for full functionality."
        }
    }
}
```

## Backend Error Handling
```typescript
class AppError extends Error {
  constructor(
    public statusCode: number,
    public message: string,
    public isOperational = true
  ) {
    super(message);
  }
}

app.use((err: AppError, req, res, next) => {
  const { statusCode = 500, message } = err;
  logger.error({ error: err, request: req.url });
  res.status(statusCode).json({
    error: { message: statusCode === 500 ? 'Internal server error' : message }
  });
});
```
