@test "checking process: nginx (master process) web2py" {
  run docker exec web2py /bin/bash -c "ps aux --forest | grep -v grep | grep 'nginx: master process /usr/sbin/nginx'"
  [ "$status" -eq 0 ]
}

@test "checking process: nginx (worker process) web2py" {
  run docker exec web2py /bin/bash -c "ps aux --forest | grep -v grep | grep 'nginx: worker process'"
  [ "$status" -eq 0 ]
}

@test "checking process: uwsgi (master process) web2py" {
  run docker exec web2py /bin/bash -c "ps aux --forest | grep -v grep | grep '/usr/local/bin/uwsgi --master'"
  [ "$status" -eq 0 ]
}

@test "checking process: uwsgi (worker process) web2py" {
  run docker exec web2py /bin/bash -c "ps aux --forest | grep -v grep | grep '/usr/local/bin/uwsgi --ini uwsgi.ini'"
  [ "$status" -eq 0 ]
}


@test "checking process: nginx (master process) web2py_min" {
  run docker exec web2py_min /bin/bash -c "ps aux --forest | grep -v grep | grep 'nginx: master process /usr/sbin/nginx'"
  [ "$status" -eq 0 ]
}

@test "checking process: nginx (worker process) web2py_min" {
  run docker exec web2py_min /bin/bash -c "ps aux --forest | grep -v grep | grep 'nginx: worker process'"
  [ "$status" -eq 0 ]
}

@test "checking process: uwsgi (master process) web2py_min" {
  run docker exec web2py_min /bin/bash -c "ps aux --forest | grep -v grep | grep '/usr/local/bin/uwsgi --master'"
  [ "$status" -eq 0 ]
}

@test "checking process: uwsgi (worker process) web2py_min" {
  run docker exec web2py_min /bin/bash -c "ps aux --forest | grep -v grep | grep '/usr/local/bin/uwsgi --ini uwsgi.ini'"
  [ "$status" -eq 0 ]
}

@test "checking process: nginx (master process disabled by DISABLE_NGINX)" {
  run docker exec web2py_no_nginx /bin/bash -c "ps aux --forest | grep -v grep | grep 'nginx: master process /usr/sbin/nginx'"
  [ "$status" -eq 1 ]
}

@test "checking process: nginx (worker process disabled by DISABLE_NGINX)" {
  run docker exec web2py_no_nginx /bin/bash -c "ps aux --forest | grep -v grep | grep 'nginx: worker process'"
  [ "$status" -eq 1 ]
}

@test "checking process: uwsgi (master process disabled by DISABLE_UWSGI)" {
  run docker exec web2py_no_uwsgi /bin/bash -c "ps aux --forest | grep -v grep | grep '/usr/local/bin/uwsgi --master'"
  [ "$status" -eq 1 ]
}

@test "checking process: uwsgi (worker process disabled by DISABLE_UWSGI)" {
  run docker exec web2py_no_uwsgi /bin/bash -c "ps aux --forest | grep -v grep | grep '/usr/local/bin/uwsgi --ini uwsgi.ini'"
  [ "$status" -eq 1 ]
}
