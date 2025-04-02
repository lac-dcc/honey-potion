# Contributing to Honey Potion

Thank you for considering contributing to Honey Potion! We welcome all contributions, whether it's reporting bugs, improving documentation, adding features, or fixing issues.

## Table of Contents

- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Reporting Issues](#reporting-issues)
- [Submitting Code Changes](#submitting-code-changes)
- [Code Style](#code-style)
- [Branching & Commit Messages](#branching--commit-messages)
- [Testing](#testing)
- [Community & Support](#community--support)
- [License](#license)

## Getting Started

1. **Fork the repository** on GitHub.
2. **Clone your fork** to your local machine:
   ```sh
   git clone https://github.com/your-username/honey-potion.git
   ```
3. **Navigate to the project directory:**
   ```sh
   cd honey-potion
   ```
4. **Install dependencies** (if applicable):
   ```sh
   mix deps.get
   ```
5. **Create a new branch** for your work:
   ```sh
   git checkout -b feature-or-bugfix-name
   ```

## How to Contribute

### Reporting Issues

If you find a bug or have a feature request, please create an issue on GitHub by following these steps:

- Search the [existing issues](https://github.com/lac-dcc/honey-potion/issues) to avoid duplicates.
- Open a new issue with a clear title and description.
- Provide steps to reproduce (if reporting a bug).
- Suggest a possible fix or enhancement (if applicable).

### Submitting Code Changes

1. **Ensure your branch is up to date** with the latest `main` branch:
   ```sh
   git fetch origin
   git checkout main
   git pull origin main
   ```
2. **Make your changes** and commit them.
3. **Write meaningful commit messages** (see [Branching & Commit Messages](#branching--commit-messages)).
4. **Push your branch** to your fork:
   ```sh
   git push origin feature-or-bugfix-name
   ```
5. **Open a Pull Request (PR)**:
   - Go to the original repository on GitHub.
   - Click on "New Pull Request".
   - Select your branch and describe the changes.
   - Link any related issues and add reviewers (if applicable).

## Code Style

- Follow the coding style used in the project.
- Maintain consistency in formatting (e.g., indentation, spacing, naming conventions).
- Use meaningful variable and function names.
- Avoid large, unrelated changes in a single PR.

## Branching & Commit Messages

**Branch Naming:**
- Use a descriptive name, such as `feature/add-login-support` or `fix/navbar-alignment`.

**Commit Messages:**
- Use the following format:
  ```
  [type]: Brief summary of the change
  ```
  Examples:
  ```
  feat: Add login functionality
  fix: Resolve navbar alignment issue
  docs: Update installation guide
  ```

## Testing

- Run all tests before submitting a PR:
  ```sh
  mix test
  ```
- If applicable, add tests for new features or bug fixes.
- Ensure tests pass before requesting a review.

## Community & Support

- Join the discussion on [discussions page](https://github.com/lac-dcc/honey-potion/discussions) (if applicable).
- Follow the project's [Code of Conduct](CODE_OF_CONDUCT.md).
- Ask questions by opening a discussion or issue on GitHub.

## License

By contributing, you agree that your contributions will be licensed under the [Project License](LICENSE).

---

Thank you for your contributions! 🎉

