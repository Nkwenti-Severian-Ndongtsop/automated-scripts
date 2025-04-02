# Automated Shell Scripts

## Overview
This repository contains simple and useful shell scripts for automating tasks like system maintenance, backups, and cleanup operations. These scripts are designed to run directly on Unix-based systems (Linux/macOS) without any extra setup.

## How to Use
1. **Clone the Repository:**
   ```sh
   git clone https://github.com/Nkwenti-Severian-Ndongtsop/automated-scripts.git
   cd automated-scripts
   ```
2. **Give Execution Permission:**
   ```sh
   chmod +x <filename>
   ```
3. **Run a Script:**
   ```sh
   ./<filename>
   ```

## Automating with Cron Jobs
To schedule a script, add a cron job:
```sh
crontab -e
```
Example to run a script every day at midnight:
```sh
0 0 * * * /path/to/filename >> /path/to/log.log 2>&1
```

## Logs
If a script generates logs, you can check them using:
```sh
cat log.log
```

## Contributing
Feel free to submit pull requests with improvements or new scripts!

## License
MIT License.

## Contact
For any issues or suggestions, open a GitHub issue.

