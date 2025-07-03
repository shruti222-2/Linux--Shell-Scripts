#!/bin/bash
# ---------------------------------------------------------
# Cron Job Automator & Tracker
# Author: Shruti Shinde
# Description: Reads a list of cron jobs from file, installs them, and logs the process.
# ---------------------------------------------------------

INPUT_FILE="cron_tasks.txt"
BACKUP_FILE="$HOME/cron_backup_$(date +%F_%T).bak"
LOG_FILE="$HOME/cron_automator.log"
TEMP_CRON="temp_cron.txt"

log() {
    echo "[$(date '+%F %T')] $1" | tee -a "$LOG_FILE"
}

backup_existing_cron() {
    log "📦 Backing up current crontab..."
    crontab -l > "$BACKUP_FILE" 2>/dev/null || touch "$BACKUP_FILE"
    log "🗂 Backup saved to $BACKUP_FILE"
}

add_new_jobs() {
    log "📄 Reading tasks from $INPUT_FILE"
    crontab -l > "$TEMP_CRON" 2>/dev/null || touch "$TEMP_CRON"

    while IFS= read -r line; do
        # Skip comments or empty lines
        [[ -z "$line" || "$line" =~ ^# ]] && continue

        # Check if line already exists in crontab
        if grep -Fxq "$line" "$TEMP_CRON"; then
            log "⏩ Skipping duplicate: $line"
        else
            echo "$line" >> "$TEMP_CRON"
            log "✅ Added new task: $line"
        fi
    done < "$INPUT_FILE"

    crontab "$TEMP_CRON"
    rm "$TEMP_CRON"
    log "🚀 All valid jobs have been added."
}

show_next_runs() {
    log "📅 Simulating next 3 runs for each job:"
    echo "--------------------------" >> "$LOG_FILE"
    crontab -l | while IFS= read -r job; do
        [[ "$job" =~ ^# || -z "$job" ]] && continue
        cmd=$(echo "$job" | cut -d' ' -f6-)
        schedule=$(echo "$job" | awk '{print $1,$2,$3,$4,$5}')
        next=$(bash -c "echo '$schedule' | awk '{system(\"date -d next\\\"\$1 \$2 \$3 \$4 \$5\\\"\")}'")
        log "🔜 Next run for: $cmd"
    done
}

main() {
    log "============================="
    log "🛠  CRON JOB AUTOMATOR STARTED"
    log "============================="

    [[ ! -f "$INPUT_FILE" ]] && log "❌ Task file '$INPUT_FILE' not found." && exit 1

    backup_existing_cron
    add_new_jobs
    # Optional: show_next_runs
    log "✅ Task automation complete."
    log "============================="
}

main
