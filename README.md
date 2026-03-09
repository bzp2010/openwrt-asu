# OpenWRT ASU (Attended Sysupgrade Server) in Docker

OpenWRT ASU project uses Podman to run the build scheduler and workers, and it also relies on dynamic API access to Podman for launching dynamic builders.

However, the Podman project has long occupied an awkward position, far less popular than Docker. Many platforms, such as TrueNAS and Synology DSM, use Docker instead of Podman, hindering the deployment of self-hosted image builders. Even on dedicated server platforms, Podman's adoption rate remains lower than Docker.

This project employs a DinD-like (Docker in Docker) approach to deploy ASU servers, but utilizes Podman instead (Podman in Docker). It runs the entire ASU server and workers within a single Docker container using a Podman image ([quay.io/podman/stable](https://quay.io/podman/stable)). Regardless of how many independent build containers it launches, all operations occur within the Docker container.

This encapsulates Podman's inherent complexity within the Docker container. Launching the ASU stack for this project requires only Docker Compose, with the image builder being ready to use out of the box.

## Usage

1. Obtain project's code

2. Start ASU stack

    ```bash
    docker compose up -d
    ```

3. Access ASU dashboard at [http://localhost:8000](http://localhost:8000)

## Notes

### Update pre-pulled images

Pull the image in advance and copy it into the container during packaging to avoid pulling the container image during startup.

You can also choose not to pull them to reduce the container image size, but this means the container must download these dependencies on the fly during startup.

```bash
cd images && ./fetch.sh
```

If you need to add a pre-pulled imagebuilder, you can modify the IMAGES list in `fetch.sh` by adding a new line there to include the new container.
