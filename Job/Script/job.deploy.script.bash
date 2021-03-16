eval $(ssh-agent -s)
ssh-add <(echo "$SSH_PRIVATE_KEY")
rsync -rlp -e "ssh -o StrictHostKeyChecking=no -p $SSH_PORT" --delete --exclude-from=.Build/public/typo3conf/ext/base/GitlabCI/deploy-rsync-excludes.txt --exclude-from=./local-deploy-rsync-excludes.txt --exclude=/Tests --exclude=auth.json --exclude=local-deploy-rsync-excludes.txt --exclude=codeception.yml .Build/ $SSH_LOGIN:$REMOTE_PATH
ssh -o StrictHostKeyChecking=no -p $SSH_PORT $SSH_LOGIN "
  php "$REMOTE_PATH"vendor/bin/typo3cms database:export | gzip > "$REMOTE_PATH"/backups/databases/beforedeploy.gz
  php "$REMOTE_PATH"vendor/bin/typo3cms cache:flush --files-only
  php "$REMOTE_PATH"vendor/bin/typo3cms database:updateschema 'safe'
  php "$REMOTE_PATH"vendor/bin/typo3cms install:generatepackagestates
  php "$REMOTE_PATH"vendor/bin/typo3cms install:fixfolderstructure
  php "$REMOTE_PATH"vendor/bin/typo3cms extension:setupactive
  php "$REMOTE_PATH"vendor/bin/typo3cms database:updateschema 'destructive'
  php "$REMOTE_PATH"vendor/bin/typo3cms cache:flush"
