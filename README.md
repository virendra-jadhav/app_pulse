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
end
```

# Basic Usage (Rack / Sinatra)
```ruby
require "app_pulse"

AppPulse.configure do |config|
  config.output_path = "log/app_pulse"
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

#Fault Tolerance

- Errors inside app_pulse never break your app

- Writer failures are swallowed intentionally

- Application exceptions are re-raised

- Observability must never affect availability.

#Compatibility
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

# Roadmap
**v0.1.0 (current)**

- Request lifecycle collection

- CSV / JSON / Text writers

- Rack middleware

- File-based storage

**Planned**

- v0.2.x → configurable thresholds

- v0.3.x → aggregation helpers

- v1.0 → stable observability core

**Future Extensions (separate gems)**

- `app_pulse-sql`

- `app_pulse-jobs`

- `app_pulse-exporter`

- `app_pulse-dashboard`

**Development & Testing**

- RSpec for unit tests

- Tested with:

- - Rails (modern Ruby)

- - Rack (Ruby 2.3)

- RuboCop compatible

- No CI lock-in

#License

MIT License © Virendra Jadhav

**Final Notes**

`app_pulse` is intentionally boring.

That’s a feature.

It gives you raw, trustworthy signals so you can decide what to do with them later — in reports, dashboards, or external systems.