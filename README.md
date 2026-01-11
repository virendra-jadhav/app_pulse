[![Gem Version](https://badge.fury.io/rb/app_pulse.svg)](https://rubygems.org/gems/app_pulse)

# app_pulse

> **Lightweight request signal collection for Ruby applications**  
> Collect signals today. Derive insights tomorrow.

`app_pulse` is a small, production-safe Ruby gem that tracks HTTP request lifecycle signals using Rack middleware and stores them in simple, file-based formats for offline analysis.

It is **not** an APM, **not** an optimizer, and **not** a dashboard.  
It is a **signal collector**.

---

## Philosophy

- Collect signals, not opinions
- Be lightweight and production-safe
- Zero configuration by default
- No Rails internals in core
- No database writes
- Data first, insights later
- Extensible via future gems

`app_pulse` is designed to run quietly in production without affecting request flow.

---

## What app_pulse Is (and Is Not)

### ✅ What it does
- Tracks HTTP requests via Rack middleware
- Measures request duration
- Captures status and failures
- Stores data in rotating files (CSV / JSON / Text)
- Works with Rails, Rack, Sinatra, and other Rack apps

### ❌ What it does NOT do
- No automatic optimization
- No performance advice
- No UI or dashboard
- No DB writes
- No Rails-only behavior

---

## Installation

Add to your `Gemfile`:

```ruby
gem "app_pulse"
```

Or for local development:
```
gem "app_pulse", path: "../app_pulse"
```
Then run:
```
bundle install
```
# Basic Usage (Rails)
**1. Add middleware**
```
# config/application.rb
config.middleware.use AppPulse::Middleware::Request
```


That’s it.
No initializer is required unless you want custom configuration.

**2. (Optional) Configuration**
```
# config/initializers/app_pulse.rb
AppPulse.configure do |config|
  config.output_path = "log/app_pulse"
  config.output_format = :csv
  config.sampling_rate = 1.0
  config.slow_threshold_ms = 500
end
```

# Basic Usage (Rack / Sinatra)
```ruby
require "app_pulse"

AppPulse.configure do |config|
  config.output_path = "log/app_pulse"
  config.slow_threshold_ms = 500
end

use AppPulse::Middleware::Request

run ->(env) {
  [200, { "Content-Type" => "text/plain" }, ["OK"]]
}
```
**Collected Signals**
For each request, app_pulse captures:
| Field       | Description                      |
| ----------- | -------------------------------- |
| timestamp   | UTC ISO-8601 timestamp           |
| method      | HTTP method                      |
| path        | Request path                     |
| status      | HTTP status code                 |
| duration_ms | Request duration in milliseconds |
| success     | `true` if status < 500           |
| error       | Error message (if any)           |


**Output Formats**
CSV (default)
```
2026-01-10T14:35:22Z,GET,/health,200,3.2,true,
2026-01-10T14:35:30Z,GET,/error,500,2.1,false,Boom!
```
JSON
```
{"timestamp":"2026-01-10T14:35:22Z","method":"GET","path":"/health","status":200,"duration_ms":3.2,"success":true,"error":null}

```
Text
```
timestamp=2026-01-10T14:35:22Z | method=GET | path=/health | status=200 | duration_ms=3.2 | success=true | error=

```
**File Rotation**

- Files are rotated daily

- One file per format per day

- No file locking

- Append-only writes

Example:
```
log/app_pulse/
├── 2026-01-10.csv
├── 2026-01-11.csv

```

**Sampling**
```
config.sampling_rate = 0.3
```

- 1.0 → collect 100% of requests

- 0.3 → collect ~30%

- 0.1 → collect ~10%

Sampling is:

- Stateless

- Thread-safe

- Cheap

- Industry standard

## Slow Request Threshold

By default, app_pulse collects all sampled requests.

You can optionally configure a slow request threshold to collect
only requests that exceed a given duration.

```ruby
config.slow_threshold_ms = 500
```
**Behavior:**

- `nil` (default) → collect all requests

- `500` → collect only requests taking 500ms or longer

This helps reduce noise in high-traffic applications
without changing the meaning of collected signals.

**Notes:**

- The threshold is applied after sampling

- No errors or insights are inferred

- This is a filtering mechanism, not an optimization

--- 

## Fault Tolerance

- Errors inside app_pulse never break your app

- Writer failures are swallowed intentionally

- Application exceptions are re-raised

- Observability must never affect availability.

---

## Compatibility
**Ruby**

- Ruby 2.3+ (tested on 2.3.8 and modern Ruby)

- Designed to avoid modern syntax

**Frameworks**

- Rails

- Rack

- Sinatra

- Any Rack-compatible framework

**Dependencies**

- No Rails dependency in core

- No database

- No ActiveSupport

---

# Versioning

`app_pulse` follows Semantic Versioning with a deliberately conservative approach.

- **v0.x**

  - Core behavior is stable

  - Internal structure may evolve

  - New features are additive and opt-in

  - Breaking changes (if any) are documented clearly

- **v1.0**

  - Core APIs are frozen

  - Extension points are finalized

  - Intended for long-term production use

Version bumps are intentional and documented in the changelog.

---
# Roadmap

- **v0.1.x**

  - Request lifecycle signal collection

  - Rack middleware

  - CSV / JSON / Text writers

  - File-based storage

  - Configurable sampling

  - Production-safe, fault-tolerant design

- **v0.2.x**

  - Configurable signal filtering

  - Slow request thresholds

- **v0.3.x**

  - Aggregation helpers

  - Slow endpoint identification

  - Error frequency summaries

  - Structured data preparation for reports

- **v1.0**

  - Stable observability core

  - Frozen public APIs

  - Extension-ready architecture

- **Future Extensions (separate projects)**

  - `app_pulse-sql` → database query timing

  - `app_pulse-jobs` → background job tracking

  - `app_pulse-exporter` → external systems

  - `app_pulse-dashboard` → UI & reports

---

## Development & Testing

- RSpec for unit tests

- Tested with:

    - Rails (modern Ruby)

    - Rack (Ruby 2.3)

- RuboCop compatible

- No CI lock-in

# License

MIT License © Virendra Jadhav

## Feedback & Roadmap

app_pulse is intentionally minimal in its early versions.

Feedback, real-world use cases, and design discussions are welcome.
Please open an issue for:
- feature requests
- design questions
- integration ideas

Dashboards and insights are planned as separate projects.


**Final Notes**

`app_pulse` is intentionally boring.

That’s a feature.

It gives you raw, trustworthy signals so you can decide what to do with them later — in reports, dashboards, or external systems.