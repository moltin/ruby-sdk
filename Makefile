default: build

build:
	gem build moltin.gemspec

clean:
	rm -f *.gem
