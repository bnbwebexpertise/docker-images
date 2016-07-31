FROM bnbwebexpertise/gitlab-ci-runner-php7-laravel

RUN php -n /usr/local/bin/composer -n create-project october/october /octobercms dev-master
RUN sed -i "s/disableCoreUpdates' => false/disableCoreUpdates' => true/" /octobercms/config/cms.php

WORKDIR /octobercms

RUN phpunit --version
