# logtool-script
# Linux Admin Toolkit

A collection of lightweight, production-ready Linux scripts to simplify system administration tasks such as log management, automated backups, and intelligent `crontab` scheduling.

## 📌 Features

### 1. **LogTool**
- Cleans, rotates, and archives system/application logs.
- Supports filtering logs by date, size, or keywords.
- Compresses old logs to save disk space.
- Optional email alerts for critical log entries.

### 2. **Backup Script**
- Creates incremental or full backups of files and directories.
- Supports local and remote backup (via `rsync`/`scp`).
- Configurable retention period to avoid storage overflow.
- Supports daily, weekly, or on-demand backups.

### 3. **Crontab Smart Organizer**
- Automatically organizes and optimizes cron jobs.
- Detects duplicate or conflicting schedules.
- Creates readable job descriptions for easier maintenance.
- Generates backup of your current `crontab` before changes.

---

## 🛠 Requirements
- Bash 4.0+
- `gzip`, `tar`, `rsync`, `scp` (for backup script)
- `mail` or `sendmail` (optional, for email alerts)

---

## 🚀 Installation
```bash
git clone https://github.com/yourusername/linux-admin-toolkit.git
cd linux-admin-toolkit
chmod +x *.sh

