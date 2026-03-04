## Terraform multi-tier application with docker

# 3 tier app

# App
simple flask app that connect to mysql DB.
- port 8888
- health script on apply

# Web
ngix basic web .
- port 8081

# DB
mysql database.
- port 3306

---

# Setup network

make sure you have a network for each workspace sa follow:
dev- network_dev
staging- network_staging
prod- network_prod

if not create the networks with this command-
```
docker network create <network_name>
```

# Setup the DB

inside the db container run setup.sql in terra\modules\database\setup.sql

# Workspaces

# Dev , Staging , Prod

Each workspace have different number of replicas as follow:
Dev- web_replicas = 1, app_replicas = 1, db_replicas = 1
Staging- web_replicas = 2, app_replicas = 2, db_replicas = 1
Prod- web_replicas = 3, app_replicas = 3, db_replicas = 1

- all workspaces can run simultaneously
- each workspace run on a different network and different ports

# Deploy a workspace 

Select workspace-
```
terraform workspace select <workspace_name>
```
Deploy workspace-
```
terraform init
terraform apply
```

---

# Ports
| Workspace | Dev | Staging | Prod |
| :--- | :---: | :---: | :--- |
| Web | 8081 | 8091-8092 | 8101-8103 |
| App | 8888 | 8898-8899 | 8908-8910 |
| DB | 3306 | 3316 | 3326 |

# Access to the websites

In your browser go to-
```
http://localhost:<Port>/
```


