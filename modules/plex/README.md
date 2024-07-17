# Plex Module

To allow plex to access your files, you need to set the permissions to your user.

```bash
sudo chown -R username:users /mnt/Videos
```

If you encounter any issues, try to set the plex config's permissions to your user as well:

```bash
sudo chown -R username:users /var/lib/plex
```

You can't use the `/home/\<username\>/Videos/` folder because plex will not be able to access it.
