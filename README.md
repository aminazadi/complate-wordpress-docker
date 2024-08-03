# Complete WordPress Docker Setup

This repository contains a complete setup for running WordPress, MySQL, and phpMyAdmin using Docker. The setup includes a Dockerfile and a `docker-compose.yml` file to simplify the deployment process.

## Features

- **WordPress**: Latest version of WordPress.
- **MySQL**: Official MySQL image for the database.
- **phpMyAdmin**: Web-based interface for MySQL administration.
- **Persistent Storage**: Data is stored in the same directory as the Dockerfile.
- **All Required Modules**: All necessary modules for a complete WordPress setup are installed by this package.

## Prerequisites

- [Docker](https://www.docker.com/products/docker-desktop) (version 20.10.7 or higher)
- [Docker Compose](https://docs.docker.com/compose/install/) (version 1.29.2 or higher)

## Installation

1. **Clone the repository**:
   ```sh
   git clone https://github.com/aminazadi/complate-wordpress-docker.git
   cd complate-wordpress-docker
   ```

2. **Create a .env file**:
   Create a file named `.env` and copy the customized values from `envsample` file. Below is an explanation of each variable in `envsample`:

   - `WORDPRESS_DB_HOST`: Database host (default is `db:3306`)
   - `WORDPRESS_DB_USER`: Database user (default is `root`)
   - `WORDPRESS_DB_PASSWORD`: Database password (default is `example`)
   - `WORDPRESS_DB_NAME`: Database name (default is `wordpress`)
   - `MYSQL_ROOT_PASSWORD`: Root password for MySQL (default is `example`)
   - `PMA_HOST`: Hostname for phpMyAdmin (default is `db`)
   - `PMA_PORT`: Port for phpMyAdmin (default is `3306`)

3. **Ensure permissions for `cmd.sh` and `start.sh`**:
   ```sh
   chmod +x cmd.sh
   chmod +x start.sh
   ```

4. **Run the Docker Compose setup**:
   ```sh
   ./cmd.sh u
   ```

5. **Access WordPress**:
   Open your browser and go to `http://localhost:8000`

6. **Access phpMyAdmin**:
   Open your browser and go to `http://localhost:8080`
   - Server: `db`
   - Username: `root`
   - Password: `example`

## Directory Structure

```plaintext
.
├── db_data                  # MySQL data
├── wp_data                  # WordPress data
├── Dockerfile               # Dockerfile for custom configurations
├── docker-compose.yml       # Docker Compose configuration
├── envsample                # Sample environment variables file
├── cmd.sh                   # Script to run Docker Compose commands
├── start.sh                 # Script to start the setup
└── README.md                # This file
```

## Customization

### Environment Variables

You can customize the environment variables in the `.env` file based on the `envsample` file:

- `WORDPRESS_DB_HOST`: Database host (default is `db:3306`)
- `WORDPRESS_DB_USER`: Database user (default is `root`)
- `WORDPRESS_DB_PASSWORD`: Database password (default is `example`)
- `WORDPRESS_DB_NAME`: Database name (default is `wordpress`)
- `MYSQL_ROOT_PASSWORD`: Root password for MySQL (default is `example`)
- `PMA_HOST`: Hostname for phpMyAdmin (default is `db`)
- `PMA_PORT`: Port for phpMyAdmin (default is `3306`)

### Volumes

Volumes are used to persist the data:

- `db_data`: Stores MySQL data files.
- `wp_data`: Stores WordPress files.

## Backup & Restore

### Backup

To backup the MySQL database, use the following command:

```sh
docker exec CONTAINER_ID /usr/bin/mysqldump -u root --password=example wordpress > backup.sql
```

### Restore

To restore the MySQL database, use the following command:

```sh
docker exec -i CONTAINER_ID /usr/bin/mysql -u root --password=example wordpress < backup.sql
```

## Troubleshooting

### Common Issues

- **Container not starting**: Check if the ports `8000` and `8080` are free.
- **Database connection errors**: Verify the database credentials in the `.env` file.

### Logs

To view the logs for a specific container, use:

```sh
docker-compose logs CONTAINER_NAME
```

## Contributing

Feel free to submit issues and pull requests. Contributions are welcome!

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Note

This setup does not handle domain connection to the specified port. You need to configure domain settings separately.

