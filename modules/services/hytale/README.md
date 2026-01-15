# Hytale

This module installs a dedicated **Hytale Server** using the Docker image provided by [indifferentbroccoli/hytale-server-docker](https://github.com/indifferentbroccoli/hytale-server-docker).

---

## Usage

Enable the module in your NixOS configuration:

```nix
{
    modules.services.hytale.enable = true;
}
```

Rebuild your system after enabling the module.

---

## Initial Setup & Authentication

The Hytale dedicated server requires two authentication steps:

1. Authenticating the server download
2. Authenticating the server instance itself

### 1. Authenticating the Server Download

After enabling the module, start the service:

```bash
systemctl start podman-hytale.service
```

Then:

1. Open the logs of the service:

```bash
journalctl -u podman-hytale.service -f
```

2. Copy the authentication URL shown in the logs
3. Open the URL in your browser
4. Log in with your Hytale account
5. Return to the terminal and wait for the download to complete

### 2. Authenticating the Server Instance

Once the download has finished, attach to the running container:

```bash
podman attach hytale
```

Inside the container console, authenticate the server:

```bash
/auth login device
```

Follow the instructions shown in the terminal.

#### Persist the Authentication Token

To ensure authentication persists across rebuilds and restarts, run:

```bash
/auth persist Encrypted
```

After this step, the server can be restarted without re-authentication.
