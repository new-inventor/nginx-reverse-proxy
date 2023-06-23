Build image
`docker build -t htpasswd ./infrastructure/htpasswd/`

- for full user line: 
`docker run -e PASS=123 -e USER=qwe htpasswd`
- for password only: 
`docker run -e PASS=123 htpasswd`
