# Monitoring & Observability

## Application Monitoring

### iOS Monitoring
```swift
// Crash reporting with Sentry
SentrySDK.start { options in
    options.dsn = "your-sentry-dsn"
    options.environment = "production"
    options.tracesSampleRate = 0.1
}

// Device-specific analytics
Analytics.track("session_started", properties: [
    "pm5_model": deviceInfo.model,
    "connection_type": "bluetooth",
    "signal_strength": rssi,
    "device_model": UIDevice.current.modelName,
    "ios_version": UIDevice.current.systemVersion,
    "memory_tier": capabilities.memoryTier.rawValue
])
```

### Backend Monitoring
```typescript
// Prometheus metrics
const httpRequestDuration = new promClient.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status'],
});
```

## Infrastructure Monitoring

Self-Hosted:
```yaml
services:
  prometheus:
    image: prom/prometheus
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
```
