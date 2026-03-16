REPO := git@github.com:dshcherbatiuk/dotnvim.git
NVIM_DIR := $(HOME)/.config/nvim

.PHONY: help setup install pull push sync upgrade doctor fonts deps clean backup edit

help: ## Show available commands
	@echo "\033[1mdotnvim\033[0m — Neovim config manager"
	@echo ""
	@echo "  \033[1mNew machine:\033[0m"
	@echo "    git clone $(REPO) ~/.config/nvim && cd ~/.config/nvim && make setup"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36mmake %-12s\033[0m %s\n", $$1, $$2}'

setup: fonts deps sync ## First-time setup on a new machine
	@echo "✅ Setup complete! Restart your terminal, then open nvim."

pull: ## Pull latest config + sync plugins
	@echo "⬇️  Pulling latest config..."
	@git -C $(NVIM_DIR) pull --rebase
	@echo ""
	@$(MAKE) -s sync
	@echo "✅ Config updated and plugins synced"

push: ## Commit and push config changes
	@echo "⬆️  Pushing config..."
	@git -C $(NVIM_DIR) add -A
	@git -C $(NVIM_DIR) diff --cached --quiet && echo "Nothing to commit" || \
		git -C $(NVIM_DIR) commit -m "update nvim config"
	@git -C $(NVIM_DIR) push
	@echo "✅ Config pushed"

sync: ## Sync plugins from rocks.toml
	@echo "🔄 Syncing plugins..."
	@nvim --headless -c "Rocks sync" -c "sleep 15" -c "qa!" 2>&1 || true
	@echo "✅ Plugins synced"

upgrade: ## Update all plugins to latest
	@echo "⬆️  Upgrading plugins..."
	@nvim --headless -c "Rocks update" -c "sleep 10" -c "qa!" 2>&1 || true
	@echo "✅ Plugins upgraded"

doctor: ## Check health: fonts, LSP servers, plugins
	@echo "🩺 Running diagnostics..."
	@echo ""
	@nvim --version | head -1
	@echo ""
	@echo "→ Nerd Font:"
	@fc-list 2>/dev/null | grep -qi "nerd" && echo "  ✅ Nerd Font detected" || echo "  ⚠️  No Nerd Font — run: make fonts"
	@echo ""
	@echo "→ Plugin store:"
	@test -d ~/.local/share/nvim/rocks && echo "  ✅ rocks.nvim data exists" || echo "  ❌ Missing — run: make setup"
	@echo ""
	@echo "→ Language servers:"
	@for cmd in rust-analyzer jdtls kotlin-language-server elixir-ls pyright clangd bash-language-server; do \
		command -v $$cmd >/dev/null 2>&1 && echo "  ✅ $$cmd" || echo "  ⚠️  $$cmd not found"; \
	done
	@echo ""
	@echo "→ Plugin configs:"
	@nvim --headless -c "checkhealth rocks-config" -c "qa!" 2>&1 | grep -E "OK|WARN|ERROR" || true

fonts: ## Install Nerd Font + configure Kitty
	@./scripts/setup-fonts.sh

deps: ## Install external deps (ImageMagick, mermaid-cli)
	@./scripts/setup-deps.sh

clean: ## Remove plugin cache for fresh install
	@echo "🧹 Clearing plugin cache..."
	@rm -rf ~/.local/share/nvim/rocks
	@echo "✅ Cache cleared. Run: make sync"

backup: ## Backup config to ~/.config/nvim.bak
	@echo "📦 Backing up config..."
	@rsync -a --exclude='.git' ~/.config/nvim/ ~/.config/nvim.bak/
	@echo "✅ Backup → ~/.config/nvim.bak/"

edit: ## Open config in Neovim
	@nvim $(NVIM_DIR)/init.lua
