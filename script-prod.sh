# Obtenemos el listado de servidores de BD de producción
az_servers=$(az postgres flexible-server list --output json --query "[? contains(resourceGroup,'PROD')].{NAME_SERVER: name, RESOURCE_GROUP: resourceGroup}")
    for row in $(echo "${az_servers}" | jq -r '.[] | @base64'); do
        _jq() {
            echo ${row} | base64 -d | jq -r ${1}
        }

        name_server=$(_jq '.NAME_SERVER')
        resource_group=$(_jq '.RESOURCE_GROUP')

        echo "Iniciando el servidor: ${name_server} en el grupo de recursos: ${resource_group}"

        # Ejecuta el comando para iniciar el servidor
        az postgres flexible-server start --resource-group "${resource_group}" --name "${name_server}" --no-wait
        echo "======================================================================================================================"
        echo "El servidor ${name_server} ha sido iniciado."
        echo "======================================================================================================================"
    done

