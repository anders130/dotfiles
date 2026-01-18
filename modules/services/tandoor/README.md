# Tandoor Recipes

## Migrating tandoor-recipes on NixOS

On the running instance you want to migrate away from, run:

```bash
sudo /var/lib/tandoor-recipes/tandoor-recipes-manage export -a \
    --exclude contenttypes \
    --exclude auth.permission \
    --exclude auth.group \
    --exclude admin.logentry > /home/$USER/tandoor-recipes-dump.json
```

After copying the dump file to your new instance, run:

```bash
sudo mkdir /data
sudo chown -R tandoor_recipes:tandoor_recipes /data
sudo mv /path/to/tandoor-recipes-dump.json /data/dump.json

sudo /var/lib/tandoor-recipes/tandoor-recipes-manage import /data/dump.json
```
