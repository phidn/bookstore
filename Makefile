.DEFAULT_GOAL := help
PORT := 4321
PID_FILE := .bookstore.pid
LOG_FILE := bookstore.log

.PHONY: help menu run run-prod stop status logs dev dev-prod build deploy db-migrate db-seed

help: ## Hiển thị menu hướng dẫn các lệnh có sẵn
	@echo "\033[1;34m============================================================\033[0m"
	@echo "\033[1;32m  📚 Bookstore — Storefront Quản Lý & Vận Hành\033[0m"
	@echo "\033[1;34m============================================================\033[0m"
	@echo "\033[1;33mSử dụng:\033[0m make [target]"
	@echo ""
	@echo "\033[1;33mLệnh chính:\033[0m"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'
	@echo "\033[1;34m============================================================\033[0m"

menu: help ## Alias cho help (hiển thị menu lệnh)

run: ## Chạy dev server ở background (local data, port 4321)
	@if lsof -i :$(PORT) > /dev/null 2>&1; then \
		PID=$$(lsof -ti :$(PORT) | head -n 1); \
		echo $$PID > $(PID_FILE); \
		echo "\033[1;33m⚠️  Bookstore đang chạy ở background (PID: $$PID).\033[0m"; \
		echo "👉 URL: http://localhost:$(PORT)/"; \
		echo "👉 Xem logs: make logs"; \
	else \
		echo "\033[1;32m🚀 Đang khởi động Bookstore dev server ở background (Local Data)...\033[0m"; \
		nohup npm run dev > $(LOG_FILE) 2>&1 & echo $$! > $(PID_FILE); \
		for i in 1 2 3 4 5 6 7 8 9 10; do \
			if lsof -i :$(PORT) > /dev/null 2>&1; then \
				break; \
			fi; \
			sleep 0.5; \
		done; \
		if lsof -i :$(PORT) > /dev/null 2>&1; then \
			PID=$$(lsof -ti :$(PORT) | head -n 1); \
			echo $$PID > $(PID_FILE); \
			echo "\033[1;32m✅ Bookstore đã chạy thành công ở background (PID: $$PID).\033[0m"; \
			echo "👉 Địa chỉ: \033[1;36mhttp://localhost:$(PORT)/\033[0m"; \
			echo "👉 Dữ liệu: \033[1;33mLocal (.wrangler/state)\033[0m"; \
			echo "👉 File log: \033[33m$(LOG_FILE)\033[0m"; \
			echo "👉 Xem log thời gian thực: \033[36mmake logs\033[0m"; \
			echo "👉 Dừng server: \033[36mmake stop\033[0m"; \
		else \
			echo "\033[1;31m❌ Không thể khởi động Bookstore. Chi tiết logs:\033[0m"; \
			tail -n 20 $(LOG_FILE) 2>/dev/null || true; \
			exit 1; \
		fi; \
	fi

