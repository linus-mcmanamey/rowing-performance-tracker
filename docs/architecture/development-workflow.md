# Development Workflow

## Branch Strategy
```
main                 # Production-ready code
├── develop         # Integration branch
├── feature/*       # Feature branches (Linear issue ID)
├── bugfix/*        # Bug fix branches
└── release/*       # Release preparation branches
```

## Standardized Story Development Workflow

### Overview
Every epic and user story follows this standardized Git workflow to ensure consistency, quality, and proper branch management across the project lifecycle.

### Story Lifecycle Git Workflow

#### Phase 1: Story Preparation (Scrum Master)
```bash
# 1. Update main branch with story documentation
git checkout main
git pull origin main
git add docs/stories/{epic}.{story}.{title}.md
git commit -m "Create Story {epic}.{story}: {title}

- Add comprehensive story documentation
- Include acceptance criteria and task breakdown
- Provide technical context from architecture
- Ready for development assignment"
git push origin main

# 2. Update GitHub issue status
gh issue comment {issue-number} --body "📋 Story documentation ready for development"
```

#### Phase 2: Development Branch Setup (Before Development)
```bash
# 1. Ensure main branch is current
git checkout main
git pull origin main

# 2. Create or update develop branch
git checkout develop 2>/dev/null || git checkout -b develop
git pull origin develop 2>/dev/null || true
git merge main --no-ff
git push -u origin develop

# 3. Create feature branch from develop
git checkout -b feature/story-{epic}.{story}-{short-description}
git push -u origin feature/story-{epic}.{story}-{short-description}

# 4. Update GitHub issue with branch info
gh issue comment {issue-number} --body "🌿 Development branch ready: feature/story-{epic}.{story}-{short-description}"
```

#### Phase 3: Development Implementation (Developer)
```bash
# 1. Work on feature branch
git checkout feature/story-{epic}.{story}-{short-description}

# 2. Regular commits during development
git add .
git commit -m "Implement {specific-feature}

- Description of changes
- Reference to AC or task completed"
git push origin feature/story-{epic}.{story}-{short-description}

# 3. Update GitHub issue with progress
gh issue comment {issue-number} --body "🔄 Implementation in progress: {current-task-description}"
```

#### Phase 4: Story Completion (Developer)
```bash
# 1. Final commit with story completion
git add .
git commit -m "Complete Story {epic}.{story}: {title}

✅ All Acceptance Criteria Met:
- AC1: {description}
- AC2: {description}
...

📝 Implementation Summary:
- {key-changes-made}
- {files-created-modified}
- {testing-completed}

🤖 Generated with [Claude Code](https://claude.ai/code)
Co-Authored-By: Claude <noreply@anthropic.com>"

git push origin feature/story-{epic}.{story}-{short-description}

# 2. Create Pull Request
gh pr create \
  --title "Story {epic}.{story}: {title}" \
  --body "$(cat <<'EOF'
## Story Completion Summary
**Story:** {epic}.{story} - {title}
**Branch:** feature/story-{epic}.{story}-{short-description} → develop

### ✅ Acceptance Criteria Completed
- [x] AC1: {description}
- [x] AC2: {description}
...

### 📝 Implementation Details
- {key-technical-decisions}
- {files-created-modified}
- {testing-approach}

### 🧪 Testing Status
- [x] Unit tests passing
- [x] Linting compliance
- [x] Coverage threshold met
- [x] Manual testing completed

### 📋 Checklist
- [x] All acceptance criteria met
- [x] Code follows project standards
- [x] Tests written and passing
- [x] Documentation updated
- [x] Ready for review

Resolves #{issue-number}
EOF
  )" \
  --base develop \
  --head feature/story-{epic}.{story}-{short-description}

# 3. Update GitHub issue
gh issue comment {issue-number} --body "✅ Story implementation completed - PR created for review"
```

#### Phase 5: Review and Merge (Team)
```bash
# 1. After PR approval, merge to develop
gh pr merge {pr-number} --squash --delete-branch

# 2. Update develop branch locally
git checkout develop
git pull origin develop

# 3. When epic/release ready, merge develop to main
git checkout main
git pull origin main
git merge develop --no-ff -m "Release: Epic {epic} completion

- Story {epic}.1: {title}
- Story {epic}.2: {title}
...

All stories tested and approved."
git push origin main

# 4. Tag release if needed
git tag -a v{version} -m "Release v{version}: {epic-description}"
git push origin v{version}
```

### Branch Naming Convention
- **Feature branches**: `feature/story-{epic}.{story}-{short-description}`
- **Bugfix branches**: `bugfix/issue-{number}-{short-description}`
- **Release branches**: `release/v{version}`
- **Hotfix branches**: `hotfix/issue-{number}-{short-description}`

Examples:
- `feature/story-1.2-ci-cd-testing-framework`
- `feature/story-2.1-pm5-bluetooth-connection`
- `bugfix/issue-45-memory-leak-fix`

### GitHub Issue Integration
Every story follows this issue lifecycle:

1. **Draft**: Story created and documented
2. **Ready**: Branch setup completed, ready for development
3. **In Progress**: Development actively happening
4. **Review**: PR created, code review in progress
5. **Done**: PR merged, story completed

### Automated Workflows
The CI/CD pipeline (Story 1.2) will automate:
- Linting and testing on every PR
- Coverage reporting and threshold enforcement
- Automated builds for iOS
- Branch protection rules
- Merge conflict detection

## Legacy Git Workflow (Reference)
The original workflow below is maintained for reference but should be superseded by the Standardized Story Development Workflow above.

### Original GitHub Projects Integration
1. **Issue Creation**: Create GitHub issue with proper labels and assign to project
2. **Branch Creation**: `git checkout -b feature/issue-123-description`
3. **Development**: Make changes with TDD approach
4. **Testing**: Run tests locally before commit (including device compatibility tests)
5. **PR Creation**: GitHub PR auto-links to issue and updates project status
6. **Code Review**: Required approval before merge
7. **Merge**: Squash merge to develop, issue auto-closes and moves in project
8. **Deploy**: Automated deployment on merge to main

## Development Environment Setup

### iOS Development
```bash