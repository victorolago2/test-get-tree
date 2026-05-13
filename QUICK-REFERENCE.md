# Git Subtree Quick Reference

## Essential Commands

### Add a Subtree
```bash
git subtree add --prefix=<path> <repo-url> <branch> --squash
```

### Pull Updates
```bash
git subtree pull --prefix=<path> <repo-url> <branch> --squash
```

### Push Changes
```bash
git subtree push --prefix=<path> <repo-url> <branch>
```

## With Remotes (Recommended)

```bash
# Add remote first
git remote add <remote-name> <repo-url>

# Then use shorter syntax
git subtree add --prefix=<path> <remote-name> <branch> --squash
git subtree pull --prefix=<path> <remote-name> <branch> --squash
git subtree push --prefix=<path> <remote-name> <branch>
```

## Common Workflow

```bash
# 1. Create/init your project
git init my-project
cd my-project

# 2. Add remotes for your dependencies
git remote add logger https://github.com/example/logger.git
git remote add utils https://github.com/example/utils.git

# 3. Add subtrees
git subtree add --prefix=libs/logger logger main --squash
git subtree add --prefix=libs/utils utils main --squash

# 4. Commit your code
echo "console.log('Hello');" > src/main.js
git add src/
git commit -m "Add main file"

# 5. Update dependencies periodically
git subtree pull --prefix=libs/logger logger main --squash
git subtree pull --prefix=libs/utils utils main --squash

# 6. If you improve a library, push back
# (make changes to libs/logger/)
git subtree push --prefix=libs/logger logger main
```

## Directory Structure

```
my-project/
├── src/
│   └── main.js
├── libs/              # All git subtrees go here
│   ├── logger/        # Added from git subtree
│   └── utils/         # Added from git subtree
├── package.json
├── .gitignore
└── README.md
```

## Viewing Subtree Information

```bash
# Check which remotes are configured
git remote -v

# View commits in a subtree
git log --oneline -- libs/logger/

# See if subtree contains uncommitted changes
git status libs/logger/
```

## Helper Script Usage

Make the script executable:
```bash
chmod +x subtree-helper.sh
```

Use it:
```bash
./subtree-helper.sh add libs/logger https://github.com/example/logger.git main
./subtree-helper.sh pull libs/logger https://github.com/example/logger.git main
./subtree-helper.sh status
./subtree-helper.sh help
```

## Key Points

| Aspect | Detail |
|--------|--------|
| **--squash flag** | Recommended - keeps commit history clean |
| **--prefix** | Directory where subtree code lives |
| **Remote names** | Use `git remote add` to avoid long URLs |
| **Workflow** | Add remote → Add subtree → Update as needed |
| **Contributing** | Make changes → Commit → `git subtree push` |

## Troubleshooting Quick Fixes

```bash
# Verify branch/remote name
git ls-remote https://github.com/example/logger.git

# Check current branch
git branch -a

# See all remotes
git remote -v

# Undo last subtree add (if not pushed yet)
git reset --hard HEAD~1
```

## Using .subtrees.conf

Create a `.subtrees.conf` file:
```
libs/logger:https://github.com/example/logger.git:main
libs/utils:https://github.com/example/utils.git:main
libs/test:https://github.com/example/test.git:develop
```

Then update all with:
```bash
./subtree-helper.sh update-all
```

## One-Liners

```bash
# Add and commit in one go
git subtree add --prefix=libs/new https://github.com/ex/new.git main --squash && git push

# Update all from package.json dependencies (advanced)
grep '".*":' package.json | awk '{print $1}' | xargs -I {} git subtree pull --prefix=libs/{} https://github.com/example/{}.git main --squash

# List all subtrees in current project
find . -name ".git" -type d | grep -v "^\./\.git$"
```

## Performance Tips

- Use `--squash` for cleaner history
- Pin to tags/versions when possible
- Don't add huge repos as subtrees
- Consider package managers for many small deps
- Update on schedule, not constantly

## When NOT to Use Subtree

- Frequently changing external code
- Many (>5-10) different subtrees
- Complex dependency chains
- Team unfamiliar with git subtree
- Prefer using a package manager instead
