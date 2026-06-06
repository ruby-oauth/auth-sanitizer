<a href="https://github.com/ruby-oauth"><img alt="ruby-oauth Logo by Aboling0, CC BY-SA 4.0" src="https://logos.galtzo.com/assets/images/ruby-oauth/avatar-128px.svg" width="14%" align="right"/></a>

# 💎 Auth::Sanitizer

[![Version][👽versioni]][👽version] [![GitHub tag (latest SemVer)][⛳️tag-img]][⛳️tag] [![License: MIT][📄license-img]][📄license] [![Downloads Rank][👽dl-ranki]][👽dl-rank] [![CodeCov Test Coverage][🏀codecovi]][🏀codecov] [![Coveralls Test Coverage][🏀coveralls-img]][🏀coveralls] [![QLTY Test Coverage][🏀qlty-covi]][🏀qlty-cov] [![QLTY Maintainability][🏀qlty-mnti]][🏀qlty-mnt] [![CI Heads][🚎3-hd-wfi]][🚎3-hd-wf] [![CI Runtime Dependencies @ HEAD][🚎12-crh-wfi]][🚎12-crh-wf] [![CI Current][🚎11-c-wfi]][🚎11-c-wf] [![CI Truffle Ruby][🚎9-t-wfi]][🚎9-t-wf] [![CI JRuby][🚎10-j-wfi]][🚎10-j-wf] [![Deps Locked][🚎13-🔒️-wfi]][🚎13-🔒️-wf] [![Deps Unlocked][🚎14-🔓️-wfi]][🚎14-🔓️-wf] [![CI Test Coverage][🚎2-cov-wfi]][🚎2-cov-wf] [![CI Style][🚎5-st-wfi]][🚎5-st-wf] [![Apache SkyWalking Eyes License Compatibility Check][🚎15-🪪-wfi]][🚎15-🪪-wf]

`if ci_badges.map(&:color).detect { it != "green"}` ☝️ [let me know][✉️discord-invite], as I may have missed the [discord notification][✉️discord-invite].

---

`if ci_badges.map(&:color).all? { it == "green"}` 👇️ send money so I can do more of this. FLOSS maintenance is now my full-time job.

[![OpenCollective Backers][🖇osc-backers-i]][🖇osc-backers] [![OpenCollective Sponsors][🖇osc-sponsors-i]][🖇osc-sponsors] [![Sponsor Me on Github][🖇sponsor-img]][🖇sponsor] [![Liberapay Goal Progress][⛳liberapay-img]][⛳liberapay] [![Donate on PayPal][🖇paypal-img]][🖇paypal] [![Buy me a coffee][🖇buyme-small-img]][🖇buyme] [![Donate on Polar][🖇polar-img]][🖇polar] [![Donate at ko-fi.com][🖇kofi-img]][🖇kofi]

<details>
 <summary>👣 How will this project approach the September 2025 hostile takeover of RubyGems? 🚑️</summary>

I've summarized my thoughts in [this blog post](https://dev.to/galtzo/hostile-takeover-of-rubygems-my-thoughts-5hlo).

</details>

## 🌻 Synopsis <a href="https://discord.gg/3qme4XHNKN"><img alt="Galtzo FLOSS Logo by Aboling0, CC BY-SA 4.0" src="https://logos.galtzo.com/assets/images/galtzo-floss/avatar-128px.svg" width="8%" align="right"/></a> <a href="https://ruby-toolbox.com"><img alt="ruby-lang Logo, Yukihiro Matsumoto, Ruby Visual Identity Team, CC BY-SA 2.5" src="https://logos.galtzo.com/assets/images/ruby-lang/avatar-128px.svg" width="8%" align="right"/></a>

`auth-sanitizer` provides small, dependency-light helpers for keeping OAuth and authentication secrets out of object
inspection and log output.

The gem is intentionally narrow in scope. It does not change HTTP requests, token objects, persistence, or application
configuration for you. Instead, it gives host gems and applications two reusable redaction surfaces:

- `Auth::Sanitizer::FilteredAttributes` redacts selected attributes from standard Ruby `#inspect` output.
- `Auth::Sanitizer::SanitizedLogger` wraps an existing logger and redacts sensitive values from string log messages.

Out of the box, logger sanitization filters the key names most commonly found in OAuth and OpenID Connect debug output:

```ruby
Auth::Sanitizer.default_filtered_keys
# => [
#      "access_token",
#      "refresh_token",
#      "id_token",
#      "client_secret",
#      "assertion",
#      "code_verifier",
#      "token",
#    ]
```

Redacted values are replaced with `"[FILTERED]"` by default. The replacement label can be changed globally by installing
a provider, or per logger by passing `label:` to `Auth::Sanitizer::SanitizedLogger.new`.

The library snapshots filter configuration when a redacting object is initialized. That keeps already-created objects
and logger wrappers stable even if a host application changes its configuration later.

Consumers that need to avoid defining the generic top-level `Auth` namespace can use the isolated loader:

```ruby
require "auth_sanitizer/loader"

AUTH_SANITIZER = AuthSanitizer::Loader.load_isolated
```

