# 🚀 Snowflake Streamlit Deployment Setup

This repository contains a simple Streamlit application deployed on **Snowflake** using **GitHub Actions**. It supports multiple environments: **development**, **acceptance**, and **production**.

---

## 📁 Project Directory Structure

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

---

## 📄 Purpose of Each File/Directory

- **`.github/workflows/deploy.yml`**: Defines the CI/CD pipeline for deploying the application via GitHub Actions.
- **`.devcontainer/`**:
  - `devcontainer.json`: Configuration file for VS Code Dev Containers.
  - `Dockerfile`: Sets up the development environment inside the container.
- **`app/`**:
  - `app.py`: The core Streamlit application code.
  - `requirements.txt`: Lists all Python dependencies required to run the app.
  - `snowflake_app.yml`: Configuration file for deploying the app to Snowflake.
- **`mock_data/`**:
  - `orders.csv`: Contains sample data for local development without connecting to Snowflake.
- **`snowflake/setup.sql`**: SQL script to create necessary roles, users, warehouses, and tables in Snowflake.
- **`run_mock.sh`**: Bash script to run the Streamlit app using mock data locally.
- **`README.md`**: Documentation explaining how to set up, deploy, and develop the application.
- **`.gitignore`**: Specifies files and directories that should be ignored by Git.

---

## 📦 Setup Instructions

### 🔑 Prerequisites

- Snowflake Account
- GitHub Repository
- GitHub Actions Enabled

### ⚙️ Snowflake Configuration

1. **Run the Snowflake setup script (`snowflake/setup.sql`):**  
   This script will automatically:
   - Create the necessary **roles** and **service users**.
   - Assign required **permissions**.
   - Set up **dedicated warehouses** for each environment:
     - `dev_wh` for Development
     - `acc_wh` for Acceptance
     - `prod_wh` for Production
   - Create **databases**, **schemas**, and **tables** for each environment.

2. **Verify the Setup:**  
   After running the script, you can verify the objects with:
   ```sql
   SHOW ROLES;
   SHOW USERS;
   SHOW WAREHOUSES;
   SHOW DATABASES;
   ```

### 🚀 Step 2: GitHub Environment Configuration

1. **Create GitHub Environments:**
   - Go to **Settings → Environments → New Environment**.
   - Create environments for:
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
   | `SNOWFLAKE_WAREHOUSE`         | Warehouse for the environment user     |

4. **Protect Environments:**
   - Enable **manual approval** for `acceptance` and `production` deployments.

---

## 📊 Deployment Environments

- **Development:** Continuous deployment after merging to `main`.
- **Acceptance & Production:** Manual approval required.

---

## 🗂️ Snowflake Warehouse Configuration

### ❓ **Why We Didn't Specify the Warehouse in `snowflake_app.yml`**

Instead of defining the warehouse in the `snowflake_app.yml` file, we chose to:

1. **Assign a Default Warehouse to Each Service Account:**

   - `dev_wh` for `deploy_dev_user`
   - `acc_wh` for `deploy_acc_user`
   - `prod_wh` for `deploy_prod_user`

2. **Benefits of This Approach:**

   - **Environment Isolation:** Ensures that each environment uses its own warehouse without relying on separate configuration files.
   - **Simplified CI/CD:** No need to manage multiple deployment YAML files for different environments.
   - **Security:** Reduces the risk of accidentally deploying to the wrong warehouse.

3. **Fallback Mechanism:**

   - Even if the `snowflake_app.yml` is missing or misconfigured, Snowflake will still use the correct warehouse based on the service user's default settings.

4. **Flexibility for Future Changes:**

   - If needed, warehouses can be updated directly at the user level without modifying the deployment configuration.

---

## 🛠️ Local Development Setup

### **Option 1: Using VS Code Dev Containers (Recommended)**

1. **Install Prerequisites:**

   - Docker
   - Visual Studio Code
   - Remote - Containers Extension

2. **Clone the Repository:**

   ```bash
   git clone https://github.com/your-username/your-repo.git
   cd your-repo
   ```

