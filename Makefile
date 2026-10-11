.DEFAULT_GOAL := help

FORMULAE := $(patsubst Formula/%.rb,%,$(wildcard Formula/*.rb))
SMOKE_TAP := soundblaster/smoke
SMOKE_DIR := DerivedData/HomebrewSmoke

.PHONY: help style smoke cask-style cask-audit clean

help:
	@printf '%s\n' \
		'Targets:' \
		'  make style  Validate every formula Ruby syntax and Homebrew style' \
		'  make smoke  Install and test every formula through a temporary local tap' \
		'  make cask-style  Validate Casks/*.rb syntax and Homebrew style' \
		'  make cask-audit  Audit the Dreams cask through a temporary local tap (downloads the DMG)' \
		'  make clean  Remove local smoke artifacts'

style:
	@command -v brew > /dev/null || { printf '%s\n' 'Homebrew is not installed.'; exit 1; }
	@set -e; \
	for formula in $(FORMULAE); do \
		ruby -c "Formula/$$formula.rb"; \
		brew style "Formula/$$formula.rb"; \
	done

smoke: style
	@set -e; \
		export HOMEBREW_NO_AUTO_UPDATE=1; \
		export HOMEBREW_NO_ENV_HINTS=1; \
		export HOMEBREW_NO_INSTALL_CLEANUP=1; \
		for formula in $(FORMULAE); do brew uninstall --force "$(SMOKE_TAP)/$$formula-smoke" > /dev/null 2>&1 || true; done; \
		brew untap "$(SMOKE_TAP)" > /dev/null 2>&1 || true; \
		rm -rf "$(SMOKE_DIR)"; \
		mkdir -p "$(SMOKE_DIR)"; \
		brew tap-new --no-git "$(SMOKE_TAP)" > /dev/null; \
		trap 'for formula in $(FORMULAE); do brew uninstall --force "$(SMOKE_TAP)/$$formula-smoke" > /dev/null 2>&1 || true; done; brew untap "$(SMOKE_TAP)" > /dev/null 2>&1 || true' EXIT; \
		tap_dir="$$(brew --repository "$(SMOKE_TAP)")"; \
		for formula in $(FORMULAE); do \
			smoke_name="$$formula-smoke"; \
			class_name="$$(ruby -e 'puts ARGV[0].split("-").map(&:capitalize).join' "$$formula")"; \
			sed "s/class $$class_name < Formula/class $${class_name}Smoke < Formula/" "Formula/$$formula.rb" > "$$tap_dir/Formula/$$smoke_name.rb"; \
			brew install --skip-link --formula "$(SMOKE_TAP)/$$smoke_name"; \
			installed_bin="$$(brew --prefix "$(SMOKE_TAP)/$$smoke_name")/bin/$$formula"; \
			test -x "$$installed_bin"; \
			brew test --force "$(SMOKE_TAP)/$$smoke_name"; \
			if [ "$$formula" = fsd-ios ]; then "$$installed_bin" doctor --json > "$(SMOKE_DIR)/doctor.json"; fi; \
		done
	@swift -e 'import Foundation; let data = try Data(contentsOf: URL(fileURLWithPath: CommandLine.arguments[1])); let payload = try JSONSerialization.jsonObject(with: data) as! [String: Any]; precondition(payload["tool"] as? String == "fsd-ios"); precondition(payload["version"] as? String == "0.4.0"); precondition(payload["passed"] as? Bool == true)' "$(SMOKE_DIR)/doctor.json"

CASK_FILE := Casks/dreams.rb
CASK_NAME := dreams

cask-style:
	@command -v brew > /dev/null || { printf '%s\n' 'Homebrew is not installed.'; exit 1; }
	ruby -c "$(CASK_FILE)"
	brew style "$(CASK_FILE)"

cask-audit: cask-style
	@set -e; \
		export HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_ENV_HINTS=1; \
		brew untap "$(SMOKE_TAP)" > /dev/null 2>&1 || true; \
		brew tap-new --no-git "$(SMOKE_TAP)" > /dev/null; \
		trap 'brew untap "$(SMOKE_TAP)" > /dev/null 2>&1 || true' EXIT; \
		tap_dir="$$(brew --repository "$(SMOKE_TAP)")"; \
		mkdir -p "$$tap_dir/Casks"; \
		cp "$(CASK_FILE)" "$$tap_dir/Casks/$(CASK_NAME).rb"; \
		brew audit --cask --online "$(SMOKE_TAP)/$(CASK_NAME)"; \
		brew fetch --cask "$(SMOKE_TAP)/$(CASK_NAME)"

clean:
	rm -rf DerivedData
