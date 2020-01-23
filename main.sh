#!/bin/bash

chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

echo '[+] Starting mysql...'
service mysql start

echo '[+] Starting NGINX Unit'
service unit start

sleep 5

cat <<-EOF > /tmp/unit-php.json
{ 
  "applications": {
    "ergast": {
      "type": "php",
      "processes": 2,
      "root": "/var/www/html/php/api/",
      "script": "index.php",
      "user": "www-data",
      "group": "www-data",
      "options": {
        "file": "/var/www/html/php.ini",
        "admin": {
            "memory_limit": "256M",
            "variables_order": "EGPCS",
            "expose_php": "1"
        },
        "user": {
            "display_errors": "1"
        }
      }
    }
  },
  "listeners": {
    "*:80": {
      "pass": "routes"
    }
  },
  "routes": [
    {
      "match": {
        "uri": [ "/api/*" ]
      },
      "action": {
       "pass": "applications/ergast"
      }
    },
    {
      "action": {
        "share": "/var/www/html"
      }
    }
  ],
  "access_log": "/var/log/unit_access.log",
  "settings": {
    "http": {
      "static": {
        "mime_types": {
          "application/javascript": [ 
            ".js"
          ],
          "text/css": [
            ".css"
          ],
          "image/png": [
            ".png"
          ],
          "image/x-icon": [
            ".ico"
          ]
        }
      }
    }
  }
}
EOF

curl -X PUT --data-binary @/tmp/unit-php.json --unix-socket \
       /var/run/control.unit.sock http://localhost/config/

while true
do
    tail -f /var/log/unit_access.log
    exit 0
done
