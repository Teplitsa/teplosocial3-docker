#!/bin/bash

cd /site/wordpress/wp-content/themes/teplosocial-backend

composer install

cd /site/wordpress

# Update mongo cache
wp tps_cache update_advantage_list --allow-root
wp tps_cache update_certificate_list --allow-root
wp tps_cache update_course_list --allow-root
wp tps_cache update_stats --allow-root
wp tps_cache update_tag_list --allow-root
wp tps_cache update_testimonial_list --allow-root
wp tps_cache update_track_list --allow-root
wp tps_cache update_user_progress_list --allow-root

# Create mysql custom table for notifications microservice
wp tps_notifications create_schema --allow-root

php-fpm