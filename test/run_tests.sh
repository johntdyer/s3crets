#!/bin/sh
s3crets -s input/secrets -j input/
echo "\nShowing expected output on the left and actual output on the right\n"
diff -y expected_output.json input/node.new.json 
rm input/node.new.json
