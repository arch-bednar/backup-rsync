#!/bin/bash
65;6003;1cos="BackUp"
function main(){
    OUTPUT="temp.txt"
    dialog --clear \
	   --title "$os" \
	   --backtitle "$os"\
	   --msgbox "Witaj w BackUp\nMasz 3 opcje do wyboru synchronizacji" 8 40
    
    dialog --clear \
	   --title "Ale najpierw podaj katalog który zsynchronizować" \
	   --backtitle "$os"\
	   --inputbox "Podaj katalog do synchronizacji" 10 40 2> $OUTPUT

   path=$(<$OUTPUT)
   NEXT=$?
    if [ "$NEXT" == 0 ]; then
        choice                                                                                                 
    elif [ "$NEXT" == 1 ]; then
        exit;
    else
        exit;
    fi
}

function choice(){
    dialog --clear\
           --title "$os" \
           --backtitle "$os"\
           --msgbox "Wybierz gdzie chcesz zsynchronizować zawartość" 7 40

    dialog --clear\
           --title "$os"\
           --backtitle "$os"\
           --menu "Gdzie chcesz zsynchronizować?" 10 40 3 1 "folder" 2 "dysk zewnętrzny" 3 "host" 2>$OUTPUT

    case $(<$OUTPUT) in
	1)
	    folder
	    ;;
	2)
	    dysk
	    ;;
	3)
	    byssh
	    ;;
	*) echo nic
    esac
}

function folder(){
    dialog --clear \
           --title "Podaj katalog który ma być zsynchronizowany" \
           --backtitle "$os"\
           --inputbox "Podaj katalog do synchronizacji" 10 40 2> $OUTPUT
    rsync -a --info=progres2 "$path" "$(<$OUTPUT)"
    zakonczono
}

function dysk(){
    dialog --clear \
           --title "Podaj punkt montowania dysku" \
           --backtitle "$os"\
           --inputbox "Podaj (tylko)punkt montowania dysku" 10 40 2> $OUTPUT
    temp=$(<$OUTPUT)
    #test=$(lsblk -o MOUNTPOINT | grep $(<$OUTPUT))
    if  test -d "$temp"; then #wymyślić sposób#lsblk -o MOUNTPOINT | grep $(<$OUTPUT); then
	dialog --clear \
	       --title "Podaj katalog na $temp"\
	       --backtitle "$os"\
	       --inputbox "Podaj katalog" 10 40 2> $OUTPUT
	rsync -a --info=progress2 "$path" "$temp/$(<$OUTPUT)"
	zakonczono
    else
	clear
	echo "Brak takiego katalogu"
    fi
}

function byssh(){
    dialog --clear\
           --title "Podaj hosta w formacie host@xxx.xxx.xxx.xxx"\
           --backtitle "$os"\
           --inputbox "Podaj hosta" 10 40 2> $OUTPUT
    host=$(<$OUTPUT)
    
    dialog --clear\
	   --title "Podaj katalog na hoscie"\
	   --backtitle "$os"\
	   --inputbox "Podaj katalog" 10 40 2> $OUTPUT
    dir=$(<$OUTPUT)

    rsync -a --info=progress2 "$path" "$host":"$dir"
    zakonczono

}

function zakonczono(){
    dialog --clear \
           --title "$os" \
	   --backtitle "$os"\
           --msgbox "Zakończono $os" 8 40
}

main
