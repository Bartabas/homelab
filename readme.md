# 🏠 My Homelab Setup

This repository contains the docker-compose.yml file and configuration instructions for my personal homelab. The goal of this setup is to run various self-hosted services on a local network, accessible via easy-to-remember `.local` domain names instead of IP addresses and port numbers.

This entire stack is managed by Docker and orchestrated with Docker Compose.

## 🔧 Core Components

The setup relies on two key services for network management:

- **AdGuard Home**: Acts as a network-wide DNS server. Its primary jobs are to block ads and trackers and, most importantly, to resolve our custom `.local` domains (e.g., `n8n.local`) to the homelab server's IP address.

- **Nginx Proxy Manager (NPM)**: Acts as a reverse proxy. It receives all web traffic and, based on the requested domain name, forwards it to the correct application container. This is what allows us to use standard web ports (80/443) for all services without exposing their individual ports.

## 📦 Services Deployed

| Service | Container Name | Purpose |
|---------|----------------|---------|
| AdGuard Home | `adguard-home` | DNS and Ad-Blocking |
| Nginx Proxy Manager | `nginx-proxy-manager` | Reverse Proxy |
| Portainer | `portainer` | Docker Management UI |
| n8n | `n8n` | Workflow Automation |
| Stirling-PDF | `stirling-pdf` | PDF Manipulation Toolkit |
| Omni-tools | `omni-tools` | All-in-one Toolkit |

## 🚀 Initial Setup Instructions

### Step 1: Clone the Repository

Clone this repository to your Docker host machine:

```bash
git clone https://github.com/your-username/homelab.git
cd homelab
```

### Step 2: Free Up Port 53

Before starting, you must disable the default systemd-resolved stub listener on the host machine.

```bash
# Edit the configuration file
sudo nano /etc/systemd/resolved.conf

# Uncomment and set DNSStubListener=no
# DNSStubListener=no

# Restart the service
sudo systemctl restart systemd-resolved
```

### Step 3: Launch the Stack

Start all services using Docker Compose:

```bash
docker compose up -d
```

## ⚙️ Configuration

After launching the stack, you must configure AdGuard Home and Nginx Proxy Manager.

### Part 1: Configure AdGuard Home (The Address Book)

1. **Access the Setup Wizard**: Open your browser to `http://<your_server_ip>:3000`.

2. **Complete the Wizard**: Follow the on-screen instructions to create your admin user and password. The default port settings are fine.

3. **Add DNS Rewrites**: This is the most important step. In the AdGuard dashboard, navigate to **Filters → DNS rewrites**.

   Click "Add DNS rewrite" for each service you want to access via a local domain. Replace `192.168.1.101` with your server's actual local IP address.

   | Domain | Answer (Your Server's IP) |
   |--------|---------------------------|
   | `adguard.local` | `192.168.1.101` |
   | `npm.local` | `192.168.1.101` |
   | `portainer.local` | `192.168.1.101` |
   | `n8n.local` | `192.168.1.101` |
   | `stirling.local` | `192.168.1.101` |
   | `omni.local` | `192.168.1.101` |

4. **Configure Your Router**: Log in to your home router's admin page and find the DHCP/LAN settings. Set the Primary DNS Server to your homelab server's IP address. This will make all devices on your network use AdGuard Home automatically. You may need to restart your devices for them to pick up the new DNS server.

### Part 2: Configure Nginx Proxy Manager (The Traffic Cop)

1. **Access the Admin UI**: Open your browser to `http://<your_server_ip>:81` (or `http://npm.local:81` once DNS is working).

2. **First-Time Login**: Log in with the default credentials and change them immediately:
   - **Email**: `admin@example.com`
   - **Password**: `changeme`

3. **Create Proxy Hosts**: In the dashboard, go to **Hosts → Proxy Hosts** and click "Add Proxy Host". Create an entry for each service according to the table below. For the SSL tab on each entry, select "None".

   | Domain Name | Forward Hostname/IP<br/>(must match container_name) | Forward Port<br/>(container's internal port) |
   |-------------|-----------------------------------------------------|----------------------------------------------|
   | `adguard.local` | `adguard-home` | `80` |
   | `npm.local` | `nginx-proxy-manager` | `81` |
   | `portainer.local` | `portainer` | `9000` |
   | `n8n.local` | `n8n` | `5678` |
   | `stirling.local` | `stirling-pdf` | `8080` |
   | `omni.local` | `omni-tools` | `80` |

## ✅ Accessing Your Services

Once everything is configured, you can access your services using their clean `.local` URLs:

| Service | Local URL | Direct Management URL |
|---------|-----------|----------------------|
| AdGuard Home | `http://adguard.local` | `http://<server_ip>:3000` |
| Nginx Proxy Manager | `http://npm.local` | `http://<server_ip>:81` |
| Portainer | `http://portainer.local` | `https://<server_ip>:9443` |
| n8n | `http://n8n.local` | - |
| Stirling-PDF | `http://stirling.local` | - |
| Omni-tools | `http://omni.local` | - |

## 🛠️ Troubleshooting

### Common Issues

- **Services not accessible via `.local` domains**: Verify that your devices are using the homelab server as their DNS server.
- **Port 53 conflicts**: Ensure systemd-resolved stub listener is disabled as shown in Step 2.
- **Container networking issues**: Check that all containers are running with `docker ps` and verify container names match the proxy host configurations.

### Useful Commands

```bash
# Check container status
docker ps

# View logs for a specific service
docker logs <container_name>

# Restart the entire stack
docker compose down && docker compose up -d

# Update containers
docker compose pull && docker compose up -d
```

## 📝 Notes

- Replace `192.168.1.101` with your actual server IP address throughout the configuration
- Ensure your router supports custom DNS server configuration
- All services are accessible on standard HTTP ports (no need to remember port numbers!)
- For production use, consider implementing SSL certificates via Let's Encrypt

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
