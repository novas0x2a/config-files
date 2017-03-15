#!/usr/bin/env python
from __future__ import absolute_import, division, print_function, unicode_literals

import distutils.version  # pylint: disable=no-name-in-module, import-error
import {{PROJECT}}
import six


def test_version():
    assert {{PROJECT}}.VERSION
    assert {{PROJECT}}.__version__ == {{PROJECT}}.VERSION
    assert distutils.version.LooseVersion({{PROJECT}}.VERSION)
    assert isinstance({{PROJECT}}.VERSION, six.string_types)
    assert len({{PROJECT}}.VERSION.split('.')) == 3
