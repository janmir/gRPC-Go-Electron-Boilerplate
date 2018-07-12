all:
	npm run build
	npm run debug

init-env: init-npm install-electron install-webpack install-babel install-grpc
	npm install google-protobuf --save
	npm install hyperapp --save
	npm install electron-builder --save-dev

init-npm:
	chmod +x init-dev.sh
	./init-dev.sh

install-electron:
	npm install electron@latest --save-dev

install-grpc: #1
	#install grpc and build it for electron
	npm install grpc --runtime=electron --target=2.0.4 --save
	#sudo npm install grpc --build-from-source --runtime=electron --target=2.0.4 --target_arch=x64 --target_platform=darwin --save
	#install grpc-tools
	sudo npm install --unsafe-perm  grpc-tools --save

install-babel: #2
	npm install babel-core --save-dev
	npm install babel-loader --save-dev
	npm install babel-preset-env --save-dev
	npm install babel-plugin-transform-react-jsx --save-dev
	touch .babelrc

install-webpack: #3
	npm install --save-dev ajv@^6.0.0
	npm install --save-dev webpack@4.15.0
	npm install --save-dev webpack-cli
	touch webpack.config.js

protoc:
	#create the proto files
	grpc_tools_node_protoc --js_out=import_style=commonjs,binary:. --grpc_out=. --plugin=protoc-gen-grpc=`which grpc_tools_node_protoc_plugin` grpc.proto
