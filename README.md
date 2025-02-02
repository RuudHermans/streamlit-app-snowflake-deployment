# 🚀 Snowflake Streamlit Deployment Setup

This repository contains a simple Streamlit application deployed on **Snowflake** using **GitHub Actions**. It supports multiple environments: **development**, **acceptance**, and **production**.

---

## 📁 Project Directory Structure

Here's an overview of the project directory structure along with the purpose of each file:

```
/ (root of your repository)
├── .github/
│   └── workflows/
│       └── deploy.yml           # GitHub Actions Workflow for CI/CD
├── .devcontainer/
│   ├── devcontainer.json        # VS Code Dev Container Configuration
│   └── Dockerfile               # Dockerfile for Dev Container Setup
├── app/
│   ├── app.py                   # Main Streamlit Application
│   ├── requirements.txt         # Python Dependencies
│   └── snowflake_app.yml        # Snowflake App Configuration
├── mock_data/
│   └── orders.csv               # Mock Data for Orders Table
├── snowflake/
│   └── setup.sql                # Snowflake Roles & Permissions Setup Script
├── run_mock.sh                  # Script to Run the App with Mock Data
├── README.md                    # Project Documentation
└── .gitignore                   # Specifies Files to Ignore in Git
```

### **Purpose of Each File/Directory:**

- **`.github/workflows/deploy.yml`** - Automates deployments using GitHub Actions.
- **`.devcontainer/`** - Contains configuration for consistent development environments using VS Code Dev Containers.
  - `devcontainer.json` - Defines extensions and settings for the dev container.
  - `Dockerfile` - Specifies the environment to build the container.
- **`app/`** - Core application folder.
  - `app.py` - The main Streamlit app where UI and logic are implemented.
  - `requirements.txt` - Lists required Python libraries.
  - `snowflake_app.yml` - Configures the Snowflake deployment settings.
- **`mock_data/`** - Holds mock data for local development.
  - `orders.csv` - Sample dataset to simulate Snowflake data.
- **`snowflake/setup.sql`** - SQL script to create roles, users, and tables in Snowflake.
- **`run_mock.sh`** - Bash script to start the app with mock data for testing.
- **`README.md`** - This documentation file explaining project setup, usage, and contributions.
- **`.gitignore`** - Defines files and directories to be excluded from version control.

---

## 📦 1. Setup Instructions

### **🔐 Prerequisites:**
- A **Snowflake account** with admin privileges.
- A **GitHub repository** with access to GitHub Actions.

### **Step 1: Snowflake Setup**
1. **Run the Snowflake Permission Script:**  
   Execute `snowflake/setup.sql` in your Snowflake account:
   ```sql
   -- Connect as SECURITYADMIN
   USE ROLE SECURITYADMIN;
   -- Run the script to create roles, service users, and the orders table
   ```

2. **Create Service Accounts & Roles:**
   - `deploy_dev_user` (for development)
   - `deploy_acc_user` (for acceptance)
   - `deploy_prod_user` (for production)

### **Step 2: GitHub Environment Configuration**
1. **Create GitHub Environments:**
   Go to **Settings → Environments → New Environment**.

   Create environments for:
   - `development`
   - `acceptance`
   - `production`

2. **Add Environment Secrets:**
   In each environment, add the following secrets:

   | Secret Name                   | Value                                  |
   |-------------------------------|----------------------------------------|
   | `SNOWFLAKE_ACCOUNT`           | Your Snowflake account name            |
   | `SNOWFLAKE_DATABASE`          | Database name (e.g., `dev_database`)   |
   | `SNOWFLAKE_SCHEMA`            | Schema name (e.g., `dev_schema`)       |
   | `SNOWFLAKE_ROLE`              | Role for deployment (e.g., `SYSADMIN`) |
   | `SNOWFLAKE_USER`              | Username for the environment           |
   | `SNOWFLAKE_PASSWORD`          | Password for the environment user      |

3. **Protect Environments:**
   - Enable **manual approval** for `acceptance` and `production` environments.

4. **Verify GitHub Actions Workflow:**
   The deployment workflow is stored in:
   ```bash
   .github/workflows/deploy.yml
   ```

---

## 🛠️ 2. Local Development Setup

### **Option 1: Using VS Code Dev Containers** *(Recommended)*

1. **Install Prerequisites:**
   - [Docker](https://www.docker.com/products/docker-desktop)
   - [Visual Studio Code](https://code.visualstudio.com/)
   - [Remote - Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

2. **Open the Project in VS Code:**
   ```bash
   git clone https://github.com/your-username/your-repo.git
   cd your-repo
   code .
   ```

3. **Reopen in Container:**
   - In VS Code, press `F1` → **Remote-Containers: Reopen in Container**.
   - This will build the container defined in `.devcontainer/Dockerfile`.

4. **Run the App with Mock Data:**
   ```bash
   ./run_mock.sh
   ```

### **Option 2: Running Locally Without Containers**

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/your-username/your-repo.git
   cd your-repo/app
   ```

2. **Install Dependencies:**
   Ensure you have Python 3.9+ installed.
   ```bash
   pip install -r requirements.txt
   ```

3. **Run the Streamlit App Locally with Mock Data:**
   ```bash
   ./run_mock.sh
   ```

---

## 🚀 Deployment Flow

1. **Merge PR into `main`.**
2. **Auto-deploy to `development`.**
3. **Manual approval required** for `acceptance` and `production` deployments.

---

## 🔄 Special Work Instructions: Updating the Streamlit Version

When updating the Streamlit version, follow these steps to ensure compatibility:

1. **Update Locally First:**
   - Open `requirements.txt` and change the Streamlit version to the desired version:
     ```bash
     streamlit==<new_version>
     ```

2. **Test Locally:**
   - Reinstall dependencies:
     ```bash
     pip install -r requirements.txt
     ```
   - Run the app to verify functionality:
     ```bash
     ./run_mock.sh
     ```

3. **Update `snowflake_app.yml`:**
   - After confirming the app works locally, update the Streamlit version in `snowflake_app.yml`:
     ```yaml
     environment:
       streamlit_version: "<new_version>"
     ```

4. **Commit & Deploy:**
   - Commit changes and push:
     ```bash
     git add .
     git commit -m "Update Streamlit to <new_version>"
     git push origin main
     ```
   - This will trigger the GitHub Actions workflow.
   - **Manually approve** deployments to `acceptance` and `production` environments as needed.

5. **Monitor Deployment:**
   - Verify the app functions correctly in all environments.

---

## 💬 Need Help?
For issues, create a [GitHub Issue](https://github.com/your-username/your-repo/issues).

Happy coding! 🚀