The returned module is an anonymously namespaced `Auth::Sanitizer`, suitable for internal assignment in host gems.
Use `require: false` in gems that want to avoid every new top-level namespace, including `AuthSanitizer`; see
[Zero Top-Level Namespace Additions](#zero-top-level-namespace-additions).

This gem is used by the following libraries to ensure clean output:

- oauth
- oauth-tty
- oauth2
- omniauth-ldap
- omniauth-identity

## 💡 Info you can shake a stick at

| Tokens to Remember | [![Gem name][⛳️name-img]][⛳️gem-name] [![Gem namespace][⛳️namespace-img]][⛳️gem-namespace] |
|-------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Works with JRuby | [![JRuby 9.2 Compat][💎jruby-9.2i]][🚎jruby-9.2-wf] [![JRuby 9.3 Compat][💎jruby-9.3i]][🚎jruby-9.3-wf] <br/> [![JRuby 9.4 Compat][💎jruby-9.4i]][🚎jruby-9.4-wf] [![JRuby current Compat][💎jruby-c-i]][🚎10-j-wf] [![JRuby HEAD Compat][💎jruby-headi]][🚎3-hd-wf]|
| Works with Truffle Ruby | [![Truffle Ruby 22.3 Compat][💎truby-22.3i]][🚎truby-22.3-wf] [![Truffle Ruby 23.0 Compat][💎truby-23.0i]][🚎truby-23.0-wf] [![Truffle Ruby 23.1 Compat][💎truby-23.1i]][🚎truby-23.1-wf] <br/> [![Truffle Ruby 24.2 Compat][💎truby-24.2i]][🚎truby-24.2-wf] [![Truffle Ruby 25.0 Compat][💎truby-25.0i]][🚎truby-25.0-wf] [![Truffle Ruby current Compat][💎truby-c-i]][🚎9-t-wf]|
| Works with MRI Ruby 4 | [![Ruby 4.0 Compat][💎ruby-4.0i]][🚎11-c-wf] [![Ruby current Compat][💎ruby-c-i]][🚎11-c-wf] [![Ruby HEAD Compat][💎ruby-headi]][🚎3-hd-wf]|
| Works with MRI Ruby 3 | [![Ruby 3.0 Compat][💎ruby-3.0i]][🚎ruby-3.0-wf] [![Ruby 3.1 Compat][💎ruby-3.1i]][🚎ruby-3.1-wf] [![Ruby 3.2 Compat][💎ruby-3.2i]][🚎ruby-3.2-wf] [![Ruby 3.3 Compat][💎ruby-3.3i]][🚎ruby-3.3-wf] [![Ruby 3.4 Compat][💎ruby-3.4i]][🚎ruby-3.4-wf]|
| Works with MRI Ruby 2 | ![Ruby 2.2 Compat][💎ruby-2.2i] <br/> [![Ruby 2.4 Compat][💎ruby-2.4i]][🚎ruby-2.4-wf] [![Ruby 2.5 Compat][💎ruby-2.5i]][🚎ruby-2.5-wf] [![Ruby 2.6 Compat][💎ruby-2.6i]][🚎ruby-2.6-wf] [![Ruby 2.7 Compat][💎ruby-2.7i]][🚎ruby-2.7-wf]|
| Support & Community | [![Join Me on Daily.dev's RubyFriends][✉️ruby-friends-img]][✉️ruby-friends] [![Live Chat on Discord][✉️discord-invite-img-ftb]][✉️discord-invite] [![Get help from me on Upwork][👨🏼‍🏫expsup-upwork-img]][👨🏼‍🏫expsup-upwork] [![Get help from me on Codementor][👨🏼‍🏫expsup-codementor-img]][👨🏼‍🏫expsup-codementor] |
| Source | [![Source on GitLab.com][📜src-gl-img]][📜src-gl] [![Source on CodeBerg.org][📜src-cb-img]][📜src-cb] [![Source on Github.com][📜src-gh-img]][📜src-gh] [![The best SHA: dQw4w9WgXcQ!][🧮kloc-img]][🧮kloc] |
| Documentation | [![Current release on RubyDoc.info][📜docs-cr-rd-img]][🚎yard-current] [![YARD on Galtzo.com][📜docs-head-rd-img]][🚎yard-head] [![Maintainer Blog][🚂maint-blog-img]][🚂maint-blog] [![GitLab Wiki][📜gl-wiki-img]][📜gl-wiki] [![GitHub Wiki][📜gh-wiki-img]][📜gh-wiki] |
| Compliance | [![License: MIT][📄license-img]][📄license] [![Apache license compatibility: Category A][📄license-compat-img]][📄license-compat] [![📄ilo-declaration-img]][📄ilo-declaration] [![Security Policy][🔐security-img]][🔐security] [![Contributor Covenant 2.1][🪇conduct-img]][🪇conduct] [![SemVer 2.0.0][📌semver-img]][📌semver] |
| Style | [![Enforced Code Style Linter][💎rlts-img]][💎rlts] [![Keep-A-Changelog 1.0.0][📗keep-changelog-img]][📗keep-changelog] [![Gitmoji Commits][📌gitmoji-img]][📌gitmoji] [![Compatibility appraised by: appraisal2][💎appraisal2-img]][💎appraisal2] |
| Maintainer 🎖️ | [![Follow Me on LinkedIn][💖🖇linkedin-img]][💖🖇linkedin] [![Follow Me on Ruby.Social][💖🐘ruby-mast-img]][💖🐘ruby-mast] [![Follow Me on Bluesky][💖🦋bluesky-img]][💖🦋bluesky] [![Contact Maintainer][🚂maint-contact-img]][🚂maint-contact] [![My technical writing][💖💁🏼‍♂️devto-img]][💖💁🏼‍♂️devto] |
| `...` 💖 | [![Find Me on WellFound:][💖✌️wellfound-img]][💖✌️wellfound] [![Find Me on CrunchBase][💖💲crunchbase-img]][💖💲crunchbase] [![My LinkTree][💖🌳linktree-img]][💖🌳linktree] [![More About Me][💖💁🏼‍♂️aboutme-img]][💖💁🏼‍♂️aboutme] [🧊][💖🧊berg] [🐙][💖🐙hub] [🛖][💖🛖hut] [🧪][💖🧪lab] |

### Compatibility

Compatible with MRI Ruby 2.2.0+, and concordant releases of JRuby, and TruffleRuby.
CI workflows and Appraisals are generated for MRI Ruby 2.4+.
This test floor is configured by `ruby.test_minimum` in `.kettle-jem.yml` and
may be higher than the gem's runtime compatibility floor when legacy Rubies are
not practical for the current toolchain.

| 🚚 _Amazing_ test matrix was brought to you by | 🔎 appraisal2 🔎 and the color 💚 green 💚 |
|------------------------------------------------|--------------------------------------------------------|
| 👟 Check it out! | ✨ [github.com/appraisal-rb/appraisal2][💎appraisal2] ✨ |

### Federated DVCS

<details markdown="1">
 <summary>Find this repo on federated forges (Coming soon!)</summary>

| Federated [DVCS][💎d-in-dvcs] Repository | Status | Issues | PRs | Wiki | CI | Discussions |
|-------------------------------------------------|-----------------------------------------------------------------------|---------------------------|--------------------------|---------------------------|--------------------------|------------------------------|
| 🧪 [ruby-oauth/auth-sanitizer on GitLab][📜src-gl] | The Truth | [💚][🤝gl-issues] | [💚][🤝gl-pulls] | [💚][📜gl-wiki] | 🐭 Tiny Matrix | ➖ |
| 🧊 [ruby-oauth/auth-sanitizer on CodeBerg][📜src-cb] | An Ethical Mirror ([Donate][🤝cb-donate]) | [💚][🤝cb-issues] | [💚][🤝cb-pulls] | ➖ | ⭕️ No Matrix | ➖ |
| 🐙 [ruby-oauth/auth-sanitizer on GitHub][📜src-gh] | Another Mirror | [💚][🤝gh-issues] | [💚][🤝gh-pulls] | [💚][📜gh-wiki] | 💯 Full Matrix | [💚][gh-discussions] |
| 🎮️ [Discord Server][✉️discord-invite] | [![Live Chat on Discord][✉️discord-invite-img-ftb]][✉️discord-invite] | [Let's][✉️discord-invite] | [talk][✉️discord-invite] | [about][✉️discord-invite] | [this][✉️discord-invite] | [library!][✉️discord-invite] |

</details>

[gh-discussions]: https://github.com/ruby-oauth/auth-sanitizer/discussions

### Enterprise Support [![Tidelift](https://tidelift.com/badges/package/rubygems/auth-sanitizer)](https://tidelift.com/subscription/pkg/rubygems-auth-sanitizer?utm_source=rubygems-auth-sanitizer&utm_medium=referral&utm_campaign=readme)

Available as part of the Tidelift Subscription.

<details markdown="1">
 <summary>Need enterprise-level guarantees?</summary>

The maintainers of this and thousands of other packages are working with Tidelift to deliver commercial support and maintenance for the open source packages you use to build your applications. Save time, reduce risk, and improve code health, while paying the maintainers of the exact packages you use.

[![Get help from me on Tidelift][🏙️entsup-tidelift-img]][🏙️entsup-tidelift]

- 💡Subscribe for support guarantees covering _all_ your FLOSS dependencies
- 💡Tidelift is part of [Sonar][🏙️entsup-tidelift-sonar]
- 💡Tidelift pays maintainers to maintain the software you depend on!<br/>📊`@`Pointy Haired Boss: An [enterprise support][🏙️entsup-tidelift] subscription is "[never gonna let you down][🧮kloc]", and *supports* open source maintainers

Alternatively:

- [![Live Chat on Discord][✉️discord-invite-img-ftb]][✉️discord-invite]
- [![Get help from me on Upwork][👨🏼‍🏫expsup-upwork-img]][👨🏼‍🏫expsup-upwork]
- [![Get help from me on Codementor][👨🏼‍🏫expsup-codementor-img]][👨🏼‍🏫expsup-codementor]

</details>

## ✨ Installation

Install the gem and add to the application's Gemfile by executing:

```console
bundle add auth-sanitizer
```

If bundler is not being used to manage dependencies, install the gem by executing:

```console
gem install auth-sanitizer
```

## ⚙️ Configuration

Most applications can use the defaults. Configuration is available when a host gem or application wants to align
redaction with its own logging conventions.

### Loading Mode

This gem has two supported loading modes.

The direct API defines the top-level `Auth` namespace:

```ruby
require "auth/sanitizer"

class TokenResponse
  include Auth::Sanitizer::FilteredAttributes
end
```

This is convenient for applications that already own or intentionally use `Auth`.

Libraries and applications that need to avoid the generic top-level `Auth` namespace should use the isolated loader:

```ruby
require "auth_sanitizer/loader"

AUTH_SANITIZER = AuthSanitizer::Loader.load_isolated

class TokenResponse
  include AUTH_SANITIZER::FilteredAttributes
end
```

`AuthSanitizer::Loader.load_isolated` evaluates the sanitizer implementation inside an anonymous module and returns that
module's `Auth::Sanitizer` constant. Assign the returned module to a constant owned by your library or application, then
include from that constant.

When declaring the dependency in a Gemfile, prefer one of these explicit forms:

```ruby
gem "auth-sanitizer", require: false
```

or:

```ruby
gem "auth-sanitizer", require: "auth_sanitizer/loader"
```

Use `require: false` when the consuming library will decide which loading mode to use internally. Use
`require: "auth_sanitizer/loader"` when Bundler should make the isolated loader available during `Bundler.require`.

#### Zero Top-Level Namespace Additions

A gem that needs zero new top-level namespaces from this dependency can load the loader itself inside an anonymous
namespace. On Ruby 3.1+, use `Kernel.load(path, module)`:

```ruby
auth_sanitizer_requirement = Gem::Requirement.new("~> 0.1", ">= 0.1.3")
auth_sanitizer_spec = Gem.loaded_specs["auth-sanitizer"]
unless auth_sanitizer_spec && auth_sanitizer_requirement.satisfied_by?(auth_sanitizer_spec.version)
  auth_sanitizer_spec = Gem::Specification.find_by_name("auth-sanitizer", auth_sanitizer_requirement)
end
auth_sanitizer_loader_path = File.join(
  auth_sanitizer_spec.full_gem_path,
  "lib/auth_sanitizer/loader.rb"
)
unless File.file?(auth_sanitizer_loader_path)
  raise LoadError, "auth-sanitizer #{auth_sanitizer_requirement} loader not found at #{auth_sanitizer_loader_path}"
end

auth_sanitizer_loader_namespace = Module.new
Kernel.load(auth_sanitizer_loader_path, auth_sanitizer_loader_namespace)

AUTH_SANITIZER = auth_sanitizer_loader_namespace
  .const_get(:AuthSanitizer)
  .const_get(:Loader)
  .load_isolated
```

That pattern leaves both `Auth` and `AuthSanitizer` undefined at top level. The consuming gem should assign the returned
module under its own namespace and use that internal constant.

<details markdown="1">
  <summary>Ruby 2.2-compatible zero-top-level loading</summary>

Ruby 2.2 through Ruby 3.0 do not support `Kernel.load(path, module)`. For those versions, evaluate the loader source
inside an anonymous namespace with `Module#module_eval`:

```ruby
auth_sanitizer_requirement = Gem::Requirement.new("~> 0.1", ">= 0.1.3")
auth_sanitizer_spec = Gem.loaded_specs["auth-sanitizer"]
unless auth_sanitizer_spec && auth_sanitizer_requirement.satisfied_by?(auth_sanitizer_spec.version)
  auth_sanitizer_spec = Gem::Specification.find_by_name("auth-sanitizer", auth_sanitizer_requirement)
end
auth_sanitizer_loader_path = File.join(
  auth_sanitizer_spec.full_gem_path,
  "lib/auth_sanitizer/loader.rb"
)
unless File.file?(auth_sanitizer_loader_path)
  raise LoadError, "auth-sanitizer #{auth_sanitizer_requirement} loader not found at #{auth_sanitizer_loader_path}"
end

auth_sanitizer_loader_namespace = Module.new
auth_sanitizer_loader_namespace.module_eval(
  File.read(auth_sanitizer_loader_path),
  auth_sanitizer_loader_path,
  1
)

AUTH_SANITIZER = auth_sanitizer_loader_namespace
  .const_get(:AuthSanitizer)
  .const_get(:Loader)
  .load_isolated
```

</details>

### Filtered Label

The default replacement label is:

```ruby
Auth::Sanitizer.filtered_label
# => "[FILTERED]"
```

To use a different label globally, install a callable provider:

```ruby
Auth::Sanitizer.filtered_label_provider = -> { "[REDACTED]" }
```

The provider is called when a `FilteredAttributes` object or `SanitizedLogger` wrapper is initialized. Existing
instances keep the label they captured at initialization time:

```ruby
Auth::Sanitizer.filtered_label_provider = -> { "[FILTERED]" }
logger = Auth::Sanitizer::SanitizedLogger.new(Logger.new($stdout))

Auth::Sanitizer.filtered_label_provider = -> { "[REDACTED]" }

# `logger` still uses "[FILTERED]"; new wrappers use "[REDACTED]".
```

This makes it safe for libraries to delegate the label to host configuration:

```ruby
Auth::Sanitizer.filtered_label_provider = -> { MyGem.config.filtered_label }
```

### Logger Keys

`Auth::Sanitizer::SanitizedLogger` defaults to `Auth::Sanitizer.default_filtered_keys`. Pass `filtered_keys:` when your
application logs additional sensitive fields:

```ruby
logger = Auth::Sanitizer::SanitizedLogger.new(
  Logger.new($stdout),
  filtered_keys: Auth::Sanitizer.default_filtered_keys + %w[
    api_key
    private_key
    session_secret
  ]
)
```

You can also replace the list entirely:

```ruby
logger = Auth::Sanitizer::SanitizedLogger.new(
  Logger.new($stdout),
  filtered_keys: %w[my_secret],
  label: "[GONE]"
)
```

Logger key matching is case-insensitive for supported string formats. The keys are used to redact:

- JSON-style pairs, such as `"access_token": "abc123"` and `'client_secret': 'abc123'`
- query-string and form-encoded pairs, such as `access_token=abc123&scope=read`
- `Authorization:` header values, regardless of `filtered_keys`

Only string payloads are sanitized. Non-string log payloads are delegated unchanged to the wrapped logger.

### Inspect Attributes

Classes opt in to inspect redaction by including `Auth::Sanitizer::FilteredAttributes` and declaring the attribute names
that should be hidden:

```ruby
class OAuthCredential
  include Auth::Sanitizer::FilteredAttributes

  attr_reader :access_token, :expires_at

  filtered_attributes :access_token

  def initialize(access_token, expires_at)
    @access_token = access_token
    @expires_at = expires_at
  end
end
```

`FilteredAttributes#inspect` delegates to `super.inspect` first, then redacts only narrow, standard Ruby inspect
fragments for configured names. This preserves host object inspect behavior instead of rebuilding the object's output.

For example, `filtered_attributes :access_token` redacts `@access_token="..."` in normal object inspect output:

```ruby
OAuthCredential.new("secret", Time.now).inspect
# => #<OAuthCredential:0x... @access_token=[FILTERED], @expires_at=2026-06-04 08:00:00 -0600>
```

Configured names are also redacted when they appear as string-valued keys inside standard Ruby hash inspect fragments,
which is useful for adapter models that store attributes in an internal hash:

```ruby
class IdentityRecord
  include Auth::Sanitizer::FilteredAttributes

  filtered_attributes :password_digest

  def initialize(identity_data)
    @identity_data = identity_data
  end
end

IdentityRecord.new({id: 1, password_digest: "$2a$secret"}).inspect
# => #<IdentityRecord:0x... @identity_data={id: 1, password_digest: [FILTERED]}>
```

The inspect redactor intentionally leaves unsupported or highly customized inspect formats unchanged. It only replaces
quoted string values in these standard shapes:

- `@name="value"`
- `{name: "value"}`
- `{:name => "value"}`
- `{"name" => "value"}`

This conservative behavior avoids breaking host models whose `inspect` output has application-specific formatting.

Calling `filtered_attributes` again replaces the class-level list:

```ruby
OAuthCredential.filtered_attributes(:access_token, :refresh_token)
OAuthCredential.filtered_attribute_names
# => [:access_token, :refresh_token]
```

Passing no attributes clears the class-level list for subsequently initialized objects:

```ruby
OAuthCredential.filtered_attributes
OAuthCredential.filtered_attribute_names
# => []
```

As with logger wrappers, the per-object filter is captured during initialization. Objects that already exist keep their
original inspect behavior.

## 🔧 Basic Usage

Require the gem:

```ruby
require "auth/sanitizer"
```

Or load it without defining top-level `Auth`. This still defines top-level `AuthSanitizer`; see
[Zero Top-Level Namespace Additions](#zero-top-level-namespace-additions) for the stricter loading pattern.

```ruby
require "auth_sanitizer/loader"

AUTH_SANITIZER = AuthSanitizer::Loader.load_isolated

class TokenResponse
  include AUTH_SANITIZER::FilteredAttributes
end
```

### Redact `#inspect`

Use `Auth::Sanitizer::FilteredAttributes` for objects that may appear in exception messages, console sessions, or debug
output through `#inspect`:

```ruby
class TokenResponse
  include Auth::Sanitizer::FilteredAttributes

  attr_reader :access_token, :refresh_token, :scope

  filtered_attributes :access_token, :refresh_token

  def initialize(access_token:, refresh_token:, scope:)
    @access_token = access_token
    @refresh_token = refresh_token
    @scope = scope
  end
end

response = TokenResponse.new(
  access_token: "access-token-value",
  refresh_token: "refresh-token-value",
  scope: "profile email"
)

response.inspect
# => #<TokenResponse:0x... @access_token=[FILTERED], @refresh_token=[FILTERED], @scope="profile email">
```

Only the configured attributes are redacted. Other instance variables remain visible so inspected objects are still
useful while debugging. Inspect filtering is conservative: unsupported custom formats are left unchanged rather than
risking a malformed `inspect` result.

### Redact Logger Output

Wrap an existing logger with `Auth::Sanitizer::SanitizedLogger`:

```ruby
require "logger"
require "auth/sanitizer"

logger = Auth::Sanitizer::SanitizedLogger.new(Logger.new($stdout))

logger.debug("access_token=abc123&scope=profile")
# Logs: access_token=[FILTERED]&scope=profile

logger.debug('{"client_secret": "super-secret", "grant_type": "client_credentials"}')
# Logs: {"client_secret": "[FILTERED]", "grant_type": "client_credentials"}

logger.debug("Authorization: Bearer abc123")
# Logs: Authorization: "[FILTERED]"
```

The wrapper implements the common Ruby logger methods and sanitizes string values passed through them:

```ruby
logger.add(Logger::DEBUG, "refresh_token=abc123", "oauth")
logger << "id_token=abc123"

logger.debug { "code_verifier=abc123" }
logger.info("token=abc123")
logger.warn("client_secret=abc123")
logger.error("assertion=abc123")
logger.fatal("Authorization: Bearer abc123")
logger.unknown("access_token=abc123")
```

The wrapper also delegates common logger configuration to the wrapped logger when supported:

```ruby
logger.level = Logger::WARN
logger.progname = "my-app"
logger.formatter = proc { |_severity, _time, _progname, message| "#{message}\n" }
logger.close
```

Methods not implemented by the wrapper are delegated to the underlying logger when that logger responds to them.

### Custom Logger Keys

Use `filtered_keys:` for application-specific secrets:

```ruby
logger = Auth::Sanitizer::SanitizedLogger.new(
  Logger.new($stdout),
  filtered_keys: %w[access_token api_key signing_secret],
  label: "[SECRET]"
)

logger.debug("api_key=12345&access_token=abc123")
# Logs: api_key=[SECRET]&access_token=[SECRET]
```

`filtered_keys:` applies to JSON-style, query-string, and form-encoded key/value pairs. `Authorization:` headers are
always redacted by `SanitizedLogger`, even if `Authorization` is not listed as a filtered key.

### Important Limits

`auth-sanitizer` is a logging and inspection helper, not a complete secret-management system.

- It redacts supported string patterns before delegating to a logger.
- It does not mutate source hashes, token objects, HTTP requests, or HTTP responses.
- It does not recursively sanitize arbitrary Ruby objects passed to a logger as non-string payloads.
- It cannot protect secrets that are logged through a different logger, printed directly, or interpolated into an
  unsupported format.

For best results, wrap the logger as close as possible to the code that emits authentication debug output, and avoid
logging raw token structures unless they pass through the sanitizer first.

## 🦷 FLOSS Funding

While ruby-oauth tools are free software and will always be, the project would benefit immensely from some funding.
Raising a monthly budget of... "dollars" would make the project more sustainable.

We welcome both individual and corporate sponsors! We also offer a
wide array of funding channels to account for your preferences.
Currently, [Open Collective][🖇osc] is our preferred funding platform.

**If you're working in a company that's making significant use of ruby-oauth tools we'd
appreciate it if you suggest to your company to become a ruby-oauth sponsor.**

You can support the development of ruby-oauth tools via
[GitHub Sponsors][🖇sponsor],
[Liberapay][⛳liberapay],
[PayPal][🖇paypal],
[Open Collective][🖇osc]
and [Tidelift][🏙️entsup-tidelift].

| 📍 NOTE |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| If doing a sponsorship in the form of donation is problematic for your company <br/> from an accounting standpoint, we'd recommend the use of Tidelift, <br/> where you can get a support-like subscription instead. |

### Open Collective for Individuals

Support us with a monthly donation and help us continue our activities. [[Become a backer](https://opencollective.com/ruby-oauth#backer)]

NOTE: [kettle-readme-backers][kettle-readme-backers] updates this list every day, automatically.

<!-- OPENCOLLECTIVE-INDIVIDUALS:START -->
No backers yet. Be the first!
<!-- OPENCOLLECTIVE-INDIVIDUALS:END -->

### Open Collective for Organizations

Become a sponsor and get your logo on our README on GitHub with a link to your site. [[Become a sponsor](https://opencollective.com/ruby-oauth#sponsor)]

NOTE: [kettle-readme-backers][kettle-readme-backers] updates this list every day, automatically.

<!-- OPENCOLLECTIVE-ORGANIZATIONS:START -->
No sponsors yet. Be the first!
<!-- OPENCOLLECTIVE-ORGANIZATIONS:END -->

[kettle-readme-backers]: https://github.com/ruby-oauth/auth-sanitizer/blob/main/exe/kettle-readme-backers

### Another way to support open-source

I’m driven by a passion to foster a thriving open-source community – a space where people can tackle complex problems, no matter how small. Revitalizing libraries that have fallen into disrepair, and building new libraries focused on solving real-world challenges, are my passions. I was recently affected by layoffs, and the tech jobs market is unwelcoming. I’m reaching out here because your support would significantly aid my efforts to provide for my family, and my farm (11 🐔 chickens, 2 🐶 dogs, 3 🐰 rabbits, 8 🐈‍ cats).

If you work at a company that uses my work, please encourage them to support me as a corporate sponsor. My work on gems you use might show up in `bundle fund`.

I’m developing a new library, [floss_funding][🖇floss-funding-gem], designed to empower open-source developers like myself to get paid for the work we do, in a sustainable way. Please give it a look.

**[Floss-Funding.dev][🖇floss-funding.dev]: 👉️ No network calls. 👉️ No tracking. 👉️ No oversight. 👉️ Minimal crypto hashing. 💡 Easily disabled nags**

[![OpenCollective Backers][🖇osc-backers-i]][🖇osc-backers] [![OpenCollective Sponsors][🖇osc-sponsors-i]][🖇osc-sponsors] [![Sponsor Me on Github][🖇sponsor-img]][🖇sponsor] [![Liberapay Goal Progress][⛳liberapay-img]][⛳liberapay] [![Donate on PayPal][🖇paypal-img]][🖇paypal] [![Buy me a coffee][🖇buyme-small-img]][🖇buyme] [![Donate on Polar][🖇polar-img]][🖇polar] [![Donate to my FLOSS efforts at ko-fi.com][🖇kofi-img]][🖇kofi] [![Donate to my FLOSS efforts using Patreon][🖇patreon-img]][🖇patreon]

## 🔐 Security

See [SECURITY.md][🔐security].

## 🤝 Contributing

If you need some ideas of where to help, you could work on adding more code coverage,
or if it is already 💯 (see [below](#code-coverage)) check [issues][🤝gh-issues] or [PRs][🤝gh-pulls],
or use the gem and think about how it could be better.

We [![Keep A Changelog][📗keep-changelog-img]][📗keep-changelog] so if you make changes, remember to update it.

See [CONTRIBUTING.md][🤝contributing] for more detailed instructions.

### 🚀 Release Instructions

See [CONTRIBUTING.md][🤝contributing].

### Code Coverage

<details markdown="1">
<summary>Coverage service badges</summary>

[![Coverage Graph][🏀codecov-g]][🏀codecov]

[![Coveralls Test Coverage][🏀coveralls-img]][🏀coveralls]

[![QLTY Test Coverage][🏀qlty-covi]][🏀qlty-cov]

</details>

### 🪇 Code of Conduct

Everyone interacting with this project's codebases, issue trackers,
chat rooms and mailing lists agrees to follow the [![Contributor Covenant 2.1][🪇conduct-img]][🪇conduct].

## 🌈 Contributors

[![Contributors][🖐contributors-img]][🖐contributors]

Made with [contributors-img][🖐contrib-rocks].

Also see GitLab Contributors: [https://gitlab.com/ruby-oauth/auth-sanitizer/-/graphs/main][🚎contributors-gl]

<details>
 <summary>⭐️ Star History</summary>

<a href="https://star-history.com/ruby-oauth/auth-sanitizer&Date">
 <picture>
 <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=ruby-oauth/auth-sanitizer&type=Date&theme=dark" />
 <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=ruby-oauth/auth-sanitizer&type=Date" />
 <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=ruby-oauth/auth-sanitizer&type=Date" />
 </picture>
</a>

</details>

## 📌 Versioning

This library follows [![Semantic Versioning 2.0.0][📌semver-img]][📌semver] for its public API where practical.
For most applications, prefer the [Pessimistic Version Constraint][📌pvc] with two digits of precision.

For example:

```ruby
spec.add_dependency("auth-sanitizer", "~> 0.0")
```

<details markdown="1">
<summary>📌 Is "Platform Support" part of the public API? More details inside.</summary>

Dropping support for a platform can be a breaking change for affected users.
If a release changes supported platforms, it should be called out clearly in the changelog and versioned with that impact in mind.

To get a better understanding of how SemVer is intended to work over a project's lifetime,
read this article from the creator of SemVer:

- ["Major Version Numbers are Not Sacred"][📌major-versions-not-sacred]

</details>

See [CHANGELOG.md][📌changelog] for a list of releases.

## 📄 License

The gem is available as open source under the terms of
the [MIT](MIT.md) [![License: MIT][📄license-img]][📄license-ref].

### © Copyright

See [LICENSE.md][📄license] for the official copyright notice.

<details markdown="1">
<summary>Copyright holders</summary>

- Copyright (c) 2026 Peter H. Boling

</details>

## 🤑 A request for help

Maintainers have teeth and need to pay their dentists.
After getting laid off in an RIF in March, and encountering difficulty finding a new one,
I began spending most of my time building open source tools.
I'm hoping to be able to pay for my kids' health insurance this month,
so if you value the work I am doing, I need your support.
Please consider sponsoring me or the project.

To join the community or get help 👇️ Join the Discord.

[![Live Chat on Discord][✉️discord-invite-img-ftb]][✉️discord-invite]

To say "thanks!" ☝️ Join the Discord or 👇️ send money.

[![Sponsor ruby-oauth/auth-sanitizer on Open Source Collective][🖇osc-all-bottom-img]][🖇osc] 💌 [![Sponsor me on GitHub Sponsors][🖇sponsor-bottom-img]][🖇sponsor] 💌 [![Sponsor me on Liberapay][⛳liberapay-bottom-img]][⛳liberapay] 💌 [![Donate on PayPal][🖇paypal-bottom-img]][🖇paypal]

### Please give the project a star ⭐ ♥.

Many parts of this project are actively managed by a [kettle-jem](https://github.com/structuredmerge/structuredmerge-ruby/tree/main/gems/kettle-jem) smart template utilizing [StructuredMerge.org](https://structuredmerge.org) merge contracts.

Thanks for RTFM. ☺️

[⛳liberapay-img]: https://img.shields.io/liberapay/goal/pboling.svg?logo=liberapay&color=a51611&style=flat
[⛳liberapay-bottom-img]: https://img.shields.io/liberapay/goal/pboling.svg?style=for-the-badge&logo=liberapay&color=a51611
[⛳liberapay]: https://liberapay.com/pboling/donate
[🖇osc-all-img]: https://img.shields.io/opencollective/all/ruby-oauth
[🖇osc-sponsors-img]: https://img.shields.io/opencollective/sponsors/ruby-oauth
[🖇osc-backers-img]: https://img.shields.io/opencollective/backers/ruby-oauth
[🖇osc-backers]: https://opencollective.com/ruby-oauth#backer
[🖇osc-backers-i]: https://opencollective.com/ruby-oauth/backers/badge.svg?style=flat
[🖇osc-sponsors]: https://opencollective.com/ruby-oauth#sponsor
[🖇osc-sponsors-i]: https://opencollective.com/ruby-oauth/sponsors/badge.svg?style=flat
[🖇osc-all-bottom-img]: https://img.shields.io/opencollective/all/ruby-oauth?style=for-the-badge
[🖇osc-sponsors-bottom-img]: https://img.shields.io/opencollective/sponsors/ruby-oauth?style=for-the-badge
[🖇osc-backers-bottom-img]: https://img.shields.io/opencollective/backers/ruby-oauth?style=for-the-badge
[🖇osc]: https://opencollective.com/ruby-oauth
[🖇sponsor-img]: https://img.shields.io/badge/Sponsor_Me!-pboling.svg?style=social&logo=github
[🖇sponsor-bottom-img]: https://img.shields.io/badge/Sponsor_Me!-pboling-blue?style=for-the-badge&logo=github
[🖇sponsor]: https://github.com/sponsors/pboling
[🖇polar-img]: https://img.shields.io/badge/polar-donate-a51611.svg?style=flat
[🖇polar]: https://polar.sh/pboling
[🖇kofi-img]: https://img.shields.io/badge/ko--fi-%E2%9C%93-a51611.svg?style=flat
[🖇kofi]: https://ko-fi.com/pboling
[🖇patreon-img]: https://img.shields.io/badge/patreon-donate-a51611.svg?style=flat
[🖇patreon]: https://patreon.com/galtzo
[🖇buyme-small-img]: https://img.shields.io/badge/buy_me_a_coffee-%E2%9C%93-a51611.svg?style=flat
[🖇buyme-img]: https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20latte&emoji=&slug=pboling&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff
[🖇buyme]: https://www.buymeacoffee.com/pboling
[🖇paypal-img]: https://img.shields.io/badge/donate-paypal-a51611.svg?style=flat&logo=paypal
[🖇paypal-bottom-img]: https://img.shields.io/badge/donate-paypal-a51611.svg?style=for-the-badge&logo=paypal&color=0A0A0A
[🖇paypal]: https://www.paypal.com/paypalme/peterboling
[🖇floss-funding.dev]: https://floss-funding.dev
[🖇floss-funding-gem]: https://github.com/galtzo-floss/floss_funding
[✉️discord-invite]: https://discord.gg/3qme4XHNKN
[✉️discord-invite-img-ftb]: https://img.shields.io/discord/1373797679469170758?style=for-the-badge&logo=discord
[✉️ruby-friends-img]: https://img.shields.io/badge/daily.dev-%F0%9F%92%8E_Ruby_Friends-0A0A0A?style=for-the-badge&logo=dailydotdev&logoColor=white
[✉️ruby-friends]: https://app.daily.dev/squads/rubyfriends

[✇bundle-group-pattern]: https://gist.github.com/pboling/4564780
[⛳️gem-namespace]: https://github.com/ruby-oauth/auth-sanitizer
[⛳️namespace-img]: https://img.shields.io/badge/namespace-Auth::Sanitizer-3C2D2D.svg?style=square&logo=ruby&logoColor=white
[⛳️gem-name]: https://bestgems.org/gems/auth-sanitizer
[⛳️name-img]: https://img.shields.io/badge/name-auth--sanitizer-3C2D2D.svg?style=square&logo=rubygems&logoColor=red
[⛳️tag-img]: https://img.shields.io/github/tag/ruby-oauth/auth-sanitizer.svg
[⛳️tag]: https://github.com/ruby-oauth/auth-sanitizer/releases
[🚂maint-blog]: http://www.railsbling.com/tags/auth-sanitizer
[🚂maint-blog-img]: https://img.shields.io/badge/blog-railsbling-0093D0.svg?style=for-the-badge&logo=rubyonrails&logoColor=orange
[🚂maint-contact]: http://www.railsbling.com/contact
[🚂maint-contact-img]: https://img.shields.io/badge/Contact-Maintainer-0093D0.svg?style=flat&logo=rubyonrails&logoColor=red
[💖🖇linkedin]: http://www.linkedin.com/in/peterboling
[💖🖇linkedin-img]: https://img.shields.io/badge/LinkedIn-Profile-0B66C2?style=flat&logo=newjapanprowrestling
[💖✌️wellfound]: https://wellfound.com/u/peter-boling
[💖✌️wellfound-img]: https://img.shields.io/badge/peter--boling-orange?style=flat&logo=wellfound
[💖💲crunchbase]: https://www.crunchbase.com/person/peter-boling
[💖💲crunchbase-img]: https://img.shields.io/badge/peter--boling-purple?style=flat&logo=crunchbase
[💖🐘ruby-mast]: https://ruby.social/@galtzo
[💖🐘ruby-mast-img]: https://img.shields.io/mastodon/follow/109447111526622197?domain=https://ruby.social&style=flat&logo=mastodon&label=Ruby%20@galtzo
[💖🦋bluesky]: https://bsky.app/profile/galtzo.com
[💖🦋bluesky-img]: https://img.shields.io/badge/@galtzo.com-0285FF?style=flat&logo=bluesky&logoColor=white
[💖🌳linktree]: https://linktr.ee/galtzo
[💖🌳linktree-img]: https://img.shields.io/badge/galtzo-purple?style=flat&logo=linktree
[💖💁🏼‍♂️devto]: https://dev.to/galtzo
[💖💁🏼‍♂️devto-img]: https://img.shields.io/badge/dev.to-0A0A0A?style=flat&logo=devdotto&logoColor=white
[💖💁🏼‍♂️aboutme]: https://about.me/peter.boling
[💖💁🏼‍♂️aboutme-img]: https://img.shields.io/badge/about.me-0A0A0A?style=flat&logo=aboutme&logoColor=white
[💖🧊berg]: https://codeberg.org/pboling
[💖🐙hub]: https://github.org/pboling
[💖🛖hut]: https://sr.ht/~galtzo/
[💖🧪lab]: https://gitlab.com/pboling
[👨🏼‍🏫expsup-upwork]: https://www.upwork.com/freelancers/~014942e9b056abdf86?mp_source=share
[👨🏼‍🏫expsup-upwork-img]: https://img.shields.io/badge/UpWork-13544E?style=for-the-badge&logo=Upwork&logoColor=white
[👨🏼‍🏫expsup-codementor]: https://www.codementor.io/peterboling?utm_source=github&utm_medium=button&utm_term=peterboling&utm_campaign=github
[👨🏼‍🏫expsup-codementor-img]: https://img.shields.io/badge/CodeMentor-Get_Help-1abc9c?style=for-the-badge&logo=CodeMentor&logoColor=white
[🏙️entsup-tidelift]: https://tidelift.com/subscription/pkg/rubygems-auth-sanitizer?utm_source=rubygems-auth-sanitizer&utm_medium=referral&utm_campaign=readme
[🏙️entsup-tidelift-img]: https://img.shields.io/badge/Tidelift_and_Sonar-Enterprise_Support-FD3456?style=for-the-badge&logo=sonar&logoColor=white
[🏙️entsup-tidelift-sonar]: https://blog.tidelift.com/tidelift-joins-sonar
[💁🏼‍♂️peterboling]: http://www.peterboling.com
[🚂railsbling]: http://www.railsbling.com
[📜src-gl-img]: https://img.shields.io/badge/GitLab-FBA326?style=for-the-badge&logo=Gitlab&logoColor=orange
[📜src-gl]: https://gitlab.com/ruby-oauth/auth-sanitizer
[📜src-cb-img]: https://img.shields.io/badge/CodeBerg-4893CC?style=for-the-badge&logo=CodeBerg&logoColor=blue
[📜src-cb]: https://codeberg.org/ruby-oauth/auth-sanitizer
[📜src-gh-img]: https://img.shields.io/badge/GitHub-238636?style=for-the-badge&logo=Github&logoColor=green
[📜src-gh]: https://github.com/ruby-oauth/auth-sanitizer
[📜docs-cr-rd-img]: https://img.shields.io/badge/RubyDoc-Current_Release-943CD2?style=for-the-badge&logo=readthedocs&logoColor=white
[📜docs-head-rd-img]: https://img.shields.io/badge/YARD_on_Galtzo.com-HEAD-943CD2?style=for-the-badge&logo=readthedocs&logoColor=white
[📜gl-wiki]: https://gitlab.com/ruby-oauth/auth-sanitizer/-/wikis/home
[📜gh-wiki]: https://github.com/ruby-oauth/auth-sanitizer/wiki
[📜gl-wiki-img]: https://img.shields.io/badge/wiki-gitlab-943CD2.svg?style=for-the-badge&logo=gitlab&logoColor=white
[📜gh-wiki-img]: https://img.shields.io/badge/wiki-github-943CD2.svg?style=for-the-badge&logo=github&logoColor=white
[👽dl-rank]: https://bestgems.org/gems/auth-sanitizer
[👽dl-ranki]: https://img.shields.io/gem/rd/auth-sanitizer.svg
[👽version]: https://bestgems.org/gems/auth-sanitizer
[👽versioni]: https://img.shields.io/gem/v/auth-sanitizer.svg
[🏀qlty-mnt]: https://qlty.sh/gh/ruby-oauth/projects/auth-sanitizer
[🏀qlty-mnti]: https://qlty.sh/gh/ruby-oauth/projects/auth-sanitizer/maintainability.svg
[🏀qlty-cov]: https://qlty.sh/gh/ruby-oauth/projects/auth-sanitizer/metrics/code?sort=coverageRating
[🏀qlty-covi]: https://qlty.sh/gh/ruby-oauth/projects/auth-sanitizer/coverage.svg
[🏀codecov]: https://codecov.io/gh/ruby-oauth/auth-sanitizer
[🏀codecovi]: https://codecov.io/gh/ruby-oauth/auth-sanitizer/graph/badge.svg
[🏀coveralls]: https://coveralls.io/github/ruby-oauth/auth-sanitizer?branch=main
[🏀coveralls-img]: https://coveralls.io/repos/github/ruby-oauth/auth-sanitizer/badge.svg?branch=main
[🚎ruby-2.4-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/ruby-2.4.yml
[🚎ruby-2.5-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/ruby-2.5.yml
[🚎ruby-2.6-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/ruby-2.6.yml
[🚎ruby-2.7-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/ruby-2.7.yml
[🚎ruby-3.0-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/ruby-3.0.yml
[🚎ruby-3.1-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/ruby-3.1.yml
[🚎ruby-3.2-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/ruby-3.2.yml
[🚎ruby-3.3-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/ruby-3.3.yml
[🚎ruby-3.4-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/ruby-3.4.yml
[🚎jruby-9.2-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/jruby-9.2.yml
[🚎jruby-9.3-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/jruby-9.3.yml
[🚎jruby-9.4-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/jruby-9.4.yml
[🚎truby-22.3-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/truffleruby-22.3.yml
[🚎truby-23.0-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/truffleruby-23.0.yml
[🚎truby-23.1-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/truffleruby-23.1.yml
[🚎truby-24.2-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/truffleruby-24.2.yml
[🚎truby-25.0-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/truffleruby-25.0.yml
[🚎2-cov-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/coverage.yml
[🚎2-cov-wfi]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/coverage.yml/badge.svg
[🚎3-hd-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/heads.yml
[🚎3-hd-wfi]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/heads.yml/badge.svg
[🚎5-st-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/style.yml
[🚎5-st-wfi]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/style.yml/badge.svg
[🚎9-t-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/truffle.yml
[🚎9-t-wfi]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/truffle.yml/badge.svg
[🚎10-j-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/jruby.yml
[🚎10-j-wfi]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/jruby.yml/badge.svg
[🚎11-c-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/current.yml
[🚎11-c-wfi]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/current.yml/badge.svg
[🚎12-crh-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/dep-heads.yml
[🚎12-crh-wfi]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/dep-heads.yml/badge.svg
[🚎13-🔒️-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/locked_deps.yml
[🚎13-🔒️-wfi]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/locked_deps.yml/badge.svg
[🚎14-🔓️-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/unlocked_deps.yml
[🚎14-🔓️-wfi]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/unlocked_deps.yml/badge.svg
[🚎15-🪪-wf]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/license-eye.yml
[🚎15-🪪-wfi]: https://github.com/ruby-oauth/auth-sanitizer/actions/workflows/license-eye.yml/badge.svg
[💎ruby-2.2i]: https://img.shields.io/badge/Ruby-2.2_(%F0%9F%9A%ABCI)-AABBCC?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.4i]: https://img.shields.io/badge/Ruby-2.4-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.5i]: https://img.shields.io/badge/Ruby-2.5-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.6i]: https://img.shields.io/badge/Ruby-2.6-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-2.7i]: https://img.shields.io/badge/Ruby-2.7-DF00CA?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.0i]: https://img.shields.io/badge/Ruby-3.0-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.1i]: https://img.shields.io/badge/Ruby-3.1-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.2i]: https://img.shields.io/badge/Ruby-3.2-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.3i]: https://img.shields.io/badge/Ruby-3.3-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-3.4i]: https://img.shields.io/badge/Ruby-3.4-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-4.0i]: https://img.shields.io/badge/Ruby-4.0-CC342D?style=for-the-badge&logo=ruby&logoColor=white
[💎ruby-c-i]: https://img.shields.io/badge/Ruby-current-CC342D?style=for-the-badge&logo=ruby&logoColor=green
[💎ruby-headi]: https://img.shields.io/badge/Ruby-HEAD-CC342D?style=for-the-badge&logo=ruby&logoColor=blue
[💎truby-22.3i]: https://img.shields.io/badge/Truffle_Ruby-22.3-34BCB1?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-23.0i]: https://img.shields.io/badge/Truffle_Ruby-23.0-34BCB1?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-23.1i]: https://img.shields.io/badge/Truffle_Ruby-23.1-34BCB1?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-24.2i]: https://img.shields.io/badge/Truffle_Ruby-24.2-34BCB1?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-25.0i]: https://img.shields.io/badge/Truffle_Ruby-25.0-34BCB1?style=for-the-badge&logo=ruby&logoColor=pink
[💎truby-c-i]: https://img.shields.io/badge/Truffle_Ruby-current-34BCB1?style=for-the-badge&logo=ruby&logoColor=green
[💎jruby-9.2i]: https://img.shields.io/badge/JRuby-9.2-FBE742?style=for-the-badge&logo=ruby&logoColor=red
[💎jruby-9.3i]: https://img.shields.io/badge/JRuby-9.3-FBE742?style=for-the-badge&logo=ruby&logoColor=red
[💎jruby-9.4i]: https://img.shields.io/badge/JRuby-9.4-FBE742?style=for-the-badge&logo=ruby&logoColor=red
[💎jruby-c-i]: https://img.shields.io/badge/JRuby-current-FBE742?style=for-the-badge&logo=ruby&logoColor=green
[💎jruby-headi]: https://img.shields.io/badge/JRuby-HEAD-FBE742?style=for-the-badge&logo=ruby&logoColor=blue
[🤝gh-issues]: https://github.com/ruby-oauth/auth-sanitizer/issues
[🤝gh-pulls]: https://github.com/ruby-oauth/auth-sanitizer/pulls
[🤝gl-issues]: https://gitlab.com/ruby-oauth/auth-sanitizer/-/issues
[🤝gl-pulls]: https://gitlab.com/ruby-oauth/auth-sanitizer/-/merge_requests
[🤝cb-issues]: https://codeberg.org/ruby-oauth/auth-sanitizer/issues
[🤝cb-pulls]: https://codeberg.org/ruby-oauth/auth-sanitizer/pulls
[🤝cb-donate]: https://donate.codeberg.org/
[🤝contributing]: https://github.com/ruby-oauth/auth-sanitizer/blob/main/CONTRIBUTING.md
[🏀codecov-g]: https://codecov.io/gh/ruby-oauth/auth-sanitizer/graph/badge.svg
[🖐contrib-rocks]: https://contrib.rocks
[🖐contributors]: https://github.com/ruby-oauth/auth-sanitizer/graphs/contributors
[🖐contributors-img]: https://contrib.rocks/image?repo=ruby-oauth/auth-sanitizer
[🚎contributors-gl]: https://gitlab.com/ruby-oauth/auth-sanitizer/-/graphs/main
[🪇conduct]: https://github.com/ruby-oauth/auth-sanitizer/blob/main/CODE_OF_CONDUCT.md
[🪇conduct-img]: https://img.shields.io/badge/Contributor_Covenant-2.1-259D6C.svg
[📌pvc]: http://guides.rubygems.org/patterns/#pessimistic-version-constraint
[📌semver]: https://semver.org/spec/v2.0.0.html
[📌semver-img]: https://img.shields.io/badge/semver-2.0.0-259D6C.svg?style=flat
[📌semver-breaking]: https://github.com/semver/semver/issues/716#issuecomment-869336139
[📌major-versions-not-sacred]: https://tom.preston-werner.com/2022/05/23/major-version-numbers-are-not-sacred.html
[📌changelog]: https://github.com/ruby-oauth/auth-sanitizer/blob/main/CHANGELOG.md
[📗keep-changelog]: https://keepachangelog.com/en/1.0.0/
[📗keep-changelog-img]: https://img.shields.io/badge/keep--a--changelog-1.0.0-34495e.svg?style=flat
[📌gitmoji]: https://gitmoji.dev
[📌gitmoji-img]: https://img.shields.io/badge/gitmoji_commits-%20%F0%9F%98%9C%20%F0%9F%98%8D-34495e.svg?style=flat-square
[🧮kloc]: https://www.youtube.com/watch?v=dQw4w9WgXcQ
[🧮kloc-img]: https://img.shields.io/badge/KLOC-0.145-FFDD67.svg?style=for-the-badge&logo=YouTube&logoColor=blue
[🔐security]: https://github.com/ruby-oauth/auth-sanitizer/blob/main/SECURITY.md
[🔐security-img]: https://img.shields.io/badge/security-policy-259D6C.svg?style=flat
[📄copyright-notice-explainer]: https://opensource.stackexchange.com/questions/5778/why-do-licenses-such-as-the-mit-license-specify-a-single-year
[📄license]: LICENSE.md
[📄license-ref]: MIT.md
[📄license-img]: https://img.shields.io/badge/License-MIT-259D6C.svg
[📄license-compat]: https://www.apache.org/legal/resolved.html#category-a
[📄license-compat-img]: https://img.shields.io/badge/Apache_Compatible:_Category_A-✓-259D6C.svg?style=flat&logo=Apache

[📄ilo-declaration]: https://www.ilo.org/declaration/lang--en/index.htm
[📄ilo-declaration-img]: https://img.shields.io/badge/ILO_Fundamental_Principles-✓-259D6C.svg?style=flat
[🚎yard-current]: http://rubydoc.info/gems/auth-sanitizer
[🚎yard-head]: https://auth-sanitizer.galtzo.com
[💎stone_checksums]: https://github.com/galtzo-floss/stone_checksums
[💎SHA_checksums]: https://gitlab.com/ruby-oauth/auth-sanitizer/-/tree/main/checksums
[💎rlts]: https://github.com/rubocop-lts/rubocop-lts
[💎rlts-img]: https://img.shields.io/badge/code_style_&_linting-rubocop--lts-34495e.svg?plastic&logo=ruby&logoColor=white
[💎appraisal2]: https://github.com/appraisal-rb/appraisal2
[💎appraisal2-img]: https://img.shields.io/badge/appraised_by-appraisal2-34495e.svg?plastic&logo=ruby&logoColor=white
[💎d-in-dvcs]: https://railsbling.com/posts/dvcs/put_the_d_in_dvcs/
