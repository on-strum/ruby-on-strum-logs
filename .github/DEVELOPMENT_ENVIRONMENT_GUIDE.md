# Development environment guide

## Preparing

Clone `ruby-on-strum-logs` repository:

```bash
git clone https://github.com/on-strum/ruby-on-strum-logs.git
cd  ruby-gem
```

Configure latest Ruby environment:

```bash
echo 'ruby-3.2.0' > .ruby-version
cp .circleci/gemspec_latest on_strum-logs.gemspec
```

## Commiting

Commit your changes excluding `.ruby-version`, `on_strum-logs.gemspec`

```bash
git add . ':!.ruby-version' ':!on_strum-logs.gemspec'
git commit -m 'Your new awesome on_strum-logs feature'
```
