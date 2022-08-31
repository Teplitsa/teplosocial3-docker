# How to setup the project

## For Unix/MacOS: to deploy the project to your local machine follow the instructions below:

1. Create a new directory
2. Open a terminal in the dicrectory and run the command:

```
git clone -q "git@github.com:Teplitsa/teplosocial3-docker.git" "./docker" \
    -b main && \
    chmod +x ./docker/setup.sh && \
    ./docker/setup.sh
```

3. Then run the command:
```
cd ./docker && docker compose up
```

## For Windows 10: to deploy the project to your local machine follow the instructions below:

1. Create a new directory (i.e. D:\dev-teplosocial)
2. Open a cmd ("run as Administrator") in the directory, then run the commands:

```
git clone -q "https://github.com/Teplitsa/teplosocial3-docker.git" "./docker" -b main
docker/setup.sh
```

3. Then run the commands:
```
cd docker
docker compose up
```
