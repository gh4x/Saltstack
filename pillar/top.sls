base:
  '*':
    - users

  'G@env:dev and G@role:dbserver':
    - match: compound
    - dev.mysql

  'G@env:stage and G@role:dbserver':
    - match: compound
    - stage.mysql

  'G@env:prod and G@role:dbserver':
    - match: compound
    - prod.mysql