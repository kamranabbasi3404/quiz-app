# Jenkins Setup Guide

## Quick Setup for Quiz-App Project

### Prerequisites
- Docker Desktop installed and running
- Git repository for your project

---

## Option 1: Jenkins in Docker (Recommended)

### Step 1: Start Jenkins Container

```powershell
# Create volume for Jenkins data persistence
docker volume create jenkins-data

# Run Jenkins container
docker run -d `
  --name jenkins `
  -p 8080:8080 `
  -p 50000:50000 `
  -v jenkins-data:/var/jenkins_home `
  -v /var/run/docker.sock:/var/run/docker.sock `
  jenkins/jenkins:lts
```

### Step 2: Access Jenkins

1. Open browser: http://localhost:8080
2. Get initial admin password:
   ```powershell
   docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
   ```
3. Copy password and paste in browser
4. Click "Install suggested plugins"
5. Create admin user account

### Step 3: Install Required Plugins

1. Go to **Manage Jenkins** → **Manage Plugins**
2. Click **Available** tab
3. Search and install:
   - ✅ Git Plugin
   - ✅ Maven Integration Plugin
   - ✅ Docker Pipeline Plugin
   - ✅ Pipeline Plugin
   - ✅ Email Extension Plugin (optional)
4. Restart Jenkins after installation

### Step 4: Configure Tools

1. Go to **Manage Jenkins** → **Global Tool Configuration**

2. **Add JDK**:
   - Click "Add JDK"
   - Name: `JDK-17`
   - Check "Install automatically"
   - Select version: Java 17

3. **Add Maven**:
   - Click "Add Maven"
   - Name: `Maven-3.9`
   - Check "Install automatically"
   - Select version: 3.9.x

4. Click **Save**

### Step 5: Create Pipeline Job

1. Click **New Item**
2. Enter name: `Quiz-App-Pipeline`
3. Select **Pipeline**
4. Click **OK**

5. **Configure the job**:
   
   **General Tab**:
   - Description: "CI/CD Pipeline for Quiz Application"
   
   **Build Triggers**:
   - ✅ Poll SCM
   - Schedule: `H/5 * * * *` (checks every 5 minutes)
   
   **Pipeline**:
   - Definition: "Pipeline script from SCM"
   - SCM: Git
   - Repository URL: `<your-git-repo-url>`
   - Branch: `*/main` (or `*/master`)
   - Script Path: `Jenkinsfile`

6. Click **Save**

### Step 6: Test the Pipeline

