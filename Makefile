
all : index.html radial.js sample.js style.css radial.min.js

index.html : index.jade
	jade < index.jade > index.html
radial.js : radial.coffee
	coffee -c radial.coffee


radial.min.js : radial.js
	uglifyjs < radial.js > radial.min.js

sample.js : sample.coffee
	coffee -c sample.coffee

style.css : style.styl
	stylus < style.styl > style.css

dependencies :
	wget http://github.com/DmitryBaranovskiy/raphael/raw/master/raphael-min.js

phony: all, dependencies
