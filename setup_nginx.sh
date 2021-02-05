mkdir -p /etc/nginx/conf.d
curl https://raw.githubusercontent.com/stevenfoong/kubernetes-assignment/main/default.conf -o /etc/nginx/conf.d/default.conf
cat > /etc/nginx/conf.d/wordpress.conf <<'endmsg'
server {
    listen 80;
    server_name wordpress.barehandsgame.com;

    location / {
        proxy_pass http://wordpress_upstream;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

upstream wordpress_upstream {
    server 10.128.0.37:30992 weight=3;
    server 10.128.0.35:30992;
	server 10.128.0.36:30992;
endmsg
