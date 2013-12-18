# Created by G. Peter Lepage (Cornell University) on 12/2013.
# Copyright (c) 2013 G. Peter Lepage. 
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version (see <http://www.gnu.org/licenses/>).
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

PYTHON = python

install : 
	$(PYTHON) setup.py install --user --record files-vegas.$(PYTHON)

install-sys : 		
	$(PYTHON) setup.py install --record files-vegas.$(PYTHON)

uninstall :			# mostly works (may leave some empty directories)
	- cat files-vegas.$(PYTHON) | xargs rm -rf

doc-html:
	rm -rf doc/html; sphinx-build -b html doc/source doc/html

doc-pdf:
	rm -rf doc/vegas.pdf
	sphinx-build -b latex doc/source doc/latex
	cd doc/latex; make vegas.pdf; mv vegas.pdf ..

doc-zip doc.zip:
	cd doc/html; zip -r doc *; mv doc.zip ../..

doc-all: doc-html doc-pdf doc-zip

sdist:			# source distribution
	$(PYTHON) setup.py sdist

.PHONY: tests

tests: 
	$(PYTHON) -m unittest discover

run-examples:
	$(MAKE) -C examples PYTHON=$(PYTHON) run

upload-pypi:
	python setup.py sdist upload

upload-git:
	make doc-all
	git commit -a -m "prep for upload"
	git push origin master

clean:
	rm -f -r build 
	rm -rf __pycache__
	rm -f *.so *.tmp *.pyc *.prof *.c .coverage doc.zip
	rm -f -r dist
	# $(MAKE) -C doc/source clean
	# $(MAKE) -C tests clean
	# $(MAKE) -C examples clean

