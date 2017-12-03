#!/usr/bin/env bash

echo "**************"
echo "UPDATE CIVICRM"
echo "**************"

#! http://wiki.civicrm.org/confluence/display/CRMDOC/Drupal+CiviCRM+upgrade+script+based+on+drush
#! https://civicrm.stackexchange.com/questions/4829/is-it-easy-to-upgrade-civicrm-using-drush

#! execute cron.
drush core-cron

#! clear cache.
drush cc all
drush cc civicrm

#! Check Drupal variables assigned to civicrm.
#drush vget civicrm

#! Install CiviCRM theme?
# drush dl tao rubik
# drush pm-enable tao rubik
# drush eval 'variable_set("civicrmtheme_theme_admin", "rubik")';

#! Backup CiviCRM database.
#drush civicrm-sql-dump --result-file=./civicrm.sql

#! Backup Drupal database.
#drush sql-dump --result-file=./drupal.sql

#! Take the Site Offline (for production site upgrades).
drush vset maintenance_mode 1

#! Disable all CiviCRM integration / extension modules.
#drush dis -y civicrm_cron

#! Delete all previous version code files.
rm -rf sites/all/modules/contrib/civicrm

#! Delete CiviCRM temp files.
rm -rf sites/default/files/civicrm/templates_c/*
chown -R 1000:www-data sites/default/files/civicrm/templates_c
chmod -R 775 sites/default/files/civicrm/templates_c

#! Unpack the latest package and verify permissions.
civiVersion=4.7.27

curl -L "https://download.civicrm.org/civicrm-$civiVersion-drupal.tar.gz" -o civicrm.tar.gz
tar -xf civicrm.tar.gz -C sites/all/modules/contrib/
rm -rf civicrm.tar.gz
chown -R 1000:www-data sites/all/modules/contrib/civicrm/
chmod -R 775 sites/all/modules/contrib/civicrm/

#! Commit CiviCRM to GIT.
git add sites/all/modules/contrib/civicrm
git commit -m "Downloaded CiviCRM $civiVersion." --quiet

#! Unpack CiviCRM language(s).
curl -L "https://download.civicrm.org/civicrm-$civiVersion-l10n.tar.gz" -o civicrm-l10n.tar.gz
mkdir sites/all/modules/contrib/civicrm/l10n
tar -xf civicrm-l10n.tar.gz -C sites/all/modules/contrib/
rm -rf civicrm-l10n.tar.gz

#! Commit CiviCRM l10n to GIT.
git add sites/all/modules/contrib/civicrm
git commit -m "Downloaded CiviCRM l10n $civiVersion." --quiet

#! Update CiviCRM db.
drush civicrm-upgrade-db

#! Enable all CiviCRM integration / extension modules.
#drush en -y civicrm_cron

#! Site Online.
drush vset maintenance_mode 0

#! THE END.
echo "******************"
echo "that's all folks!!"
echo "******************"