1. Click **Build Now**
2. Watch build progress in "Build History"
3. Click on build number (e.g., #1)
4. Click **Console Output** to see logs

---

## Option 2: Jenkins on Windows

### Step 1: Download and Install

1. Download from: https://www.jenkins.io/download/
2. Run the installer (jenkins.msi)
3. Follow installation wizard
4. Jenkins starts automatically on http://localhost:8080

### Step 2: Initial Setup

Same as Option 1, Steps 2-6

---

## Pipeline Stages Explained

Your Jenkinsfile includes these stages:

1. **Checkout**: Pull latest code from Git
2. **Build**: Compile Java code with Maven
3. **Test**: Run unit tests
4. **Package**: Create JAR file
5. **Docker Build**: Build Docker image
6. **Docker Push**: Push to registry (optional)
7. **Deploy**: Deploy with docker-compose
8. **Health Check**: Verify containers are running

---

## Setting Up Git Integration

### For GitHub

1. **Create Personal Access Token**:
   - GitHub → Settings → Developer settings → Personal access tokens
   - Generate new token with `repo` scope
   - Copy the token

2. **Add Credentials in Jenkins**:
   - Manage Jenkins → Manage Credentials
   - Click "(global)" → Add Credentials
   - Kind: Username with password
   - Username: Your GitHub username
   - Password: Your personal access token
   - ID: `github-credentials`
   - Click **Create**

3. **Use in Pipeline**:
   - In pipeline configuration, select credentials when adding repository URL

### For GitLab/Bitbucket

Similar process - create access token and add to Jenkins credentials.

---

## Setting Up Webhooks (Optional)

For automatic builds on code push:

### GitHub Webhook

1. Go to your GitHub repository
2. Settings → Webhooks → Add webhook
3. Payload URL: `http://your-jenkins-url:8080/github-webhook/`
4. Content type: `application/json`
5. Select: "Just the push event"
6. Click **Add webhook**

### In Jenkins

1. Edit your pipeline job
2. Build Triggers → Check "GitHub hook trigger for GITScm polling"
3. Save

Now builds will trigger automatically on code push!

---

## Email Notifications (Optional)

### Configure Email

1. **Manage Jenkins** → **Configure System**
2. Scroll to **Extended E-mail Notification**
3. SMTP server: `smtp.gmail.com` (for Gmail)
4. SMTP Port: `465`
5. Credentials: Add your email credentials
6. Use SSL: ✅
7. Default recipients: your-email@example.com

### Update Jenkinsfile

Uncomment email sections in Jenkinsfile:
```groovy
emailext (
    subject: "SUCCESS: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
    body: "Build successful!",
    to: 'your-email@example.com'
)
```

---

## Troubleshooting

### Jenkins Container Won't Start

```powershell
# Check logs
docker logs jenkins

# Restart container
docker restart jenkins
```

### Can't Access Jenkins UI

- Verify Docker Desktop is running
- Check if port 8080 is available
- Try: http://localhost:8080 or http://127.0.0.1:8080

### Pipeline Fails at Docker Stage

- Ensure Docker Desktop is running
- Verify Docker socket is mounted in Jenkins container
- Check Jenkins has permission to access Docker

### Build Fails: "Tool not found"

- Go to Global Tool Configuration
- Verify tool names match Jenkinsfile (`JDK-17`, `Maven-3.9`)
- Ensure tools are installed/configured

### Git Authentication Failed

- Add credentials in Jenkins
- Use HTTPS URL for repository
- Verify credentials are selected in pipeline config

---

## Best Practices

✅ **Use Pipeline from SCM**: Store Jenkinsfile in repository  
✅ **Use Credentials**: Never hardcode passwords  
✅ **Enable Notifications**: Get alerts on build failures  
✅ **Archive Artifacts**: Keep build outputs  
✅ **Clean Workspace**: Prevent disk space issues  
✅ **Use Stages**: Organize pipeline logically  
✅ **Add Health Checks**: Verify deployments  

---

## Useful Jenkins Commands

```powershell
# Start Jenkins container
docker start jenkins

# Stop Jenkins container
docker stop jenkins

# View Jenkins logs
docker logs -f jenkins

# Restart Jenkins
docker restart jenkins

# Backup Jenkins data
docker run --rm -v jenkins-data:/data -v ${PWD}:/backup alpine tar czf /backup/jenkins-backup.tar.gz -C /data .

# Restore Jenkins data
docker run --rm -v jenkins-data:/data -v ${PWD}:/backup alpine tar xzf /backup/jenkins-backup.tar.gz -C /data
```

---

## Next Steps

1. ✅ Install Jenkins (Docker or Windows)
2. ✅ Configure plugins and tools
3. ✅ Create pipeline job
4. ✅ Test with manual build
5. ⬜ Set up Git webhooks for auto-builds
6. ⬜ Configure email notifications
7. ⬜ Add more test stages to pipeline

---

## Additional Resources

- **Jenkins Documentation**: https://www.jenkins.io/doc/
- **Pipeline Syntax**: https://www.jenkins.io/doc/book/pipeline/syntax/
- **Plugin Index**: https://plugins.jenkins.io/

---

For complete DevOps guide, see [DEVOPS_GUIDE.md](DEVOPS_GUIDE.md)
