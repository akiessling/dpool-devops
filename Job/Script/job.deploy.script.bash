eval $(ssh-agent -s)
wget https://raw.githubusercontent.com/akiessling/dpool-devops/main/Job/Excludes/Deploy/typo3.txt
ssh-add <(echo "$SSH_PRIVATE_KEY")
rsync -rlp -e "ssh -o StrictHostKeyChecking=no -p $SSH_PORT" --delete --exclude-from=./typo3.txt --exclude-from=local-deploy-rsync-excludes.txt --exclude=local-deploy-rsync-excludes.txt --exclude=Tests --exclude=codeception.yml .Build/ $SSH_LOGIN:$REMOTE_PATH
ssh -o StrictHostKeyChecking=no -p $SSH_PORT $SSH_LOGIN "
  php "$REMOTE_PATH"vendor/bin/typo3cms database:export | gzip > "$REMOTE_PATH"backups/databases/beforedeploy.gz
  php "$REMOTE_PATH"vendor/bin/typo3cms cache:flush
  php "$REMOTE_PATH"vendor/bin/typo3cms database:updateschema
  php "$REMOTE_PATH"vendor/bin/typo3cms install:fixfolderstructure
  php "$REMOTE_PATH"vendor/bin/typo3cms cache:flush"
