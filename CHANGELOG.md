# CHANGELOG

## [0.2.0] – Signal Filtering

### Added
- Configurable slow request threshold (`slow_threshold_ms`)
- Ability to collect only slow requests without changing signal semantics

### Notes
- Filtering is applied after sampling
- Default behavior is unchanged when the threshold is not set
- No insights, rankings, or opinions are introduced
- Backward compatible and opt-in

## [0.1.1] – Packaging Fix

### Fixed
- Ensure config file is included in the gem package
- Remove built `.gem` artifacts from source control
- Fix runtime load error when requiring the gem


## [0.1.0] – Initial Release

### Added
- Rack middleware for HTTP request lifecycle tracking
- Request duration measurement using monotonic clock
- CSV, JSON, and Text output writers
- Daily file rotation
- Configurable sampling rate
- Fault-tolerant design (never breaks host app)

### Notes  
- File-based storage only (no DB writes)
- Rails-agnostic core
- Ruby 2.3+ compatible
