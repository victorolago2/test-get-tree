# Git Subtree Working Tutorial

This guide walks through a complete, runnable git subtree example.

## Step 1: Create a Test Project

```bash
# Create a new directory for testing
mkdir -p ~/git-subtree-demo
cd ~/git-subtree-demo

# Initialize git repository
git init
git config user.email "test@example.com"
git config user.name "Test User"

# Create project structure
mkdir -p src libs

# Create initial files
cat > README.md << 'EOF'
# My Demo App

This app demonstrates Git Subtree usage with real repositories.
EOF

cat > package.json << 'EOF'
{
  "name": "subtree-demo",
  "version": "1.0.0",
  "description": "Git Subtree demonstration",
  "main": "src/main.js"
}
EOF

cat > src/main.js << 'EOF'
#!/usr/bin/env node

console.log("=== Git Subtree Demo ===");
console.log("This app uses git subtrees to manage dependencies");
EOF

chmod +x src/main.js

# Initial commit
git add .
git commit -m "Initial project setup"
```

## Step 2: Add Remotes for Easier Management

Using remotes makes commands shorter and more readable:

```bash
# Add remotes for the libraries we'll use as subtrees
git remote add pino-repo https://github.com/pinojs/pino.git
git remote add lodash-repo https://github.com/lodash/lodash.git

# Verify remotes were added
git remote -v
```

Output should show:
```
lodash-repo      https://github.com/lodash/lodash.git (fetch)
lodash-repo      https://github.com/lodash/lodash.git (push)
pino-repo        https://github.com/pinojs/pino.git (fetch)
pino-repo        https://github.com/pinojs/pino.git (push)
```

## Step 3: Add First Subtree - Pino Logger

```bash
# Add pino as a subtree
git subtree add --prefix=libs/pino pino-repo master --squash

# This will:
# 1. Clone the pino repository
# 2. Create a single squashed commit
# 3. Place the code in libs/pino/

# Verify it was added
ls -la libs/pino/
git log --oneline | head -5
```

Expected output:
```
abc1234 Add 'libs/pino/' from commit 'xyz789...'
def5678 Initial project setup
```

## Step 4: Add Second Subtree - Lodash Utilities

```bash
# Add lodash as a subtree
git subtree add --prefix=libs/lodash lodash-repo master --squash

# View updated structure
ls -la libs/

# Check status
git status
```

## Step 5: Use the Libraries in Your Code

Now let's create code that uses the subtree dependencies:

```bash
cat > src/app.js << 'EOF'
// Using libraries from git subtrees
const pino = require('../libs/pino');
const _ = require('../libs/lodash');

const logger = pino();

logger.info('Application Started');
logger.info('Lodash version info', { util: typeof _.each });

// Use lodash utilities
const arr = [1, 2, 3, 4, 5];
_.forEach(arr, (n) => {
  logger.debug(`Processing number: ${n}`);
});

logger.info('Processing complete');
EOF

# Commit the new code
git add src/app.js
git commit -m "Add app using subtree libraries"

# View the commit log
git log --oneline | head -10
```

## Step 6: Check Subtree Status

```bash
# View files in libs/pino/
echo "=== Pino Subtree Contents ==="
ls libs/pino/ | head -20

# View commits affecting pino subtree
echo -e "\n=== Recent Pino Commits ==="
git log --oneline --follow -- libs/pino/ | head -10

# View commits affecting lodash subtree
echo -e "\n=== Recent Lodash Commits ==="
git log --oneline --follow -- libs/lodash/ | head -10
```

## Step 7: Pull Updates from Subtree

Update to the latest version of a library:

```bash
# Pull latest updates from pino
git subtree pull --prefix=libs/pino pino-repo master --squash

# Check the log to see the update
git log --oneline | head -5

# Pull latest updates from lodash
git subtree pull --prefix=libs/lodash lodash-repo master --squash
```

## Step 8: Make Local Changes to Subtree

Sometimes you'll need to improve or fix code in a subtree:

