#!/bin/bash

VERSION=21.1.0 # Oracle Graph Server and Client Version

rm -rf ./scripts/oracle-graph-plsql
unzip ./packages/oracle-graph-plsql-$VERSION.zip -d ./scripts/oracle-graph-plsql

