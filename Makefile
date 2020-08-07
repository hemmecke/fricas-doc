# This Makefile is intended to create the website
# https://fricas.github.io, but can also be used to create
# a website with the same content under another URL.

default: all

# We need the FriCAS source repository in order to compile FriCAS, the
# FriCAS book, and the FriCAS API. That repository must live in the
# "fricas" subdirectory inside this repository. If it is not
# available, it can be cloned from https://github.com/fricas/fricas.
DOCVARS_MK=fricas/src/doc/docvars.mk
ifndef FRICAS_REPO
include ${DOCVARS_MK}
else
ifndef SOURCE_URL
include ${DOCVARS_MK}
else
ifndef DOC_URL
include ${DOCVARS_MK}
endif
endif
endif

# The output of calling "make" will live in the top-level "html"
# directory, ready to be committed to fricas.github.com, for example.

# Out-of-source builds are not supported.

# As usual, set MKDIR_P.
MKDIR_P=mkdir -p

VARS = FRICAS_REPO=${FRICAS_REPO} SOURCE_URL=${SOURCE_URL} DOC_URL=${DOC_URL}
all:
	echo PWD: ${PWD}
	echo GIT: ${FRICAS_REPO}
	echo URL: ${SOURCE_URL}
	echo DOC: ${DOC_URL}
	${MAKE} stamp/book.pdf stamp/fricas-doc stamp/api

copy: stamp/book.pdf stamp/fricas-doc stamp/api
	-rm -rf html
	cp -R doc/build/html .
	-rm -rf html/api
	cp -R fricas/src/doc/sphinx/build/html html/api
	cp stamp/book.pdf html/book.pdf

here:
	${MAKE} FRICAS_REPO=file://${PWD}/fricas \
	        SOURCE_URL=file://${PWD}/fricas \
	        DOC_URL=file://${PWD}/html \
	    all

# We only build here the FRICASsys part, since that is the only thing
# that is needed.
fricas/myconfigure:
	if test "${USE_GITHASH_AS_VERSION}" = "yes"; then \
	  sh ./myconfigure.sh fricas/configure > fricas/myconfigure; \
	else \
	  cp fricas/configure fricas/myconfigure; \
	fi
	cd fricas && ./myconfigure

###################################################################
# 1) Compile the book.
stamp/fricas: fricas/myconfigure
	cd fricas && ${MAKE}
	${MKDIR_P} stamp && touch $@

DOC=fricas/src/doc
stamp/book.pdf: stamp/fricas
	cd ${DOC} && ${MAKE} pics
	# repeat to get references correct
	cd ${DOC} && ${MAKE} $(VARS) book.dvi
	cd ${DOC} && ${MAKE} $(VARS) book.dvi
	cd ${DOC} && ${MAKE} $(VARS) book.pdf
	${MKDIR_P} stamp && cp ${DOC}/book.pdf $@

###################################################################
# 2) That what is generated from fricas-doc. This part contains
#    webpages that do neither include the FriCAS book nor the API
#    description. We have to 'make html' inside the following
#    directory.
#    Pages are generated into a subdirectory from which we copy.
stamp/fricas-doc:
	cd doc && ${MAKE} html
	${MKDIR_P} stamp && touch $@

###################################################################
# 3) The API description pages.
stamp/api: stamp/fricas
	cd ${DOC} && ${MAKE} $(VARS) newsphinx
	${MKDIR_P} stamp && touch $@

###################################################################
# We clean the generated directory ${GENDIR}.
clean:
	-rm -rf fricas/myconfigure stamp html doc/build
	-cd fricas/src/doc && make sphinxclean

distclean: clean
	-rm -rf fricas

###################################################################
github.io-local: all
	git checkout master
	git ls | grep -v '^api' | grep -v '^\.nojekyll' | xargs rm
	cp -r ${GENDIR}/* .
	git add -u
	git add .
	git reset github_data
