# How to setup the project

To deploy the project to your local machine follow the instructions below:

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