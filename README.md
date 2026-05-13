# Git Subtree Example

A comprehensive guide to using Git subtree for managing external repositories as subdirectories.

## What is Git Subtree?

Git subtree allows you to embed one repository as a subdirectory within another repository. It's an alternative to Git submodules that merges the external code directly into your repository history.

## Key Differences from Submodules

| Feature | Subtree | Submodule |
|---------|---------|-----------|
| External repo code | Merged directly | Reference only |
| Clone behavior | No extra steps | `--recursive` needed |
| History | Intertwined | Separate |
| Complexity | Simpler | More powerful |

## Quick Start

### 1. Add a Subtree

```bash
git subtree add --prefix=<prefix> <repository-url> <branch> --squash
```

**Example:**
```bash
git subtree add --prefix=vendor/logging https://github.com/example/logging-lib.git main --squash
```

- `--prefix`: Path where the external repo will live in your project
- `--squash`: Combines all external repo commits into a single commit (recommended)

### 2. Pull Updates from Subtree

```bash
git subtree pull --prefix=<prefix> <repository-url> <branch> --squash
```

**Example:**
```bash
git subtree pull --prefix=vendor/logging https://github.com/example/logging-lib.git main --squash
```

### 3. Push Changes to Subtree

If you modify code in the subtree directory:

```bash
git subtree push --prefix=<prefix> <repository-url> <branch>
```

**Example:**
```bash
git subtree push --prefix=vendor/logging https://github.com/example/logging-lib.git main
```

## Project Structure Example

```
my-project/
├── README.md
├── src/
│   ├── main.js
│   └── config.js
├── vendor/
│   ├── logging/          # Git subtree
│   │   ├── package.json
│   │   ├── index.js
│   │   └── README.md
│   └── utils/            # Another git subtree
│       ├── package.json
│       └── helpers.js
└── package.json
```

## Practical Workflow

### Setting Up

```bash
# Initialize main project
mkdir my-project
cd my-project
git init

# Add first subtree
git subtree add --prefix=vendor/logging https://github.com/example/logging-lib.git main --squash

# Add another subtree
git subtree add --prefix=vendor/utils https://github.com/example/utils-lib.git main --squash
```

### Working with Subtrees

```bash
# View commits from subtree
git log --grep=logging

# Update vendor/logging from remote
git subtree pull --prefix=vendor/logging https://github.com/example/logging-lib.git main --squash

# Make changes to logging code
# (edit files in vendor/logging/)
git add vendor/logging/
git commit -m "Improve logging configuration"

# Push changes back to logging-lib
git subtree push --prefix=vendor/logging https://github.com/example/logging-lib.git main
```

### Using Remote Aliases (Recommended)

Add remotes to avoid long URLs:

```bash
# Add remotes
git remote add logging-lib https://github.com/example/logging-lib.git
git remote add utils-lib https://github.com/example/utils-lib.git

# Now you can use shorter commands
git subtree add --prefix=vendor/logging logging-lib main --squash
git subtree pull --prefix=vendor/logging logging-lib main --squash
git subtree push --prefix=vendor/logging logging-lib main
```

## Real-World Example

### Step 1: Initialize Project

```bash
cd /tmp
mkdir my-app && cd my-app
git init
echo "# My App" > README.md
git add .
git commit -m "Initial commit"
```

### Step 2: Add Dependencies as Subtrees

```bash
# Add a logging library
git subtree add --prefix=libs/logger https://github.com/js-logging/js-logging.git main --squash

# Add a validation library
git subtree add --prefix=libs/validator https://github.com/chriso/validator.js.git master --squash
```

### Step 3: Use Libraries in Your Project

```bash
mkdir -p src
cat > src/app.js << 'EOF'
// Import libraries from subtree
const logger = require('../libs/logger');
const validator = require('../libs/validator');

logger.info('Application started');
const email = 'user@example.com';
if (validator.isEmail(email)) {
  logger.info(`Valid email: ${email}`);
}
EOF

git add src/app.js
git commit -m "Add main application using subtree libraries"
```

### Step 4: Update Subtree

```bash
# Pull latest changes from logger library
git subtree pull --prefix=libs/logger https://github.com/js-logging/js-logging.git main --squash
```

### Step 5: Contribute Back to Subtree

```bash
# Make improvements to logger
echo "// New utility function" >> libs/logger/utils.js

git add libs/logger/utils.js
git commit -m "Add utility function to logger"

# Push changes back to original repository
git subtree push --prefix=libs/logger https://github.com/js-logging/js-logging.git main
```

## Advanced Topics

### Viewing Subtree History

```bash
# Show commits affecting a specific subtree
git log --follow --oneline -- libs/logger/

# Show just the squashed subtree commits
git log --grep="Squashed" --oneline
```

### Removing a Subtree

Unlike submodules, there's no built-in remove command. To remove:

```bash
# Remove the directory
git rm -r libs/logger/

# Commit the removal
git commit -m "Remove logger subtree"
```

### Listing All Subtrees

```bash
# Check git remote configuration
git remote -v

# Or examine .git/config for subtree information
cat .git/config
```

## Best Practices

1. **Use `--squash`**: Keeps your history clean by combining external commits
2. **Document dependencies**: List all subtrees in your README
3. **Use remote aliases**: Makes commands shorter and more readable
4. **Version pin**: Consider tagging specific versions instead of branches
5. **Test updates**: Always test after pulling subtree updates
6. **Communicate changes**: If pushing back to subtree, notify maintainers

## When to Use Git Subtree

✅ **Good for:**
- Small, stable dependencies
- When you need to modify external code
- Simple projects with few dependencies
- When contributors are unfamiliar with submodules

❌ **Not ideal for:**
- Frequently updated dependencies
- Complex dependency trees
- Large monorepos
- Many sub-projects

## Comparison with Alternatives

### Git Subtree vs. Package Manager
- **Subtree**: Source code available, can modify
- **Package Manager**: Version control, but less control

### Git Subtree vs. Copy/Paste
- **Subtree**: Can pull updates, maintain history
- **Copy/Paste**: Manual updates, no tracking

## Troubleshooting

### "Can't merge" error
```bash
# Ensure you're on the correct branch
git branch -a

# Try with a fresh fetch
git fetch --all
git subtree pull --prefix=libs/logger origin main --squash
```

### "Not a valid object name"
```bash
# Verify the remote and branch exist
git ls-remote https://github.com/example/repo.git

# Check if branch name is correct (main vs master)
```

### Undoing a Subtree Add
```bash
# Revert the commit that added the subtree
git revert <commit-hash>
```

## References

- [Git Subtree Documentation](https://git-scm.com/docs/git-subtree)
- [Mastering Git Subtrees](https://medium.com/@porteneuve/mastering-git-subtrees-2e7c5e36c8d2)
- [Git Subtree vs Submodules](https://www.atlassian.com/blog/git/alternatives-to-git-submodule-git-subtree)