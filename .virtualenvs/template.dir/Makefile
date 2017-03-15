BASE := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

SHELL := bash -o errexit -o pipefail

ifdef VERBOSE
	Q =
	E = @true 
	CAPTURE := 
else
	Q = @
	E = @echo 
	CAPTURE := $(shell command -v chronic 2>/dev/null) 
endif


UPSTREAM = upstream/master
HEAD     = HEAD

all: help

help:
	$(Q)awk -F ':|##' \
		'/^[^\t].+?:.*?##/ {\
			printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF \
		}' $(MAKEFILE_LIST) | sort

clean: ## clean working dir
	$(E)Cleaning...
	$(Q)find $(BASE) -name '*.pyc' \
		-o -name '*.orig' \
		-o -name '*_BACKUP_*' \
		-o -name '*_BASE_*' \
		-o -name '*_LOCAL_*' \
		-o -name '*_REMOTE_*' | xargs rm 2>/dev/null || true
	$(Q)rm -rf "$(BASE)/dist"
	$(Q)rm -f "$(BASE)/{test-sequence,test-sequence-tox,pylint}.log"
	$(Q)rm -rf $(BASE)/htmlcov
	$(Q)rm -rf $(BASE)/.coverage

deps: ## install requirements for prod
	$(E)Installing deps...
	$(Q)$(CAPTURE)pip install -r "$(BASE)/requirements.txt"

dev: deps ## install requirements for test and dev
	$(E)Handling dev requirements...
	$(Q)$(CAPTURE)pip install -r "$(BASE)/test-requirements.txt" \
							  -r "$(BASE)/dev-requirements.txt" \
							  -r "$(BASE)/dist-requirements.txt"
	$(Q)$(CAPTURE)pip install -e "$(BASE)"

lint: lint-pylint lint-pep8 ## run all linters on current version

lint-pylint: ## pylint current version
	$(E)pylinting...
	$(Q)pylint --rcfile="$(BASE)/.pylintrc" {{PROJECT}} tests 2>&1 | tee "$(BASE)/$@.log"

lint-pep8: ## pep8 current version
	$(E)pep8ing...
	$(Q)pep8 --config="$(BASE)/.pep8" {{PROJECT}} tests 2>&1 | tee "$(BASE)/$@.log"

test: ## run tests for current version and env
	$(E)Testing...
	$(Q)py.test --no-print-logs

rerun: ## rerun just the tests that failed last run
	-$(Q)tput reset
	$(E)Testing...
	$(Q)py.test --lf -vv

fix: ## rerun the last failed tests, stopping after the first failure
	-$(Q)tput reset
	$(E)Testing...
	$(Q)py.test --lf -vv -x

test-tox: ## run tests for current version and all envs
	$(E)Testing all...
	$(Q)tox -c "$(BASE)/tox.ini"

test-sequence: ## run tests for all pending commits and current env
	git -C "$(BASE)" test-sequence --set-tag "checked-$@" $(UPSTREAM)..$(HEAD) "make PYTEST_ADDOPTS='-p no:sugar' -C $(BASE) clean dev test lint" 2>&1 | tee "$(BASE)/$@.log"

test-sequence-tox: ## run tests for all pending commits and all envs
	git -C "$(BASE)" test-sequence --set-tag "checked-$@" $(UPSTREAM)..$(HEAD) "make PYTEST_ADDOPTS='-p no:sugar' -C $(BASE) test-tox"  2>&1 | tee "$(BASE)/$@.log"

dist: clean dist-check ## build dist tarball
	$(E)Making dist tarball...
	$(Q)$(CAPTURE)python "$(BASE)/setup.py" sdist
	$(Q)ln -sf $$(basename "$(BASE)"/dist/*) "$(BASE)/dist/current"
	$(E)"	" $$(readlink -f $(BASE)/dist/current)

dist-check: ## build dist tarball and check it
	check-manifest $(BASE)

dist-tox: ## use tox and run a dist-check and a dist
	$(Q)tox -c "$(BASE)/tox.ini" -e makedist

coverage: ## display current code coverage in browser
	$(Q)coverage html -d $(BASE)/htmlcov
	$(Q)python -m webbrowser -t file://$(BASE)/htmlcov/index.html

coverage-console: ## display current code coverage on console
	$(Q)coverage report --skip-covered

docker-images: docker-image-base docker-image-full ## Build/push all the intermediate images

docker-image-base: scripts/testing/Dockerfile.base
	$(Q)docker build -t novas0x2a/python-testing:2.7_3.5 -f $< scripts/testing
	$(Q)docker push novas0x2a/python-testing:2.7_3.5

docker-image-full: scripts/testing/Dockerfile.full
	$(Q)docker build -t novas0x2a/{{PROJECT}}-testing:2.7_3.5 -f $< scripts/testing
	$(Q)docker push novas0x2a/{{PROJECT}}-testing:2.7_3.5


.PHONY:                \
	all                \
	clean              \
	coverage           \
	coverage-console   \
	deps               \
	dev                \
	dist               \
	dist-check         \
	dist-tox           \
	docker-images      \
	docker-image-base  \
	docker-image-full  \
	help               \
	lint               \
	lint-pep8          \
	lint-pylint        \
	rerun              \
	test               \
	test-sequence      \
	test-sequence-tox  \
	test-tox

.SUFFIXES:
