# Git Subtree Visual Guide

## Workflow Overview

```
┌─────────────────────────────────────────────────────────┐
│         Your Main Repository (my-project)               │
├─────────────────────────────────────────────────────────┤
│                                                           │
│  ┌──────────────────────────────────────────────┐       │
│  │  src/                                        │       │
│  │  ├── main.js                                │       │
│  │  └── app.js                                 │       │
│  └──────────────────────────────────────────────┘       │
│                                                           │
│  ┌──────────────────────────────────────────────┐       │
│  │  libs/  (Git Subtrees)                       │       │
│  │  ├── logger/   ← git subtree 1 ────┐        │       │
│  │  ├── utils/    ← git subtree 2 ─┐  │        │       │
│  │  └── test/     ← git subtree 3 ─┼──┤        │       │
│  └────────────────────────────────┼──┼────────┘       │
│                                    │  │               │
│  Git History                       │  │               │
│  ├─ Initial commit                 │  │               │
│  ├─ Add 'libs/logger' from...      │  │               │
│  ├─ Add 'libs/utils' from...       │  │               │
│  ├─ Add 'libs/test' from...        │  │               │
│  └─ Update app.js                  │  │               │
└────────────────────────────────────┼──┼───────────────┘
                                     │  │
              ┌──────────────────────┘  │
              │                         │
    ┌─────────▼──────────┐   ┌─────────▼──────────┐
    │  logger-lib repo   │   │  utils-lib repo    │
    │  (GitHub)          │   │  (GitHub)          │
    └────────────────────┘   └────────────────────┘
```

## Command Flow

```
┌─ START: Adding a Subtree ─┐
│                            │
│  1. git remote add         │
│     logger-repo            │
│     <URL>                  │
│          │                 │
│          ▼                 │
│  2. git subtree add        │
│     --prefix=libs/logger   │
│     logger-repo master     │
│     --squash               │
│          │                 │
│          ▼                 │
│  3. Subtree added!         │
│     Checkout complete      │
│     Code is merged         │
│                            │
└────────────────────────────┘

┌─ PULLING Updates ─┐
│                   │
│  git subtree pull │
│  --prefix=...     │
│  logger-repo      │
│  master --squash  │
│        │          │
│        ▼          │
│  Updates merged   │
│  into your repo   │
│                   │
└───────────────────┘

┌─ PUSHING Changes ─┐
│                   │
│  (Make changes)   │
│  git add .        │
│  git commit       │
│        │          │
│        ▼          │
│  git subtree push │
│  --prefix=...     │
│  logger-repo      │
│  master           │
│        │          │
│        ▼          │
│  Changes sent to  │
│  original repo    │
│                   │
└───────────────────┘
```

## Directory Structure After Adding Subtrees

```
my-project/
├── .git/                      # Your git repository
│   ├── objects/
│   ├── refs/
│   └── config                 # Stores remote info
│
├── src/                        # Your code
│   ├── main.js
│   └── app.js
│
├── libs/                       # Subtree directory
│   ├── logger/                 # ← Subtree 1 (full code merged)
│   │   ├── .git/              # (No separate .git!)
│   │   ├── package.json
│   │   ├── index.js
│   │   └── README.md
│   │
│   ├── utils/                  # ← Subtree 2 (full code merged)
│   │   ├── package.json
│   │   ├── index.js
│   │   └── ...
│   │
│   └── test/                   # ← Subtree 3 (full code merged)
│       ├── package.json
│       └── ...
│
├── README.md
├── package.json
└── .gitignore                  # (Don't exclude libs/)
```

## Git Subtree vs Alternatives

```
┌──────────────────────────────────────────────────┐
│          How External Code Gets Included         │
├──────────────────────────────────────────────────┤
│                                                   │
│  GIT SUBTREE (This tutorial)                      │
│  ┌────────────────────────────────────┐          │
│  │ Code: MERGED into your repo        │          │
│  │ History: INCLUDED in your repo     │          │
│  │ .git: Your repo tracks it          │          │
│  │ Editing: Direct file edit          │          │
│  │ Cloning: No extra steps            │          │
│  │ Complexity: Simple ✓               │          │
│  └────────────────────────────────────┘          │
│           ▲                                       │
│  GIT SUBMODULE                                    │
│  ┌────────────────────────────────────┐          │
│  │ Code: REFERENCE to external repo   │          │
│  │ History: Not in your repo          │          │
│  │ .git: Own separate .git            │          │
│  │ Editing: Requires coordination     │          │
│  │ Cloning: Needs --recursive         │          │
│  │ Complexity: Complex                │          │
│  └────────────────────────────────────┘          │
│           ▲                                       │
│  PACKAGE MANAGER (npm, pip, etc)                  │
│  ┌────────────────────────────────────┐          │
│  │ Code: Downloaded to node_modules   │          │
│  │ History: Not tracked               │          │
│  │ .git: No git integration           │          │
│  │ Editing: Not intended              │          │
│  │ Versioning: Via package.json       │          │
│  │ Complexity: Medium                 │          │
│  └────────────────────────────────────┘          │
│                                                   │
└──────────────────────────────────────────────────┘
```

