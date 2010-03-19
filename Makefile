build: Makefile.perl
	cd tirex-renderd; $(MAKE) $(MFLAGS)
	$(MAKE) -f Makefile.perl

Makefile.perl: Makefile.PL
	perl Makefile.PL PREFIX=/usr DESTDIR=$(DESTDIR) FIRST_MAKEFILE=Makefile.perl
	rm -f Makefile.perl.old

install: build
	install -m 755 -g root -o root -d $(DESTDIR)/usr/bin/
	install -m 755 -g root -o root -d $(DESTDIR)/usr/share/tirex
	install -m 755 -g root -o root -d $(DESTDIR)/usr/share/munin/plugins
	install -m 755 -g root -o root bin/tirex-batch             $(DESTDIR)/usr/bin/
	install -m 755 -g root -o root bin/tirex-send              $(DESTDIR)/usr/bin/
	install -m 755 -g root -o root bin/tirex-master            $(DESTDIR)/usr/bin/
	install -m 755 -g root -o root bin/tirex-renderd-starter   $(DESTDIR)/usr/bin/
	install -m 755 -g root -o root bin/tirex-status            $(DESTDIR)/usr/bin/
	install -m 755 -g root -o root bin/tirex-syncd             $(DESTDIR)/usr/bin/
	install -m 755 -g root -o root bin/tirex-tiledir-check     $(DESTDIR)/usr/bin/
	install -m 755 -g root -o root bin/tirex-tiledir-stat      $(DESTDIR)/usr/bin/
	install -m 755 -g root -o root bin/tirex-rendering-control $(DESTDIR)/usr/bin/
	install -m 755 -g root -o root munin/*                     $(DESTDIR)/usr/share/munin/plugins

	mkdir -p man-generated 
	for i in bin/*; do if grep -q "=head" $$i; then pod2man $$i > man-generated/`basename $$i`.1; fi; done
	pod2man --section=5 doc/tirex.conf.pod > man-generated/tirex.conf.5

	install -m 755 -g root -o root -d                  $(DESTDIR)/etc/tirex
	install -m 644 -g root -o root etc/tirex.conf.dist $(DESTDIR)/etc/tirex/tirex.conf
	install -m 755 -g root -o root -d                  $(DESTDIR)/usr/share/man/man1/
	install -m 644 -g root -o root man-generated/*.1   $(DESTDIR)/usr/share/man/man1/
	install -m 755 -g root -o root -d                  $(DESTDIR)/usr/share/man/man5/
	install -m 644 -g root -o root man-generated/*.5   $(DESTDIR)/usr/share/man/man5/

	cd tirex-renderd; $(MAKE) DESTDIR=$(DESTDIR) install
	$(MAKE) -f Makefile.perl install

clean: Makefile.perl
	$(MAKE) -f Makefile.perl clean
	cd tirex-renderd; $(MAKE) DESTDIR=$(DESTDIR) clean
	rm -f Makefile.perl
	rm -f Makefile.perl.old
	rm -f build-stamp
	rm -f configure-stamp
	rm -rf blib man-generated

