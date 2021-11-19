add_a_user()
{
  USER=$1
  shift; shift
  # descarta os dois primeiros parametros
  COMMENTS=$@
  
  useradd $USER
  if [ "$?" -ne "0" ]; then
    echo "Falha ao tentar adicionar usuário"
    return 1
  fi

  passwd $USER
  if [ "$?" -ne "0" ]; then
    echo "Erro ao tentar definir senha"
    return 2
  fi

  return 0
}

add_a_group()
{
  GROUP=$1
  
  groupadd $GROUP
  if [ "$?" -ne "0" ]; then
    echo "Falha ao tentar adicionar grupo"
    return 1
  fi

  return 0
}

remove_user()
{
    USER=$1
    userdel $USER
    if [ "$?" -ne "0" ]; then
        echo "Falha ao tentar remover usuário"
        return 1
    fi
    
    return 0
}

remove_group()
{
    GROUP=$1
    groupdel $GROUP

    if [ "$?" -ne "0" ]; then
        echo "Falha ao tentar remover grupo"
        return 1
    fi
    
    return 0
}

change_user()
{
    USER=$1
    ARQ_NAME=$2

    chown $USER $ARQ_NAME

    if [ "$?" -ne "0" ]; then
        echo "Falha ao modificar dono do arquivo"
        return 1
    fi
    
    return 0
}

change_group()
{
    GROUP=$1
    ARQ_NAME=$2

    chgrp $GROUP $ARQ_NAME

    if [ "$?" -ne "0" ]; then
        echo "Falha ao modificar grupo dono do arquivo"
        return 1
    fi
    
    return 0
}

# Corpo principal do script

echo " ------------ Menu ------------ "
echo "1 - adicionar usuário"
echo "2 - adicionar grupo"
echo "3 - remover usuário"
echo "4 - remover grupo"
echo "5 - modificar o dono de um arquivo ou diretório"
echo "6 - modificar o grupo dono de um arquivo ou diretório"

read -p "Opção: " OPTION

case $OPTION in
    1)
        read -p "Insira um nome do usuário: " USER
        
        echo "Adicionando '$USER' ..."

        add_a_user $USER Novo user
        ADDUSER_RETURN_CODE=$?
        if [ $ADDUSER_RETURN_CODE -eq 0 ]; then
            echo "Usuário $USER adicionado com sucesso!"
        else
            echo "Erro ao adicionar usuário $USER"
        fi
        
        ;;

    2)
        read -p "Insira um nome de grupo: " GROUP
        
        echo "Adicionando '$GROUP' ..."

        add_a_group $GROUP 
        ADDGROUP_RETURN_CODE=$?
        if [ $ADDGROUP_RETURN_CODE -eq 0 ]; then
            echo "Grupo $GROUP adicionado com sucesso!"
        else
            echo "Erro ao adicionar grupo $GROUP"
        fi
        
        ;;
    3)
        read -p "Insira o nome do usuário: " USER

        echo "Removendo $USER ..."

        remove_user $USER
        REMOVEUSER_RETURN_CODE=$?
        if [ $REMOVEUSER_RETURN_CODE -eq 0 ]; then
            echo "Usuário $USER removido com sucesso!"
        else
            echo "Erro ao remover usuário $USER"
        fi
        ;;

    4)
        read -p "Insira o nome do grupo: " GROUP
        echo "Removendo $GROUP ... "

        remove_group $GROUP
        REMOVEGROUP_RETURN_CODE=$?
        if [ $REMOVEGROUP_RETURN_CODE -eq 0 ]; then
            echo "Grupo $GROUP removido com sucesso!"
        else
            echo "Erro ao remover grupo $GROUP"
        fi
        ;;

    5)
        read -p "Insira o nome do usúario: " USER
        read -p "Insira o nome do arquivo: " ARQ_NAME
        echo "Modificando o dono de $ARQ_NAME ..."
        change_user $USER $ARQ_NAME
        CHANGE_U_RETURN_CODE=$?

        if [ $CHANGE_U_RETURN_CODE -eq 0 ]; then
            echo "Dono de $ARQ_NAME modificado com sucesso!"
        else
            echo "Erro ao modificar dono de $ARQ_NAME"
        fi
        ;;

    6)
        read -p "Insira o nome do grupo: " GROUP
        read -p "Insira o nome do arquivo: " ARQ_NAME
        echo "Modificando o grupo dono de $ARQ_NAME ..."
        change_group $GROUP $ARQ_NAME
        CHANGE_G_RETURN_CODE=$?

        if [ $CHANGE_G_RETURN_CODE -eq 0 ]; then
            echo "Dono de $ARQ_NAME modificado com sucesso!"
        else
            echo "Erro ao modificar dono de $ARQ_NAME"
        fi
        ;;
    *)
        echo "Opção inválida"
        ;;
esac

exit 1