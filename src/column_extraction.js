#!/usr/bin/env node
const csv = require('fast-csv')
const fs = require('fs');
const ArgumentParser = require('argparse').ArgumentParser;
const parser = new ArgumentParser({
  version: '0.0.1',
  addHelp: true,
  description: 'Create a client project'
});
parser.addArgument(['-i', '--input'], {
  help: 'project key in mongo',
});

parser.addArgument(['-o', '--output'], {
  help: 'output',
});

parser.addArgument(['-t', '--thresholds'], {
  help: 'thresholds',
});

/**
 * Use case
 *
 * 1- extraire toutes les colonnes du fichier "ME all data log2norm UMI" pour lesquelles la ligne 2 a pour valeur "5".

 2- extraire toutes les colonnes du fichier "ME all data log2norm UMI" pour lesquelles la ligne 2 a pour valeur "1" ou "10".

 3- extraire toutes les colonnes du fichier "ME all data log2norm UMI" pour lesquelles la ligne 2 a pour valeur "2", "6", "9"  ou "11".
 */

function searchIndices(array, thresholds){
  const indices = [0];
  array.forEach( (value, index) =>{
    if(thresholds.indexOf(value) > -1){
      indices.push(index);
    }
  });
  return indices;
}

function filterByIndices(array, indices){
  const results = [];
  array.forEach( (value, index) =>{
    if(indices.indexOf(index) > -1){
      results.push(value);
    }
  });
  return results;
}

function getIndices(input,thresholds){

  return new Promise( (resolve, reject) => {
    let firstLine = null
    let indices = null;
      csv
        .fromPath(input)
        .on("data", function (data) {
          if (firstLine) {
            indices = searchIndices(data,thresholds);
            resolve(indices)
          } else {
            firstLine = data;
          }
        })
  })

}

function execute() {
  const args = parser.parseArgs();

  const thresholds = args.thresholds.split(',');
  getIndices(args.input, thresholds)
    .then (indices => csv
                    .fromPath(args.input)
                    .transform(obj => filterByIndices(obj,indices))
                    .pipe(csv.createWriteStream())
                    .pipe(fs.createWriteStream(args.output)))

}

execute()

