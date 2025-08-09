add_mcp:
	@claude mcp add filesystem -- npx -y @modelcontextprotocol/server-filesystem "/Users/linusmcmanamey/Development/surfseer/d_n_w"
	@claude mcp add github -e GITHUB_PERSONAL_ACCESS_TOKEN -- npx -y @modelcontextprotocol/server-github
	@claude mcp add XcodeBuildMCP -- npx -y xcodebuildmcp@latest


build:
	#@sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
	@cd /Users/linusmcmanamey/Development/surfseer/d_n_w/ios-app
	@xcodebuild -project d_n_w.xcodeproj -scheme d_n_w -destination 'platform=iOS Simulator,name=iPhone 15' build