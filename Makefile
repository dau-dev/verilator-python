#########
# BUILD #
#########
.PHONY: develop build build-verilator install dependencies-linux dependencies-macos dependencies-win copy-verilator copy-verilator-win update-verilator-config

develop:  ## install dependencies and build library
	uv pip install -e .[develop]

requirements:  ## install prerequisite python build requirements
	python -m pip install --upgrade pip toml
	python -m pip install `python -c 'import toml; c = toml.load("pyproject.toml"); print("\n".join(c["build-system"]["requires"]))'`
	python -m pip install `python -c 'import toml; c = toml.load("pyproject.toml"); print(" ".join(c["project"]["optional-dependencies"]["develop"]))'`

build:  ## build the python library
	python -m build -n -w

dependencies-linux:
	yum install bison ccache flex -y

dependencies-macos:
	HOMEBREW_NO_AUTO_UPDATE=1 brew install bison ccache flex make ninja
	brew unlink bison flex && brew link --force bison && brew link --force flex

dependencies-win:
	choco install cmake curl winflexbison3 ninja unzip zip --no-progress -y

build-verilator:  ## build verilator
	git submodule update --init --recursive
	cmake -B build src -DCMAKE_CXX_STANDARD=17 -DCMAKE_INSTALL_PREFIX=verilator
	cmake --build build --config Release -j 3
	cmake --install build

copy-verilator:  ## copy verilator to bin
	rm -rf src build .gitmodules verilator/examples verilator/bin/verilator_ccache_report verilator/bin/verilator_difftree verilator/bin/verilator_gantt verilator/bin/verilator_profcfunc verilator/verilator-config-version.cmake verilator/verilator-config.cmake

update-verilator-config:
	echo "AR = ar" >> verilator/include/verilated.mk
	echo "CXX = c++" >> verilator/include/verilated.mk
	echo "LINK = c++" >> verilator/include/verilated.mk
	echo "PYTHON3 = python" >> verilator/include/verilated.mk

install:  ## install library
	uv pip install .

#########
# LINTS #
#########
.PHONY: lint-py lint-docs fix-py fix-docs lint lints fix format

lint-py:  ## lint python with ruff
	python -m ruff check verilator
	python -m ruff format --check verilator

lint-docs:  ## lint docs with mdformat and codespell
	python -m mdformat --check README.md 
	python -m codespell_lib README.md 

fix-py:  ## autoformat python code with ruff
	python -m ruff check --fix verilator
	python -m ruff format verilator

fix-docs:  ## autoformat docs with mdformat and codespell
	python -m mdformat README.md 
	python -m codespell_lib --write README.md 

lint: lint-py lint-docs  ## run all linters
lints: lint
fix: fix-py fix-docs  ## run all autoformatters
format: fix

################
# Other Checks #
################
.PHONY: check-dist check-types checks check

check-dist:  ## check python sdist and wheel with check-dist
	check-dist -v

check-types:  ## check python types with ty
	ty check --python $$(which python)

checks: check-dist

# Alias
check: checks

#########
# TESTS #
#########
.PHONY: test coverage tests

test:  ## run python tests
	python -m pytest -v verilator/tests

coverage:  ## run tests and collect test coverage
	python -m pytest -v verilator/tests --cov=verilator --cov-report term-missing --cov-report xml

# Alias
tests: test

###########
# VERSION #
###########
.PHONY: show-version patch minor major

show-version:  ## show current library version
	@bump-my-version show current_version

patch:  ## bump a patch version
	@bump-my-version bump patch

minor:  ## bump a minor version
	@bump-my-version bump minor

major:  ## bump a major version
	@bump-my-version bump major

########
# DIST #
########
.PHONY: dist dist-build dist-sdist dist-local-wheel publish

dist-build:  # build python dists
	python -m build -w -s

dist-check:  ## run python dist checker with twine
	python -m twine check dist/*

dist: clean dist-build dist-check  ## build all dists

publish: dist  ## publish python assets

#########
# CLEAN #
#########
.PHONY: deep-clean clean

deep-clean: ## clean everything from the repository
	git clean -fdx

clean: ## clean the repository
	rm -rf .coverage coverage cover htmlcov logs build dist *.egg-info

############################################################################################

.PHONY: help

# Thanks to Francoise at marmelab.com for this
.DEFAULT_GOAL := help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

print-%:
	@echo '$*=$($*)'