3. **Open in VS Code and Reopen in Container:**

   - Open the project in VS Code.
   - Press `F1` → **Remote-Containers: Reopen in Container**.

4. **Run the App with Mock Data:**

   ```bash
   ./run_mock.sh
   ```

### **Option 2: Running Locally Without Containers**

1. **Install Python Dependencies:**

   ```bash
   pip install -r app/requirements.txt
   ```

2. **Run the App with Mock Data:**

   ```bash
   ./run_mock.sh
   ```

---

## 🧪 Mocking Snowflake Data for Local Development

### 🚀 **Tutorial: Adding a New `Customers` Table with Mock Data**

1. **Create the Table in Snowflake:**

   ```sql
   CREATE OR REPLACE TABLE dev_database.dev_schema.customers (
       customer_id STRING,
       customer_name STRING,
       email STRING
   );
   ```

2. **Create Mock Data Locally:**

   - Add `mock_data/customers.csv`:
     ```csv
     customer_id,customer_name,email
     C001,John Doe,john@example.com
     C002,Jane Smith,jane@example.com
     C003,Bob Johnson,bob@example.com
     ```

3. **Update `app.py` to Load Mock Data:**

   ```python
   if USE_MOCK_DATA:
       customers_data = pd.read_csv("mock_data/customers.csv")
   else:
       session = st.connection("snowflake").session()
       customers_data = session.table("customers").to_pandas()
   ```

4. **Run the App:**

   ```bash
   ./run_mock.sh
   ```

---

## 🚀 Deployment Process

1. Push changes to GitHub.
2. GitHub Actions deploys to Development automatically.
3. Manual approvals required for Acceptance and Production deployments.

---

## 🚀 Developing a New Feature Using Feature Branches

Follow these steps to develop a new feature efficiently:

### 1️⃣ Create a New Feature Branch

Start by creating a new branch based on the `main` branch:

```bash
git checkout -b feature/new-feature-name
```

### 2️⃣ Add Mock Data (if Needed)

If your new feature relies on additional data:

- Place mock data files in the `mock_data/` directory.
- Ensure the data structure matches what the app expects.

### 3️⃣ Develop Locally

Run the app with mock data to test changes in isolation:

```bash
./run_mock.sh
```

*(Note: `USE_MOCK_DATA=true` is set by default in `run_mock.sh`, so no manual switching is needed.)*

#### 🔍 Test with Real Snowflake Data (Optional)

If you want to validate your feature with real Snowflake data:

- When the app is deployed to Snowflake, it will automatically connect to real Snowflake data because `USE_MOCK_DATA` is not set, and it defaults to `false`.
- *(No manual switching required for deployments.)*

### 4️⃣ Commit and Push Changes

After completing development and local testing:

```bash
git add .
git commit -m "Add new feature: [feature description]"
git push origin feature/new-feature-name
```

### 5️⃣ Create a Pull Request (PR)

- Go to your GitHub repository.
- Click **"Compare & Pull Request"**.
- Provide a clear description of your feature and related changes.

### 6️⃣ Code Review and Merge

- Submit the PR for review.
- Address feedback if needed.
- Once approved, merge the PR into the `main` branch.

### 7️⃣ Deploy to Environments

- GitHub Actions will automatically deploy to the **development** environment.
- For **acceptance** and **production**, trigger manual approvals in GitHub Actions.

---

This workflow ensures safe, tested deployments across environments while maintaining code quality through peer reviews. 🚀

---

## 🔄 Special Work Instructions: Updating the Streamlit Version

1. **Update `requirements.txt`:**

   ```bash
   streamlit==<new_version>
   ```

2. **Test Locally:**

   ```bash
   pip install -r app/requirements.txt
   ./run_mock.sh
   ```

3. **Update `snowflake_app.yml` for Deployment:**

   ```yaml
   environment:
     streamlit_version: "<new_version>"
   ```

4. **Commit & Push Changes:**

   ```bash
   git add .
   git commit -m "Update Streamlit version"
   git push origin main
   ```

5. **Deploy with Manual Approvals for Acceptance/Production.**
