

#!/bin/bash



# Check CPU usage

CPU_USAGE=$(top -bn1 | grep load | awk '{printf "%.2f\n", $(NF-2)}')

CPU_THRESHOLD=80



if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then

    echo "CPU usage is high"

fi



# Check memory usage

MEM_USAGE=$(free | grep Mem | awk '{printf "%.2f\n", $3/$2 * 100.0}')

MEM_THRESHOLD=80



if (( $(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc -l) )); then

    echo "Memory usage is high"

fi



# Check disk space

DISK_USAGE=$(df -h | awk '{if ($NF == "/") {print $5}}' | sed 's/%//g')

DISK_THRESHOLD=80



if (( $(echo "$DISK_USAGE > $DISK_THRESHOLD" | bc -l) )); then

    echo "Disk space is running low"

fi