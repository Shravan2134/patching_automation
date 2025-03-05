# **Automated Non-Critical Patch Management Using Ansible**

## ** Project Overview**
This project automates **non-critical patch updates** across multiple operating systems using **Ansible roles**. Each OS distribution has a dedicated role for modularity and maintainability. The playbook executes tasks such as:
- **Fetching available non-critical patches**
- **Applying updates**
- **Logging results**
- **Generating reports**
- **Emailing pre- and post-patch reports**

## **📁 Project Structure**
```
patching_automation/
│-- inventory.yml         
│-- site.yml             
│-- roles/
│   ├── ubuntu_debian/    
│   │   ├── tasks/
│   │   │   ├── main.yml
│   │   ├── templates/
│   │   │   ├── pre_patch_email.j2
│   │   │   ├── post_patch_email.j2
│   ├── centos_rhel/     
│   │   ├── tasks/
│   │   │   ├── main.yml
│   │   ├── templates/
│   │   │   ├── pre_patch_email.j2
│   │   │   ├── post_patch_email.j2
│   ├── suse/             
│   │   ├── tasks/
│   │   │   ├── main.yml
│   │   ├── templates/
│   │   │   ├── pre_patch_email.j2
│   │   │   ├── post_patch_email.j2
│-- group_vars/
│   ├── all.yml          
│-- README.md            
```

## **🔧 Setup & Prerequisites**
### **🔹 Requirements**
- Ansible installed on the controller machine (`pip install ansible`)
- SSH access to managed hosts
- SMTP credentials for email notifications

### **🔹 Configuration**
Update the `group_vars/all.yml` file with the necessary variables:
```yaml
email_username: "************"
email_password: "***********"
recipient_email: "***********"
patch_dir: "/home/adminuser/non_critical_patching"
pre_patch_file: "pre_patching_list.txt"
post_patch_file: "post_patching_report.txt"
```

## **🚀 Workflow**
1. **Identify OS & Apply Corresponding Role**
   - The `site.yml` playbook detects the OS and runs the appropriate role (Ubuntu, CentOS, or SUSE).

2. **Pre-Patching Phase**
   - Fetches a list of **non-critical updates**.
   - Saves the list in a file (`pre_patching_list.txt`).
   - Sends an **email report** with the list of pending patches.

3. **Patching Phase**
   - Iterates through the **list of patches** and installs them.
   - Logs the success or failure of each patch.

4. **Post-Patching Phase**
   - Generates a **patching report (`post_patching_report.txt`)**.
   - Fetches the report back to the **Ansible controller**.
   - Sends an **email notification** with the patching summary.

## **🎯 Running the Playbook**
To execute the patching automation, run:
```bash
ansible-playbook -i inventory.yml site.yml
```

## **📬 Email Reporting (Jinja Templates)**
Two email templates are used:
- **Pre-Patch Email (`pre_patch_email.j2`)**
  ```
  Subject: Pre-Patching Report for {{ inventory_hostname }}

  The following non-critical updates are available:
  {% for package in pre_patch_list %}
  - {{ package }}
  {% endfor %}
  ```

- **Post-Patch Email (`post_patch_email.j2`)**
  ```
  Subject: Post-Patching Report for {{ inventory_hostname }}

  Patch installation results:
  {% for result in patch_results.results %}
  Package: {{ result.item }} - Status: {% if result.rc == 0 %} SUCCESS {% else %} FAILED {% endif %}
  {% endfor %}
  ```

## **🔍 Debugging and logs:
use the command:

  ansible-playbook -i inventory.yml site.yml -vvvv


