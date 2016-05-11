#!/bin/sh

while true
  do
    echo "$(date) Check DocService"

    #is_docservice_started=$(sudo -n supervisorctl status DocService | grep RUNNING | wc -l);
    is_docservice_started=$(supervisorctl status DocService | grep RUNNING | wc -l);

    if [ "$is_docservice_started" != 0 ]; then

      fcgi_error_count=0

      while [ 3 -gt "$fcgi_error_count" ]
        do
          #sudo timelimit -q -T 1 -t 20 sudo -u onlyoffice \
          #REQUEST_METHOD=GET \
          #SCRIPT_NAME=/CanvasService.ashx \
          #SCRIPT_FILENAME=/CanvasService.ashx \
          #cgi-fcgi -bind -connect 127.0.0.1:9001 > /dev/null 2>&1

          su -c "REQUEST_METHOD=GET SCRIPT_NAME=/CanvasService.ashx SCRIPT_FILENAME=/CanvasService.ashx cgi-fcgi -bind -connect 127.0.0.1:9001 > /dev/null 2>&1" onlyoffice

          if [ "$?" != 0 ];
            then
              fcgi_error_count=`expr $fcgi_error_count + 1`
            else
              echo "$(date) All seems ok"

              sleep 30s
              break
          fi
        done

      if [ 3 -le "$fcgi_error_count" ]; then
        echo 'Ping fastcgi server failed!'
        echo -n 'Try to restart DocService...'
        sudo -n supervisorctl restart DocService > /dev/null 2>&1
        echo 'Done'
        sleep 1m
      fi


    else

      echo 'DocService is stopped, skip checking.'
      sleep 15m
    fi
  done
