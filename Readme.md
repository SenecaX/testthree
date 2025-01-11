Here’s the updated **README.md** to reflect the final workflow and scripts:

---

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
   - Log in to GitHub CLI before running the scripts:
     ```bash
     gh auth login
     ```

### **Run the Main Script**
1. Make the scripts executable:
   ```bash
   chmod +x main_init.sh init_mvp.sh init_version_control.sh
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
   - Creates a remote repository on GitHub using `gh`.
   - Links the local repository to the remote `origin`.

3. **Branch Conventions**:
   - Pushes the initial commit to `main`.
   - Creates and pushes `dev` and `staging` branches to GitHub.

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
1. **GitHub CLI Not Authenticated**:
   - Run `gh auth login` to resolve.

2. **GitHub Repository Name Conflict**:
   - Use a different project name if a repository with the same name already exists.

3. **Git Not Installed**:
   - Ensure Git is installed and accessible via your system's PATH.

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
- Initializes a Git repository in the project folder.
- Creates a `.gitignore` file with rules for Node.js projects.
- Creates a GitHub repository using `gh` and links the local repository to it.
- Pushes `main`, `dev`, and `staging` branches to GitHub.

---

## **Next Steps**
- Start building your MVP in `front/` and `back/`.
- Extend the scripts for additional features like CI/CD, deployment, or database setup.

``` 

---

### **Key Updates**
- **Explains all phases** clearly and concisely.
- Distinguishes between how each script (`main_init.sh`, `init_mvp.sh`, `init_version_control.sh`) operates.
- Keeps the focus on actionable steps for running the scripts.

Let me know if this aligns with what you need! 😊