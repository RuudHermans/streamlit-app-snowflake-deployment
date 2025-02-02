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

### **Step 1: Clone the Repository**
```bash
git clone https://github.com/your-username/your-repo.git
cd your-repo/app
```

### **Step 2: Install Dependencies**
Ensure you have Python 3.9+ installed.
```bash
pip install -r requirements.txt
```

### **Step 3: Run the Streamlit App Locally**
```bash
streamlit run app.py
```

### **Mocking Snowflake Data for Local Development**
If you want to test the app with data that would normally be stored in Snowflake:

1. **Create Mock Data:**
   - Add a mock data file named `orders.csv` in the `mock_data/` folder with the following columns:
     ```csv
     order_number,order_name
     001,Order Alpha
     002,Order Beta
     003,Order Gamma
     ...
     015,Order Omicron
     ```

2. **Switch to Mock Mode:**
   - Use an environment variable to toggle between Snowflake and mock data:
     ```bash
     export USE_MOCK_DATA=true
     streamlit run app.py
     ```

3. **Data Handling in Code:**
   - Implemented in `app.py` to automatically detect mock mode and load `orders.csv`.

### **Do We Need Anything Else?**
- ✅ **All dependencies** are listed in `requirements.txt`.
- ✅ Mock data allows testing without a live Snowflake connection.

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
     export USE_MOCK_DATA=true
     streamlit run app.py
     ```

3. **Verify with Real Snowflake Data:**
   - Disable mock mode to connect to Snowflake:
     ```bash
     unset USE_MOCK_DATA
     streamlit run app.py
     ```

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
     streamlit run app.py
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
