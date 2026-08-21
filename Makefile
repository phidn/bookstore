.DEFAULT_GOAL := help
PORT := 4321
PID_FILE := .bookstore.pid
LOG_FILE := bookstore.log
export PATH := /Users/phi/.nvm/versions/node/v22.22.2/bin:$(PATH)

.PHONY: help menu run run-local run-staging run-prod stop status logs dev dev-local dev-staging dev-prod build deploy deploy-staging db-migrate db-migrate-prod db-seed seed-local seed-staging sync-staging reset-local

help: ## Hiển thị menu hướng dẫn các lệnh có sẵn
	@echo "\033[1;34m========================================================================\033[0m"
	@echo "\033[1;32m  📚 Tiểu Viện Hữu Thư — Bookstore Storefront & Dev Server\033[0m"
	@echo "\033[1;34m========================================================================\033[0m"
	@echo "\033[1;33mSử dụng:\033[0m make [target]"
	@echo ""
	@echo "\033[1;35m🚀 Chạy Dev Server theo 3 Môi Trường (Background trên port $(PORT)):\033[0m"
	@echo "  \033[36mrun / run-local\033[0m      Chạy Local Dev (Dữ liệu Local D1 sạch / cơ bản)"
	@echo "  \033[36mrun-staging\033[0m          Chạy Staging / Demo (200+ sách thực tế Tiểu Viện Hữu Thư)"
	@echo "  \033[36mrun-prod\033[0m             Chạy kết nối trực tiếp Cloudflare Production (D1/R2/KV)"
	@echo ""
	@echo "\033[1;35m💻 Chạy Foreground (Terminal trực tiếp):\033[0m"
	@echo "  \033[36mdev / dev-local\033[0m      Astro dev với Local Data"
	@echo "  \033[36mdev-staging\033[0m          Astro dev với Staging Demo Data (tự kiểm tra seed)"
	@echo "  \033[36mdev-prod\033[0m             Astro dev với Production Remote Data"
	@echo ""
	@echo "\033[1;35m📦 Quản Lý Dữ Liệu & Seed Database:\033[0m"
	@echo "  \033[36mseed-staging\033[0m         Nạp dữ liệu mẫu Staging (200+ sách, 16 danh mục) vào local D1"
	@echo "  \033[36mseed-local\033[0m           Nạp dữ liệu dev tối thiểu (seed.sql) vào local D1"
	@echo "  \033[36msync-staging\033[0m         Xuất/đồng bộ dữ liệu mới nhất từ Cloudflare Prod về seed-staging.sql"
	@echo "  \033[36mdb-migrate\033[0m           Áp dụng migrations vào local D1"
	@echo "  \033[36mreset-local\033[0m          Xoá sạch toàn bộ dữ liệu local D1 (về trạng thái ban đầu)"
	@echo ""
	@echo "\033[1;35m⚙️  Quản Lý Tiến Trình & Vận Hành:\033[0m"
	@echo "  \033[36mstop\033[0m                 Dừng bookstore dev server đang chạy background"
	@echo "  \033[36mstatus\033[0m               Kiểm tra trạng thái tiến trình đang chạy"
	@echo "  \033[36mlogs\033[0m                 Xem logs thời gian thực (tail -f $(LOG_FILE))"
	@echo "  \033[36mbuild\033[0m                Build dự án cho Cloudflare Worker"
	@echo "  \033[36mdeploy\033[0m               Deploy storefront lên Cloudflare Production (tieuvienhuuthu.store)"
	@echo "  \033[36mdeploy-staging\033[0m       Deploy lên Cloudflare Staging Demo (bookstore-demo.phidang.work)"
	@echo "\033[1;34m========================================================================\033[0m"

menu: help

run: run-local

run-local: ## Chạy dev server ở background với dữ liệu Local
	@if lsof -i :$(PORT) > /dev/null 2>&1; then \
		PID=$$(lsof -ti :$(PORT) | head -n 1); \
		echo $$PID > $(PID_FILE); \
		echo "\033[1;33m⚠️  Bookstore đang chạy ở background (PID: $$PID).\033[0m"; \
		echo "👉 URL: http://localhost:$(PORT)/"; \
		echo "👉 Xem logs: make logs"; \
	else \
		echo "\033[1;32m🚀 Đang khởi động Bookstore dev server (Môi trường: LOCAL)...\033[0m"; \
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
			echo "\033[1;32m✅ Bookstore (Local) đã chạy thành công ở background (PID: $$PID).\033[0m"; \
			echo "👉 Địa chỉ: \033[1;36mhttp://localhost:$(PORT)/\033[0m"; \
			echo "👉 Môi trường: \033[1;33mLocal (.wrangler/state)\033[0m"; \
			echo "👉 File log: \033[33m$(LOG_FILE)\033[0m"; \
			echo "👉 Xem logs: \033[36mmake logs\033[0m"; \
			echo "👉 Dừng server: \033[36mmake stop\033[0m"; \
		else \
			echo "\033[1;31m❌ Không thể khởi động Bookstore. Chi tiết logs:\033[0m"; \
			tail -n 20 $(LOG_FILE) 2>/dev/null || true; \
			exit 1; \
		fi; \
	fi

