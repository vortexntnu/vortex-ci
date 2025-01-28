module.exports = {
    branches: [process.env.DEFAULT_BRANCH || "main"], // Fallback to "main" if DEFAULT_BRANCH is not set
    plugins: [
      "@semantic-release/commit-analyzer",
      "@semantic-release/release-notes-generator",
      "@semantic-release/github"
    ]
};
