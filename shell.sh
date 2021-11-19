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

# Corpo principal do script

echo " ------------ Menu ------------ "
echo "1 - adicionar usuário"
echo "2 - remover usuário"

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
        read -p "Nome do usuário: " USER

        echo "Removendo $USER ..."

        remove_user $USER
        REMOVEUSER_RETURN_CODE=$?
        if [ $REMOVEUSER_RETURN_CODE -eq 0 ]; then
            echo "Usuário $USER removido com sucesso!"
        else
            echo "Erro ao remover usuário $USER"
        fi
        ;;
    *)
        echo "Opção inválida"
        ;;
esac

exit 1