# Git Subtree - Practical Examples

## Example 1: Simple Node.js Project with Dependencies

### Setup

```bash
# Create project directory
mkdir example1-app
cd example1-app
git init
git config user.email "you@example.com"
git config user.name "Your Name"

# Create initial structure
mkdir -p src libs
cat > package.json << 'EOF'
{
  "name": "example1-app",
  "version": "1.0.0",
  "description": "App using git subtrees"
}
EOF

cat > README.md << 'EOF'
# Example 1 App

This app demonstrates git subtree usage.

## Dependencies (via git subtree)
- libs/logger: Logging library
EOF

git add .
git commit -m "Initial project setup"
```

### Add Subtrees

```bash
# Add a real logging library as subtree
# (Using a real public repo for demo)
git subtree add --prefix=libs/pino https://github.com/pinojs/pino.git master --squash

# Verify it was added
ls -la libs/pino/
git log --oneline | head -5
```

### Create App Code

```bash
cat > src/app.js << 'EOF'
// Using subtree dependency
const pino = require('../libs/pino');
const logger = pino();

logger.info('Application started');
logger.warn('This is a warning');
logger.error('This is an error');
EOF

git add src/app.js
git commit -m "Add main application file"
```

### Update Subtree

```bash
# Pull latest from pino
git subtree pull --prefix=libs/pino https://github.com/pinojs/pino.git master --squash

# Check for updates
git log --oneline | head -3
```

---

## Example 2: Monorepo with Multiple Subtrees

### Initialize Monorepo

```bash
mkdir example2-monorepo
cd example2-monorepo
git init

# Create structure
mkdir -p {ui,backend,shared}/libs
mkdir -p src

echo "# Monorepo with Subtrees" > README.md
git add .
git commit -m "Initial monorepo structure"
```

### Add Multiple Subtrees

```bash
# Add UI library
git subtree add --prefix=ui/libs/react-icons https://github.com/react-icons/react-icons.git master --squash

# Add utilities
git subtree add --prefix=shared/libs/lodash https://github.com/lodash/lodash.git master --squash

# Add testing library
git subtree add --prefix=ui/libs/jest https://github.com/facebook/jest.git main --squash

# Verify all were added
git log --oneline | head -10
```

### Organize with Remotes

```bash
# Add remotes for easier management
git remote add react-icons https://github.com/react-icons/react-icons.git
git remote add lodash https://github.com/lodash/lodash.git
git remote add jest https://github.com/facebook/jest.git

# Now pull updates using shorter commands
git subtree pull --prefix=ui/libs/react-icons react-icons master --squash
git subtree pull --prefix=shared/libs/lodash lodash master --squash
```

---

## Example 3: Contributing Back to Subtree

### Fork and Modify

```bash
# Let's say you improved a library in your subtree
# Edit a file in the subtree
cat >> libs/logger/README.md << 'EOF'

## Custom Improvements
- Added performance monitoring
- Improved error handling
EOF

# Stage and commit the change
git add libs/logger/README.md
git commit -m "Enhance logger documentation"

# View the commits
git log --oneline | head -5
```

### Create a Feature Branch (Simulating Contribution)

```bash
# This shows the workflow for contributing
git checkout -b contrib/logger-improvements

# Make changes
echo "Enhanced performance" >> libs/logger/CHANGELOG.md

git add libs/logger/CHANGELOG.md
git commit -m "Add performance improvements to logger"

# In a real scenario, you'd push this to subtree
# git subtree push --prefix=libs/logger https://github.com/example/logger.git feature/improvements

# Or merge back to main
git checkout main
git merge contrib/logger-improvements
```

---

## Example 4: Handling Version Updates

### Pin to Tags

```bash
# Add subtree at specific version/tag
git subtree add --prefix=libs/express https://github.com/expressjs/express.git v4.18.2 --squash

# Later, update to new version
git subtree pull --prefix=libs/express https://github.com/expressjs/express.git v4.20.0 --squash
```

