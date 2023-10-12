# Development environment guide

## Preparing

Clone `ruby_gem_name` repository:

```bash
git clone https://github.com/on-strum/ruby-gem-name.git
cd  ruby-gem
```

Configure latest Ruby environment:

```bash
echo 'ruby-3.1.2' > .ruby-version
cp .circleci/gemspec_latest ruby_gem_name.gemspec
```

## Commiting

Commit your changes excluding `.ruby-version`, `ruby_gem_name.gemspec`

```bash
git add . ':!.ruby-version' ':!ruby_gem_name.gemspec'
git commit -m 'Your new awesome ruby_gem_name feature'
```
