# Feather Mail

An abstract mail component for Feather CMS.

[![Release: 1.0.0-rc.2](https://img.shields.io/badge/Release-1%2E0%2E0--rc%2E2-F05138)](https://github.com/feather-framework/feather-mail/releases/tag/1.0.0-rc.2)

## Features

- Mail currency type to send messages
- Validation helpers and errors
- Raw MIME encoder for transport providers
- Attachments and HTML support

## Requirements

![Swift 6.3+](https://img.shields.io/badge/Swift-6%2E3%2B-F05138)
![Platforms: Linux, macOS, iOS, tvOS, watchOS, visionOS](https://img.shields.io/badge/Platforms-Linux_%7C_macOS_%7C_iOS_%7C_tvOS_%7C_watchOS_%7C_visionOS-F05138)

- Swift 6.3+
- Platforms:
  - Linux
  - macOS 15+
  - iOS 18+
  - tvOS 18+
  - watchOS 11+
  - visionOS 2+

## Installation

Use Swift Package Manager; add the dependency to your `Package.swift` file:

```swift
.package(url: "https://github.com/feather-framework/feather-mail", exact: "1.0.0-rc.2"),
```

Then add `FeatherMail` to your target dependencies:

```swift
.product(name: "FeatherMail", package: "feather-mail"),
```

For in-memory test support, add `FeatherMailTesting`:

```swift
.product(name: "FeatherMailTesting", package: "feather-mail"),
```

`TestMailClient` validates and records sent messages. Use `getMailbox()` to
inspect them and `clearMailbox()` to reset the client between test cases.

## Usage

[![DocC API documentation](https://img.shields.io/badge/DocC-API_documentation-F05138)](https://feather-framework.github.io/feather-mail/)

API documentation is available at the following link.

> [!WARNING]
> This repository is a work in progress, things can break until it reaches v1.0.0.

## Mail implementations

The following mail client implementations are available for use:

- [Feather Mail SES](https://github.com/feather-framework/feather-mail-ses)
- [Feather Mail SMTP](https://github.com/feather-framework/feather-mail-smtp)

The in-memory testing client is provided by `FeatherMailTesting` in this
package; it is not a delivery provider.

## Development

- Build: `swift build`
- Test:
  - local: `make test`
  - using Docker: `make docker-test`
- Format: `make format`
- Check: `make check`

## Contributing

[Pull requests](https://github.com/feather-framework/feather-mail/pulls) are welcome. Please keep changes focused and include tests for new logic.
