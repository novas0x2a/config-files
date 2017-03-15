#!/usr/bin/env python
from __future__ import absolute_import, division, print_function, unicode_literals

import errno
import functools
import inspect
import os.path
import re
import setuptools
import subprocess


try:
    from pip.req import parse_requirements as pip_parse_requirements
    if 'session' in inspect.getargspec(pip_parse_requirements).args:
        # pylint: disable=invalid-name
        pip_parse_requirements = functools.partial(pip_parse_requirements, session=False)
except ImportError:
    raise ImportError('Install pip.')


THISDIR = os.path.abspath(os.path.dirname(__file__))
VMOD    = os.path.join(THISDIR, '{{PROJECT}}', '__version__.py')


VERSION_RE = re.compile(r'Version:\s*(.*)\s*$')
def get_version():
    try:
        with open(os.path.join(THISDIR, 'PKG-INFO'), 'rU') as f:
            for line in f:
                match = VERSION_RE.match(line)
                if match:
                    return match.group(1)
    except EnvironmentError as e:
        if e.errno != errno.ENOENT:
            raise

    try:
        version = subprocess.check_output(('git', '-C', THISDIR, 'describe', '--match', 'v*', '--exact-match', '--dirty=-dirty'))
        if 'dirty' not in version:
            return version.decode().strip()
    except Exception as e:
        pass

    try:
        version = subprocess.check_output(('git', '-C', THISDIR, 'describe', '--match', 'v*', '--always', '--dirty=-dirty', '--long'))
        return version.decode().strip()
    except Exception as e:
        pass

    return '0.0.0'


def write_version(v):
    with open(VMOD, 'w') as f:
        f.write('''#!/usr/bin/env python\n\nVERSION = '%s'\n''' % v)


VERSION = get_version()
write_version(VERSION)


def parse_reqs(fn):
    path = os.path.join(THISDIR, fn)
    reqs = pip_parse_requirements(path)
    return [str(r.req) for r in reqs]


INSTALL_REQUIRE = parse_reqs('requirements.txt')
TESTS_REQUIRE   = parse_reqs('test-requirements.txt')


PACKAGES = ['{{PROJECT}}'] + ['{{PROJECT}}.' + i for i in setuptools.find_packages('{{PROJECT}}')]
PACKAGES = [str(i) for i in PACKAGES]

setuptools.setup(
    name='{{PROJECT}}',
    version=VERSION,
    maintainer='Mike Lundy',
    maintainer_email='mike@fluffypenguin.org',
    packages=PACKAGES,
    include_package_data=True,
    install_requires=INSTALL_REQUIRE,
    tests_require=TESTS_REQUIRE,
    extras_require=dict(
        test=TESTS_REQUIRE,
        tests=TESTS_REQUIRE,
    ),

    entry_points={
        'console_scripts': [
        ],
    }
)
