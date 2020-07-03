#!/bin/bash
#archivos creados con la informacion en extencion .txt
OUTFILE="usePhone-stats.txt" #3problema
OUTFILE1="metrics.txt"       #1problema
OUTFILE2="evacuation.txt"    #2problema
#


# USO SCRIPT, se crea con el fin de analizar datos especificos de un directorio. este conlleva parametros los cuales hacen 
# referencia al directorio y se utiliza:
#uso: ./stats.sh -d <director> [-h] 
# -d:directorio donde estan los datos a procesar
# -h:muestra este mensaje y termina de procesar este parametro.
usoScript(){
	echo "Uso: $0 -d search_dir [-h] "
	exit
}
#

# Problema Numero 3
# Determinar el promedio de los usos de tiempo del telefomno movil.
# 
#los resultados del siguente archivo sera: usePhone-stats.txt con la siguiente estructura
#			timestamp:promedio:min:max
#
#
promedioTelefonosMoviles(){
	
	# Se realiza una búsqueda recursiva en el directorio ingresado de todos
	# los archivos usePhone-*.txt
	usePhoneFiles=(`find $searchDir -name '*usePhone-*.txt' -print | sort `)


	#idea: crear un archivo en donde las columna i-ésima representen la cantidad de personas 
	#      que utilizan el teléfono en el instante t=10i.
	#      Luego, procesar cada columna para calcular las estadísticas solicitadas


	tmpFile="fracaso.txt"> $tmpFile

	for i in ${usePhoneFiles[*]}; 
	do	
		printf "> %s\n" $i
		tiempos=(`cat $i | tail -n+3 | cut -d ':' -f 3`)
		for i in ${tiempos[*]};
		do
			printf "%d:" $i >> $tmpFile
		done
		printf "\n" >> $tmpFile
	done 

	#Determinar el total de columnas a procesar
		#Sacar la primera linea			: head -1 $tmpFile
		#eliminar el último caracter	: sed 's/.$//' 
		#cambiar todos los ':' por '\n'	: tr ':' '\n'
		#contar las líneas				: wc -l

	totalFields=$(head -3 $tmpFile | sed 's/.$//' | tr ':' '\n'| wc -l)> $OUTFILE
	# el archivo tiene una linea de cabecera, que comienza con '#'
	printf "#timestamp:promedio:min:max\n" >> $OUTFILE
	for i in $(seq 1 $totalFields); do
		out=$(cat $tmpFile | cut -d ':' -f $i |\
			awk 'BEGIN{ min=2**63-1+2; max=0}\
				#{if($1<min){min=$1};if($1>max){max=$1};total+=$1;if($1>-1){ count+=1};}\
				{if($1<min && $1>-1){min=$1};if($1>max){max=$1};total+=$1;if($1>-1) {count+=1};}\
				END {print total":"total/count":"min":"max}')
            
		printf "$out\n" >> $OUTFILE
	done

	rm $tmpFile
}
# Problema Numero 1
# DEterminar promedio de las siguentes Metricas de desempeño
# Tiempo de simulador, suma de 3 campos timeExemakeage+tieexelcal+timeeeecsim.
# Memoria utilizada por el simulador.
# los resultados del archivo sera: archivo metrics.txt con la siguiente estructura
#			TsimTotal:promedio:min:max ,campo (6,7,8)
#           MemUsed:promedio:maxn:min ,campo (9)
#
# fin promedio telefonos.

