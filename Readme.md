### **Updated README.md**

```markdown
# MVP Initialization Scripts

Automate the setup of a lightweight MVP environment with frontend, backend, and version control configured. This repository provides modular scripts to streamline your development workflow.

---

## **Usage**

### **Prerequisites**
1. **Tools**:
   - [Node.js](https://nodejs.org/) (with Yarn: `npm install -g yarn`)
   - [Git](https://git-scm.com/)
   - [GitHub CLI (`gh`)](https://cli.github.com/)

2. **Authentication**:
   - The script will automatically log you into GitHub CLI if you are not already authenticated. 
   - To verify or manually log in, use:
     ```bash
     gh auth login
     ```

### **Run the Main Script**
1. Make the scripts executable:
   ```bash
   chmod +x main_init.sh init_mvp.sh init_version_control.sh init_dev_env.sh init_deployment.sh
   ```

2. Run the main script:
   ```bash
   ./main_init.sh <project-name>
   ```
   Replace `<project-name>` with your desired project name (e.g., `my-mvp`).

---

## **What Happens**

### **Phase 1: Project Setup (`init_mvp.sh`)**
1. **Frontend (`front/`)**:
   - Initializes a React + TypeScript project using Vite.
   - Sets up the folder structure: `src/components/`, `src/pages/`, `src/features/`.
   - Creates a boilerplate `App.tsx` file.

2. **Backend (`back/`)**:
   - Initializes a Node.js + Express project with TypeScript.
   - Sets up the folder structure: `src/controllers/`, `src/models/`, `src/services/`.
   - Creates a boilerplate `app.ts` file.

3. **Environment Variables**:
   - Creates `.env` and `.env.example` with placeholders for `PORT` and `DB_URI`.

---

### **Phase 2: Version Control Setup (`init_version_control.sh`)**
1. **Git Initialization**:
   - Initializes a Git repository in the project folder.
   - Creates a `.gitignore` file with Node.js-specific rules.

2. **GitHub Integration**:
   - Checks for GitHub authentication.
     - If not authenticated, opens the browser to log you into GitHub CLI (`gh auth login`).
   - Creates a remote repository on GitHub using `gh`.
   - Links the local repository to the remote `origin`.

3. **Branch Conventions**:
   - Pushes the initial commit to `main`.
   - Creates and pushes `dev` and `staging` branches to GitHub.

---

---

### **Phase 3: Development Environment Standardization (`init_dev_env.sh`)**

#### **Objective**
Enhance the developer experience and enforce consistent coding standards across the frontend and backend.

#### **What Happens**
1. **Frontend Tools**:
   - **ESLint**: Ensures consistent code quality.
   - **Prettier**: Formats code for readability.
   - **Lint-Staged**: Runs linting and formatting on staged files during commits.
   - **Husky**: Adds a `pre-commit` hook to automate lint-staged execution.

2. **Backend Tools**:
   - **Nodemon**: Enables live server reloading during development.
   - **Jest**: Sets up a basic testing framework with TypeScript support.

3. **Shared Tools**:
   - **Husky**: Configures pre-commit hooks to enforce linting and formatting across the project.

#### **How It Works**
- The script (`init_dev_env.sh`) automates the installation and configuration of the above tools:
  1. Frontend setup includes ESLint, Prettier, and lint-staged.
  2. Backend setup includes Nodemon and Jest with TypeScript configuration.
  3. Husky is set up for pre-commit hooks in both frontend and backend.

#### **Key Benefits**
- **Consistency**: Enforces uniform code style across the entire codebase.
- **Productivity**: Automates tasks like linting, formatting, and live reloading.
- **Quality**: Ensures code quality through pre-commit checks.

---

## **Updated Workflow**

The main script (`main_init.sh`) now orchestrates three phases:

1. **Phase 1: Project Setup**:
   - Initializes frontend and backend projects with standard folder structures and boilerplate code.

2. **Phase 2: Version Control Setup**:
   - Sets up Git and GitHub repositories with proper branch conventions.

3. **Phase 3: Development Environment Standardization**:
   - Adds tools like ESLint, Prettier, Nodemon, Jest, Husky, and lint-staged for consistent code quality and an enhanced developer experience.

---

## **Folder Structure**

After running the scripts, your project will have the following structure:

```
<project-name>/
├── front/
│   └── src/
│       ├── components/
│       ├── pages/
│       ├── features/
│       └── App.tsx
├── back/
│   └── src/
│       ├── controllers/
│       ├── models/
│       ├── services/
│       └── app.ts
├── .env
├── .env.example
├── .gitignore
```

---

## **Common Issues**

1. **GitHub CLI Not Installed**:
   - Ensure `gh` is installed:
     ```bash
     brew install gh
     ```

2. **GitHub CLI Not Authenticated**:
   - The script automatically initiates login if you're not authenticated. However, you can manually log in using:
     ```bash
     gh auth login
     ```

3. **GitHub Repository Name Conflict**:
   - If a repository with the same name already exists on GitHub, use a different project name or manually handle the conflict.

4. **Git Not Installed**:
   - Ensure Git is installed and accessible in your system's PATH.

---

## **How the Scripts Work**

### **1. Main Script (`main_init.sh`)**
The main script orchestrates the entire setup process:
1. Executes `init_mvp.sh` for frontend and backend project setup.
2. Executes `init_version_control.sh` for Git and GitHub integration.

---

### **2. Frontend and Backend Setup (`init_mvp.sh`)**
- Creates the frontend and backend folders with standard folder structures.
- Initializes frontend with Vite and backend with Express.
- Sets up boilerplate files (`App.tsx` for frontend, `app.ts` for backend).
- Creates `.env` and `.env.example` for environment variables.

---

### **3. Version Control Setup (`init_version_control.sh`)**
- **Git Initialization**:
  - Sets up a local Git repository and creates a `.gitignore` file with rules for Node.js projects.

- **GitHub Authentication**:
  - Checks if you're authenticated with GitHub CLI.
  - If not, it automatically initiates the `gh auth login` process, opening a browser for you to authenticate.

- **Repository Creation**:
  - Creates a GitHub repository with the provided project name.
  - Links the local repository to the remote `origin`.

- **Branch Conventions**:
  - Pushes the initial commit to `main`.
  - Creates and pushes `dev` and `staging` branches to GitHub.

---

## **Next Steps**
- Start building your MVP in the `front/` and `back/` directories.
- Extend the scripts for additional features like CI/CD, deployment, or database setup.

---