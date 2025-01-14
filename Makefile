# This file implements the GNOME Build API:
# http://people.gnome.org/~walters/docs/build-api.txt

FIRMWAREDIR = /lib/firmware

all:

check:
	@if ! which pre-commit >/dev/null; then \
		echo "Install pre-commit to check files"; \
		exit 1; \
	fi
	@pre-commit run --all-files

dist:
	@mkdir -p release dist
	./copy-firmware.sh release
	@TARGET=linux-firmware_`git describe`.tar.gz; \
	cd release && tar -czf ../dist/$${TARGET} *; \
	echo "Created dist/$${TARGET}"
	@rm -rf release

install:
	install -d $(DESTDIR)$(FIRMWAREDIR)
	./copy-firmware.sh $(DESTDIR)$(FIRMWAREDIR)

install-xz:
	install -d $(DESTDIR)$(FIRMWAREDIR)
	./copy-firmware.sh --xz $(DESTDIR)$(FIRMWAREDIR)

install-zst:
	install -d $(DESTDIR)$(FIRMWAREDIR)
	./copy-firmware.sh --zstd $(DESTDIR)$(FIRMWAREDIR)

clean:
	rm -rf release dist