run-prod: ## Chạy dev server ở background kết nối PRODUCTION DATA API (port 4321)
	@if lsof -i :$(PORT) > /dev/null 2>&1; then \
		PID=$$(lsof -ti :$(PORT) | head -n 1); \
		echo $$PID > $(PID_FILE); \
		echo "\033[1;33m⚠️  Bookstore đang chạy (PID: $$PID).\033[0m"; \
		echo "👉 URL: http://localhost:$(PORT)/"; \
		echo "👉 Nếu muốn chuyển sang Production Data, vui lòng chạy: make stop && make run-prod"; \
	else \
		echo "\033[1;32m🚀 Đang khởi động Bookstore dev server với PRODUCTION DATA API ở background...\033[0m"; \
		nohup npm run dev:prod > $(LOG_FILE) 2>&1 & echo $$! > $(PID_FILE); \
		for i in $$(seq 1 30); do \
			if lsof -i :$(PORT) > /dev/null 2>&1; then \
				break; \
			fi; \
			sleep 0.5; \
		done; \
		if lsof -i :$(PORT) > /dev/null 2>&1; then \
			PID=$$(lsof -ti :$(PORT) | head -n 1); \
			echo $$PID > $(PID_FILE); \
			echo "\033[1;32m✅ Bookstore (Production Data) đã chạy thành công ở background (PID: $$PID).\033[0m"; \
			echo "👉 Địa chỉ: \033[1;36mhttp://localhost:$(PORT)/\033[0m"; \
			echo "👉 Dữ liệu: \033[1;35mCloudflare Production (D1 / R2 / KV)\033[0m"; \
			echo "👉 File log: \033[33m$(LOG_FILE)\033[0m"; \
			echo "👉 Xem log thời gian thực: \033[36mmake logs\033[0m"; \
			echo "👉 Dừng server: \033[36mmake stop\033[0m"; \
		else \
			echo "\033[1;31m❌ Không thể khởi động Bookstore với Production Data. Chi tiết logs:\033[0m"; \
			tail -n 20 $(LOG_FILE) 2>/dev/null || true; \
			exit 1; \
		fi; \
	fi

stop: ## Dừng tiến trình dev bookstore đang chạy background
	@echo "\033[1;33m🛑 Đang dừng Bookstore dev server...\033[0m"
	@if [ -f $(PID_FILE) ]; then \
		PID=`cat $(PID_FILE)`; \
		kill -9 $$PID 2>/dev/null || true; \
		pkill -9 -P $$PID 2>/dev/null || true; \
		rm -f $(PID_FILE); \
	fi
	@pkill -9 -f "wrangler-dist/cli.js dev" 2>/dev/null || true
	@pkill -9 -f "wrangler dev" 2>/dev/null || true
	@pkill -9 -f "astro dev" 2>/dev/null || true
	@lsof -ti :$(PORT) | xargs kill -9 2>/dev/null || true
	@for i in $$(seq 1 10); do \
		if ! lsof -i :$(PORT) > /dev/null 2>&1; then \
			break; \
		fi; \
		sleep 0.2; \
	done
	@echo "\033[1;32m✅ Đã dừng Bookstore dev server.\033[0m"

status: ## Kiểm tra trạng thái tiến trình bookstore
	@if lsof -i :$(PORT) > /dev/null 2>&1; then \
		PIDS=$$(lsof -ti :$(PORT) | tr '\n' ' '); \
		echo "\033[1;32m● Bookstore đang RUNNING trên http://localhost:$(PORT)/ (PID: $$PIDS)\033[0m"; \
	elif [ -f $(PID_FILE) ] && kill -0 `cat $(PID_FILE)` 2>/dev/null; then \
		PID=`cat $(PID_FILE)`; \
		echo "\033[1;33m● Bookstore đang chạy (PID: $$PID) nhưng chưa lắng nghe cổng $(PORT).\033[0m"; \
	else \
		echo "\033[1;31m○ Bookstore hiện KHÔNG chạy.\033[0m"; \
	fi

logs: ## Xem logs thời gian thực của bookstore
	@touch $(LOG_FILE)
	@echo "\033[1;34m--- Đang xem logs của $(LOG_FILE) (Ctrl+C để thoát) ---\033[0m"
	@tail -f $(LOG_FILE)

dev: ## Chạy bookstore dev server ở foreground (local data)
	@npm run dev

dev-prod: ## Chạy bookstore dev server ở foreground với PRODUCTION DATA API
	@npm run dev:prod

build: ## Build bookstore cho production
	@npm run build

deploy: ## Deploy bookstore lên Cloudflare Production
	@CLOUDFLARE_ACCOUNT_ID=b22e7099a9368ee7983a9ea38bca434d npm run deploy

db-migrate: ## Áp dụng Cloudflare D1 migrations (local)
	@npm run db:migrate

db-seed: ## Nạp dữ liệu mẫu seed vào local D1
	@npm run db:seed
