# Docker Quick Start Scripts

## Windows PowerShell Scripts

### Start Application
# File: docker-start.ps1
Write-Host "Starting Quiz Application with Docker..." -ForegroundColor Green
docker-compose up --build -d
Write-Host "`nContainers started successfully!" -ForegroundColor Green
Write-Host "View logs with: docker-compose logs -f" -ForegroundColor Yellow

### Stop Application
# File: docker-stop.ps1
Write-Host "Stopping Quiz Application..." -ForegroundColor Yellow
docker-compose down
Write-Host "Containers stopped successfully!" -ForegroundColor Green

### View Logs
# File: docker-logs.ps1
Write-Host "Viewing application logs (Ctrl+C to exit)..." -ForegroundColor Cyan
docker-compose logs -f

### Restart Application
# File: docker-restart.ps1
Write-Host "Restarting Quiz Application..." -ForegroundColor Yellow
docker-compose restart
Write-Host "Containers restarted successfully!" -ForegroundColor Green

---

## Usage Instructions

### Option 1: Copy commands directly
Copy the commands from above and run them in PowerShell.

### Option 2: Create script files
1. Create files with the names shown (e.g., `docker-start.ps1`)
2. Copy the content under each section
3. Run with: `.\docker-start.ps1`

### Common Commands

```powershell
# Build and start (first time or after code changes)
docker-compose up --build

# Start in background (detached mode)
docker-compose up -d

# Stop containers
docker-compose down

# View logs
docker-compose logs -f

# Check container status
docker-compose ps

# Restart specific service
docker-compose restart quiz-app

# Access MySQL database
docker exec -it quizapp-mysql mysql -uroot -prootpassword quizapp

# Clean up everything (CAUTION: deletes data)
docker-compose down -v
```

---

## Troubleshooting

### Port Conflicts
If port 3306 is already in use, edit `docker-compose.yml`:
```yaml
ports:
  - "3308:3306"  # Change 3308 to any available port
```

### Permission Issues
Run PowerShell as Administrator if you encounter permission errors.

### Container Won't Start
Check logs:
```powershell
docker-compose logs mysql-db
docker-compose logs quiz-app
```

---

For detailed documentation, see [DEVOPS_GUIDE.md](DEVOPS_GUIDE.md)
