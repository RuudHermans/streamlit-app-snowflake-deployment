# 🚀 Snowflake Streamlit Deployment Setup

This repository contains a simple Streamlit application deployed on **Snowflake** using **GitHub Actions**. It supports multiple environments: **development**, **acceptance**, and **production**.

---

## 📦 1. Setup Instructions

### **🔐 Prerequisites:**
- A **Snowflake account** with admin privileges.
- A **GitHub repository** with access to GitHub Actions.

### **Step 1: Snowflake Setup**
1. **Run the Snowflake Permission Script:**  
   Execute `snowflake_permission_setup.sql` in your Snowflake account:
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

### **Mocking Snowflake Data for Local Development**

When developing new features locally, it's often necessary to mock Snowflake data, especially when adding new tables. This section guides you on how to create mock data that mirrors Snowflake tables for seamless local development.

1. **Adding New Tables to Snowflake:**
   - First, define your new table in Snowflake. For example:
     ```sql
     CREATE OR REPLACE TABLE dev_database.dev_schema.customers (
         customer_id STRING,
         customer_name STRING,
         email STRING
     );
     ```

2. **Create Corresponding Mock Data:**
   - In the `mock_data/` folder, create a new CSV file matching the table structure. For the `customers` table:
     ```csv
     customer_id,customer_name,email
     C001,John Doe,john@example.com
     C002,Jane Smith,jane@example.com
     C003,Bob Johnson,bob@example.com
     ```

3. **Organize Mock Data:**
   - Place the mock data file inside the `mock_data/` directory. Example structure:
     ```
     mock_data/
     ├── orders.csv
     └── customers.csv
     ```

4. **Update the App to Load Mock Data:**
   - In `app.py`, modify the code to load the new mock data when `USE_MOCK_DATA=true`:
     ```python
     if USE_MOCK_DATA:
         orders_data = pd.read_csv("mock_data/orders.csv")
         customers_data = pd.read_csv("mock_data/customers.csv")
     else:
         session = st.connection("snowflake").session()
         orders_data = session.table("orders").to_pandas()
         customers_data = session.table("customers").to_pandas()
     ```

5. **Run the App with Mock Data (Single Command):**
   - Simply run:
     ```bash
     ./run_mock.sh
     ```
   - This script sets the environment variable `USE_MOCK_DATA=true` and starts the app.

### **Best Practices for Mock Data:**
- **Consistency:** Ensure mock data columns match exactly with the Snowflake table schema.
- **Sample Variety:** Include diverse sample data to cover edge cases.
- **Sensitive Data:** Never use real customer or sensitive data in mock files.

### ✅ **Do We Need Anything Else?**
- ✅ Add new mock CSV files as needed.
- ✅ Keep mock data updated as Snowflake schemas evolve.
- ✅ Test thoroughly with both mock data locally and real data post-deployment.

---

## 🌱 3. Adding New Features with Feature Branches

1. **Create a New Feature Branch:**
   ```bash
   git checkout -b feature/new-awesome-feature
   ```

2. **Develop Your Feature:**
   - Modify files as needed.
   - Test the app locally using mock data:
     ```bash
     ./run_mock.sh
     ```

3. **Verify with Real Snowflake Data (via Deployment):**
   - **Push your branch to GitHub:**
     ```bash
     git push origin feature/new-awesome-feature
     ```
   - **Create a Pull Request (PR)** to merge the feature branch into `main`.
   - Once merged, the GitHub Actions workflow will automatically deploy the app to the **development** environment.
   - **Access the deployed app** through the Snowflake-hosted URL provided by the workflow.

4. **Commit Changes:**
   ```bash
   git add .
   git commit -m "Add new awesome feature"
   ```

5. **Push to GitHub:**
   ```bash
   git push origin feature/new-awesome-feature
   ```

6. **Create a Pull Request (PR):**
   - Go to GitHub.
   - Open a PR to merge `feature/new-awesome-feature` into `main`.

7. **Merge & Deploy:**
   - After code review, merge the PR.
   - The GitHub Actions workflow will **automatically deploy** the app to the **development** environment.
   - **Manual approval** is required to deploy to **acceptance** and **production**.

---

## 🚀 **Deployment Flow**

1. **Merge PR into `main`.**
2. **Auto-deploy to `development`.**
3. **Manual approval required** for `acceptance` and `production` deployments.

---

## 🔄 **Special Work Instructions: Updating the Streamlit Version**

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

## 💬 **Need Help?**
For issues, create a [GitHub Issue](https://github.com/your-username/your-repo/issues).

Happy coding! 🚀
