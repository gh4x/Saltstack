debconf-utils:
  pkg.installed

mysql_setup:
  debconf.set:
    - name: mysql-server
    - data:
        'mysql-server/root_password': {'type': 'password', 'value': '{{ salt['pillar.get']('mysql:root_pw', '') }}' }
        'mysql-server/root_password_again': {'type': 'password', 'value': '{{ salt['pillar.get']('mysql:root_pw', '') }}' }
    - require:
      - pkg: debconf-utils

python-mysqldb:
  pkg.installed

mysql-server:
  pkg.installed:
    - require:
      - debconf: mysql-server
      - pkg: python-mysqldb

mysql:
  service.running:
    - watch:
      - pkg: mysql-server
      - file: /etc/mysql/my.cnf

/etc/mysql/my.cnf:
  file.managed:
    - source: salt://mysql/files/etc/mysql/my.cnf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 640
    - require:
      - pkg: mysql-server

/etc/salt/minion.d/mysql.conf:
  file.managed:
    - source: salt://mysql/files/etc/salt/minion.d/mysql.conf
    - user: root
    - group: root
    - mode: 640
    - require:
      - service: mysql

/etc/mysql/salt.cnf:
  file.managed:
    - source: salt://mysql/files/etc/mysql/salt.cnf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 640
    - require:
      - service: mysql

restart_minion_for_mysql:
  service.running:
    - name: salt-minion
    - watch:
      - file: /etc/salt/minion.d/mysql.conf