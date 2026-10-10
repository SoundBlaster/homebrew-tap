.DEFAULT_GOAL := help

FORMULA := Formula/fsd-ios.rb
FORMULA_NAME := fsd-ios
SMOKE_TAP := soundblaster/smoke
SMOKE_DIR := DerivedData/HomebrewSmoke

.PHONY: help style smoke cask-style cask-audit clean

help:
	@printf '%s\n' \
		'Targets:' \
		'  make style  Validate formula Ruby syntax and Homebrew style' \
		'  make smoke  Install and test the formula through a temporary local tap' \
		'  make cask-style  Validate Casks/*.rb syntax and Homebrew style' \
		'  make cask-audit  Audit the Dreams cask through a temporary local tap (downloads the DMG)' \
		'  make clean  Remove local smoke artifacts'

style:
	@command -v brew > /dev/null || { printf '%s\n' 'Homebrew is not installed.'; exit 1; }
	ruby -c "$(FORMULA)"
	brew style "$(FORMULA)"

smoke: style
	@set -e; \
		export HOMEBREW_NO_AUTO_UPDATE=1; \
		export HOMEBREW_NO_ENV_HINTS=1; \
		export HOMEBREW_NO_INSTALL_CLEANUP=1; \
		brew uninstall --force "$(SMOKE_TAP)/$(FORMULA_NAME)" > /dev/null 2>&1 || true; \
		brew untap "$(SMOKE_TAP)" > /dev/null 2>&1 || true; \
		rm -rf "$(SMOKE_DIR)"; \
		mkdir -p "$(SMOKE_DIR)"; \
		brew tap-new --no-git "$(SMOKE_TAP)" > /dev/null; \
		trap 'brew uninstall --force "$(SMOKE_TAP)/$(FORMULA_NAME)" > /dev/null 2>&1 || true; brew untap "$(SMOKE_TAP)" > /dev/null 2>&1 || true' EXIT; \
		tap_dir="$$(brew --repository "$(SMOKE_TAP)")"; \
		cp "$(FORMULA)" "$$tap_dir/Formula/$(FORMULA_NAME).rb"; \
		brew install --formula "$(SMOKE_TAP)/$(FORMULA_NAME)"; \
		installed_bin="$$(brew --prefix "$(SMOKE_TAP)/$(FORMULA_NAME)")/bin/$(FORMULA_NAME)"; \
		test -x "$$installed_bin"; \
		"$$installed_bin" --version; \
		brew test "$(SMOKE_TAP)/$(FORMULA_NAME)"; \
		"$$installed_bin" doctor --json > "$(SMOKE_DIR)/doctor.json"
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
