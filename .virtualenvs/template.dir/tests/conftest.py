#!/usr/bin/env python
from __future__ import absolute_import, division, print_function, unicode_literals

import collections
import json
import logging
import pprint
import pytest
import six

from _pytest.assertion import pytest_assertrepr_compare as upstream_compare


LOGGER = logging.getLogger('test')

def json_formatter(obj):
    return json.dumps(obj, sort_keys=True, indent=4).splitlines()


def pprint_formatter(obj):
    return pprint.pformat(obj).splitlines()


def _noop(_obj, default):
    return default


def try_get_filename(obj, default):
    return getattr(obj, 'name', default)


def try_formatters(obj):
    if isinstance(obj, six.string_types):
        try:
            yield obj.splitlines(True), type(obj).splitlines, _noop
        except Exception:
            pass

    elif hasattr(obj, 'readlines'):
        try:
            yield obj.readlines(), type(obj).readlines, try_get_filename
        except Exception:
            pass

    try:
        yield json_formatter(obj), json_formatter, _noop
    except Exception:
        pass

    yield pprint_formatter(obj), pprint_formatter, _noop

def reformat(before, after, before_name, after_name):
    for formatted_before, formatter, getname in try_formatters(before):
        formatted_before_name = getname(before, before_name)

        try:
            formatted_after      = formatter(after)
            formatted_after_name = getname(after, after_name)
            break
        except Exception:
            pass

    else:
        formatted_before = None  # this kills a warning because pylint doesn't detect this properly
        raise AssertionError('unable to find any way to represent %r and %r' % (type(before), type(after)))

    return formatted_before, formatted_after, formatted_before_name, formatted_after_name

def pytest_assertrepr_compare(config, op, left, right):
    if op == '==':
        # There's no guarantee, but the usual formulation is actual, expected
        # (because the common assert flow is `assert actual == expected`)
        # Therefore we call the upstream diff with left and right swapped.

        if isinstance(left, six.string_types) or isinstance(right, six.string_types):
            return upstream_compare(config, op, right, left)

        if isinstance(left, collections.Container) and isinstance(right, collections.Container):
            right, left, _right_name, _left_name = reformat(right, left, str(type(right)), str(type(left)))
            return upstream_compare(config, op, '\n'.join(right), '\n'.join(left))

@pytest.fixture(scope='function')
def tmpfile(request, tmpdir):
    return tmpdir.join(request.function.__name__)
