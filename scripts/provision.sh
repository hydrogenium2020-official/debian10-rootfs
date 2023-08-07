#!/bin/bash
set -eu

cd "$(dirname "$0")" 

cat << EOF > /usr/sbin/policy-rc.d
#!/bin/sh

# For most Docker users, "apt-get install" only happens during "docker build",
# where starting services doesn't work and often fails in humorous ways. This
# prevents those failures by stopping the services from attempting to start.

exit 101
EOF
chmod 755 /usr/sbin/policy-rc.d

apt-get update

LOCALE=${1:-en_US.UTF-8}

# Setup locale
cat <<EOF > /etc/default/locale
LANG="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_ALL="en_US.UTF-8"
EOF

echo "locales locales/default_environment_locale select $LOCALE" | debconf-set-selections
echo "locales locales/locales_to_be_generated multiselect $LOCALE UTF-8" | debconf-set-selections
apt-get install -y locales
dpkg-reconfigure --frontend noninteractive locales


apt-get install -y curl

# Crete a random temporary directory
TMP_DIR=$(mktemp -d)

LATEST_URL="https://github.com/KindOS-workspace/system-profile/releases/latest/download/debian12_requirements.txt"
curl -sL $LATEST_URL -o $TMP_DIR/requirements.txt

REQUIRE_PACKAGES=$(grep -vE '^\s*#' $TMP_DIR/requirements.txt)

apt-get update
apt-get install -y $REQUIRE_PACKAGES


apt-get clean
rm -rf /var/lib/apt/lists/*