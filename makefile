# A template makefile that works for static websites.
# Need to export TEMPLATE_DIR as ENV var
export TEMPLATE_DIR = templates
# Export MARKDOWN_DIR
export MARKDOWN_DIR = markdown
PTML_DIR = html_src
UTILS_DIR = utils
DOCKER_DIR = docker
PANDOC = /home/gcallah/pandoc-2.9.2.1/bin/pandoc
# REPO = this repo!

INCS = $(TEMPLATE_DIR)/head.txt $(TEMPLATE_DIR)/logo.txt $(TEMPLATE_DIR)/menu.txt

HTMLFILES = $(shell ls $(PTML_DIR)/*.ptml | sed -e 's/.ptml/.html/' | sed -e 's/$(PTML_DIR)\///')

PTMLFILES = $(shell ls $(MARKDOWN_DIR)/*.md | sed -e 's/.md/.ptml/' | sed -e 's/$(MARKDOWN_DIR)/$(PTML_DIR)/')

FORCE:

tests: FORCE
	echo "Here is where you should run your tests."

%.html: $(PTML_DIR)/%.ptml $(PTMLFILES) $(INCS)
	python3 $(UTILS_DIR)/html_checker.py $<
	$(UTILS_DIR)/html_include.awk <$< >$@
	git add $@

local: $(HTMLFILES) $(INCS)

$(PTML_DIR)/%.ptml: $(MARKDOWN_DIR)/%.md
	# Requires pandoc, uses commonmark flavor of markdown
<<<<<<< HEAD
	pandoc -f commonmark -t html5 <$< >$@
	git add $@
=======
	$(PANDOC) -f commonmark -t html5 <$< >$@
>>>>>>> 56f923300fdb157dd0d4e14ddd61c414afd266c3

ptml: $(PTMLFILES)

prod: local tests
	-git commit -a 
	git pull origin master
	git push origin master

utils: FORCE
	cd utils; git submodule update --init

submods:
	git submodule foreach 'git pull origin master'
	
nocrud:
	rm *~
	rm .*swp
	rm $(PTML_DIR)/*~
	rm $(PTML_DIR)/.*swp

clean:
	touch $(PTML_DIR)/*.ptml; make local
