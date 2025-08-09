# External APIs

## GitHub API
- **Purpose:** Project management, issue tracking, and development workflow synchronization
- **Documentation:** https://docs.github.com/en/rest and https://docs.github.com/en/graphql
- **Base URL(s):** https://api.github.com/graphql and https://api.github.com
- **Authentication:** GitHub Personal Access Token (stored in GitHub Secrets) and GitHub App for MCP
- **Rate Limits:** 5000 requests per hour for authenticated requests

**Key Endpoints Used:**
- `POST /repos/{owner}/{repo}/issues` - Create issues with labels and project assignment
- `PATCH /repos/{owner}/{repo}/issues/{issue_number}` - Update issue status
- `POST /repos/{owner}/{repo}/pulls` - Create pull requests
- `mutation updateProjectV2ItemFieldValue` - Update project board status
- `query repository` - Fetch issues and project status

**Integration Notes:** 
- GitHub MCP tools in Claude Code for interactive development
- GitHub Actions integration for automated status updates
- Project URL: https://github.com/users/linus-mcmanamey/projects/1/views/1
- Labels follow hierarchy: epic → story → task → subtask
- Component labels map to areas: comp-ios, comp-backend, comp-web, comp-infra
