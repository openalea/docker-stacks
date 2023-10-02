import pytest
import importlib
import os.path
import sys

def test_config_paths():
    assert os.path.exists('/etc/profile.d/init_conda.sh')
    assert os.path.exists('/opt/conda/.condarc')
    assert os.path.exists('/opt/start')


def test_environment_variables():
    assert os.environ['NB_USER'] == 'openalea'
    assert os.environ['NB_UID'] == '1000'
    assert 'NB_PYTHON_PREFIX' in os.environ


def test_default_conda_environment():
    assert sys.prefix == '/opt/conda/envs/openalea'

packages = [
    'openalea.mtg', 'openalea.plantgl', 'jupyterlab'
    ]

@pytest.mark.parametrize('package_name', packages, ids=packages)
def test_import(package_name):
    importlib.import_module(package_name)
