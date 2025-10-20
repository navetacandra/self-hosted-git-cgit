# Git Server with CGit

This project provides a Git server running inside a Docker container, complete with the CGit web interface for browsing repositories.

## Running the Server

You have two options for running the server:

### Option 1: Using Docker Compose (Recommended)

The easiest way to run the server is by using Docker Compose. Simply run the following command from the project's root directory:

```bash
docker-compose up -d --build
```

This command will automatically build the Docker image and run the container in the background.

### Option 2: Manually with Docker Build

If you don't want to use Docker Compose, you can build and run the container manually.

**1. Build the Image**

To build the Docker image, run the following command from the project's root directory:

```bash
docker build -t git-server .
```

**2. Run the Container**

After the image is successfully built, run the Docker container with the following command:

```bash
docker run -d --name git-server \
  -p 8080:80 \
  -p 2222:22 \
  -v git-repo:/home/git \
  git-server
```

The server will be accessible at `http://localhost:8080` for the web interface and `ssh://git@localhost:2222` for Git access.

## Usage

### Creating a New Repository

To create a new Git repository, you can use the `new-git` script available inside the container. Run the following command:

```bash
docker exec -it git-server new-git <repository-name>
```

Replace `<repository-name>` with your desired repository name.

### Cloning, Pushing, Fetching and Pulling Repositories

#### Via SSH

To clone, push, fetch and pull repositories via SSH, use the following command:

```bash
git clone ssh://git@localhost:2222/<repository-name>.git
```

### Browsing Repositories Via HTTP

The CGit web interface is available for browsing repositories. You can access it at `http://localhost:8080/`. Please note that push, fetch, and pull functionalities are not supported over HTTP; it is for preview only.

### Adding SSH Public Keys

To allow SSH access to the repositories, you need to add your SSH public key to the `authorized_keys` file inside the container. Copy your public key, then add it to the `/home/git/.ssh/authorized_keys` file inside the container.