### Document Versions

```bash
cat > DEPENDENCIES.md << 'EOF'
# Subtree Dependencies

| Library | Path | Source | Version |
|---------|------|--------|---------|
| Pino | libs/pino | https://github.com/pinojs/pino | master |
| Express | libs/express | https://github.com/expressjs/express | v4.18.2 |
| Lodash | libs/lodash | https://github.com/lodash/lodash | master |

## Update Commands

```bash
# Update all subtrees
git subtree pull --prefix=libs/pino https://github.com/pinojs/pino master --squash
git subtree pull --prefix=libs/express https://github.com/expressjs/express v4.20.0 --squash
git subtree pull --prefix=libs/lodash https://github.com/lodash/lodash master --squash
```

## How to Contribute

If you make improvements to any subtree:

1. Commit your changes locally
2. Push to the upstream repository:
   ```bash
   git subtree push --prefix=libs/pino https://github.com/pinojs/pino master
   ```
3. Open a pull request in the original repository
EOF

git add DEPENDENCIES.md
git commit -m "Document subtree dependencies"
```

---

## Example 5: Complex Workflow Script

Create `update-subtrees.sh`:

```bash
#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Git Subtree Manager${NC}"
echo "====================="

# Define subtrees
declare -a SUBTREES=(
    "libs/logger:https://github.com/pinojs/pino.git:master"
    "libs/utils:https://github.com/lodash/lodash.git:master"
    "libs/test:https://github.com/facebook/jest.git:main"
)

# Function to update subtree
update_subtree() {
    local prefix=$1
    local url=$2
    local branch=$3
    
    echo -e "\n${YELLOW}Updating ${prefix}...${NC}"
    
    if git subtree pull --prefix="$prefix" "$url" "$branch" --squash 2>/dev/null; then
        echo -e "${GREEN}✓ Successfully updated ${prefix}${NC}"
    else
        echo -e "${RED}✗ Failed to update ${prefix}${NC}"
        return 1
    fi
}

# Update all subtrees
for subtree in "${SUBTREES[@]}"; do
    IFS=':' read -r prefix url branch <<< "$subtree"
    update_subtree "$prefix" "$url" "$branch"
done

echo -e "\n${GREEN}All subtrees updated!${NC}"
```

### Usage

```bash
chmod +x update-subtrees.sh
./update-subtrees.sh
```

---

## Troubleshooting Examples

### Issue: Merge Conflicts in Subtree

```bash
# When pulling causes conflicts
git subtree pull --prefix=libs/logger https://github.com/example/logger.git main --squash

# If conflicts occur:
# 1. Resolve conflicts manually
git status
# Edit conflicted files
git add resolved-files
git commit -m "Resolve subtree conflicts"
```

### Issue: Subtree History is Messy

```bash
# Verify squash is being used
git subtree pull --prefix=libs/logger https://github.com/example/logger.git main --squash

# View subtree commits
git log --oneline -- libs/logger/ | head -10
```

### Issue: Need to Revert Subtree Addition

```bash
# Find the commit that added the subtree
git log --oneline --grep="Add libs/logger"

# Revert it
git revert <commit-hash>
```

---

## Tips & Tricks

### Quick Status of All Subtrees

```bash
echo "Checking subtrees..."
for dir in libs/*/; do
    echo "$(basename "$dir"): $(cd "$dir" && git log -1 --oneline || echo 'Not a git repo')"
done
```

### Archive Project with Subtrees

```bash
# Subtrees are already merged, so simple tar works
tar -czf my-project-backup.tar.gz .
```

### Integration with CI/CD

```yaml
# Example GitHub Actions workflow
name: Update Subtrees

on:
  schedule:
    - cron: '0 0 * * 0'  # Weekly

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Update subtrees
        run: ./update-subtrees.sh
      - name: Commit and push
        run: |
          git config user.name "Bot"
          git config user.email "bot@example.com"
          git add -A
          git commit -m "Update subtrees" || true
          git push
```

