#!/bin/node
const fs = require('fs');
//Obtain the environment string passed to the node script
const environment = process.argv[2];
//read the content of the json file
let envFileContent = require(`../envs/${environment}.json`);

if (environment === 'development') {
  console.log("envFileContent", envFileContent)
  const localEnvFile = require('../envs/local.json');
  envFileContent = {
    ...envFileContent,
    ...{
      API_URL: envFileContent.API_URL.replace(
        '{LOCAL_IP}',
        localEnvFile.LOCAL_IP,
      ),
    },
  };
}

//copy the json inside the env.json file
fs.writeFileSync('env.json', JSON.stringify(envFileContent, undefined, 2));