## Typical Project with Multiple Subtrees

```
REPOSITORY STRUCTURE:
─────────────────────

my-company-app
├── Project Code
│   └── src/
│       ├── components/
│       ├── utils/
│       └── services/
│
├── Subtree: UI Components
│   └── libs/ui-lib/
│       ├── Button.js
│       ├── Modal.js
│       └── Input.js
│
├── Subtree: Authentication
│   └── libs/auth/
│       ├── login.js
│       ├── logout.js
│       └── tokens.js
│
├── Subtree: Database Utilities
│   └── libs/db-utils/
│       ├── connection.js
│       └── migrations/
│
└── Configuration
    ├── .subtrees.conf
    ├── package.json
    └── README.md


TYPICAL WORKFLOW:
─────────────────

Day 1: Setup
  $ git remote add ui-lib https://github.com/company/ui-lib.git
  $ git remote add auth https://github.com/company/auth.git
  $ git remote add db-utils https://github.com/company/db-utils.git
  $ git subtree add --prefix=libs/ui-lib ui-lib main --squash
  $ git subtree add --prefix=libs/auth auth main --squash
  $ git subtree add --prefix=libs/db-utils db-utils main --squash

Day 5: Use dependencies
  $ npm install
  $ node src/index.js

Day 10: Update dependencies
  $ git subtree pull --prefix=libs/ui-lib ui-lib main --squash
  $ git subtree pull --prefix=libs/auth auth main --squash

Day 15: Fix bug in ui-lib
  $ # Edit libs/ui-lib/Button.js
  $ git add libs/ui-lib/
  $ git commit -m "Fix Button component"
  $ git subtree push --prefix=libs/ui-lib ui-lib main

Day 20: Merge updates from all libs
  $ ./subtree-helper.sh update-all
```

## Key Concepts Visual

```
┌─────────────────────────────────────────┐
│  Git Subtree Key Concepts               │
├─────────────────────────────────────────┤
│                                          │
│  SQUASH                                  │
│  ┌──────────────────────────────────┐  │
│  │ External Repo History:            │  │
│  │  • Commit 1                       │  │
│  │  • Commit 2                       │  │
│  │  • Commit 3                       │  │
│  │  • ... (many commits)             │  │
│  │                                   │  │
│  │ --squash option:                  │  │
│  │  ↓↓↓ COMBINE ↓↓↓                  │  │
│  │                                   │  │
│  │ Your Repo History:                │  │
│  │  • Add 'libs/logger' from...      │  │
│  │    (One combined commit!)         │  │
│  └──────────────────────────────────┘  │
│                                          │
│  PREFIX                                  │
│  ┌──────────────────────────────────┐  │
│  │ --prefix=libs/logger             │  │
│  │         ↓                         │  │
│  │ Extracts code to this directory  │  │
│  │                                   │  │
│  │ Without prefix: All files would   │  │
│  │ be at root (messy!)              │  │
│  └──────────────────────────────────┘  │
│                                          │
│  REMOTES                                 │
│  ┌──────────────────────────────────┐  │
│  │ git remote add logger-repo URL   │  │
│  │           ↓                      │  │
│  │ Saves URL with short name        │  │
│  │ (Avoid long URLs repeatedly)     │  │
│  │                                   │  │
│  │ Use: git subtree add ...         │  │
│  │      ... logger-repo main        │  │
│  │      (instead of full URL)       │  │
│  └──────────────────────────────────┘  │
│                                          │
└─────────────────────────────────────────┘
```

## State Transitions

```
INITIAL STATE
─────────────
my-project/
├── src/
├── package.json
└── README.md


AFTER: git subtree add --prefix=libs/logger ... --squash
───────────────────────────────────────────────────────
my-project/
├── src/
├── libs/
│   └── logger/        ← External repo code now here
│       ├── package.json
│       ├── index.js
│       └── ...
├── package.json
└── README.md

Commits:
  • Initial commit
  + Add 'libs/logger' from commit xyz... (SQUASHED)


AFTER: make changes to libs/logger/
──────────────────────────────────
(Files modified)
├── src/
├── libs/
│   └── logger/
│       └── SOME-FILE.js   ← Modified


AFTER: git add . && git commit "Improve logger"
──────────────────────────────────────────────
Commits:
  • Initial commit
  + Add 'libs/logger' from...
  + Improve logger   ← Your changes


AFTER: git subtree push --prefix=libs/logger logger-repo main
───────────────────────────────────────────────────────────
Changes sent to:
  https://github.com/example/logger-repo

Original repo:
  Receives your commit about logger
  Authors can review & merge
```

## Commands at a Glance

```
OPERATION              COMMAND                              WHEN TO USE
───────────────────────────────────────────────────────────────────────
Add Subtree           git subtree add                        Initial setup
Pull Updates          git subtree pull                       Keep current
Push Changes          git subtree push                       Share fixes
View Subtree Log      git log -- libs/logger/                Understand history
List Remotes          git remote -v                          See config
Remove Subtree        git rm -r libs/logger/                 Clean up
Status Check          git status libs/logger/                Verify state
```
