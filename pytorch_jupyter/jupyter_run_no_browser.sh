#!/usr/bin/env sh
DEFALT_PORT="${JUPYTER_PORT}"
RED='\033[0;31m'
NC='\033[0m'

# Check the defalt network port is available. If not, change it
port=$DEFALT_PORT
ret_code="$(lsof -Pi :$port -sTCP:LISTEN -t)"

while [ ! -z $ret_code ]
do
    printf "${RED}PORT:$port has been occupied, change it automatically.\n${NC}"
    port=$((port + 1))
    ret_code="$(lsof -Pi :$port -sTCP:LISTEN -t)"
    sleep 0.5
done

#Don't open the broswer automatically
# Allow root because docker container is runnig as 'root'
jupyter notebook --no-browser \
                --allow-root \
                --ip="0.0.0.0" \
                --port="$port"

