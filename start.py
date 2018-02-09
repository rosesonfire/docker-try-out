import subprocess

def getPortMapArgs(container):
  return ['-p', container['portMap']] if 'portMap' in container else []

containers = [
  { 'name': 'master'},
  { 'name': 'logging', 'portMap': '8080:80' },
  { 'name': 'static', 'portMap': '8081:80'}
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
    + ['--name', container['name'], container['name']]
    for container in containers
  ]
]

for commandSet in commandSets:
  for command in commandSet:
    subprocess.call(['docker'] + command)
