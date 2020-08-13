# Symfony CLI tool v4

Build to be used as security check action in Gitlab CI :

    cd /path/to/folder/containing/composer-lock-file
    docker run --rm -v $(pwd):/code bnbwebexpertise/symfony-cli:latest symfony security:check --dir /code

Gitlab CI :

```yaml
php-security:
  image: bnbwebexpertise/symfony-cli
  script:
    - cd ${CI_PROJECT_DIR}
    - symfony security:check --force-update --dir .

```
