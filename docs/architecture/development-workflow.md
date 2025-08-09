# Development Workflow

## Branch Strategy
```
main                 # Production-ready code
├── develop         # Integration branch
├── feature/*       # Feature branches (Linear issue ID)
├── bugfix/*        # Bug fix branches
└── release/*       # Release preparation branches
```

## Git Workflow with GitHub Projects Integration
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