promedioMetrics(){

	#idea: crear un archivo en donde las columna i-ésima representen la cantidad de personas 
	#      que utilizan el teléfono en el instante t=10i.
	#      Luego, procesar cada columna para calcular las estadísticas solicitadas
    # Trabajo para sobtener datos de algun campo especifico

    usesFiles1=(`find $searchDir -name '*executionSummary-*.txt' -print | sort `)

	tmpFile1="1234.txt" > $tmpFile1
	tmpFile2="12344.txt" > $tmpFile2
	for i in ${usesFiles1[*]}; 
	do	
		printf "> %s\n" $i
		tiempos1=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{sum=0}{sum=$6+$7+$8} END{print sum}')
		for i in ${tiempos1[*]};
		do
			printf "%d:" $i >> $tmpFile2
		done
		printf "\n" >> $tmpFile2
	done 

    totalFields1 =$(head -3 $tmpFile1 | sed 's/.$//' | tr ':' '\n'| wc -l) > $OUTFILE1  
    totalFields2 =$(head -3 $tmpFile2 | sed 's/.$//' | tr ':' '\n'| wc -l) > $OUTFILE1  
	for i in ${usesFiles1[*]}; 
	do	
		printf "> %s\n" $i
		tiempos=(`cat $i | tail -n+2 | cut -d ':' -f 9`)
		for i in ${tiempos[*]};
		do
			printf "%d:" $i >> $tmpFile1
		done
		printf "\n" >> $tmpFile1
       
	done 

    ######En esta parte se imprime todo lo contenido en out1 el cual tiene el contenido de $tmpFile2,$tmpFile1 
    printf "tsimTotal:promedio:max:min\n" >> $OUTFILE1
	for i in $(seq 1 $totalFields1); do
        out1=$(cat $tmpFile2 | cut -d ':' -f $i |\
          		awk 'BEGIN{ min=2**63-1; max=0}\
				{if($1<min && $1>1){min=$1};if($1>max){max=$1};total+=$1;if($1>1) {count+=1};}\
				END {print total":"total/count":"max":"min}')

        printf "$out1\n" >> $OUTFILE1
	done

	
	printf "#MemUsed:promedio:max:min\n" >> $OUTFILE1
	for i in $(seq 1 $totalFields2); do
	    out=$(cat $tmpFile1 | cut -d ':' -f $i |\
			    awk 'BEGIN{ min=2**63-1; max=0}\
				{if($1<min && $1>1){min=$1};if($1>max){max=$1};total+=$1;if($1>1) {count+=1};}\
				END {print total":"total/count":"max":"min}')
		printf "$out\n" >> $OUTFILE1
       
	done
	rm $tmpFile1
	rm $tmpFile2
}
# Problema Numero 2
# los resultados del archivo sera : evacuacion.txt, el cual calcula el promedio de las evacuaciones, el min y max 
# para los siguentes grupos de personas.
#Salida: archivo evacuacion.txt con la siguiente estructura
#			alls:promedio:min:max 
#           residents:promedio:min:max 
#           visitorsI:promedio:min:max 
#           residents-G0:promedio:min:max 
#           residents-G1:promedio:min:max 
#           residents-G2:promedio:min:max 
#           residents-G3:promedio:min:max
#           visitorsI-G0:promedio:min:max 
#           visitorsI-G1:promedio:min:max 
#           visitorsI-G2:promedio:min:max 
#           visitorsI-G3:promedio:min:max  
#            
#
#Modificar
promedioEvacuacion(){

    usesFiles1=(`find $searchDir -name '*summary-*.txt' -print | sort `)
    #pasa la lista de cada campo seleccionado en la parte de abajo
	all="all.txt" > $all
    all1="all1.txt" > $all1
	all11="all11.txt" > $all11
    all4="all4.txt" > $all4
    all5="all5.txt" > $all5
    all6="all6.txt" > $all6
    all7="all7.txt" > $all7
    all8="all8.txt" > $all8
    all9="all9.txt" > $all9
    all10="all10.txt" > $all10
    all12="all12.txt" > $all12

    #
    
    totalFields12 =$(head -1 $all12 | sed 's/.$//' | tr ':' '\n'| wc -l) > $OUTFILE2
    totalFields10 =$(head -1 $all10 | sed 's/.$//' | tr ':' '\n'| wc -l) > $OUTFILE2 
    totalFields9 =$(head -1 $all9 | sed 's/.$//' | tr ':' '\n'| wc -l) > $OUTFILE2 
    totalFields8 =$(head -1 $all8 | sed 's/.$//' | tr ':' '\n'| wc -l) > $OUTFILE2 
    totalFields7 =$(head -1 $all7 | sed 's/.$//' | tr ':' '\n'| wc -l) > $OUTFILE2 
    totalFields6 =$(head -1 $all6 | sed 's/.$//' | tr ':' '\n'| wc -l) > $OUTFILE2 
    totalFields5 =$(head -1 $all5 | sed 's/.$//' | tr ':' '\n'| wc -l) > $OUTFILE2 
    totalFields4 =$(head -1 $all4 | sed 's/.$//' | tr ':' '\n'| wc -l) > $OUTFILE2 
    totalFields3 =$(head -1 $all11 | sed 's/.$//' | tr ':' '\n'| wc -l) > $OUTFILE2 
	totalFields2 =$(head -1 $all1 | sed 's/.$//' | tr ':' '\n'| wc -l) > $OUTFILE2 
    totalFields1 =$(head -1 $all | sed 's/.$//' | tr ':' '\n'| wc -l) > $OUTFILE2 

    # parte donde se pasa su tarea en funcion a lo entregado
    ################################################1|############################################(ALL)
	for i in ${usesFiles1[*]}; 
	do	
		printf "> %s\n" $i
		evacAll=(`cat $i | tail -n+2 | cut -d ':' -f 8 > all;`)

	done 
    ################################################2|############################################(r)
    for i in ${usesFiles1[*]}; 
	do	

		printf "> %s\n" $i
		evacAll1=(`cat $i | tail -n+2 | awk -F ':' '$3 == 0' | cut -d ':' -f 8 > all1;`)
       
	done
    ################################################3|############################################(visitorsI)
      for i in ${usesFiles1[*]}; 
	do	

		printf "> %s\n" $i
		evacAll7=(`cat $i | tail -n+2 | awk -F ':' '$3 == 1' | cut -d ':' -f 8 > all7;`)
       
	done 
    ################################################4|############################################ (rGO)

	 for i in ${usesFiles1[*]}; 
	do	

		printf "> %s\n" $i
		evacAll12=(`cat $i | tail -n+2 | awk -F ':' '$3 == 0' | awk -F ':' '$4 == 0' | cut -d ':' -f 8 > all11;`)
       
	done 
    ################################################5|############################################(rG1)
     for i in ${usesFiles1[*]}; 
	do	

		printf "> %s\n" $i
		evacAll4=(`cat $i | tail -n+2 | awk -F ':' '$3 == 0' | awk -F ':' '$4 == 1' | cut -d ':' -f 8 > all4;`)
       
	done 
    ################################################6|############################################(rG2)
      for i in ${usesFiles1[*]}; 
	do	

		printf "> %s\n" $i
		evacAll5=(`cat $i | tail -n+2 | awk -F ':' '$3 == 0' | awk -F ':' '$4 == 2' | cut -d ':' -f 8 > all5;`)
       
	done 
    ################################################7|############################################(rG3)
      for i in ${usesFiles1[*]}; 
	do	

		printf "> %s\n" $i
		evacAll6=(`cat $i | tail -n+2 | awk -F ':' '$3 == 0' | awk -F ':' '$4 == 3' | cut -d ':' -f 8 > all6;`)
       
	done 
    
    ################################################8|############################################(visitanteI-G0)
      for i in ${usesFiles1[*]}; 
	do	

		printf "> %s\n" $i
		evacAll8=(`cat $i | tail -n+2 | awk -F ':' '$3 == 1' | awk -F ':' '$4 == 0' | cut -d ':' -f 8  > all8;`)
       
	done 
    ################################################9|############################################(visitanteI-G1)
      for i in ${usesFiles1[*]}; 
	do	

		printf "> %s\n" $i
		evacAll9=(`cat $i | tail -n+2 | awk -F ':' '$3 == 1' | awk -F ':' '$4 == 1' | cut -d ':' -f 8  > all9;`)
       
	done 
    ################################################10|############################################(visitanteI-G2)
      for i in ${usesFiles1[*]}; 
	do	

		printf "> %s\n" $i
		evacAll10=(`cat $i | tail -n+2 | awk -F ':' '$3 == 1' | awk -F ':' '$4 == 2' | cut -d ':' -f 8  > all10;`)
       
	done 
    ################################################11|############################################(visitanteI-G3)
      for i in ${usesFiles1[*]}; 
	do	

		printf "> %s\n" $i
		evacAll12=(`cat $i | tail -n+2 | awk -F ':' '$3 == 1' | awk -F ':' '$4 == 3' | cut -d ':' -f 8  > all12;`)
       
	done 

     
    
    #PRINT
    ################################################1|############################################
	printf "alls:promedio:max:min\n" >> $OUTFILE2
	for i in $(seq 1 $totalFields1); do
	    out3=$(cat all | cut -d ':' -f $i |\
			    awk 'BEGIN{ min=2**63-1; max=0}\
				{if($1<min){min=$1};if($1>max){max=$1};total+=$1;count+=1;}\
				END {print total":"total/count":"max":"min}')
		printf "$out3\n" >> $OUTFILE2
	done
        ################################################2|############################################
   
	printf "Residents:promedio:max:min\n" >> $OUTFILE2
	for i in $(seq 1 $totalFields2); do
	    out2=$(cat all1 | cut -d ':' -f $i |\
			    awk 'BEGIN{ min=2**63-1; max=0}\
				{if($1<min){min=$1};if($1>max){max=$1};total+=$1;count+=1;}\
				END {print total":"total/count":"max":"min}')
		printf "$out2\n" >> $OUTFILE2
	done
	################################################3|############################################
    	printf "visitante I:promedio:max:min\n" >> $OUTFILE2

	for i in $(seq 1 $totalFields7); do
	    out9=$(cat all7 | cut -d ':' -f $i |\
			    awk 'BEGIN{ min=2**63-1; max=0}\
				{if($1<min){min=$1};if($1>max){max=$1};total+=$1;count+=1;}\
				END {print total":"total/count":"max":"min}')
		printf "$out9\n" >> $OUTFILE2
	done
    ################################################4|############################################


	printf "Residents-G0:promedio:max:min\n" >> $OUTFILE2
	for i in $(seq 1 $totalFields3); do
	    out5=$(cat all11 | cut -d ':' -f $i |\
			    awk 'BEGIN{ min=2**63-1; max=0}\
				{if($1<min){min=$1};if($1>max){max=$1};total+=$1;count+=1;}\
				END {print total":"total/count":"max":"min}')
		printf "$out5\n" >> $OUTFILE2
	done
	################################################5|############################################
    printf "Residents-G1:promedio:max:min\n" >> $OUTFILE2
	for i in $(seq 1 $totalFields4); do
	    out6=$(cat all4 | cut -d ':' -f $i |\
			    awk 'BEGIN{ min=2**63-1; max=0}\
				{if($1<min){min=$1};if($1>max ){(max=$1)};if($1>3000){printf ""$1};total+=$1;count+=1;}\
				END {print total":"total/count":"max":"min}')
		printf "$out6\n" >> $OUTFILE2
    done
    ################################################6|############################################
      printf "Residents-G2:promedio:max:min\n" >> $OUTFILE2
	for i in $(seq 1 $totalFields5); do
	    out7=$(cat all5 | cut -d ':' -f $i |\
			    awk 'BEGIN{ min=2**63-1; max=0}\
				{if($1<min){min=$1};if($1>max){max=$1};total+=$1;count+=1;}\
				END {print total":"total/count":"max":"min}')
		printf "$out7\n" >> $OUTFILE2
	done
    
	################################################7|############################################
    	#printf "Residents-G3:promedio:max:min\n" >> $OUTFILE2

	for i in $(seq 1 $totalFields6); do
	    out8=$(cat all6 | cut -d ':' -f $i |\
			    awk 'BEGIN{ min=2**63-1; max=0}\
				{if($1<min){min=$1};if($1>max){max=$1};total+=$1;count+=1;}\
				END {print total":"total/count":"max":"min}')
		printf "$out8\n" >> $OUTFILE2
	done
    ################################################8|############################################
    	#printf "visitanteI-G0:promedio:max:min\n" >> $OUTFILE2

	for i in $(seq 1 $totalFields8); do
	    out10=$(cat all8 | cut -d ':' -f $i |\
			    awk 'BEGIN{ min=2**63-1; max=0}\
				{if($1<min){min=$1};if($1>max){max=$1};total+=$1;count+=1;}\
				END {print total":"total/count":"max":"min}')
		printf "$out10\n" >> $OUTFILE2
	done
    
	################################################9|############################################
    	printf "visitanteI-G1:promedio:max:min\n" >> $OUTFILE2

	for i in $(seq 1 $totalFields9); do
	    out11=$(cat all9 | cut -d ':' -f $i |\
			    awk 'BEGIN{ min=2**63-1; max=0}\
				{if($1<min){min=$1};if($1>max){max=$1};total+=$1;count+=1;}\
				END {print total":"total/count":"max":"min}')
		printf "$out11\n" >> $OUTFILE2
	done
    ################################################10|############################################
    	printf "visitanteI-G2:promedio:max:min\n" >> $OUTFILE2

	for i in $(seq 1 $totalFields10); do
	    out12=$(cat all10 | cut -d ':' -f $i |\
			    awk 'BEGIN{ min=2**63-1; max=0}\
				{if($1<min){min=$1};if($1>max){max=$1};total+=$1;count+=1;}\
				END {print total":"total/count":"max":"min}')
		printf "$out12\n" >> $OUTFILE2
	done
    ################################################11|############################################
   	printf "visitanteI-G3:promedio:max:min\n" >> $OUTFILE2

    for i in $(seq 1 $totalFields12); do
	    out13=$(cat all12 | cut -d ':' -f $i |\
			    awk 'BEGIN{ min=2**63-1; max=0}\
				{if($1<min){min=$1};if($1>max){max=$1};total+=$1;count+=1;}\
				END {print total":"total/count":"max":"min}')
		printf "$out13\n" >> $OUTFILE2
	done


    #rm remover archvos *.txt
    rm $all
    rm $all1
    rm all
    rm all1
    rm $all11
    rm all11
    rm $all4
    rm all4
    rm $all5
    rm all5
    rm $all6
    rm all6
    rm $all7
    rm all7
    rm $all8
    rm all8
    rm $all9
    rm all9
    rm $all10
    rm all10
    rm $all12
    rm all12
}
#
# MAIN
#
#opciones de parametro de scrip
# si es un directorio se utiliza stats.sh -d <directorio>
while getopts "d:h" opt; do
  case ${opt} in
    d ) 
		searchDir=$OPTARG
      ;;
    h )
		usoScript
      ;;
    \? ) 
		usoScript
      ;;
  esac
done
shift $((OPTIND -1))

if [ -z $searchDir ]; then
	usoScript
fi
#se define un if para el parametro -d, para mostrar cuando el directorio es distinto a los establecido por el scrips.
if [ ! -d $searchDir ]; then
        echo "$searchDir no es un directorio"
        exit
fi

printf "Directorio busqueda: %s\n" $searchDir


#cada promedio indica la llamada de dicha funcion, los cuales sacara el promedio,max y min.
promedioTelefonosMoviles
promedioMetrics
promedioEvacuacion
