# Git Subtree Examples - Complete Documentation Index

Welcome! This is a comprehensive guide to using Git Subtree for managing external repositories as subdirectories. Below is a navigation guide to help you find what you need.

## 📚 Documentation Files

### For Quick Start
- **[QUICK-REFERENCE.md](QUICK-REFERENCE.md)** - Essential commands and common patterns
  - Perfect if you just need the commands
  - ~2 minute read
  - Copy-paste ready

### For Learning
- **[README.md](README.md)** - Comprehensive guide covering everything
  - Deep dive into Git Subtree concepts
  - When to use vs alternatives
  - Best practices and troubleshooting
  - ~15 minute read

### For Hands-On Tutorial
- **[TUTORIAL.md](TUTORIAL.md)** - Step-by-step working example
  - Run along and learn by doing
  - Complete script provided
  - Ready-to-use demo setup
  - ~30 minute read

### For Understanding Concepts
- **[VISUAL-GUIDE.md](VISUAL-GUIDE.md)** - Diagrams and visual explanations
  - ASCII diagrams of workflow
  - Visual comparisons with alternatives
  - State transitions illustrated
  - ~10 minute read

### For Advanced Examples
- **[EXAMPLES.md](EXAMPLES.md)** - Real-world scenarios
  - Multiple subtree setups
  - CI/CD integration
  - Contribution workflows
  - ~20 minute read

## 🛠️ Tools & Scripts

### Helper Script
- **[subtree-helper.sh](subtree-helper.sh)** - Bash utility for managing subtrees
  ```bash
  chmod +x subtree-helper.sh
  ./subtree-helper.sh help
  ```
  Features:
  - Add/pull/push subtrees easily
  - Batch update from config
  - View history and status
  - Colorized output

### Configuration Files
- **[.subtrees.conf.example](.subtrees.conf.example)** - Template for managing multiple subtrees
  - Rename to `.subtrees.conf` and customize
  - Used by helper script for bulk operations
  - Format: `prefix:url:branch`

- **[.gitignore.example](.gitignore.example)** - Recommended gitignore settings
  - Shows what to exclude
  - Important: Don't exclude `libs/`!

## 🎯 Choose Your Path

### I'm brand new to Git Subtree
1. Read: [QUICK-REFERENCE.md](QUICK-REFERENCE.md) (2 min)
2. Skim: [VISUAL-GUIDE.md](VISUAL-GUIDE.md) (5 min)
3. Learn: [TUTORIAL.md](TUTORIAL.md) (30 min)
4. Reference: [README.md](README.md) (on demand)

### I need to get started quickly
1. Read: [QUICK-REFERENCE.md](QUICK-REFERENCE.md) (2 min)
2. Run: Commands from there directly

### I want to understand everything
1. Read: [README.md](README.md) (main guide)
2. Review: [VISUAL-GUIDE.md](VISUAL-GUIDE.md) (concepts)
3. Practice: [TUTORIAL.md](TUTORIAL.md) (hands-on)
4. Explore: [EXAMPLES.md](EXAMPLES.md) (advanced)

### I need specific scenarios
- Check [EXAMPLES.md](EXAMPLES.md) for your use case
- Search for keywords like "monorepo", "CI/CD", "contribute"

## 📋 Common Tasks Quick Links

### Adding a Subtree
```bash
git remote add repo-name https://github.com/user/repo.git
git subtree add --prefix=libs/reponame repo-name main --squash
```
👉 Full details in [QUICK-REFERENCE.md](QUICK-REFERENCE.md)

### Updating Dependencies
```bash
git subtree pull --prefix=libs/reponame repo-name main --squash
```
👉 Full details in [QUICK-REFERENCE.md](QUICK-REFERENCE.md)

