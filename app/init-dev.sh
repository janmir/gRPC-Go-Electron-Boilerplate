#!/bin/bash

cat > webpack.config.js <<EOL
const path = require('path');

module.exports = {
  mode: 'none',
  entry: './index.js',
  output: {
    filename: 'app.js',
    path: __dirname
  },
  module: {
    rules: [
      { test: /\.js$/, exclude: /node_modules/, loader: "babel-loader" }
    ]
  },
  externals: {
    grpc: 'grpc'
  },
  watchOptions: {
    poll: true
  },
  target: "electron-main"
};
EOL

cat > .babelrc <<EOL
{
  "presets": ["env"],
  "plugins": [["transform-react-jsx", { "pragma": "h" }]]
}
EOL

cat > electron.js <<EOL
const {app, BrowserWindow} = require('electron')
const grpc = require('grpc')
const messages = require("./grpc_pb")
const services = require("./grpc_grpc_pb")

console.log("main process")

function createWindow () {
  // Create the browser window.
  win = new BrowserWindow({width: 800, height: 600})

  // and load the index.html of the app.
  win.loadFile('index.html')

  win.webContents.openDevTools()
  
  console.log("started.")
  setTimeout(clientPool, 1000)
}

var client = new services.RPCClient('0.0.0.0:5000',grpc.credentials.createInsecure());
var call = client.connect();
call.on('data', function(pack) {
  console.log("On-Receive-Data:")
  console.log(pack.getData())
});

call.on('end', function(pack) {
  console.log("On-Exit:")
  console.log(pack)
});

clientPool = ()=>{
  console.log("On-Send-Data")
  var request = new messages.Package();
  request.setData("Hellooowww pows");
  call.write(request);
  //call.end();
}

app.on('ready', createWindow)
EOL

cat > index.js <<EOL
import { h, app } from "hyperapp"
//import * as grpc from "grpc"
//import * as messages from "./grpc_pb"
//import * as services from "./grpc_grpc_pb"

const state = {
    
}

const actions = {
    
}

const view = (state, actions) => (
    <div>Hello World!!</div>
)

const hype = app(state, actions, view, document.body)
EOL

cat > package.json <<EOL
{
  "name": "electron-grpc-client",
  "version": "1.0.0",
  "description": "gRPC client running in electron.",
  "main": "electron.js",
  "scripts": {
    "watch": "webpack --watch",
    "build": "webpack",
    "pack": "webpack -p",
    "start": "electron ."
  },
  "repository": {
    "type": "git",
    "url": ".."
  },
  "keywords": [
    "grpc",
    "electron"
  ],
  "author": "janmir",
  "license": "MIT",
  "devDependencies": {
  },
  "dependencies": {
  }
}
EOL

cat > index.html <<EOL
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Hello World!</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        We are using node <script>document.write(process.versions.node)</script>,
        Chrome <script>document.write(process.versions.chrome)</script>,
        and Electron <script>document.write(process.versions.electron)</script>.
        <script>require('./app.js')</script>
    </body>
</html>
EOL