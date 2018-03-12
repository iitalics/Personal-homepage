OUT=www
STATIC=static
UPLOAD_TO=CCS:.www

static = $(wildcard $(STATIC)/*.*)

all: static_files
	sassc style.sass $(OUT)/style.css
	racket site.rkt

static_files:
	cp $(static) $(OUT)

clean:
	rm -rf compiled $(wildcard $(OUT)/*)

upload:
	scp $(wildcard $(OUT)/*.*) $(UPLOAD_TO)

.PHONY: all static_files clean upload