### Contributing Back
```bash
# Make changes to libs/reponame/
git add libs/reponame/
git commit -m "Your improvement"
git subtree push --prefix=libs/reponame repo-name main
```
👉 Full workflow in [EXAMPLES.md](EXAMPLES.md#example-3-contributing-back-to-subtree)

### Managing Multiple Subtrees
1. Create `.subtrees.conf` (see [.subtrees.conf.example](.subtrees.conf.example))
2. Use helper: `./subtree-helper.sh update-all`

👉 Full details in [EXAMPLES.md](EXAMPLES.md#example-5-complex-workflow-script)

### Understanding Workflow
👉 See [VISUAL-GUIDE.md](VISUAL-GUIDE.md) for ASCII diagrams

## 🤔 FAQ

**Q: What's the difference between Git Subtree and Git Submodule?**
A: See [README.md - Comparison Table](README.md#key-differences-from-submodules)

**Q: When should I use Git Subtree?**
A: See [README.md - When to Use](README.md#when-to-use-git-subtree) or [VISUAL-GUIDE.md](VISUAL-GUIDE.md)

**Q: How do I update all subtrees at once?**
A: Use `.subtrees.conf` + `subtree-helper.sh update-all`
See [EXAMPLES.md#example-5](EXAMPLES.md#example-5-complex-workflow-script)

**Q: Can I contribute my changes back?**
A: Yes! See [EXAMPLES.md#example-3](EXAMPLES.md#example-3-contributing-back-to-subtree)

**Q: What does `--squash` do?**
A: See [VISUAL-GUIDE.md - SQUASH](VISUAL-GUIDE.md#key-concepts-visual)

**Q: How do I remove a subtree?**
A: See [README.md - Removing a Subtree](README.md#removing-a-subtree)

## 🚀 Getting Started (Fastest Path)

### Option 1: Just Give Me Commands (~2 min)
```
→ Open: QUICK-REFERENCE.md
→ Copy commands
→ Done!
```

### Option 2: Show Me How (~30 min)
```
→ Follow: TUTORIAL.md
→ Run the example
→ Practice with real repos
```

### Option 3: Full Education (~1.5 hours)
```
1. QUICK-REFERENCE.md (5 min) - Overview
2. VISUAL-GUIDE.md (15 min) - Understand concepts
3. README.md (30 min) - Deep dive
4. TUTORIAL.md (30 min) - Hands-on
5. EXAMPLES.md (20 min) - Advanced scenarios
```

## 🔧 Helper Script Usage

Make it executable first:
```bash
chmod +x subtree-helper.sh
```

### Common Commands
```bash
# Add a new subtree
./subtree-helper.sh add libs/logger https://github.com/example/logger.git main

# Pull updates
./subtree-helper.sh pull libs/logger https://github.com/example/logger.git main

# Update all from config
./subtree-helper.sh update-all

# View subtree status
./subtree-helper.sh status

# See all options
./subtree-helper.sh help
```

See [subtree-helper.sh](subtree-helper.sh) for full documentation.

## 📞 Key Commands Reference

| Command | Purpose | Where to Learn |
|---------|---------|---|
| `git subtree add` | Add external repo as subdirectory | [QUICK-REFERENCE.md](QUICK-REFERENCE.md) |
| `git subtree pull` | Get updates from external repo | [QUICK-REFERENCE.md](QUICK-REFERENCE.md) |
| `git subtree push` | Send changes back to external repo | [QUICK-REFERENCE.md](QUICK-REFERENCE.md) |
| `git remote add` | Create alias for repo URL | [QUICK-REFERENCE.md](QUICK-REFERENCE.md) |
| `git log -- <path>` | View history of subtree | [README.md](README.md#viewing-subtree-history) |

## 💡 Pro Tips

1. **Always use `--squash`** - Keeps history clean
2. **Use remote aliases** - Shorter, less error-prone
3. **Document your subtrees** - In README or `.subtrees.conf`
4. **Test before pushing** - Especially when contributing back
5. **Version your dependencies** - Consider tagging instead of branches

See more tips in [README.md - Best Practices](README.md#best-practices)

## 🐛 Troubleshooting

### Common Issues
- **"Not a valid object name"** → [README.md - Troubleshooting](README.md#troubleshooting)
- **"Can't merge" error** → [README.md - Troubleshooting](README.md#troubleshooting)
- **Undo a subtree add** → [EXAMPLES.md](EXAMPLES.md#issue-need-to-revert-subtree-addition)

### Need Help?
1. Search this documentation
2. Check [README.md - Troubleshooting](README.md#troubleshooting)
3. Review relevant [EXAMPLES.md](EXAMPLES.md)
4. Check Git official docs: `git subtree --help`

## 📖 Additional Resources

- [Official Git Subtree Documentation](https://git-scm.com/docs/git-subtree)
- [Atlassian Git Subtree Guide](https://www.atlassian.com/blog/git/alternatives-to-git-submodule-git-subtree)
- [GitHub Guides](https://github.com/git-tips/tips)

## 📝 Document Map

```
test-get-tree/
├── README.md ........................ Main comprehensive guide
├── QUICK-REFERENCE.md .............. Essential commands (START HERE!)
├── VISUAL-GUIDE.md ................. Diagrams and concepts
├── TUTORIAL.md ..................... Step-by-step example
├── EXAMPLES.md ..................... Real-world scenarios
├── INDEX.md (THIS FILE) ............ Navigation guide
├── subtree-helper.sh ............... Utility script
├── .subtrees.conf.example .......... Config template
├── .gitignore.example .............. Git ignore template
└── [Your Project Files]
```

## 🎓 Learning Outcomes

After going through this documentation, you should be able to:

✅ Understand when and why to use Git Subtree
✅ Add external repositories as subtrees
✅ Pull updates from subtrees
✅ Make changes and contribute back
✅ Manage multiple subtrees efficiently
✅ Troubleshoot common issues
✅ Compare with alternatives (submodules, package managers)

## 🚀 Next Steps

1. **Choose your learning path** from the options above
2. **Start with [QUICK-REFERENCE.md](QUICK-REFERENCE.md)** - Takes 2 minutes
3. **Follow [TUTORIAL.md](TUTORIAL.md)** if you want hands-on practice
4. **Use [subtree-helper.sh](subtree-helper.sh)** in your projects
5. **Reference [README.md](README.md)** when you have detailed questions

---

**Questions?** Check the relevant section above or search the docs.

**Ready?** → [QUICK-REFERENCE.md](QUICK-REFERENCE.md)

**Want to learn?** → [TUTORIAL.md](TUTORIAL.md)

**Need deep knowledge?** → [README.md](README.md)
