# docker-postfix-mailgw
Simple postfix mail gateway 

# build

docker build -t postfix-mailqw .

# run
sudo docker run -p 25:25  \ 
  -e maildomain=mail.domain.com  
  -e smtp_user=user:pwd 
  -e mailrelay=smtp.domain.com 
  -e mynetwork=192.168.0.0/24  
  --name mailgw -d postfix-mailgw 
