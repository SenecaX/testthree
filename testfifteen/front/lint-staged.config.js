module.exports = {
  "**/*.{js,ts,tsx,json,css,scss,md}": [
    "prettier --write",
    "eslint --fix"
  ]
};
