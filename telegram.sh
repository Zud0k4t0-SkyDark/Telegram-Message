#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

trap ctrl_c INT
function email(){
	echo -e "Hello World"
}

function ctrl_c (){
	echo -e "\n${redColour}[*]${endColour}${purpleColour}Saliendo...${endColour}"
	tput cnorm
	exit 1
}

function borrar(){

	if [ $respuesta == "y" ]; then
		echo -e "${endColour}\n\n${greenColour}Guardando Archivo config...${endColour}"
		continue
    elif  [ $respuesta == "n" ]; then
    	echo -e "${endColour}\n\n${redColour}Borrando Archivo config...${endColour}"
		rm -r -f config
	fi
}

function inicio (){
	clear
	if [ -e config ];then
		continue
	else
		echo -e "\n${redColour}[?]${endColour}Necesita el TOKEN, ID(chat)"
		echo -en "\n${yellowColour}[*]${endColour}TOKEN:\n\t${blueColour}==> ${endColour}" && read token
		echo -en "\n${yellowColour}[*]${endColour}ID(chat)\n\t${blueColour}==> ${endColour}" && read id
		echo $token >> config ; echo $id >> config
		echo -en "\n${redColour}[?]${endColour}Deseas Guardarlo Despues de la Ejecucion del Programa? ${blueColour}[y/n]${endColour}\n\t${blueColour}==> ${endColour}" && read respuesta
	fi
	clear
}


function help_Pannel(){
	echo -e "\n${blueColour}[*]${endColour}${redColour}+-+-+-+-+-+-+-Uso de la herramienta ./telegram.sh+-+-+-+-+-+-+-+-+${endColour}${blueColour}[*]${endColour}"
	echo -e "\n\t${greenColour}[*]${endColour}${yellowColour}---Envio de Mensajes de Telegram---${endColour}${greenColour}[*]${endColour}${purpleColour}\t[-m telegram]"
	echo -e "\n\t${greenColour}[*]${endColour}${yellowColour}---Envio de Mensajes de Gmail------${endColour}${greenColour}[*]${endColour}${purpleColour}\t[-m email]"

}

function root(){
	clear
	echo -e "\n${redColour}[?]${endColour} Si el Archivo esta en la carpeta root es mejor ser ROOT, pero si no es mejor ser no serlo ${redColour}[?]${endColour}"
	if [ "$(echo $UID)"  == '0' ]; then
		echo -e "\n${greenColour}[*]${endColour} Eres root\n"
	else
		echo -e "\n${redColour}[*]${endColour} No eres root\n"
		echo -e "\n${yellowColour}[?]${endColour} Es aconsejable mejor ser root para una mejor busqueda\n"
	fi
	sleep 8
	clear

}

function comprobar(){
	if [ "$(echo $?)" == 0 ]; then
		echo -e "\n\t${yellowColour}=======>${endColour}${greenColour} Enviado Correctamente ${endColour}${yellowColour}<=======${endColour}"
	else
		echo -e "\n\t${yellowColour}=======>${endColour}${redColour} No Enviado Correctamente ${endColour}${yellowColour}<=======${endColour}"
	fi
}


function claves(){
	token="$(cat config | grep ':')"
	id="$(cat config | grep ':' -A 1 | tail -n 1)"

}

function img(){
	ruta="$(find $HOME -type f -name image.png)"; echo "@"$ruta > foto
	url="https://api.telegram.org/bot$token/sendPhoto"
}

function envio(){
	echo -e "\n${greenColour}[*]${endColour}${blueColour} Que quieres enviar ${endColour}"
	echo -en "\n\t\t\t${redColour}[?]${endColour}${yellowColour}-+-+Document${greenColour}(D)${endColour}/${yellowColour}Message${greenColour}(M)${endColour}/${yellowColour}Image${greenColour}(I)${endColour}${yellowColour}+-+-${endColour}${redColour}[*]\n${endColour}${blueColour}==> ${endColour}"; tput cnorm && read m
}

