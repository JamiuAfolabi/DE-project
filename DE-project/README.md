# DE-project
This is a data engineering project

A network was created to connect dockers container with the script below
      docker network create pg-network
      
A postgres docker container was instantiated with the script below.
  docker run -it -d \
      -e POSTGRES_USER="ny_taxi" \
      -e POSTGRES_PASSWORD="password" \
      -e POSTGRES_DB="ny_taxi" \
      -v $(pwd):/var/lib/postgresql/data \
      -p 5432:5432 \
      postgres:alpine
      
A pgadmin was instantiated with the script below
    docker run -it \
      -e PGADMIN_DEFAULT_EMAIL="jmoh.tunde@gmail.com" \
      -e PGADMIN_DEFAULT_PASSWORD="root" \
      -p 8080:80 \
      --network pg-network \
      --name pg_admin \
    dpage/pgadmin4
