build:
	npm install
	bower install
	rm -f dist/*
	cat src/koba.coffee src/koba/*.coffee | coffee --compile --stdio > dist/koba.js
	uglifyjs dist/koba.js --comments all --output dist/koba.min.js
	