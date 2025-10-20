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

## Customizing CGit (`cgitrc`)

The appearance and behavior of the CGit web interface can be customized by editing the `cgitrc` file. This file is located at `/etc/cgitrc` inside the container. To use a custom `cgitrc`, you can mount your own version using a Docker volume.

### Example `docker run` with custom `cgitrc`

```bash
docker run -dit -p 80:80 -p 22:22 -v $(pwd)/../git-repo:/home/git/ -v $(pwd)/../cgit-config:/cgit-config git-server
```

In this example:
- `-v $(pwd)/../git-repo:/home/git/`: Mounts your local `git-repo` directory to store the Git repositories.
- `-v $(pwd)/../cgit-config:/cgit-config`: Mounts your local `cgit-config` directory (containing your custom `cgitrc` and `cgit.css`) into the container.

### `cgitrc` Configuration Explained

Here are some of the key options you can customize in your `cgitrc` file:

```
# cgitrc
#
# This is the configuration file for cgit
#
# Every line is a name-value-pair, separated by an equals sign.
# The names are not case-sensitive.
#
# Lines starting with a hash are comments.

# css: URL of the CSS stylesheet
# default: /cgit.css
css=/cgit.css

# logo: URL of the logo image
# default: /cgit.png
logo=/cgit.png

# project-list: path to a file containing a list of projects
# default: (none)
project-list=/home/git/projects.list

# scan-path: directory to scan for git repositories
# default: (none)
scan-path=/home/git/

# title: title of the main page
# default: Git Repository Browser
title=My Custom Git Server

# virtual-root: the virtual root URL of cgit
# default: (none)
virtual-root=/

# about-filter: path to a script that can format the about page of a repository
# default: (none)

# branch-sort: how to sort branches
# default: name
branch-sort=age

# cache-size: size of the cache for generated pages (in number of pages)
# default: 100
cache-size=1000

# clone-prefix: prefix for clone URLs
# default: (none)
clone-prefix=ssh://git@your.domain.com

# clone-url: pattern for clone URLs
# default: (none)
clone-url=%s/%n.git

# embedded: whether to generate a full HTML document or just the content
# default: 0
embedded=0

# enable-commit-graph: whether to display the commit graph on the log page
# default: 0
enable-commit-graph=1

# enable-http-clone: whether to allow cloning over HTTP
# default: 1
enable-http-clone=0

# enable-log-filecount: whether to display the number of files in each commit
# default: 1
enable-log-filecount=1

# enable-log-linecount: whether to display the number of lines added/removed in each commit
# default: 1
enable-log-linecount=1

# max-stats: maximum number of stats to display on the summary page
# default: 20
max-stats=10

# remove-suffix: suffix to remove from repository names
# default: .git
remove-suffix=1

# root-title: title of the root page
# default: Git Repositories
root-title=Available Repositories

# summary-branches: number of branches to show in the summary view
# default: 5
summary-branches=10

# summary-log: number of log entries to show in the summary view
# default: 10
summary-log=20
```
