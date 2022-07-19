# Drupal Code Standards for PHPStorm

## 1. PHP_CodeSniffer
Run in the container
```bash
composer require --dev dealerdirect/phpcodesniffer-composer-installer
```
Go to PHPStorm, open Settings > PHP > Quality Tools , open section PHP_CodeSniffer.

Change Configuration to Local and press dotted button next to it.

Set the **PHP_CodeSniffer path** to ```[YOUR_PROJECT]/vendor/bin/phpcs``` and check it with Validate button.

Set the **PHP CodeBeautifier** to ```[YOUR_PROJECT]/vendor/bin/phpcbf```

## 2. Drupal Coding Standards
Run in the container
```bash
composer require --dev drupal/coder
```
Go to PHPStorm, open Settings > Editor > Inspections. Open **Quality tools** dropdown and select **PHP_CodeSniffer validation**

Change **Check files...** field to
```yaml
php,module,inc,install,test,profile,theme,css,info,txt,md,yml
```
Change **Coding standard** to the 'Drupal'

Open the file ```.idea/inspectionProfiles/Project_Default.xml```, find the section
```xml
<option name="CODING_STANDARD" value="Drupal" />
```
and replace it with
```xml
<option name="CODING_STANDARD" value="Drupal,DrupalPractice" />
```


## 3. Hooks for git pre-commit
### 3.1. Install (for dev environment)
 run in the container
```bash
composer require --dev brainmaestro/composer-git-hooks
```
### 3.2. Set up
Add to the **scripts** section of your **composer.json**
```yaml
    "scripts": {
        ...
        "post-install-cmd": "@update-git-hooks",
        "post-update-cmd": "@update-git-hooks",
        "update-git-hooks": "[[ -f ./vendor/bin/cghooks ]] && ./vendor/bin/cghooks update ||:;"
    }
```
then add **hooks** subsection to the **extra** section of your **composer.json**
```yaml
    "extra": {
        ...
        "hooks": {
            "pre-commit": "./utility/git-hooks/pre-commit.sh",
            "commit-msg": "./utility/git-hooks/commit-msg.sh $1"
        }
    }
```
and finally you can set up the tasks naming and commit message format in file ```utility/git-hooks/_config.sh``` (they are already fine)

