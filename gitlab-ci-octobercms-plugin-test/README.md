# OctoberCMS Plugins Test Image for GitLab CI

A `.gitlab-ci.yml` example file to test the `YourVendor.YourPluginName`
 plugin. Only the `VENDOR_NAME` and `PLUGIN_NAME` variables should be 
 adapted to the tested plugin unless you require more customization.
 
We must copy the pulled files to the OctoberCMS tree to make the 
 dependencies and autoload work as expected.
  
> Cache is not working (at least with 


```YAML
image: bnbwebexpertise/gitlab-ci-octobercms-plugin-test

variables:
  OCTOBER_DIR: '/octobercms'
  VENDOR_NAME: 'YourVendor'
  PLUGIN_NAME: 'YourPluginName'

stages:
 - test

before_script:
  - 'VENDOR_DIR=${OCTOBER_DIR}/plugins/${VENDOR_NAME,,}'
  - 'PLUGIN_DIR=${VENDOR_DIR}/${PLUGIN_NAME,,}'
  - '[[ -d ${VENDOR_DIR} ]] || { mkdir -p ${VENDOR_DIR}; }'
  - '[[ ! -d ${PLUGIN_DIR} ]] || { rm -rf ${PLUGIN_DIR}; }'
  - 'cp -R ${CI_PROJECT_DIR} ${PLUGIN_DIR}'
  - 'cd ${OCTOBER_DIR}'
  - 'composer update'
  - 'cd ${PLUGIN_DIR}'

after_script:
  - 'rm -rf ${PLUGIN_DIR}'

test:
  stage: test
  script:
    - 'echo "Running tests for ${VENDOR_NAME}.${PLUGIN_NAME} in `pwd`"'
    - 'phpunit .'
  tags:
    - docker
```

