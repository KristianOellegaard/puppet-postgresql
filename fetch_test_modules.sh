#/bin/sh
if [[ ! -d test-modules/inifile ]]; then
	git clone https://github.com/puppetlabs/puppetlabs-inifile.git test-modules/inifile
fi
if [[ ! -d test-modules/stdlib ]]; then
	git clone https://github.com/puppetlabs/puppetlabs-stdlib.git test-modules/stdlib
fi