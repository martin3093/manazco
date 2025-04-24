#!/bin/bash

# URL del endpoint
URL="https://crudcrud.com/api/dfb60b28cb354087869891e254c1c112/noticias"

# Contador de intentos
attempt=0

echo "Probando el endpoint: $URL"

while true; do
  # Incrementar el contador de intentos
  ((attempt++))

  # Realizar la solicitud con curl
  response=$(curl -s -o /dev/null -w "%{http_code}" -X GET "$URL")

  echo "Intento $attempt: Código de respuesta HTTP $response"

  # Verificar si el código de respuesta es un error 4xx
  if [[ $response == 4* ]]; then
    echo "Se recibió un código de error 4xx: $response"
    break
  fi

  # Esperar 1 segundo antes del siguiente intento
  sleep 0.5
done