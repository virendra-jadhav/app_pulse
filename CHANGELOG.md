# CHANGELOG

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
