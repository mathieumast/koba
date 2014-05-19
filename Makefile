build:
	bower install
	rm -f dist/*
	coffee --compile --join koba.js --output dist src/koba.coffee src/koba/*.coffee 
	