build:
	npm install
	bower install
	rm -f dist/*
	coffee --compile --no-header --join koba.js --output dist src/koba.coffee src/koba/*.coffee 
	uglifyjs dist/koba.js --comments all --output dist/koba.min.js
	