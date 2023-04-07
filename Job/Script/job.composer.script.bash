eval $(ssh-agent -s)
ssh-add <(echo "$SSH_PRIVATE_KEY")
mkdir .Build
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --version=1.10.17
rm composer-setup.php
export COMPOSER_ALLOW_SUPERUSER=1
export COMPOSER_MIRROR_PATH_REPOS=1
export COMPOSER_NO_INTERACTION=1
./composer.phar install --no-dev --prefer-dist --optimize-autoloader
./composer.phar dumpautoload --optimize
rm composer.phar
wget https://raw.githubusercontent.com/akiessling/dpool-devops/main/Job/Excludes/Build/typo3.txt
rsync -rlp ./ .Build/ --exclude-from=./typo3.txt
