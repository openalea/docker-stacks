import pytest
import importlib
import sys
import os
import shutil

packages = [
    'openalea.lpy', 'hydroshoot', 'hydroshoot', 'matplotlib', 'agroservices', 'weatherdata', 'openalea.mtg'
    ]

executables = [
    'plantscan3D'
    ]

@pytest.mark.parametrize('package_name', packages, ids=packages)
def test_import(package_name):
    importlib.import_module(package_name)
    
@pytest.mark.parametrize('executable_name', executables, ids=executables)
def test_find_exec(executable_name):
    shutil.which(executable_name)

def test_start():
    print(os.environ)
    if os.environ.get('OPENALEA_ENV') is not None:
        assert os.environ['OPENALEA_ENV'] == 'fullstack-openalea'
