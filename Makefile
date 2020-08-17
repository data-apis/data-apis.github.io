# type `make help` to see all options

# To build and test the website locally, simply do:
#   $ hugo
#   $ hugo server

TARGET ?= upstream
BASEURL ?=

WORKTREETARGET = "$(TARGET)/gh-pages"

ifdef BASEURL
	BASEURLARG=-b $(BASEURL)
endif

all: build

.PHONY: serve html clean deploy help

.SILENT: # remove this to see the commands executed

public: ## create a worktree branch in the public directory
	git worktree add -B gh-pages public $(WORKTREETARGET)
	rm -rf public/*

html: public ## build the website in ./public
	hugo $(BASEURLARG)
	touch public/.nojekyll
	echo data-apis.org > public/CNAME

public/.nojekyll: html

clean: ## remove the build artifacts, mainly the "public" directory
	rm -rf public
	git worktree prune
	rm -rf .git/worktrees/public

deploy: public/.nojekyll ## push the built site to the gh-pages of this repo
	cd public && git add --all && git commit -m"Publishing to gh-pages"
	@echo pushint to $(TARGET) gh-pages
	git push $(TARGET) gh-pages


# Add help text after each target name starting with '\#\#'
help:   ## Show this help.
	@echo "\nHelp for this makefile"
	@echo "Possible commands are:"
	@grep -h "##" $(MAKEFILE_LIST) | grep -v grep | sed -e 's/\(.*\):.*##\(.*\)/    \1: \2/'
