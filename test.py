import subprocess

import click
from docker.manager import Docker


@click.command()
@click.argument('repo')
def main(repo):
    """
    Tests the Dockerfile. Builds it and clones the repository passed
    to the repo arguments and runs frigg-runner inside the cloned
    folder.
    """
    print(subprocess.call(['docker', 'build', '-t', 'test-base', '.']))
    with Docker('test-base') as docker:
        print(docker.run('git clone {repo} cloned'.format(repo=repo)).out)
        print(docker.run('pip install frigg-runner').out)
        print(docker.run('frigg', working_directory='cloned').out)

if __name__ == '__main__':
    main()
