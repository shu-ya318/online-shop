# Online Shop

A production-ready full-stack e-commerce application with complete user flow, RESTful API design, and containerized deployment using Docker and Traefik reverse proxy.

**Demo Account:**
- Email: `test@gmail.com`
- Password: `12345678`

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                         Traefik                             │
│              (Reverse Proxy + SSL/TLS)                      │
│                  Port 80/443                                │
└────────────┬─────────────────────────┬──────────────────────┘
             │                         │
    ┌────────▼────────┐       ┌────────▼────────┐
    │   Frontend      │       │    Backend      │
    │   (Vue 3 +      │       │  (Spring Boot + │
    │    Nginx)       │       │    Tomcat)      │
    │   Port 80       │       │   Port 8080     │
    └─────────────────┘       └────────┬────────┘
                                       │
                       ┌───────────────┴───────────────┐
                       │                               │
               ┌───────▼──────┐                ┌───────▼──────┐
               │   Database   │                │    Cache     │
               │  (MS SQL     │                │   (Redis)    │
               │   Server)    │                │              │
               │  Port 1433   │                │  Port 6379   │
               └──────────────┘                └──────────────┘
```

## Getting Start

### Prerequisites

1. **Server Requirements**

   - Linux server (Ubuntu 20.04+, Debian 11+, or CentOS 7+ recommended)
   - **Minimum**: 2 CPU cores, 4GB RAM, 30GB disk space
   - **Recommended**: 2 CPU cores, 8GB RAM, 50GB SSD

2. **Software Requirements**

   - Docker Engine: 28.5.0
   - Docker Compose: v2.40.0

      **Note**: This project is tested with the versions above. Other versions may work but compatibility is not guaranteed.

3. **Domain & DNS**

   - A registered domain name
   - DNS A record pointing to your server's public IP

### Production Deployment

1. **Server Setup**

   ```bash
   sudo apt update && sudo apt upgrade -y

   curl -fsSL https://get.docker.com -o get-docker.sh
   sudo sh get-docker.sh

   sudo apt install docker-compose-plugin

   docker --version
   docker compose version
   ```

2. **Clone the Repository**

   ```bash
   git clone https://github.com/shu-ya318/online-shop.git
   cd online-shop
   ```

3. **Configure Environment Variables**

   Create a `.env` file in the project root. This file is ignored by Git and contains sensitive credentials for your services.

   > **Note**: `docker-compose` automatically loads the `.env` file from the root directory.

   ```.env
   # Database Configuration
   ACCEPT_EULA=Y
   SA_PASSWORD=YourStrongPassword
   MSSQL_PID=Developer

   # Redis Configuration
   REDIS_PASSWORD=YourStrongPassword
   ```

4. **Update Domain and Frontend API Endpoint**

   #### a. Domain in `docker-compose.yml`

   Edit `docker-compose.yml` and replace `shuyahsieh.xyz` with your actual domain. Also, update the email for Let's Encrypt SSL certificate generation.

   > **Note**: You must replace `shuyahsieh.xyz` and the associated email address with your own information for the reverse proxy and SSL to work correctly.

   ```yaml
   # In "frontend" service labels:
   - "traefik.http.routers.frontend.rule=Host(`shuyahsieh.xyz`)"

   # In "backend" service labels:
   - "traefik.http.routers.backend.rule=Host(`shuyahsieh.xyz`) && PathPrefix(`/api`)"

   # In "traefik" service command:
   - "--certificatesresolvers.letsencrypt.acme.email=shuyahsieh318@gmail.com"
   ```

   #### b. Frontend API Endpoint

   Before building the images, create a file named `.env.production` inside the `online-shop-frontend/` directory. This file configures the frontend to connect to the production API endpoint via the reverse proxy.

   > **Note**: The domain here must match the one used in `docker-compose.yml`.

   ```.env
   # online-shop-frontend/.env.production
   VITE_API_BASE_URL=https://shuyahsieh.xyz/api
   ```

5.  **Build and Deploy**

      ```bash
      docker compose build

      docker compose up -d
      ```

6.  **Verify Deployment**

      (1).  **Check Service Health**
         ```bash
         # All services should show "healthy" status
         docker compose ps
         ```

      (2).  **Access the Application**
         - Frontend: `https://shuyahsieh.xyz`
         - Backend API: `https://shuyahsieh.xyz/api/`

      > **Note**: Replace `shuyahsieh.xyz` with your domain.

      (3).  **Verify SSL Certificate**
         - Open your browser and navigate to your domain.
         - Check for the padlock icon indicating that HTTPS is active and the certificate is issued by Let's Encrypt.

7.  **Database Initialization**

      The database is initialized automatically on the first startup.In this project, the `db-init` directory is mounted to this location, ensuring your tables and initial data are set up without manual intervention.

## Additional Documentation

- **[Frontend README](./online-shop-frontend/README.md)**: Detailed guide for frontend development, including local setup, features showcase, and project structure.

- **[Backend README](./online-shop-backend/README.md)**: Detailed guide for backend development, including local setup, database schema, and API configuration.

## Contact

- **Email**: shuyaHsieh318@gmail.com
- **Cake**: https://www.cake.me/me/shuyahsieh
- **Linkedin**: https://www.linkedin.com/in/%E6%B7%91%E9%9B%85-%E8%AC%9D-9906772b1/
