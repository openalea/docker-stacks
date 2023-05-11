import pytest
import importlib
import os

packages = [
    'hydroroot'
    ]

@pytest.mark.parametrize('package_name', packages, ids=packages)
def test_import(package_name):
    importlib.import_module(package_name)

def test_start():
    print(os.environ)
    if os.environ.get('OPENALEA_ENV') is not None:
        assert os.environ['OPENALEA_ENV'] == 'hydroroot-openalea'
