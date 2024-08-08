#!/bin/bash

# Define o IP para SCAN
network=172.16.1

# Portas para bater (port knocking)
ports=(13 37 30000 3000 1337)

echo "Iniciando a varredura na rede $network.0/24"

for ip in {1..254}; do
    target_ip="$network.$ip"
    echo "Verificando o IP: $target_ip"
    
    for port in "${ports[@]}"; do
        sudo hping3 -S -p $port -c 1 $target_ip > /dev/null 2>&1
        
        if [ $? -eq 0 ]; then
            echo "Porta $port está aberta no IP $target_ip"
        fi
    done
    
    curl -s -o /dev/null -w "%{http_code}" http://$target_ip:1337
    if [ $? -eq 0 ]; then
        echo "Servidor HTTP encontrado no IP $target_ip na porta 1337"
    fi
done

echo "Varredura concluída."
