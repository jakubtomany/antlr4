#!/bin/bash

set -euo pipefail

pushd runtime/Swift
  echo "running native tests..."
  ./boot.py --test
  rc=$?
  if [ $rc != 0 ]; then
    echo "failed running native tests"
  fi
popd

if [ $rc == 0 ]; then
  pushd runtime-testsuite
    echo "running maven tests..."
    if [ $GROUP == "LEXER" ]; then
        mvn -q -Dgroups="org.antlr.v4.test.runtime.category.LexerTests" -Dtest=swift.** test
    elif [ $GROUP == "PARSER1" ]; then
        mvn -q -Dgroups="org.antlr.v4.test.runtime.category.ParserTestsBatch1" -Dtest=swift.** test
    elif [ $GROUP == "PARSER21" ]; then
        mvn -q -Dgroups="org.antlr.v4.test.runtime.category.ParserTestsBatch2" -Dtest=swift.** test
    elif [ $GROUP == "RECURSION" ]; then
        mvn -q -Dgroups="org.antlr.v4.test.runtime.category.LeftRecursionTests" -Dtest=swift.** test
    else
        mvn -q -Dtest=swift.** test
    fi
  popd
fi