function telegram(){
	claves
	while [ 1 == 1 ];do
		if [ $m == "D" ]; then
			tput civis
			root
			tput cnorm
			echo -en "\n${yellowColour}[*]${endColour} Nombre del Documento:\n${blueColour}==> ${endColour}" && read document; ruta="$(find $HOME -type f -name $document 2>/dev/null)"
			nombre_archivo="$(echo '@'$ruta)"
			url="https://api.telegram.org/bot$token/sendDocument"
			echo -e "\n\t${redColour}[*]${endColour}${blueColour} Enviando al Enlace:${endColour}\n\t\t${greenColour}==> ${endColour}${purpleColour} $url ${endColour}"
			echo -e "\n\t${redColour}[*]${endColour}${blueColour} Chat Id:${endColour}\n\t\t${greenColour}==> ${endColour}${purpleColour}$id${endColour}"
			echo -e "\n\t${redColour}[*]${endColour}${blueColour} Ruta del Documento:${endColour}\n\t\t${greenColour}==> ${endColour}${purpleColour}$ruta${endColour}"
			curl -s -X POST $url -F chat_id=$id -F document="$(echo $nombre_archivo)" > /dev/null 2>&1
			comprobar
			rm documento.txt 2>/dev/null
			break
		elif [ $m == "M" ] ; then
			clear
			echo -en "${yellowColour}[*]${endColour} Mensaje a enviar:\n${blueColour} ==> ${endColour}" && read mensaje
			url="https://api.telegram.org/bot$token/sendMessage"
			echo -e "\n\t${redColour}[*]${endColour}${purpleColour} Enviando al enlace${endColour}${blueColour} ==> ${endColour}$url"
			echo -e "\n\t${redColour}[*]${endColour}${purpleColour} Chat Id${endColour}${blueColour} ==> ${endColour}$id"
			echo -e "\n\t${redColour}[*]${endColour}${purpleColour} Mensaje${endColour}${blueColour} ==> ${endColour}$mensaje"
			curl -s -X POST $url -d chat_id=$id -d text="$(echo $mensaje)" > /dev/null  2>&1
			comprobar
			break
		elif [ $m == "I" ]; then
			clear
			echo -e "\n${yellowColour}[*]${endColour} Como Tomar la imagen: "
			echo -e "\n\t${redColour}[*]${endColour}${blueColour} Escritorio ${endColour}${yellowColour}(e)${endColour}"
			echo -e "\n\t${redColour}[*]${endColour}${blueColour} Propia Imagen ${endColour}${yellowColour}(p)${endColour}"
			echo -en "\n\t${redColour}[*]${endColour}${blueColour} Terminal ${endColour}${yellowColour}(t)${endColour}\n${blueColour}==> ${endColour}" && read imagen
			tput civis
			if [ $imagen == "e" ]; then
				clear
				echo -e "\n${yellowColour}[*]${endColour}Sacando Captura de la pantalla\n"
				scrot -d 4 -q 100  image.png > /dev/null 2>&1
				img
	            echo -e "\n${redColour}[*]${endColour}${purpleColour} Enviando al enlace${endColour}${blueColour} ==> ${endColour}$url\n${redColour}\n[*]${endColour}${purpleColour} Chat Id${endColour}${blueColour} ==> ${endColour}$id\n${redColour}\n[*]${endColour}${purpleColour} Ruta de la Imagen${endColour}${blueColour} ==> ${endColour}$(cat foto)\n"
	            curl -s -X POST $url -F chat_id=$id -F photo="$(cat foto)" > /dev/null 2>&1; rm foto 2>/dev/null; rm image.png 2>/dev/null
				comprobar
	            break
	        elif [ $imagen == "t" ]; then
	        	clear
	        	echo -e "\n${yellowColour}[*]${endColour} Sacando Captura de la Terminal\n"
	        	scrot -d 4 -q 100 -u image.png > /dev/null 2>&1
				img
                echo -e "\n${redColour}[*]${endColour}${purpleColour} Enviando al enlace${endColour}${blueColour} ==> ${endColour}$url\n${redColour}\n[*]${endColour}${purpleColour} Chat Id${endColour}${blueColour} ==> ${endColour}$id\n\n${redColour}[*]${endColour}${purpleColour} Ruta de la Imagen${endColour}${blueColour} ==> ${endColour}$(cat foto)\n"
                curl -s -X POST $url -F chat_id=$id -F photo="$(cat foto)" > /dev/null 2>&1 ; rm foto 2>/dev/null; rm image.png 2>/dev/null
				comprobar
                break
			elif [ $imagen == "p" ]; then
				clear
				tput cnorm
				echo -en "\n${yellowColour}[*]${endColour} Nombre del Archivo\n${blueColour}==> ${endColour}" && read foto;ruta="$(find $HOME -type f -name $foto)"
				name_archivo="$(echo @$ruta)"
				url="https://api.telegram.org/bot$token/sendPhoto"
				echo -e "\n\t${redColour}[*]${endColour}${purpleColour} Enviando al enlace${endColour}${blueColour} ==> ${endColour}$url\n\n\t${redColour}[*]${endColour}${purpleColour} Chat Id${endColour}${blueColour} ==> ${endColour}$id\n\n\t${redColour}[*]${endColour}${purpleColour} Ruta Archivo${endColour}${blueColour} ==> ${endColour}$name_archivo"
				curl -s -X POST  $url -F chat_id=$id -F photo="$(echo $name_archivo)" > /dev/null 2>&1
				comprobar
				break
			fi
		else
			clear
			envio
		fi
	done
}

parametro_contador=0;while getopts "m:h:" arg;do
	case $arg in
		m) modo=$OPTARG; let parametro_contador+=1;;
		h) hel_Pannel;;
	esac
done

tput civis

if [ $parametro_contador -eq 0 ]; then
	help_Pannel
	tput cnorm
else
	if [ "$(echo $modo)" == "telegram" ]; then
		inicio
		telegram
		borrar $respuesta 2>/dev/null
		tput cnorm
	elif [ "$(echo $modo)" == "email" ]; then
		mail
		tput cnorm
	fi
fi
