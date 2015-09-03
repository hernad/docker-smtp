#!/bin/bash

# supervisor
cat > /etc/supervisor/conf.d/supervisord.conf <<EOF
[supervisord]
nodaemon=true

[program:postfix]
command=/opt/postfix.sh

[program:rsyslog]
command=/usr/sbin/rsyslogd -n -c3
EOF

#  postfix
cat >> /opt/postfix.sh <<EOF
#!/bin/bash
service postfix start
tail -f /var/log/mail.log
EOF

# postfix settings
chmod +x /opt/postfix.sh
postconf -e myhostname=$maildomain
postconf -F '*/*/chroot = n'
postconf -e mydestination=$maildomain, localhost.localdomain, localhost
postconf -e relayhost=$mailrelay
postconf -e smtp_sasl_auth_enable=yes
postconf -e smtp_sasl_password_maps=hash:/etc/postfix/sasl_passwd
postconf -e smtp_sasl_security_options=
postconf -e mynetworks="$mynetwork 127.0.0.0/8 172.17.0.0/16 [::1]/128 [fe80::]/64"
echo "$mailrelay  $smtp_user" > /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd
postfix reload
