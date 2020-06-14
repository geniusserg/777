last=0
a=0
b=0
c=0

function fl(){
    while read LINE
        do echo $LINE
    done < $1
}

function result(){
    for i in $a $b $c
    do
        echo -ne '\007'
        fl "nums/$i.txt"
        sleep 1
    done
    if [[ "$a" == "$b" ]] && [[ "$c" == "$b" ]] && [[ "$a" == "$c" ]]; then
        eog /tmp/ruletka/win.jpg
    else
        eog /tmp/ruletka/lose.jpg
    fi
    a=0
    b=0
    c=0
}

function generate(){
    rdint
    psb=$?
    if [ 2 -ge $psb ]; then
        if [ "$last" = "3" ]; then
            fault
            last=0
        else
            win
            let "last += 1"
        fi
    else
        fault
        last=0
    fi
}

function win(){
    rdint
    rndnums=$?
    a=$rndnums
    b=$rndnums
    c=$rndnums
}

function fault(){
    while  [[ "$a" == "$b" ]] && [[ "$c" == "$b" ]] && [[ "$a" == "$c" ]]
    do
        rdint
        a=$? 
        rdint   
        b=$? 
        rdint   
        c=$? 
    done
}

function rdint(){
    RND=$RANDOM
    return $(( $RND % 10 ))
}


function shuffle(){
    for i in {1..10}
    do  
        clear
        echo -ne '\007'
        rdint
        fl "nums/$?.txt"
    done
    clear
    
}

function herewego(){
    for i in 0 1 2
    do
        clear
        fl "graph/hwgo$i.txt"
        sleep 0.5
    done
    clear
}

function interrup(){
    clear
    herewego
    sleep 1
    clear
	shuffle
    clear
    generate
    result
    sleep 1
    clear
}

function stop_game(){
    clear
	fl "graph/gg.txt"
    sleep 3
    rm -rf /tmp/ruletka
    exit 0
}

trap interrup SIGINT
trap stop_game SIGTSTP

ctrlc_string="             Press Ctrl+C to begin play; Ctrl+Z and Ctrl-C to exit!"

mkdir /tmp/ruletka 1>/dev/null 2>&1
nointernet=0
curl "https://media.istockphoto.com/photos/woman-winning-at-the-casino-picture-id499754165" -o "/tmp/ruletka/win.jpg" 1>/dev/null 2>&1 || nointernet=1
curl "https://newsofgambling.com/assets/uploads/thumb/696x479/azartnye-igry-velikie-lyudi-01.jpg" -o "/tmp/ruletka/lose.jpg" 1>/dev/null 2>&1 || nointernet=1
if [ "$nointernet" = "1" ]; then
    echo "NO INTERNET CONNECTION! PLEASE, CONNECT TO INERNET AND TRY AGAIN"
    exit 1
fi

while true
do
    clear
    fl "graph/777_1.txt"
    echo $ctrlc_string
    sleep 1
    clear
    fl "graph/777_2.txt"
    echo $ctrlc_string
    sleep 1
done
clear 
rm -rf /tmp/ruletka