run-staging: ## Chạy dev server ở background với dữ liệu STAGING / DEMO (Tiểu Viện Hữu Thư)
	@if lsof -i :$(PORT) > /dev/null 2>&1; then \
		PID=$$(lsof -ti :$(PORT) | head -n 1); \
		echo $$PID > $(PID_FILE); \
		echo "\033[1;33m⚠️  Bookstore đang chạy ở background (PID: $$PID).\033[0m"; \
		echo "👉 URL: http://localhost:$(PORT)/"; \
		echo "👉 Xem logs: make logs"; \
	else \
		COUNT=$$(npx --yes wrangler d1 execute DB --local --command="SELECT COUNT(*) as c FROM products;" 2>/dev/null | grep -o '"c": [0-9]*' | grep -o '[0-9]*' || echo "0"); \
		if [ "$$COUNT" -lt "10" ]; then \
			echo "▸ Đang nạp dữ liệu Staging demo vào local D1..."; \
			bash scripts/seed-staging.sh; \
		fi; \
		echo "\033[1;32m🚀 Đang khởi động Bookstore dev server (Môi trường: STAGING / DEMO DATA)...\033[0m"; \
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
			echo "\033[1;32m✅ Bookstore (Staging / Demo Data) đã chạy thành công ở background (PID: $$PID).\033[0m"; \
			echo "👉 Địa chỉ: \033[1;36mhttp://localhost:$(PORT)/\033[0m"; \
			echo "👉 Dữ liệu: \033[1;32mStaging (200+ sách Tiểu Viện Hữu Thư)\033[0m"; \
			echo "👉 File log: \033[33m$(LOG_FILE)\033[0m"; \
			echo "👉 Xem logs: \033[36mmake logs\033[0m"; \
			echo "👉 Dừng server: \033[36mmake stop\033[0m"; \
		else \
			echo "\033[1;31m❌ Không thể khởi động Bookstore. Chi tiết logs:\033[0m"; \
			tail -n 20 $(LOG_FILE) 2>/dev/null || true; \
			exit 1; \
		fi; \
	fi

run-prod: ## Chạy dev server ở background kết nối PRODUCTION DATA API
	@if lsof -i :$(PORT) > /dev/null 2>&1; then \
		PID=$$(lsof -ti :$(PORT) | head -n 1); \
		echo $$PID > $(PID_FILE); \
		echo "\033[1;33m⚠️  Bookstore đang chạy (PID: $$PID).\033[0m"; \
		echo "👉 URL: http://localhost:$(PORT)/"; \
		echo "👉 Nếu muốn đổi môi trường, vui lòng chạy: make stop && make run-prod"; \
	else \
		echo "\033[1;32m🚀 Đang khởi động Bookstore dev server (Môi trường: PRODUCTION DATA REMOTE)...\033[0m"; \
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

dev: dev-local

dev-local: ## Chạy bookstore dev server ở foreground (local data)
	@npm run dev:local

dev-staging: ## Chạy bookstore dev server ở foreground với Staging Demo Data
	@COUNT=$$(npx --yes wrangler d1 execute DB --local --command="SELECT COUNT(*) as c FROM products;" 2>/dev/null | grep -o '"c": [0-9]*' | grep -o '[0-9]*' || echo "0"); \
	if [ "$$COUNT" -lt "10" ]; then \
		echo "▸ Đang nạp dữ liệu Staging demo vào local D1..."; \
		bash scripts/seed-staging.sh; \
	fi
	@npm run dev:staging

dev-prod: ## Chạy bookstore dev server ở foreground với PRODUCTION DATA API
	@npm run dev:prod

build: ## Build bookstore cho production
	@npm run build

deploy: ## Deploy bookstore lên Cloudflare Production
	@npm run deploy

deploy-staging: ## Deploy bookstore lên Cloudflare Staging Demo (bookstore-demo.phidang.work)
	@npm run deploy:staging

db-migrate: ## Áp dụng Cloudflare D1 migrations (local)
	@npm run db:migrate

db-migrate-prod: ## Áp dụng Cloudflare D1 migrations (production remote)
	@npm run db:migrate:remote

db-seed: seed-staging ## Alias cho seed-staging

seed-staging: ## Nạp dữ liệu mẫu Staging (200+ sách thực tế Tiểu Viện Hữu Thư) vào local D1
	@bash scripts/seed-staging.sh

seed-local: ## Nạp dữ liệu dev mẫu sạch (seed.sql) vào local D1
	@bash scripts/seed-local.sh

sync-staging: ## Đồng bộ / xuất dữ liệu từ Cloudflare Production về seed-staging.sql
	@bash scripts/sync-staging.sh

reset-local: ## Reset toàn bộ dữ liệu D1 local về ban đầu
	@bash scripts/reset.sh --yes