```bash
# Make a change to a file in the subtree
echo "// Enhancement for pino" >> libs/pino/README.md

# View the change
git status

# Stage and commit the change
git add libs/pino/README.md
git commit -m "Enhance pino documentation"

# View the commit
git log --oneline | head -3
```

## Step 9: Push Changes Back to Subtree (Simulated)

In a real scenario, you could push changes back:

```bash
# This command would push local changes to the original repository
# NOTE: Requires push access to the original repository
# git subtree push --prefix=libs/pino pino-repo master

# For this demo, we'll just show the command
echo "To push changes back to pino repository:"
echo "git subtree push --prefix=libs/pino pino-repo master"
```

## Step 10: View Your Completed Project

```bash
# Display the project structure
tree -L 3 -I 'node_modules|.git' .

# Display the git log
echo -e "\n=== Project Commit History ==="
git log --oneline --all

# Show configuration
echo -e "\n=== Git Remotes ==="
git remote -v
```

## Complete Script (All-in-One)

Save this as `demo.sh` to run the entire tutorial:

```bash
#!/bin/bash

set -e

echo "🚀 Git Subtree Demo Setup"
echo "========================="

# Configuration
DEMO_DIR="${1:-.}"
PINO_URL="https://github.com/pinojs/pino.git"
LODASH_URL="https://github.com/lodash/lodash.git"

cd "$DEMO_DIR"

echo "📁 Initializing repository..."
git init
git config user.email "demo@example.com"
git config user.name "Demo User"

echo "📂 Creating project structure..."
mkdir -p src libs
touch README.md package.json

echo "📝 Adding initial files..."
echo "# Demo App" > README.md
echo '{"name":"demo","version":"1.0.0"}' > package.json

git add .
git commit -m "Initial setup"

echo "🔗 Adding remotes..."
git remote add pino "$PINO_URL"
git remote add lodash "$LODASH_URL"

echo "📦 Adding Pino subtree..."
git subtree add --prefix=libs/pino pino master --squash

echo "📦 Adding Lodash subtree..."
git subtree add --prefix=libs/lodash lodash master --squash

echo "✅ Demo setup complete!"
echo ""
echo "📊 Project structure:"
find . -maxdepth 2 -type d ! -path '*/\.git/*' ! -name '.git' | head -10

echo ""
echo "📜 Recent commits:"
git log --oneline | head -5

echo ""
echo "🎉 You can now:"
echo "  - Edit files in libs/pino/ and libs/lodash/"
echo "  - git subtree pull --prefix=libs/pino pino master --squash"
echo "  - git subtree push --prefix=libs/pino pino master"
```

### Run It

```bash
chmod +x demo.sh
./demo.sh ~/my-subtree-demo
cd ~/my-subtree-demo
```

## Troubleshooting This Tutorial

### Issue: "fatal: remote error: Repository not found"
- The repository URL may have changed
- Try checking the repository URL with: `git ls-remote https://github.com/pinojs/pino.git`

### Issue: "fatal: Not a valid object name"
- The branch name might be different
- Try: `git ls-remote https://github.com/pinojs/pino.git | grep HEAD`

### Issue: "Can't merge..."
- There might be conflicts
- Resolve conflicts manually, then: `git add . && git commit`

## Next Steps

1. **Explore more**: Check out `EXAMPLES.md` for advanced examples
2. **Use the helper**: Try `./subtree-helper.sh` for easier management
3. **Read the docs**: See `README.md` for comprehensive documentation
4. **Check reference**: Use `QUICK-REFERENCE.md` for common commands

## Key Takeaways

✅ **Benefits of Git Subtree:**
- Source code is fully accessible
- Can modify external code directly
- History is preserved and visible
- Can contribute back to original repo
- Works great for small, stable dependencies

❌ **When to reconsider:**
- Too many subtrees (>10)
- Frequently changing dependencies
- Better served by package managers
- Complex monorepo structures

## Useful Links

- [Git Subtree Manual](https://git-scm.com/docs/git-subtree)
- [Mastering Git Subtrees](https://www.atlassian.com/git/tutorials/git-subtree)
- [Subtree vs Submodule Comparison](https://www.atlassian.com/blog/git/alternatives-to-git-submodule-git-subtree)
