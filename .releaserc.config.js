module.exports = {
    branches: [process.env.DEFAULT_BRANCH],
    plugins: [
      "@semantic-release/commit-analyzer",
      "@semantic-release/release-notes-generator",
      "@semantic-release/github"
    ]
};
