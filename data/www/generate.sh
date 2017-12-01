#!/usr/bin/env bash
T1=$(date +%s)

logfile=/var/logs/generate-website.log
touch $logfile

#! Start.
echo "*********" >> $logfile
echo "generator" >> $logfile
echo "*********" >> $logfile

#TODO: Path variables?

#! Generator variables.
drupalUser='admin'
drupalPass='admin'
drupalMail='admin@generator.dev'
drupalPrefix=''
modUser='moderator'
modPass='moderator'
modMail='moderator@generator.dev'

#! Database variables.
dbUser='root'
dbPass='root'
dbHost='mysql'

#! Heading.
echo "Generating project folder" >> $logfile

#! Get project name.
#echo "Insert Project name:"  >> $logfile
#read projectInput

#! Cleanup & display project name.
projectClean=${projectInput//_/}
projectClean=${projectClean// /_}
projectName=${projectClean//[^a-zA-Z0-9_]/}
echo "Project name: $projectInput converted to $projectName" >> $logfile

#! Create html folder.
mv /var/www/html /var/www/_html
mkdir /var/www/html
cd /var/www/

#! Create include/exclude file(s).
excludeList=(".idea" ".idea*" ".idea/*")
excludeList=("${excludeList[@]}" ".DS_Store")
excludeList=("${excludeList[@]}" "html/sites/*/private" "html/sites/*/*settings.php" "html/sites/*/files")
excludeList=("${excludeList[@]}" "html/cache/*" ".git" "drush" "html/log")
touch include-list.txt
touch exclude-list.txt
printf '%s\n' "${excludeList[@]}" > exclude-list.txt

#! Create .gitignore from list.
gitignoreList=("# Ignore configuration files that may contain sensitive information." "html/sites/*/*settings.php")
gitignoreList=("${gitignoreList[@]}" "# Ignore paths that contain user-generated content." ".idea" "html/sites/*/files" "html/sites/*/private")
gitignoreList=("${gitignoreList[@]}" "# Ignore caches." ".idea" "html/sites/all/drush/dump.sql" "*.sql" "*.tar" "*.zip" "*.gz" "html/sites/all/civicrm/extensions/cache")
gitignoreList=("${gitignoreList[@]}" "# Ignore ds_store." "/.DS_Store" "*/.DS_Store" "*.DS_Store")
gitignoreList=("${gitignoreList[@]}" "# Ignore generate script(s)." "generate.sh" "cleanup.sh")
touch .gitignore
printf '%s\n' "${gitignoreList[@]}" > .gitignore

#! Heading.
echo "Generating GIT" >> $logfile

#! Initialize git.
rm -rf .git
git init
git add .
git commit -m "Initial commit." --quiet

#! Create git branches.
git checkout -b development
git checkout master
git checkout -b acceptance
git checkout master

#TODO: Add GIT remote functionality.

#! Heading MySQL.
echo "Generating MySQL" >> $logfile

#! Create Drupal database via MySQL.
dbDrupal=$projectName'_d'
mysql -v -u $dbUser -p$dbPass -h $dbHost -e 'create database '$dbDrupal

#! Heading.
echo "Generating Drupal" >> $logfile

#! Download latest drupal version.
drush --drupal-project-rename=dtmp dl drupal-7.x
chmod 777 /var/www/dtmp/

#! Move files from temporary to html folder.
mv /var/www/dtmp/* /var/www/html/
mv /var/www/dtmp/.htaccess /var/www/html/
mv /var/www/dtmp/.gitignore /var/www/html/

#! Remove temporary folder.
rm -rf /var/www/dtmp

#! Heading.
echo "Create drupal folders" >> $logfile

#! Create features/config/contrib/custom module folders.
mkdir /var/www/html/sites/all/modules/features
mkdir /var/www/html/sites/all/modules/config
mkdir /var/www/html/sites/all/modules/contrib
mkdir /var/www/html/sites/all/modules/custom

#! Browse to Drupal folder.
git_root=$(pwd)
cd /var/www/html

#! Commit Drupal to GIT
git add -A
git commit -m "Downloaded Drupal 7." --quiet

#! Heading.
echo "Download 3th party modules" >> $logfile

#! Downloadlist 3th party modules.
downloadList=(ctools)
downloadList+=(views admin_views views_conditional views_data_export views_field_view)
downloadList+=(extlink pathauto)
downloadList+=(ckeditor)
downloadList+=(features)
downloadList+=(admin_menu devel module_filter coffee)

#! Download 3d party modules.
for i in "${downloadList[@]}"
do
    drush dl -y $i
    #! Commit Drupal contrib modules to GIT
    git add -A
    git commit -m "Downloaded Drupal contrib module: $i." --quiet
done

#! Heading.
echo "Download 3th party themes" >> $logfile

#! Themelist 3th party themes.
themeList=(bootstrap tao rubik)

#! Download 3d party themes.
for i in "${themeList[@]}"
do
    drush dl -y $i
    #! Commit Drupal contrib modules to GIT
    git add -A
    git commit -m "Downloaded Drupal theme: $i." --quiet
done

#! Heading.
echo "Drupal installation" >> $logfile

#! Installation configuration. (standard/minimal)
drush site-install standard -y --site-name="$projectName" --site-mail="$drupalMail" \
		--db-url=mysql://$dbUser:$dbPass@$dbHost/$dbDrupal \
		--db-prefix=$drupalPrefix \
		--account-name=$drupalUser --account-pass=$drupalPass --account-mail="$drupalMail" \

#! Create group(s) and user(s).
drush role-create 'moderator' 'Site Moderator'
drush user-create $modUser --mail=$modMail --password=$modPass
drush user-add-role moderator --name=$modUser

#! Enable 3d party modules.
enableList=$downloadList
enableList+=(admin_menu_toolbar views_ui devel_generate)
for i in "${enableList[@]}"
do
    drush en -y $i
done

#! Enable default theme.
drush pm-enable -y bootstrap
drush vset theme_default bootstrap
drush pm-disable -y bartik

#! Enable admin theme.
drush vset admin_theme rubik
drush pm-disable -y seven

#! Generate content (for site_frontpage)
drush generate-content 1 --types=page

#! Heading.
echo "Set Drupal variables" >> $logfile

#! Set Drupal variables.
drush eval 'variable_set("site_default_country","BE")';
drush eval 'variable_set("date_default_timezone", "Europe/Brussels")';
drush eval '$x=variable_get("update_notify_emails");$x[0]="";variable_set("update_notify_emails",$x)'
drush eval 'variable_set("site_frontpage", "node/1")'
drush eval 'variable_set("error_level", "0")'
drush eval 'variable_set("date_format_long", "l, j F, Y - H:i")';
drush eval 'variable_set("date_format_medium", "D, d/m/Y - H:i")';
drush eval 'variable_set("date_format_short", "d/m/Y - H:i")';
drush eval 'variable_set("date_first_day", 1)';
drush eval 'variable_set("extlink_alert_text", "This link will take you to an external web site. We are not responsible for their content.")';
drush eval 'variable_set("extlink_class", "ext")';
drush eval 'variable_set("extlink_include", ".\\.pdf|.\\.doc|.\\.docx|.\\.xls|.\\.xlsx|.\\.xml|.\\.rss")';
drush eval 'variable_set("extlink_mailto_class", "mailto")';
drush eval 'variable_set("extlink_subdomains", 1)';
drush eval 'variable_set("extlink_target", "_blank")';
drush eval 'variable_set("pathauto_node_pattern", "[node:content-type]/[node:title]")';
drush eval 'variable_set("pathauto_node_page_pattern", "[node:title]")';
drush eval 'variable_set("pathauto_node_blog_entry_pattern", "blog/[node:created:custom:Y-m-d]/[node:title]")';
drush eval 'variable_set("pathauto_punctuation_underscore", "1")';
drush eval 'variable_set("features_default_export_path", "sites/all/modules/features")';

#! Disable default Drupal modules.
drush dis -y color comment shortcut toolbar dashboard help overlay

#! Heading.
echo "Download libraries" >> $logfile

#! Install CKeditor libraries.
curl "http://download.cksource.com/CKEditor/CKEditor/CKEditor%204.6.0/ckeditor_4.6.0_full.zip" -o ckeditor.zip
unzip ckeditor.zip
mv ckeditor sites/all/libraries
rm ckeditor.zip

#! Commit Commit Libraries to GIT
git add sites/all/libraries/
git commit -m "Downloaded library: CKeditor." --quiet

#! Install features.
drupal_root=$(pwd)
cd sites/all/modules/features
featureList="ctrl_feature_ckeditor"
for i in "${featureList[@]}"
do
    git clone https://github.com/kewljuice/$i
    rm -rf $i/.git
    #! Commit Features to GIT.
    git add -A
    git commit -m "Downloaded Feature: $i." --quiet
done
drush en -y $featureList;
cd $drupal_root

#! Install CiviCRM.
echo "${cp}Install CiviCRM?${cx}" >> $logfile
#read enablecivicrm

if echo "$enableCivicrm" | grep -iq "^y";
then

    #! Heading.
    echo "Download CiviCRM" >> $logfile

    #! CiviCRM variables.
    #civiUrl='http://localhost.8080/' #! vb.: http://generator.dev/ - with CLOSING SLASH.
    #civiKey=$(date |md5 | head -c32)
    civiKey=$(date |md5sum | head -c32)

    #! Unpack the latest package and verify permissions.
    curl -L "https://download.civicrm.org/civicrm-4.7.16-drupal.tar.gz" -o civicrm.tar.gz
    tar -xf civicrm.tar.gz -C sites/all/modules/contrib/
    rm -rf civicrm.tar.gz
    chmod 775 sites/default

    #! Commit Drupal to GIT
    git add -A
    git commit -m "Downloaded CiviCRM 4.7.16." --quiet

    #TODO Unpack CiviCRM language(s).

    #! Heading.
    echo "Download CiviCRM feature" >> $logfile

    #! Download feature with default parameters.
    cd sites/all/modules/features
    git clone https://github.com/kewljuice/ctrl_feature_civicrm
    rm -rf ctrl_feature_civicrm/.git
    cd $drupal_root

    #! Commit CiviCRM Feature to GIT
    git add -A
    git commit -m "Downloaded Feature: ctrl_feature_civicrm." --quiet

    #! Heading.
    echo "Install CiviCRM" >> $logfile

    #! Create CiviCRM folders.
    mkdir www/sites/all/civicrm
    mkdir www/sites/all/civicrm/extensions

    #! Create CiviCRM database via MySQL.
    dbCiviCRM=$projectName'_c'
    mysql -v -u $dbUser -p$dbPass -h $dbHost -e 'create database '$dbCiviCRM

    #! Copy civicrm.settings.php and replace variables.
    civiTmp=sites/all/modules/features/ctrl_feature_civicrm/civicrm.settings.default.php
    civiOut=sites/default/civicrm.settings.php
    sed  "s,£db_drupal£,$dbUser:$dbPass@$dbHost/$dbDrupal?new_link=true,g
	      s,£db_civi£,$dbUser:$dbPass@$dbHost/$dbCiviCRM?new_link=true,g
          s,£civi_root£,$drupal_root,g
          s,£civi_url£,$civiUrl,g
          s,£civi_key£,$civiKey,g" $civiTmp > $civiOut

    #! Import default civicrm.sql database.
    mysql -u $dbUser -h $dbHost -p$dbPass $dbCiviCRM < sites/all/modules/features/ctrl_feature_civicrm/civicrm.sql

    #! Enable CiviCRM and related module(s).
    drush en -y civicrm civicrmtheme

    #! Set write permissions.
    chmod a-w sites/default/civicrm.settings.php

    #! CiviCRM public theme.
    drush eval 'variable_set("civicrmtheme_theme_admin", "rubik")';
    drush eval 'variable_set("civicrmtheme_theme_public", "bootstrap")';

    #TODO Set Drupal views integration.

    #TODO Remove CiviCRM feature.

    #! Heading.
    echo "Install CiviCRM extensions" >> $logfile

    #! Download & enable CiviCRM extensions.
    civicrm_root=$(pwd)
    cd sites/all/civicrm/extensions
    extensionList="be.ctrl.superstyler"
    for i in "${extensionList[@]}"
    do
        git clone https://github.com/kewljuice/$i
        rm -rf $i/.git
        #! Commit Extensions to GIT.
        git add -A
        git commit -m "Downloaded Extension: $i." --quiet
        #! Activate Extension.
        drush civicrm-ext-install $i
    done
    cd $civicrm_root

    #! Clean caches.
    drush cc civicrm
fi

#! Heading.
echo "Finalize installation" >> $logfile

#! Add Caching settings to settings.php.
cachingList=('<?php');
cachingList=("${cachingList[@]}" 'if ( (isset($_SERVER["HTTPS"]) && strtolower($_SERVER["HTTPS"]) == "on")')
cachingList=("${cachingList[@]}" '     || (isset($_SERVER["HTTP_X_FORWARDED_PROTO"]) && $_SERVER["HTTP_X_FORWARDED_PROTO"] == "https")')
cachingList=("${cachingList[@]}" '     || (isset($_SERVER["HTTP_HTTPS"]) && $_SERVER["HTTP_HTTPS"] == "on")')
cachingList=("${cachingList[@]}" ') {')
cachingList=("${cachingList[@]}" '  $_SERVER["HTTPS"] = "on";')
cachingList=("${cachingList[@]}" '}')
cachingList=("${cachingList[@]}" '// Rely on the external cache for page caching.')
cachingList=("${cachingList[@]}" '$conf["cache_class_cache_page"] = "DrupalFakeCache";')
cachingList=("${cachingList[@]}" '?>')
chmod -R 755 sites/default/
mv sites/default/settings.php sites/default/old_settings.php
printf '%s\n' "${cachingList[@]}" > sites/default/temp_settings.php
cat sites/default/temp_settings.php sites/default/old_settings.php >> sites/default/settings.php
rm sites/default/*_settings.php

#! Create temporary files folder.
mkdir sites/default/files/tmp
drush eval 'variable_set("file_temporary_path", "sites/default/files/tmp")'

#! Create private files folder.
mkdir sites/default/files/private
drush eval 'variable_set("file_private_path", "sites/default/files/private")'

#! Set write permissions for Drupal installation.
chmod a-w sites/default/settings.php
chmod a-w sites/default
chmod -R 777 sites/default/files
chmod 777 sites/all/modules
chmod 777 sites/all/themes

#! Clear cache, run cron.
drush cc all
drush core-cron

#TODO: Remove generate.sh.
#! mv generate.sh _generate.sh

#! GIT merge master to other branches.
#git checkout acceptance
#git merge master --quiet
#git checkout development
#git merge master --quiet

#! Stop timer.
T2=$(date +%s)
diffsec="$(expr $T2 - $T1)"
echo | awk -v D=$diffsec '{printf "Elapsed time: %02d:%02d:%02d\n",D/(60*60),D%(60*60)/60,D%60}' >> $logfile

#! End.
echo "******************" >> $logfile
echo "that's all folks!!" >> $logfile
echo "******************" >> $logfile