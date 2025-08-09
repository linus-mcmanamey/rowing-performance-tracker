# Performance Guidelines

## iOS Performance (Device-Aware)
- **BLE parsing**: Must complete within 50ms (100ms on older devices)
- **UI updates**: 60fps on newer devices, 30fps acceptable on iPhone 6S/7
- **Power curve rendering**: < 16ms per frame (simplified on older devices)
- **Memory usage**: Adaptive data retention based on device capabilities
- **CloudKit sync**: Background queue with device-appropriate batch sizes
- **Battery optimization**: Reduced update frequencies on older devices

## Backend Performance
- API response time < 200ms (p95)
- WebSocket latency < 100ms
- Database queries indexed and optimized
- Connection pooling (min: 5, max: 20)
- Redis caching for frequently accessed data

## Database Performance
```sql
-- Critical indexes
CREATE INDEX idx_sessions_athlete_time ON sessions(athlete_id, start_time DESC);
CREATE INDEX idx_metrics_session_time ON performance_metrics(session_id, timestamp);

-- Partitioning for time-series (TimescaleDB)
SELECT create_hypertable('performance_metrics', 'timestamp', chunk_time_interval => INTERVAL '1 day');
```
