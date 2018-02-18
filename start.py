import subprocess

def getPortMapArgs(container):
  return ['-p', container['portMap']] if 'portMap' in container else []

def getEnvArgs(container):
  return [arg for env in container['env'] for arg in ['-e', env]] if 'env'\
    in container else []

containers = [
  # { 'name': 'master' },
  # { 'name': 'logging', 'portMap': '8080:80' },
  # { 'name': 'static', 'portMap': '8081:80' },
  { 'name': 'db', 'portMap': '3306:3306',
    'env': ['MYSQL_ROOT_PASSWORD_FILE=/run/secrets/mysql-root'] }
]
commonLogVolumeName = 'common-log'
volumes = [commonLogVolumeName]
commandSets = [
  # stopContainers
  [['stop', container['name']] for container in containers],
  # removeContainers
  [['rm', container['name']] for container in containers],
  # removeVolumes
  [['volume', 'rm', volume] for volume in volumes],
  # createVolumes
  [['volume', 'create', volume] for volume in volumes],
  # buildContainers
  [['build', '--no-cache=true', '-t', container['name'], container['name']]
    for container in containers],
  # runContainers
  [
    ['run', '-d', '--rm', '--mount',
      'source={0},target=/var/log/{0}'.format(commonLogVolumeName)]
    + getPortMapArgs(container)
    + getEnvArgs(container)
    + ['--name', container['name'], container['name']]
    for container in containers
  ]
]

for commandSet in commandSets:
  for command in commandSet:
    subprocess.call(['docker'] + command)
