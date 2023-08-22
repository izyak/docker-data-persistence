# DOCKER DATA PERSISTENCE

This repo is to learn how docker volumes work. To run, follow the instructions [here](#how-to-run)
# Repo structure
```
docker-data-persistence
    ├── docker-compose.yml 
    ├── Dockerfile
    ├── env
    │   └── id
    ├── myscript.sh
    ├── process.sh
    └── README.md
```

- `docker-compose` is used to manage volumes and ports in this repository.
- `Dockerfile` is used to build docker image for this project.
- `env/id` is used to keep track of sequence numbers.
- `myscript.sh` is used to fetch the id, make a http request using that `id` and save the response to a json file.
- `process.sh` runs an infinite loop which is used to keep the docker container up and running and not exit immediately.
- `README.md` contains docs for this repo.

### Script Explanation
`myscript.sh` loads `id` from `/env/id`, and uses this id to make http request to placeholder json url. This endpoint returns new json for different id. This json will be saved under `data/file_id_timestamp.json` The id is updated by 1 everytime `myscript.sh` is executed.

### Reasoning
We want the folder `data` and `env` to persist, so that when we exit from the container and run it again, the data in the `data` and `env` folder persists. The volumes of docker helps to manage this for us.

### How to persist data [Mount Volume]
In `docker-compose.yaml`, we have the following section:
```
services:
    app:
        image: learn-persistence:latest
        volumes:
            - app-data:/app/data
            - app-env:/app/env
        ports:
            - "8080:8080"
volumes:
    app-data:
    app-env:

```

### services.app.volumes section:
This section defines the volumes to be mounted in the container. Volumes allow data to persist beyond the container's lifecycle.

- app-data:/app/data: This creates a volume named app-data and mounts it to the /app/data directory inside the container. This will be used to store json response for each id.
- app-env:/app/env: Similarly, this creates a volume named app-env and mounts it to the /app/env directory inside the container. This will be used to store the `id`.

### volumes section: 
This section defines the named volumes used in the service configuration above. Named volumes provide a way to manage data outside the containers.
- app-data: Defines a named volume named app-data.
- app-env: Defines a named volume named app-env.

## How to run
1. Clone the repo
```sh
git clone https://github.com/izyak/docker-data-persistence.git
cd docker-data-persistence
```

2. Build docker image
```sh
docker build --tag learn-persistence .
```

3. Run docker container
```sh
docker compose up -d
```

4. Get the container id of the running container
```sh
docker ps
```
> Copy the container id for `learn-persistence:latest` image

5. Enter the docker container
```sh
docker exec -it <container_id_or_name> /bin/bash
```

6. Check current id and data folder.
```sh
cat env/id 
ls data/
```

7. Run the script multiple times.
```sh
./myscript.sh
./myscript.sh
./myscript.sh
```

8. Check the id and data folder again.
```sh
cat env/id 
ls data/
```
> The id should be updated, and data folder should have a few json files

9. Exit from the dontainer.
```sh
exit
```

10. Stop the container
```sh
docker compose down
```

11. Start the container again
```sh
docker compose up -d
```

12. Enter the docker container again
```sh
docker exec -it <container_id_or_name> /bin/bash
```

13. Check the id and data folder again/
```sh
cat env/id
ls data
```
> If volumes were not mounted, when we run this container again, and check, all the data should be cleared out. However, since we have mounted the volumes, the data in the volume persists.

14. You can see the volumes were created on local filesystem, which will be mounted to the docker containers.
```sh
docker volume ls
```


---
This is how docker volumes works and how they can be used to persist data in the container.